package smart.light.auth

import api.common.ApiRest
import com.smart.common.util.LogUtil
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils
import org.hibernate.SQLQuery
import org.hibernate.Session


import smart.light.saas.SysPrivilege
import smart.light.saas.SysRole
import smart.light.saas.SysRolePrivilegeR
import smart.light.saas.SysUser


import java.text.SimpleDateFormat

/**
 * 用户角色操作功能类
 * Created by liuhongbin1 on 2015/6/27.
 */
@Transactional
class RoleService {

    /**
     * 查询角色列表
     * @param packageName 子系统默认包名，不可为空
     * @param tenantId 商户id，可为空
     * @param branchId 门店id，可为空
     * @param offset
     * @param rows
     * @return
     */
    public ApiRest list(String packageName, BigInteger sysUserId, Integer offset, Integer rows, String param) {
        ApiRest r = new ApiRest()
        try {
            String hql = "from SysRole as sr";
            String filter = "sr.packageName = '${packageName}'"
//            if(tenantId != null) {
//                filter += " and sr.tenantId = ${tenantId}"
//            }
//            if(branchId != null) {
//                filter += " and sr.branchId = ${branchId}"
//            }
            if (StringUtils.isNotEmpty(param)) {
                filter += " and (sr.roleCode like '%${param}%' or sr.roleName like '%${param}%')"
            }
            if (sysUserId != null) {
                hql += " left join sr.sysUsers su ";
                filter += " and su.id = ${sysUserId}"
            }
            filter += " and sr.isDeleted = false "
            hql += " where ${filter}";
            List<SysRole> list = null;
            if (rows.intValue() == -1 && offset.intValue() == -1) {
                list = SysRole.executeQuery("select sr "+hql)
            } else {
                list = SysRole.executeQuery("select sr "+hql, [max: rows, offset: offset])
            }

            Integer total = -1
            if(offset >= 0 && rows > 0) {
                List count = SysRole.executeQuery("select count(1) "+hql)
                total = Integer.valueOf(count[0].toString())
            }
            r.isSuccess = true
            r.message = total >= 0 ? total.toString() : ""
            r.data = list
            r.clazz = list.getClass()
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "查询角色列表失败"
            LogUtil.logError(e.message + " - packageName: ${packageName}, tenantId: ${tenantId}, branchId: ${branchId}")
        } finally {
            return r
        }
    }

    /**
     * 保存角色信息
     * @param role
     * @return
     */
    public ApiRest save(SysRole role) {
        ApiRest r = new ApiRest()
        try {
            if (role.getId() != null) {
                SysRole sRole = SysRole.get(role.getId());
//                if(role.getBranchId()){
//                    sRole.setBranchId(role.getBranchId());
//                }
//                if(role.tenantId){
//                    sRole.tenantId = role.tenantId;
//                }
                sRole.setRoleName(role.getRoleName());
                sRole.setRoleCode(role.getRoleCode());
                sRole.setLastUpdateBy(role.getLastUpdateBy());
                sRole.setLastUpdateAt(role.getLastUpdateAt());
                role = sRole;
                sRole = null;
            }
            role.save flush: true
            List<SysRole> list = new ArrayList<SysRole>()
            list.add(role)
            r.isSuccess = true
            r.message = ""
            r.data = list
            r.clazz = list.class
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "保存角色信息失败"
            r.error = e.getMessage();
            LogUtil.logError(e.message + " - SysRole: ${role}")
        } finally {
            return r
        }
    }

    /**
     * 查询角色信息
     * @param tenantId
     * @param roleId
     * @return
     */
    public ApiRest find(BigInteger tenantId, BigInteger roleId) {
        ApiRest r = new ApiRest()
        try {
            SysRole role = null
            if (tenantId == null) {
                role = SysRole.findById(roleId)
            } else {
                role = SysRole.findByIdAndTenantId(roleId, tenantId)
            }
            if(role == null) {
                r.isSuccess = false
                r.message = "角色不存在"
            } else {
                List<SysRole> list = new ArrayList<SysRole>()
                list.add(role)
                r.isSuccess = true
                r.message = ""
                r.data = list
                r.clazz = list.class
            }
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "查询角色信息失败"
            LogUtil.logError(e.message + " - tenantId: ${tenantId}, roleId: ${roleId}")
        } finally {
            return r
        }
    }

    /**
     * 查询指定角色的权限信息
     * @param tenantId
     * @param roleId
     * @return
     */
    public ApiRest listRolePrivilege(BigInteger tenantId, BigInteger roleId) {
        ApiRest r = find(tenantId, roleId)
        if(r.isSuccess) {
            try {
                List<SysRole> list = r.data
                List<SysPrivilege> dataList = new ArrayList<SysPrivilege>()
                dataList.addAll(list.get(0).sysPrivileges)
                r.isSuccess = true
                r.message = ""
                r.data = dataList
                r.clazz = dataList.class
            } catch (Exception e) {
                r.isSuccess = false
                r.message = "查询角色权限信息失败"
                LogUtil.logError(e.message + " - tenantId: ${tenantId}, roleId: ${roleId}")
            } finally {
                return r
            }
        }
        return r
    }

    public ApiRest listTenantPrivilege(BigInteger tenantId, BigInteger branchId) {
        ApiRest r = new ApiRest();
        try {
            String hql = "select new map(sp.id as id, sp.isFree as isFree, sp.res as res, sp.op as op, tg.limitDate as limitDate) from TenantGoods tg, Goods g join g.sysPrivileges sp where tg.goodsId = g.id and tg.tenantId = ? and tg.branchId = ? and sp.isFree = false order by sp.res.resCode, sp.id";
            List sysPrivilegeList = SysPrivilege.executeQuery(hql, tenantId, branchId);
            r.isSuccess = true;
            r.data = sysPrivilegeList;
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.message;
            LogUtil.logError("listTenantPrivilege(${tenantId}, ${branchId}) - ${e.message}");
        }
        return r;
    }

    public ApiRest listRolePrivilegeByGoods(BigInteger goodsId) {
        ApiRest r = new ApiRest();
//        Goods goods = Goods.get(goodsId);
//        if (goods != null) {
            try {
                List<SysPrivilege> dataList = new ArrayList<SysPrivilege>()
                dataList.addAll(goods.sysPrivileges)
                r.isSuccess = true
                r.message = ""
                r.data = dataList
                r.clazz = dataList.class
            } catch (Exception e) {
                r.isSuccess = false
                r.message = "查询商品权限信息失败"
                LogUtil.logError(e.message + " - goodsId: ${goodsId}")
            }
//        } else {
//            r.isSuccess = false;
//            r.message = "无商品信息";
//        }
        return r
    }

    /**
     * 查询指定子系统的功能权限列表
     * @param packageName
     * @return
     */
    public ApiRest listPrivilege(String packageName) {
        ApiRest r = new ApiRest()
        try {
            String sql = "from SysPrivilege where res.packageName = '${packageName}' and isFree = false order by res.resCode, id"
            List<SysPrivilege> list = SysPrivilege.executeQuery(sql)
            r.isSuccess = true
            r.message = ""
            r.data = list
            r.clazz = list.class
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "查询功能权限列表失败"
            LogUtil.logError(e.message + " - packageName: ${packageName}")
        } finally {
            return r
        }
    }

    /**
     * 保存角色权限信息
     * @param tenantId
     * @param roleId
     * @param privilegeIds 权限id列表，以逗号分隔
     * @return
     */
    public ApiRest savePrivilege(BigInteger roleId, String privilegeIds) {
        ApiRest r = new ApiRest();
        try {
            SysRole sysRole = SysRole.get(roleId);
            if (sysRole != null) {
                SysRole.withSession { Session session ->
                    //删除全部权限
                    SQLQuery query = session.createSQLQuery("DELETE FROM s_role_privilege_r WHERE role_id = ${roleId}");
                    query.executeUpdate();
                    //重新添加权限
                    String sql = null;
//                    if (StringUtils.isNotEmpty(privilegeIds)) {
//////                    if (StringUtils.isNotEmpty(privilegeIds) && sysRole.tenantId != null && sysRole.branchId != null) {
////                        sql = "insert into s_role_privilege_r(role_id, privilege_id, limit_date, is_disable) select ${roleId} as role_id, gpr.privilege_id as privilege_id, max(tg.limit_date) as limit_date, 0 as is_disable " +
////                                "from s_goods_privilege_r gpr " +
////                                "join goods g on gpr.goods_id = g.id " +
////                                "join tenant_goods tg on g.id = tg.goods_id " +
////                                "where g.is_set_privilege = 1   and (tg.limit_date > '${new SimpleDateFormat("yyyy-MM-dd").format(new Date())}' or tg.limit_date = '1900-01-01') and gpr.privilege_id in (${privilegeIds}) " +
////                                "group by gpr.privilege_id";
////                        query = session.createSQLQuery(sql);
////                        query.executeUpdate();
//                    } else
                    if (StringUtils.isNotEmpty(privilegeIds)) {
                        sql = "insert into s_role_privilege_r(role_id, privilege_id, limit_date, is_disable) VALUES (${roleId}, ?, null, 0)";
                        query = session.createSQLQuery(sql)
                        String[] ids = privilegeIds.split(',')
                        Set<String> tSet = new HashSet<String>(Arrays.asList(ids))
                        tSet.each {
                            query.setBigInteger(0, BigInteger.valueOf(Long.valueOf(it)))
                            query.executeUpdate()
                        }
                    }
                }
                r.isSuccess = true
                r.message = "角色权限信息保存成功"
            } else {
                r.isSuccess = false
                r.message = "角色信息无效"
            }
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "角色权限信息保存失败"
            r.error = e.message
            r.data = null
            r.clazz = null
            LogUtil.logError(e.message + " -  roleId: ${roleId}, privilegeIds: ${privilegeIds}")
        }
        return r;
    }

    public ApiRest savePrivilegeByGoods(BigInteger goodsId, String privilegeIds) {
        ApiRest r = new ApiRest();
//        Goods goods = Goods.get(goodsId);
//        if(goods != null) {
            try {
                SysRole.withSession { Session session ->
                    //删除全部权限
                    SQLQuery query = session.createSQLQuery("DELETE FROM s_goods_privilege_r WHERE goods_id = ${goods.id}")
                    query.executeUpdate()
                    if (StringUtils.isNotEmpty(privilegeIds)) {
                        //重新添加权限
                        query = session.createSQLQuery("INSERT INTO s_goods_privilege_r(goods_id, privilege_id) VALUES(${goods.id}, ?)")
                        String[] ids = privilegeIds.split(',')
                        Set<String> tSet = new HashSet<String>(Arrays.asList(ids))
                        tSet.each {
                            query.setBigInteger(0, BigInteger.valueOf(Long.valueOf(it)))
                            query.executeUpdate()
                        }
                    }

                    String sql = "delete rpr " +
                            "from s_role_privilege_r rpr " +
                                "left join s_goods_privilege_r gpr on gpr.privilege_id = rpr.privilege_id, " +
                                "s_role r " +
                            "where rpr.role_id = r.id " +
                                "and r.tenant_id is not null " +
                                "and gpr.goods_id is null";
                    session.createSQLQuery(sql).executeUpdate();
                }
                r.isSuccess = true
                r.message = ""
                r.data = null
                r.clazz = null
            } catch (Exception e) {
                r.isSuccess = false
                r.message = "保存商品权限信息失败"
                r.data = null
                r.clazz = null
                LogUtil.logError(e.message + " - goodsId: ${goodsId}, privilegeIds: ${privilegeIds}")
            } finally {
                return r
            }
//        }
        return r
    }


    public ApiRest delete(BigInteger tenantId, BigInteger roleId) {
        ApiRest r = find(tenantId, roleId)
        if(r.isSuccess) {
            try {
                SysRole role = r.data[0]
                Set set = role.sysUsers
                if (set == null || set.isEmpty()) {
                    role.isDeleted = true
                    role.save flush: true
                    r.isSuccess = true
                    r.message = ""
                } else {
                    r.isSuccess = false
                    r.message = "角色正在使用，无法删除"
                }
                r.data = null
                r.clazz = null
            } catch (Exception e) {
                r.isSuccess = false
                r.message = "删除角色信息失败"
                LogUtil.logError(e.message + " - tenantId: ${tenantId}, roleId: ${roleId}")
            }
        }
        return r
    }

    public ApiRest maxCode(String packageName) {
        ApiRest r = new ApiRest();
        Map param = new HashMap();
        param.put("packageName", packageName);
        try {
            String hql = "select max(roleCode) from SysRole where packageName = :packageName";
//            if (StringUtils.isNotEmpty(tenantId)) {
//                hql += " and tenantId = :tenantId";
//                param.put("tenantId", BigInteger.valueOf(Long.valueOf(tenantId)));
//                if (StringUtils.isNotEmpty(branchId)) {
//                    hql += " and branchId = :branchId";
//                    param.put("branchId", BigInteger.valueOf(Long.valueOf(branchId)));
//                }
//            }
            List list = SysRole.executeQuery(hql, param);
            if (list != null && list.size() == 1) {
                r.isSuccess = true;
                r.data = list.get(0);
            } else {
                r.isSuccess = false;
            }
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.getMessage();
            LogUtil.logError("{packageName:${packageName}} - ${e.getMessage()}");
        }
        return r;
    }


    public ApiRest saveRole(BigInteger userId, String roleIds) {
        ApiRest r = new ApiRest();
        try {
            SysUser sysUser = SysUser.get(userId);
            Set<SysRole> set = sysUser.getSysRoles();
            for (SysRole sysRole : set.toArray()) {
                sysUser.removeFromSysRoles(sysRole);
            }
            if (StringUtils.isNotEmpty(roleIds)) {
                List<SysRole> list = SysRole.findAllByIdInList(Arrays.asList(roleIds.split(",")));
                for (SysRole sysRole : list) {
                    sysUser.addToSysRoles(sysRole);
                }
            }
            if (sysUser.save(flush:true)) {
                r.isSuccess = true;
            } else {
                StringBuffer error = new StringBuffer();
                sysUser.getErrors().getAllErrors().each {
                    error.append(it);
                }
                LogUtil.logError("{userId:${userId}, roleIds:${roleIds}} - ${error}");
                r.isSuccess = false;
                r.error = error.toString();
            }
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.getMessage();
            LogUtil.logError("{userId:${userId}, roleIds:${roleIds}} - ${e.getMessage()}");
        }

        return r;
    }

    public ApiRest listUserRole(BigInteger userId) {
        if (userId == null) {
            return ApiRest.INVALID_PARAMS_ERROR;
        }
        ApiRest r = new ApiRest();
        try {
            SysUser sysUser = SysUser.get(userId);
            List<SysRole> roleList = sysUser.getSysRoles().asList();
            r.isSuccess = true;
            r.message = "";
            r.data = roleList;
            r.clazz = roleList.class;
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.getMessage();
            LogUtil.logError("{userId:${userId}} - ${e.getMessage()}");
        }
        return r;
    }

    public ApiRest roleUnique(String tenantId, String branchId, String roleName) {
//        if (StringUtils.isEmpty(tenantId) || StringUtils.isEmpty(branchId) || StringUtils.isEmpty(roleName)) {
//            return ApiRest.INVALID_PARAMS_ERROR;
//        }
        ApiRest r = new ApiRest();
        try {
            List<SysRole> list = null;
//            if (tenantId.equals("0")) {
//                list = SysRole.findAllByRoleNameAndIsDeletedAndTenantIdIsNull(roleName, false);
//            } else {
//                list = SysRole.findAllByTenantIdAndBranchIdAndRoleNameAndIsDeleted(BigInteger.valueOf(Long.valueOf(tenantId)), BigInteger.valueOf(Long.valueOf(branchId)), roleName, false);
//            }
            list = SysRole.findAllByRoleNameAndIsDeleted(roleName, false);

            r.isSuccess = true;
            if (list == null || list.size() == 0) {
                r.data = true;
            } else {
                r.data = false;
            }
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.getMessage();
            LogUtil.logError("{tenantId:${tenantId}, branchId:${branchId}, roleName:${roleName}} - ${e.getMessage()}");
        }

        return r;
    }

    public ApiRest posRes(String userIds, String t) {
        if (StringUtils.isEmpty(userIds)) {
            return ApiRest.INVALID_PARAMS_ERROR;
        }
        ApiRest r = new ApiRest();
        try {
            Map<String, List<Object>> map = new LinkedHashMap<String, List<Object>>();
            if (StringUtils.isEmpty(t)) {
                String hql = "select new map(su.id as userId, sp.res.controllerName as code) from SysUser su join su.sysRoles sr join sr.sysPrivileges sp where sp.res.packageName = 'saas.pos' and su.id in (${userIds})";
                List<Map> list = (List<Map>)SysUser.executeQuery(hql);
                for (Map m : list) {
                    List<String> cList = (List<String>)map.get(m.get("userId").toString());
                    if (cList == null) {
                        cList = new ArrayList<String>();
                        map.put(m.get("userId").toString(), cList)
                    }
                    cList.add(m.get("code").toString());
                }
            } else {
                String hql = "select new map(su.id as userId, sp.res.controllerName as code, rpr.limitDate as limitDate, rpr.isDisable as isDisable) from SysRolePrivilegeR as rpr join rpr.role as sr join rpr.privilege as sp join sr.sysUsers as su where sp.res.packageName = 'saas.pos' and su.id in (${userIds})";
                List<Map> list = (List<Map>)SysUser.executeQuery(hql);
                for (Map m : list) {
                    List<Map> cList = (List<Map>)map.get(m.get("userId").toString());
                    if (cList == null) {
                        cList = new ArrayList<Map>();
                        map.put(m.get("userId").toString(), cList);
                    }
                    cList.add(m);
                }
            }
            r.isSuccess = true;
            r.data = map;
            r.clazz = map.getClass();
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.getMessage();
            LogUtil.logError("{userIds:${userIds}} - ${e.getMessage()}");
        }

        return r;
    }

    public ApiRest refreshTenantPrivilegeLimitDate(String tenantId) {
//        if (StringUtils.isEmpty(tenantId)) {
//            return ApiRest.INVALID_PARAMS_ERROR;
//        }
        ApiRest r = new ApiRest();
        try {
            SysRolePrivilegeR.withSession { Session session ->
                String sql = "update s_role_privilege_r rpr, ( " +
                                "select max(tg.limit_date) limit_date, gpr.privilege_id privilege_id from tenant_goods tg " +
                                    "join s_goods_privilege_r gpr on gpr.goods_id = tg.goods_id " +
                                " group by gpr.privilege_id) pld " +
                                "set rpr.limit_date = pld.limit_date, " +
                                    "rpr.is_disable = (case when (pld.limit_date > '${new SimpleDateFormat("yyyy-MM-dd").format(new Date())}' or  pld.limit_date = '1900-01-01') then 0 else 1 end) " +
                             "where rpr.privilege_id = pld.privilege_id and rpr.role_id in (select sr.id from s_role sr  )";
                SQLQuery query = session.createSQLQuery(sql);
                query.executeUpdate();
            }
            r.isSuccess = true;
        } catch (Exception e) {
            r.isSuccess = false;
            r.error = e.message;
            LogUtil.logError("refreshTenantPrivilegeLimitDate(${tenantId}) - ${e.message}");
        }
        return r;
    }
}
