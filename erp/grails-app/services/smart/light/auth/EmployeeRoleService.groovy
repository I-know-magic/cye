package smart.light.auth

import api.AuthApi
import api.SaaSApi
import api.common.ApiRest
import com.smart.common.Constants
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.DateUtils
import com.smart.common.util.LogUtil
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.ZTree
import grails.converters.JSON
import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import org.grails.web.json.JSONObject
import smart.light.saas.SysOperate
import smart.light.saas.SysPrivilege
import smart.light.saas.SysRes
import smart.light.saas.SysRole
import smart.light.web.vo.SysRoleVo


@Transactional
class EmployeeRoleService {
    RoleService roleService
    /**
     * 增加角色时自动生成角色编号
     */
    def getRoleCodeAuto() {
        def roleCode
        def rest = roleService.maxCode(Constants.PACKAGE_NAME)
//        def rest = AuthApi.maxRoleCode(Constants.PACKAGE_NAME, tenantId, branchId)
        if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
            roleCode = SerialNumberGenerate.nextSerialNumber(2, rest.data)
        }

        return roleCode


    }

    /**
     * 角色查询
     * @param tenantId
     * @param params
     * @return
     * @update:  角色查询部分门店 即商户门店之间共享
     */
    def queryRoles(def params) {

        ResultJSON result = new ResultJSON()
        try {
            def map = new HashMap<String, Object>()
            def rows = params.rows         //每一页的数量
            def page = params.page         //页码
            def offset = (Integer.parseInt(page) - 1) * Integer.parseInt(rows)       //从第几条数据开始
            String queryStr = "";
            if (params.queryStr) {
                queryStr = params.queryStr
            }
            def rest = roleService.list(Constants.PACKAGE_NAME, null, offset, Integer.parseInt(rows), queryStr)
//            def rest = AuthApi.listSysRole(Constants.PACKAGE_NAME, tenantId, null, null, offset, Integer.parseInt(rows), queryStr)
//            SaaSApi.parseRestData(rest, SysRole)
            if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
                List<SysRole> roles = rest.data
                List<SysRoleVo> sysRoleVoList = new ArrayList<SysRoleVo>();
                    for (int i = 0; i < roles.size(); i++) {
                    SysRoleVo sysRoleVo = new SysRoleVo()
                    SysRole role = roles.get(i)
                    sysRoleVo.packageName = role.packageName
                    sysRoleVo.roleCode = role.roleCode
                    sysRoleVo.roleName = role.roleName
                    sysRoleVo.id = role.id
                    sysRoleVo.tenantId = role.tenantId
                    sysRoleVo.createBy = role.createBy
                    sysRoleVo.createAt = role.createAt
                    sysRoleVo.lastUpdateBy = role.lastUpdateBy
                    sysRoleVo.lastUpdateAt = role.lastUpdateAt
                    sysRoleVo.isDeleted = role.isDeleted
                    sysRoleVoList.add(sysRoleVo)
                }
                map.put("rows", sysRoleVoList)
                if (rest.message) {
                    map.put("total", Integer.parseInt(rest.message))//count.size() > 0 ? count[0] : 0
                }

                result.isSuccess = true
                result.jsonMap = map
            } else if (Constants.REST_RESULT_FAILURE.equals(rest.result)) {
                result.isSuccess = false
                result.msg = rest.message
            }


        } catch (Exception e) {
            ServiceException se = new ServiceException("101", "查询数据失败", e.message)
            throw se
        }
        return result

    }

    /**
     * 编辑
     *
     *
     */
    @Transactional(readOnly = true)
    def edit(BigInteger tenantId, String id) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            if (id) {
                def rest = roleService.find(null, new BigInteger(id))
//                SaaSApi.parseRestData(rest, SysRole)
                if (rest.data.size() == 1) {
                    result.object = rest.data[0]

                }

            } else {
                throw new Exception("无效的id")
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("104", "编辑失败", e.message)
            throw se
        }
        return result
    }

    def save(SysRole sysRole) throws ServiceException {
        ResultJSON result = new ResultJSON()
        def rest
        try {
            if (!sysRole.validate()) {
                result.success = false
                sysRole.errors.allErrors.each {
                    result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
                }
                result.object = sysRole
            } else if (sysRole.id) {
                Validate.isTrue(sysRole.roleCode > '02', '管理员和销售员角色不能修改')
                rest = savesysRole(sysRole)
                if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
                    result.isSuccess = true
                    result.setMsg("保存成功!")
                } else if (Constants.REST_RESULT_FAILURE.equals(rest.result)) {
                    result.isSuccess = false
                    result.setMsg("保存失败!")
                }
            } else {
                def roleNameUnique = roleService.roleUnique(null, null, sysRole.roleName)
                if (!roleNameUnique) {
                    result.isSuccess = false
                    result.setMsg("角色名称重复，请重新录入！")
                } else {
                    rest = savesysRole(sysRole)
                    if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
                        result.isSuccess = true
                        result.setMsg("保存成功！")
                    } else if (Constants.REST_RESULT_FAILURE.equals(rest.result)) {
                        result.isSuccess = false
                        result.setMsg("角色保存失败！")
                    }
                }
            }

        } catch (Exception e) {
            ServiceException se = new ServiceException("210207", "调用角色添加接口错误", e.message)
            throw se
        }
        return result
    }

    def savesysRole(SysRole role) {
        ApiRest rest = new ApiRest()
        try {
            rest = roleService.save(role)
            return rest
        } catch (Exception e) {
            rest.isSuccess = false
            rest.error = e.getMessage()
            return rest

        }
    }

    def listSysRolePrivilege(BigInteger tenantId, BigInteger roleId) {
        def rest = roleService.listRolePrivilege(null, roleId)
//        SaaSApi.parseRestData(rest, SysPrivilege)
        return rest
    }

    /**
     * 获取系统权限
     */
    public List<ZTree> querySysPrivileges() throws ServiceException {
        try {
            def res =roleService.listPrivilege(Constants.PACKAGE_NAME)
//            def res = AuthApi.listPrivilege(Constants.PACKAGE_NAME)
//            def pos = AuthApi.listPrivilege(PropertyUtils.getDefault("pos_package_name"))
//            SaaSApi.parseRestData(res, SysPrivilege)
//            SaaSApi.parseRestData(pos, SysPrivilege)
//            res.data.addAll(pos.data)
            def zTrees = parseZTree(res.data,true)
            return zTrees
        } catch (Exception e) {
            throw new ServiceException('1002', '查询系统权限错误', e.message)
        }
    }

    /**
     * 转换为List<ZTree>
     * @param array
     * @return
     */
    private List<ZTree> parseZTree(List<SysPrivilege> array,boolean flag) {
        List<ZTree> zTrees = new ArrayList<>()
        int num = 0
        zTrees.add(new ZTree(id: '-99999', name: '全部权限', pId: '-99999'))
        array.each { def obj ->
            boolean is = true
            def cloneZ = zTrees.clone()
            for (def tree in cloneZ) {
                System.out.println("tree.id=="+tree.id);
                if (tree.id.equals(obj.res.id + '_')) {
                    System.out.println("tree.id=="+tree.id);
                    System.out.println("op=="+obj.res.id);
                    if (obj.op.actionName) {
                        def opT = new ZTree()
                        opT.id = obj.id
                        opT.name = obj.op.opName
                        System.out.println("op-opName=="+obj.op.opName);
                        opT.pId = tree.id
                        opT.memo = obj.id
//                        if(flag && (obj.limitDate==null || (obj.limitDate!="1900-01-01 00:00:00" && DateUtils.StrToDate(obj.limitDate)< new Date()))){
//                            LogUtil.logDebug("obj.op.opName="+obj.op.opName+"obj.limitDate="+obj.limitDate)
//                            opT.isHidden=true
//                        }
                        zTrees << opT
                        is = false
                        break
                    }
                    is = false
                    tree.memo = obj.id;
                    break
                }
            }
            if (is) { //菜单资源
                System.out.println("res=="+obj.res.id);
                def resT = new ZTree()
                resT.id = obj.res.id + '_res'
                System.out.println("resT.id=="+resT.id);
                resT.name = obj.res.resName
                System.out.println("res-name=="+obj.res.resName);
                resT.pId = '-99999'
                resT.nodeType = obj.res.parentId
                if (obj.op.actionName) {
                    System.out.println("res==op"+obj.op.opName);
                    def opT = new ZTree()
                    opT.id = obj.id
                    opT.name = obj.op.opName
                    opT.pId = resT.id
                    opT.memo = obj.id
                    zTrees << opT
                }
//                if(flag && (obj.limitDate==null || obj.limitDate==null || (obj.limitDate!="1900-01-01 00:00:00" && DateUtils.StrToDate(obj.limitDate)< new Date()))){
//                    LogUtil.logDebug("obj.res.resName="+obj.res.resName+"obj.limitDate="+obj.limitDate)
//                    resT.isHidden=true
//                }
                resT.memo = obj.id
                zTrees << resT
            }
            System.out.println("===================");
        }
        zTrees?.each {
            if (it.nodeType > '0') {
                it.pId = it.nodeType + '_res'
            }
        }
        return zTrees
    }

    def queryRolePrivilege(BigInteger tenantId, BigInteger roleId) {
        ResultJSON result = new ResultJSON()
        def rest
        try {
            rest = listSysRolePrivilege(tenantId, roleId)
            if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
                //组织树形结构
                def zTrees = parseZTree(rest.data,false)
                zTrees.remove(0)
                result.jsonMap = ['zt': zTrees]
                return result
            } else if (Constants.REST_RESULT_FAILURE.equals
                    (rest.result)) {
                result.isSuccess = false
                result.setMsg("查询权限错误")
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("210209", "调用查询权限接口错误", e.message)
            throw se
        }
        return result
    }

    def saveRolePrivilege(BigInteger tenantId, BigInteger roleId, String privilegeIds) {
        ResultJSON result = new ResultJSON()

        try {
//            def rest = AuthApi.findSysRole(tenantId, roleId)
//            SaaSApi.parseRestData(rest, SysRole)
//            if (rest.data[0]) {
//                Validate.isTrue(rest.data[0].roleCode > '02', '管理员和销售员角色不能设置权限')
//            }else {
//                Validate.isTrue(false,'角色不存在')
//            }
//            def rest = AuthApi.saveSysRolePrivilege(tenantId, roleId, privilegeIds)
            def rest = roleService.savePrivilege(roleId, privilegeIds)
            if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
//                WebSecurityUtils.loadResource(tenantId.toString())
                result.isSuccess = true
                result.setMsg("保存权限成功")

            } else if (Constants.REST_RESULT_FAILURE.equals(rest.result)) {
                result.isSuccess = false
                result.setMsg("保存权限失败")
            }

        } catch (Exception e) {
            ServiceException se = new ServiceException("210210", "调用保存权限接口错误", e.message)
            throw se
        }
        return result

    }
    /**
     * 删除角色，支持批量删除
     * @param params
     * @return
     */
    def delete(def params, BigInteger tenantId) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    def rest = roleService.find(null, id.toBigInteger())
//                    def rest = AuthApi.findSysRole(tenantId, id.toBigInteger())
//                    SaaSApi.parseRestData(rest, SysRole)
                    if (rest.data[0]) {
                        Validate.isTrue(rest.data[0].roleCode > '02', '管理员和销售员角色不能删除')
                    } else {
                        Validate.isTrue(false, '角色不存在')
                    }
                    rest = deleteSysRole(tenantId, new BigInteger(id))
                    if (Constants.REST_RESULT_SUCCESS.equals(rest.result)) {
                        result.isSuccess = true
                        result.setMsg("删除成功")
                    } else if (Constants.REST_RESULT_FAILURE.equals(rest.result)) {
                        result.isSuccess = false
                        result.setMsg(rest.message)

                    }

                }
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
        return result
    }
    /**
     * 删除角色
     * @param tenantId
     * @param roleId
     * @return
     */
    def deleteSysRole(BigInteger tenantId, BigInteger roleId) {
//        ApiRest rest = AuthApi.deleteSysRole(tenantId, roleId)
        ApiRest rest = roleService.delete(null, roleId)
        return rest
    }

    def createMenu(List<SysPrivilege> list) {
        Map<String, List<SysRes>> mapMenu = new HashMap<String, List<SysRes>>()
        List<SysRes> lMenu = new ArrayList<SysOperate>()
        for (int i = 0; i < list.size(); i++) {
            SysRes sysRes = list.get(i).res
            if (sysRes.parentId == 0) {
                lMenu.add(sysRes);
            }
        }
        mapMenu.put("menu", lMenu);
        return mapMenu
    }

    def createView(List<SysPrivilege> list, Map<String, List<SysRes>> mapMenu) {
        Map<String, List<SysRes>> mapView = new HashMap<String, List<SysRes>>()

        List<SysRes> menus = mapMenu.get("menu")
        for (SysRes sysRes : menus) {
            List<SysRes> lView = new ArrayList<SysOperate>()
            for (int i = 0; i < list.size(); i++) {
                SysRes sysMenu = list.get(i).res
                if (sysMenu.parentId == sysRes.id) {
                    if (findSysRes(lView, sysMenu.id))
                        lView.add(sysMenu);
                }
            }
            mapView.put(sysRes.id.toString(), lView);
        }

        return mapView
    }

    def createOp(List<SysPrivilege> list, Map<String, List<SysRes>> mapView) {
        Map<String, List<SysOperate>> mapOp = new HashMap<String, List<SysOperate>>()
        for (String key : mapView.keySet()) {
            List<SysRes> sysRess = mapView.get(key)
            for (SysRes sysRes : sysRess) {
                List<SysOperate> lop = new ArrayList<SysOperate>()
                for (int i = 0; i < list.size(); i++) {
                    SysRes sysMenu = list.get(i).res
                    if (sysMenu.id == sysRes.id) {
                        SysOperate sysOp = list.get(i).op
                        lop.add(sysOp);
                    }
                }
                mapOp.put(sysRes.id.toString(), lop);
            }

        }

        return mapOp
    }

    def findSysRes(List<SysRes> lMenu, BigInteger id) {
        for (int i = 0; i < lMenu.size(); i++) {
            SysRes sysRes = lMenu.get(i)
            if (sysRes.id == id) {
                return false
            }
        }
        return true
    }

    def queryMenu(BigInteger tenantId, BigInteger roleId) {
        ResultJSON resultJSON = new ResultJSON()
        try {
            def res = listSysRolePrivilege(tenantId, roleId)
            List<SysPrivilege> list = res.data
            Map<String, List<SysRes>> mapMenu = new HashMap<String, List<SysRes>>()
            Map<String, List<SysRes>> mapView = new HashMap<String, List<SysRes>>()
            Map<String, List<SysOperate>> mapOp = new HashMap<String, List<SysOperate>>()
            mapMenu = createMenu(list)
            mapView = createView(list, mapMenu)
            mapOp = createOp(list, mapView)
            resultJSON.jsonMap.put("menu", mapMenu)
            resultJSON.jsonMap.put("view", mapView)
            resultJSON.jsonMap.put("op", mapOp)
        } catch (Exception e) {
            resultJSON.isSuccess = false
            resultJSON.msg = "读取权限菜单失败"
            ServiceException se = new ServiceException("1005", "读取权限菜单失败", e.message)
            throw se
        }
        return resultJSON

    }

    def createmenu(List<Object> l) {
        ResultJSON resultJSON = new ResultJSON()
        Map<String, List<SysRes>> mapMenu = new HashMap<String, List<SysRes>>()
        Map<String, List<SysRes>> mapView = new HashMap<String, List<SysRes>>()
        Map<String, List<SysOperate>> mapOp = new HashMap<String, List<SysOperate>>()
        List<SysRes> listMenu = new ArrayList<SysRes>()
        try {
            for (int i = 0; i < l.size(); i++) {
                Map<String, Object> map = l.get(i)
                SysRes sysRes = setSysRes(map)
                listMenu.add(sysRes)
                List<Object> resList = map.get("resList")
                List<SysRes> listsysmenu = new ArrayList<SysRes>()
                for (Map<String, Object> childmap : resList) {
                    SysRes childsysRes = setSysRes(childmap)
                    listsysmenu.add(childsysRes)
                    List<Object> ops = childmap.get("opList")
                    List<SysOperate> oplist = new ArrayList<SysOperate>()
                    for (Map<String, Object> opmap : ops) {
                        oplist.add(setOp(opmap))
                    }
                    mapOp.put(childsysRes.id.toString(), oplist)
                }
                mapView.put(sysRes.id.toString(), listsysmenu)
            }
            mapMenu.put("menu", listMenu)
            resultJSON.jsonMap.put("menu", mapMenu)
            resultJSON.jsonMap.put("view", mapView)
            resultJSON.jsonMap.put("op", mapOp)
        } catch (Exception e) {
            resultJSON.isSuccess = false
            resultJSON.msg = "读取菜单错误!"
        }

        return resultJSON
    }

    def setSysRes(Map<String, Object> map) {
        SysRes sysRes = new SysRes()
        try {
            sysRes.parentId = map.get("parentId")?.asType(BigInteger)
            sysRes.id = map.get("resId")?.asType(BigInteger)
            sysRes.resName = map.get("resName")
            sysRes.packageName = map.get("packageName")
            sysRes.controllerName = map.get("controllerName")
            if (map.get("memo")) {
                def objArr = map.get("memo").split("#")
                sysRes.packageName = objArr[0]
                sysRes.memo = objArr[1]
            }
        } catch (Exception e) {
            LogUtil.logError("读取资源错误::"+e.getMessage())
        }
        return sysRes
    }

    def setOp(Map<String, Object> map) {
        SysOperate sysOperate = new SysOperate()
        sysOperate.actionName = map.get("actionName")
        sysOperate.opName = map.get("opName")
        sysOperate.id = map.get("id")?.asType(BigInteger)
        return sysOperate
    }
}
