package smart.light.auth

import api.MailApi
import api.RegisterApi
import api.SmsApi
import com.smart.common.Constants
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.exception.ServiceException
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils

import api.common.ApiRest



import org.hibernate.Session
import org.hibernate.SessionFactory
import org.hibernate.transform.Transformers
import org.springframework.context.MessageSource
import smart.light.saas.Branch
import smart.light.saas.SysDept
import smart.light.saas.SysEmp
import smart.light.saas.SysPrivilege
import smart.light.saas.SysRes
import smart.light.saas.SysRole
import smart.light.saas.SysUser
import smart.light.saas.Tenant

import javax.servlet.http.HttpSession
import java.util.concurrent.ConcurrentHashMap

@Transactional
class AuthService extends  BaseServiceImpl{
    private SessionFactory sessionFactory;
    private MessageSource messageSource;


    // used by the Spring IoC container to inject the session factory bean
    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // used by the Spring IoC container to inject the message source bean
    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }
    public Session getSession() {
        return  sessionFactory.getCurrentSession();
    }
    /**
     * 登录认证
     * @param loginName
     * @param loginPass
     * @param userType
     * @param sessionId
     * @return
     */
    public ApiRest login(String loginName, String loginPass, String userType, String ip, String sessionId, String tenantCode) {
        ApiRest r = new ApiRest();
        //商户员工
        try {
//            if (userType.equals(Constants.USER_TYPE_TENANT_EMPLOYEE.toString())) {
//                if (StringUtils.isNotEmpty(tenantCode)) {
//                    loginName = RegisterApi.tenantEmployeeLoginName(loginName, tenantCode);
//                } else {
//                    LogUtil.logInfo("员工 ${loginName} 登录，商户号为空");
//                    r.setResult(Constants.REST_RESULT_FAILURE);
//                    r.setMessage("商户号无效");
//                    return r;
//                }
//            }
            SysUser sUser = null;
            List<SysUser> uList = SysUser.executeQuery("from SysUser where loginName = '${loginName}' and state = ${Constants.USER_STATE_ENABLED} and isDeleted = false");
            if (uList != null && !uList.isEmpty()) {
                sUser = uList.get(0);
            }
            //通用登录判断：可通过邮箱、手机号、QQ号、帐号登录
//            if (sUser == null ) {//&& userType.equals(Constants.USER_TYPE_GENERAL.toString())
//                //手机号登录判断
//                uList = SysUser.executeQuery("from SysUser where bindMobile = '${loginName}' and state = ${Constants.USER_STATE_ENABLED} and isDeleted = false");
//                if (uList != null && !uList.isEmpty()) {
//                    sUser = uList.get(0);
//                }
//                //邮箱登录判断
//                if (sUser == null) {
//                    uList = SysUser.executeQuery("from SysUser where bindEmail = '${loginName}' and state = ${Constants.USER_STATE_ENABLED} and isDeleted = false");
//                    if (uList != null && !uList.isEmpty()) {
//                        sUser = uList.get(0);
//                    }
//                }
//                //qq号登录判断
//                if (sUser == null) {
//                    uList = SysUser.executeQuery("from SysUser where bindQq = '${loginName}' and state = ${Constants.USER_STATE_ENABLED} and isDeleted = false");
//                    if (uList != null && !uList.isEmpty()) {
//                        sUser = uList.get(0);
//                    }
//                }
//            }
            if (sUser != null) {
                if (sUser.loginPass.toUpperCase().equals(loginPass.encodeAsMD5().toUpperCase())) {
//                    if (userType.equals(Constants.USER_TYPE_GENERAL.toString()) || sUser.userType.toString().equals(userType)) {
                        if (sUser.state.equals(Constants.USER_STATE_ENABLED)) {
                            if (StringUtils.isNotEmpty(sessionId)) {
                                if (sUser.loginCount != -1) {
                                    sUser.loginCount++;
                                    sUser.setLastLoginIp(ip);
                                    sUser.setLastLoginTime(new Date());
                                    if (sUser.save(flush:true)) {
                                        //缓存
                                        createSession(sessionId, sUser, r);
                                        //记录日志
                                        userLoginLog(sessionId, sUser);
                                        r.setResult(Constants.REST_RESULT_SUCCESS);
                                        r.setMessage("登录成功");
                                        r.setData(sUser.sysRoles*.id);
                                    } else {
                                        StringBuffer error = new StringBuffer();
                                        sUser.getErrors().getAllErrors().each {
                                            error.append(it);
                                        }
                                        LogUtil.logError("用户登录异常 - {userId:${sUser.id}, loginName:${sUser.loginName}} - ${error}");
                                        r.setResult(Constants.REST_RESULT_FAILURE);
                                        r.setMessage("登录异常");
                                        r.setError(error.toString());
                                    }
                                } else {
                                    LogUtil.logInfo("用户 {id:${sUser.id}, loginName:${sUser.loginName}} 需重置密码");
                                    r.setData(sUser.getId())
                                    r.setResult(Constants.REST_RESULT_RESET);
                                    r.setMessage("请重置密码");
                                }
                            } else {
                                LogUtil.logInfo("用户 {id:${sUser.id}, loginName:${sUser.loginName}} 无session");
                                r.setResult(Constants.REST_RESULT_FAILURE);
                                r.setMessage("登录异常");
                                r.setError("无session用户");
                            }
                        } else {
                            LogUtil.logInfo("用户 {id:${sUser.id}, loginName:${sUser.loginName}} 未激活或已删除");
                            r.setResult(Constants.REST_RESULT_FAILURE);
                            r.setMessage("账号或密码错误");
                            r.setError("账号未激活或已删除");
                        }
//                    } else {
//                        LogUtil.logInfo("用户 {id:${sUser.id}, loginName:${sUser.loginName}} 用户类型与登录系统不符");
//                        r.setResult(Constants.REST_RESULT_FAILURE);
//                        r.setMessage("账号或密码错误");
//                        r.setError("无权登录");
//                    }
                } else {
                    LogUtil.logInfo("用户 {id:${sUser.id}, loginName:${sUser.loginName}} 登录密码密码错误");
                    r.setResult(Constants.REST_RESULT_FAILURE);
                    r.setMessage("账号或密码错误");
                    r.setError("密码错误");
                }
            } else {
                LogUtil.logInfo("登录帐号 ${loginName} 未注册");
                r.setResult(Constants.REST_RESULT_FAILURE);
                r.setMessage("账号或密码错误");
                r.setError("账号错误");
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("301108", "登录失败！", e.message)
            throw se
        }
        return r;
    }

    private static void createSession(String sessionId, SysUser sUser, ApiRest r) {
//        RedisClusterUtils.delSession(sessionId);
        Map sessionMap = new HashMap();
        try {
            sessionMap.put(SessionConstants.KEY_SESSION_ID, sessionId);
            sessionMap.put(SessionConstants.KEY_USER_LOGIN_NAME, sUser.getLoginName());
            sessionMap.put(SessionConstants.KEY_USER_LOGIN_COUNT, String.valueOf(sUser.getLoginCount()));
            sessionMap.put(SessionConstants.KEY_USER_NAME , sUser.getName());
            sessionMap.put(SessionConstants.KEY_USER_ID, sUser.getId().toString());
            sessionMap.put(SessionConstants.KEY_USER_TYPE, sUser.getUserType().toString());

            if (StringUtils.isNotEmpty(sUser.getBindEmail())) {
                sessionMap.put(SessionConstants.KEY_USER_BIND_EMAIL, sUser.getBindEmail());
            }
            if (StringUtils.isNotEmpty(sUser.getBindQq())) {
                sessionMap.put(SessionConstants.KEY_USER_BIND_QQ, sUser.getBindQq());
            }
            if (StringUtils.isNotEmpty(sUser.getBindMobile())) {
                sessionMap.put(SessionConstants.KEY_USER_BIND_MOBILE, sUser.getBindMobile());
            }
            if (StringUtils.isNotEmpty(sUser.getBindWechat())) {
                sessionMap.put(SessionConstants.KEY_USER_BIND_WECHAT, sUser.getBindWechat());
            }

            if (StringUtils.isNotEmpty(sUser.getLastLoginIp())) {
                sessionMap.put(SessionConstants.KEY_USER_LAST_LOGIN_IP,sUser.getLastLoginIp());
            }
            //查询用户、部门信息 Tenant--部门
            if (sUser.getUserType().equals(Constants.USER_TYPE_TENANT)) {
                SysEmp sysEmp=new SysEmp();
                Tenant tenant = null;
                Branch branch = null;
                List<Tenant> list = null;
                List<Branch> listBranch = null;
                List<SysEmp> listemp = null;
                if (sUser.getUserType().equals(Constants.USER_TYPE_TENANT)) {
                    listemp = SysEmp.executeQuery("from SysEmp where userId = ? and isDeleted = false", sUser.getId());
                    sysEmp=(listemp != null && !listemp.isEmpty()) ? listemp.get(0) : null;
                    if(sysEmp){
                        list=Tenant.executeQuery("from Tenant where id = ? and isDeleted = false", sysEmp.getTenantId());
                        listBranch=Branch.executeQuery("from Branch where id = ? and isDeleted = false", sysEmp.getBranchId());
                    }else{
                        LogUtil.logError("用户登录创建session失败 无法获取到员工信息 - {sessionId:${sessionId}, userId:${sUser.id}} ");
                    }

                }
                tenant = (list != null && !list.isEmpty()) ? list.get(0) : null;
                branch = (listBranch != null && !listBranch.isEmpty()) ? listBranch.get(0) : null;
                if (tenant != null) {
                    sessionMap.put(SessionConstants.KEY_TENANT_ID, tenant.getId().toString());
                    sessionMap.put(SessionConstants.KEY_TENANT_NAME, tenant.name != null ? tenant.name : "");
                    sessionMap.put(SessionConstants.KEY_TENANT_CODE, tenant.code != null ? tenant.code : "");

                }
                if(branch !=null){
                    sessionMap.put(SessionConstants.KEY_BRANCH_ID, branch.getId().toString());
                    sessionMap.put(SessionConstants.KEY_BRANCH_NAME, branch.name != null ? branch.name : "");
                    sessionMap.put(SessionConstants.KEY_BRANCH_TYPE, branch.branchType != null ? branch.branchType.toString() : "");
                }
            }
        } catch (Exception e) {
            LogUtil.logError("用户登录创建session失败 - {sessionId:${sessionId}, userId:${sUser.id}} - ${e.getMessage()}");
        }

        try {
            //菜单树
            String hql = "select new map(sp.res.id as resId, sp.res.packageName as packageName, sp.res.resName as resName, " +
                    "sp.res.controllerName as controllerName, sp.res.parentId as parentId, " +
                    "sp.op.id as opId, sp.op.opName as opName, sp.op.actionName as actionName, sp.res.memo as memo, sp.res.resCode, sp.op.opCode, rpr.isDisable, rpr.limitDate) " +
                    "from SysRolePrivilegeR as rpr join rpr.role as sr join rpr.privilege as sp join sr.sysUsers as su " +
                    "where su.id = ? and sp.isFree = false and sp.res.resStatus = 0  and su.isDeleted = false and sr.isDeleted = false " +
                    "order by sp.res.parentId, sp.res.resCode, sp.op.opCode";
            List<Map<String, Object>> list = (List<Map<String, Object>>)SysPrivilege.executeQuery(hql, sUser.getId());
            LinkedHashSet<Map<String, Object>> set = new LinkedHashSet<Map<String, Object>>(list);
            List<Map<String,Object>> menuList = createTree(set);
            sessionMap.put(SessionConstants.KEY_MENU_TREE, (menuList as JSON).toString());

            LightConstants.setToSession(sessionId, sessionMap);
//            RedisClusterUtils.setToSession(sessionId, sessionMap);
//            SysRole.withSession { Session session ->
//                String hql = "SELECT" +
//                        " res.id AS resId,\n" +
//                        " res.package_name AS packageName,\n" +
//                        " res.res_name AS resName,\n" +
//                        " res.controller_name AS controllerName,\n" +
//                        " res.parent_id AS parentId,\n" +
//                        " op.id AS opId,\n" +
//                        " op.op_name AS opName,\n" +
//                        " op.action_name AS actionName,\n" +
//                        " res.memo AS memo,\n" +
//                        " res.res_code,\n" +
//                        " op.op_code,\n" +
//                        " rpr.is_disable,\n" +
//                        " rpr.limit_date\n" +
//
//                        "FROM\n" +
//                        "s_role_privilege_r AS rpr\n" +
//                        "LEFT JOIN s_privilege AS sp ON rpr.privilege_id=sp.id\n" +
//                        "LEFT JOIN s_res AS res ON sp.res_id=sp.id\n" +
//                        "LEFT JOIN s_operate AS op ON sp.op_id=op.id\n" +
//                        "LEFT JOIN s_role AS sr ON rpr.role_id=sr.id\n" +
//                        "LEFT JOIN s_user_role_r AS sur ON rpr.role_id=sur.role_id\n" +
//                        "LEFT JOIN s_user AS su  ON sur.user_id=sr.id\n" +
//                        "WHERE\n" +
//                        "su.id = ?\n" +
//                        "AND sp.is_free = FALSE\n" +
//                        "AND res.res_status = 0\n" +
//                        "AND su.is_deleted = FALSE\n" +
//                        "AND sr.is_deleted = FALSE \n" +
//                        "ORDER BY\n" +
//                        "res.parent_id,\n" +
//                        "res.res_code,\n" +
//                        "op.op_code";
//                List<Map<String, Object>> list = session.createSQLQuery(hql).setParameter(0, sUser.getId()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
////            List<Map<String, Object>> list = (List<Map<String, Object>>) getSession().createSQLQuery(hql).setParameter(0, sUser.getId());
//                LinkedHashSet<Map<String, Object>> set = new LinkedHashSet<Map<String, Object>>(list);
//                List<Map<String,Object>> menuList = createTree(set);
//                sessionMap.put(SessionConstants.KEY_MENU_TREE, (menuList as JSON).toString());
//
//                RedisClusterUtils.setToSession(sessionId, sessionMap);
//            }

        } catch (Exception e) {
            LogUtil.logError("用户登录创建菜单树失败 - {sessionId:${sessionId}, userId:${sUser.id}} - ${e.getMessage()}");
            throw e;
        }
    }

    private static List<Map<String,Object>> createTree(Set<Map<String, Object>> set) {
        Map<String, Object> menuMap = new LinkedHashMap<String, Object>();
        for (Map<String, Object> map : set) {
            BigInteger parentId = (BigInteger)map.get("parentId");
            BigInteger resId = (BigInteger)map.get("resId");
            String resName = (String)map.get("resName");
            String packageName = (String)map.get("packageName");
            String controllerName = (String)map.get("controllerName");
            BigInteger opId = (BigInteger)map.get("opId");
            String opName = (String)map.get("opName");
            String actionName = (String)map.get("actionName");
            String memo = (String)map.get("memo");
            String isDisable = (String)map.get("isDisable");
            String limitDate = (String)map.get("limitDate");
            if (parentId.toString().equals("0")) {
                //parentId 等于 0 是一级菜单
                Map<String, Object> pMenuMap = (LinkedHashMap<String, Object>)menuMap.get(resId.toString());
                //初始化一级菜单
                if (pMenuMap == null) {
                    pMenuMap = new LinkedHashMap<String, Object>();
                    menuMap.put(resId.toString(), pMenuMap);
                }
                if (pMenuMap.get("parentId") == null) {
                    pMenuMap.put("parentId", parentId);
                    pMenuMap.put("resId", resId);
                    pMenuMap.put("resName", resName);
                    pMenuMap.put("packageName", packageName);
                    pMenuMap.put("controllerName", controllerName);
                    pMenuMap.put("isDisable", isDisable);
                    pMenuMap.put("limitDate", limitDate);
                }
            } else {
                //二级菜单
                Map<String, Object> pMenuMap = (LinkedHashMap<String, Object>)menuMap.get(parentId.toString());
                //初始化二级菜单对应的一级菜单
                if (pMenuMap == null) {
                    pMenuMap = new LinkedHashMap<String, Object>();
                    menuMap.put(parentId.toString(), pMenuMap);
                    pMenuMap.put("resId", parentId);
                }
                //二级菜单列表
                List<Map<String, Object>> resList = (List<Map<String, Object>>)pMenuMap.get("resList");
                //初始化二级菜单列表
                if (resList == null) {
                    resList = new ArrayList<Map<String, Object>>();
                    pMenuMap.put("resList", resList);
                }
                //标识当前二级菜单是否在列表中
                boolean isHave = false;
                //遍历二级菜单列表
                for (Map<String, Object> resMap : resList) {
                    if (resMap.get("resId").equals(resId)) {
                        isHave = true;
                        List<Map<String, Object>> opList = (ArrayList<Map<String, Object>>)resMap.get("opList");
                        Map<String, Object> opMap = new LinkedHashMap<String, Object>();
                        opMap.put("opId", opId);
                        opMap.put("opName", opName);
                        opMap.put("actionName", actionName);
                        opMap.put("memo", memo);
                        opMap.put("isDisable", isDisable);
                        opMap.put("limitDate", limitDate);
                        opList.add(opMap);
                        break;
                    }
                }
                if (!isHave) {
                    Map<String, Object> resMap = new LinkedHashMap<String, Object>();
                    resList.add(resMap);
                    resMap.put("parentId", parentId);
                    resMap.put("resId", resId);
                    resMap.put("resName", resName);
                    resMap.put("packageName", packageName);
                    resMap.put("controllerName", controllerName);
                    resMap.put("memo", memo);
                    resMap.put("isDisable", isDisable);
                    resMap.put("limitDate", limitDate);
                    List<Map<String, Object>> opList = new ArrayList<Map<String, Object>>();
                    resMap.put("opList", opList);
                    Map<String, Object> opMap = new LinkedHashMap<String, Object>();
                    opMap.put("opId", opId);
                    opMap.put("opName", opName);
                    opMap.put("actionName", actionName);
                    opMap.put("memo", memo);
                    opMap.put("isDisable", isDisable);
                    opMap.put("limitDate", limitDate);
                    opList.add(opMap);
                }
            }
        }
        List<Map<String,Object>> menuList = new ArrayList<Map<String,Object>>();
        for (Map.Entry e : menuMap.entrySet()) {
            Map<String, Object> pMenu = (Map<String, Object>)e.getValue();
            if (pMenu != null) {
                if (pMenu.get("resName") == null && pMenu.get("resId") != null) {
                    SysRes res = SysRes.get(BigInteger.valueOf(Long.valueOf((String)pMenu.get("resId"))));
                    if (res != null) {
                        pMenu.put("resName", res.getResName());
                        pMenu.put("packageName", res.getPackageName());
                        pMenu.put("controllerName", res.getControllerName());
                    }
                }
                menuList.add(pMenu);
            }
        }
        return menuList;
    }

    /**
     * 密码修改
     * @param userId
     * @param oldPass
     * @param newPass
     * @return
     */
    public ApiRest resetPassword(String userId, String oldPass, String newPass) {
        ApiRest r = new ApiRest();
        if (StringUtils.isNotEmpty(userId)) {
            if (StringUtils.isNotEmpty(oldPass) && StringUtils.isNotEmpty(newPass)) {
                oldPass = oldPass.encodeAsMD5();
                newPass = newPass.encodeAsMD5();
                SysUser sysUser = SysUser.get(new BigInteger(userId));
                SysEmp sysEmp=SysEmp.findByUserIdAndIsDeleted(new BigInteger(userId),false);

                if (sysUser != null && sysEmp != null) {
                    if (sysUser.getLoginPass().toUpperCase().equals(oldPass.toUpperCase())) {
                        sysUser.setLoginPass(newPass.toUpperCase());
                        sysEmp.setPasswordForLocal(newPass.toUpperCase());
                        if (sysUser.getLoginCount() == -1) {
                            sysUser.setLoginCount(0);
                        }
                        if(sysUser.save(flush:true)&&sysEmp.save(flush:true)) {
                            r.setResult(Constants.REST_RESULT_SUCCESS);
                            r.setMessage("密码修改成功");
                            r.setData(sysUser.getId());
                        } else {
                            StringBuffer error = new StringBuffer();
                            sysUser.getErrors().getAllErrors().each {
                                error.append(it);
                            }
                            LogUtil.logError("用户修改密码失败 - {userId:${userId}} - ${error}");
                            r.setResult(Constants.REST_RESULT_FAILURE);
                            r.setMessage("密码修改失败");
                            r.setError(error.toString());
                        }
                    } else {
                        LogUtil.logInfo("用户 ${userId} 修改密码失败，原始密码错误");
                        r.setResult(Constants.REST_RESULT_FAILURE);
                        r.setMessage("原始密码错误");
                    }
                } else {
                    LogUtil.logInfo("用户 ${userId} 修改密码失败，查无用户");
                    r.setResult(Constants.REST_RESULT_FAILURE);
                    r.setMessage("无效用户");
                }
            } else {
                LogUtil.logInfo("用户 ${userId} 修改密码失败，密码为空");
                r.setResult(Constants.REST_RESULT_FAILURE);
                r.setMessage("无效密码");
            }
        } else {
            LogUtil.logInfo("用户修改密码失败，用户Id为空");
            r.setResult(Constants.REST_RESULT_FAILURE);
            r.setMessage("无效用户");
        }
        return r;
    }

    /**
     * 密码重置
     * @param userId
     * @param newPass
     * @return
     */
    public ApiRest resetPassword(String userId, String newPass) {
        ApiRest r = new ApiRest();
        if (StringUtils.isNotEmpty(userId)) {
            newPass = newPass.encodeAsMD5();
            SysUser sysUser = SysUser.get(userId);
            if (sysUser != null) {
                sysUser.setLoginPass(newPass);
                if(sysUser.save(flush:true)) {
                    r.setResult(Constants.REST_RESULT_SUCCESS);
                    r.setMessage("密码重置成功");
                    r.setData(sysUser.getId());
                } else {
                    StringBuffer error = new StringBuffer();
                    sysUser.getErrors().getAllErrors().each {
                        error.append(it);
                    }
                    LogUtil.logError("用户重置密码失败 - {userId:${userId}} - ${error}");
                    r.setResult(Constants.REST_RESULT_FAILURE);
                    r.setMessage("密码修改失败");
                    r.setError(error.toString());
                }
                return r;
            }
        }
        LogUtil.logInfo("用户 ${userId} 重置密码失败，无效用户");
        r.setResult(Constants.REST_RESULT_FAILURE);
        r.setMessage("无效用户");
        return r;
    }

    /**
     * 登出
     * @param userId
     * @param sessionId
     * @return
     */
    public ApiRest logout(String sessionId) {
        ApiRest r = new ApiRest();
//        RedisClusterUtils.delSession(sessionId);
//        userLogoutLog(sessionId);
        r.setResult(Constants.REST_RESULT_SUCCESS);
        r.setMessage("登出成功");
        return r;
    }

    /**
     * 绑定手机
     * @param userId
     * @param number
     * @param authCode
     * @param sessionId
     * @return
     */
    public ApiRest bindMobile(String userId, String number, String authCode, String sessionId) {
        if (!"-1".equals(authCode) && !"-1".equals(sessionId)) {
            ApiRest ret = SmsApi.SmsVerifyAuthCode(number, authCode, sessionId);
            if(!ret.isSuccess) {
                return ret;
            }
        }

        ApiRest r;
        try {
            BigInteger id = BigInteger.valueOf(Long.valueOf(userId));
            SysUser user = SysUser.findByIdAndState(id, Constants.USER_STATE_ENABLED);
            user.bindMobile = number;
            user.save flush: true;

            r = new ApiRest();
            r.isSuccess = true;
            r.message = "绑定手机成功";
        } catch (Exception e) {
            LogUtil.logError("用户绑定手机失败 - {userId:${userId}, number:${number}} - ${e.message}");
            r = ApiRest.UNKNOWN_ERROR;
        }

        return r;
    }

    /**
     * 绑定微信
     * @param userId
     * @param wechatId
     * @param sessionId
     * @return
     */
    public ApiRest bindWechat(String userId, String wechatId, String sessionId) {
        ApiRest r
        try {
            BigInteger id = BigInteger.valueOf(Long.valueOf(userId));
            SysUser user = SysUser.findByIdAndState(id, Constants.USER_STATE_ENABLED);
            user.bindWechat = wechatId;
            user.save flush: true;

            r = new ApiRest();
            r.isSuccess = true;
            r.message = "绑定微信成功";
        } catch (Exception e) {
            LogUtil.logError("用户绑定微信失败 - {userId:${userId}, wechatId:${wechatId}} - ${e.message}");
            r = ApiRest.UNKNOWN_ERROR;
        }

        return r;
    }

    /**
     * 获取项目的角色权限
     * @return
     */
    public ApiRest loadResourceDefine(String packageName, String id) {
        ApiRest r;
        ConcurrentHashMap<String, Map<String, List<String>>> resourceMap = new ConcurrentHashMap<String, Map<String, List<String>>>();

        try {
            List<SysRole> roleList = null;
            if (StringUtils.isNotEmpty(id)) {
                roleList = SysRole.findAllByIsDeletedAndPackageNameAndTenantId(false, packageName, BigInteger.valueOf(Long.valueOf(id)));
            } else {
                roleList = SysRole.findAllByIsDeletedAndPackageName(false, packageName);
            }
            for (SysRole role : roleList) {
                String tenantId = "tenant_" + (role.getTenantId() != null ? String.valueOf(role.getTenantId()) : "0");
                Map<String, List<String>> tMap = resourceMap.get(tenantId);
                if (tMap == null) {
                    tMap = new ConcurrentHashMap<String, List<String>>();
                    resourceMap.put(tenantId, tMap);
                }
                String roleName = "ROLE_" + role.getId();
                Set<SysPrivilege> privSet = role.getSysPrivileges();
                for (SysPrivilege priv : privSet) {
                    if (!priv.isFree) {
                        String url = "/"+priv.getRes().getControllerName()+"/"+priv.getOp().getActionName();
                        if (!tMap.containsKey(url)) {
                            tMap.put(url, new ArrayList<String>());
                        }
                        List<String> value = tMap.get(url);
                        value.add(roleName);
                    }
                }
            }
        } catch (Exception e) {
            LogUtil.logError("{packageName:${packageName}, id:${id}} - ${e.message}");
            r = ApiRest.UNKNOWN_ERROR;
            return r;
        }
        r = new ApiRest();
        r.isSuccess = true;
        r.message = "权限获取成功";
        r.data = resourceMap;
        return r;
    }

    /**
     * 获取其他系统的访问信息
     * @param clientId
     * @return
     */
    public ApiRest packageAccess(String clientId) {
        ApiRest r;
        Map<String,String> clientMap = ClientUtils.getClient(clientId);
        if (clientMap == null) {
            r = ApiRest.INVALID_PARAMS_ERROR
            return r;
        }
        r = new ApiRest();
        r.isSuccess = true;
        r.data = clientMap;
        return r;
    }

    /**
     * 向邮箱发送绑定信息
     * @param email
     * @param type
     * @return
     */
    public ApiRest sendBindEmail(String email, String type, String id, String callback) {
        ApiRest r = new ApiRest();
        try {
            boolean unique = true;
            String e = null;
            if (type.equals(LightConstants.USER_BIND_TYPE_EMAIL)) {
                e = email;
            } else if (type.equals(LightConstants.USER_BIND_TYPE_QQ)) {
                e = email.split("@")[0];
            }
            unique = bindUnique(type, e);
            if (!unique) {
                r.isSuccess = false;
                r.message = "已被其他用户绑定";
                return r;
            }
            Map m = ["email":email, "type":type, "id":id];
            String json = (m as JSON).toString();
            String sign = json.encodeAsMD5();
            int expiryHour = 2;//TODO 可配置
//            RedisClusterUtils.hmsetExpire(LightConstants.CACHE_BIND_PREFIX+sign, m, expiryHour*60*60);
            if (callback.indexOf("?") > -1) {
                callback += ("&v=" + sign);
            } else {
                callback += ("?v=" + sign);
            }
            if (type.equals(LightConstants.USER_BIND_TYPE_EMAIL)) {
                MailApi.sendBindMail(email, callback, expiryHour);
            } else if (type.equals(LightConstants.USER_BIND_TYPE_QQ)) {
                MailApi.sendBindQQ(email, callback, expiryHour);
            }
            r.isSuccess = true;
            r.message = "验证邮件发送成功";
        } catch (Exception e) {
            LogUtil.logError("验证邮件发送失败 - {email:${email}, type:${type}, id:${id}, callback:${callback}} - ${e.getMessage()}");
            r.isSuccess = false;
            r.message = "验证邮件发送失败";
            r.error = e.getMessage();
        }

        return r;
    }

    /**
     * 验证绑定信息
     * @param v
     * @return
     */
    public ApiRest verifyBind(String v) {
        ApiRest r = new ApiRest();
        try {
            Map m = RedisClusterUtils.hgetAll(LightConstants.CACHE_BIND_PREFIX+v);
            if (m == null || m.size() == 0) {
                r.setResult(Constants.REST_RESULT_FAILURE);
                r.setMessage("绑定超时");
                return r;
            }
            String userId = m.get("id");
            String type = m.get("type");
            String email = m.get("email");
            SysUser sysUser = SysUser.get(BigInteger.valueOf(Long.valueOf(userId)));
            if (sysUser != null) {
                if (type.equals(LightConstants.USER_BIND_TYPE_EMAIL)) {
                    sysUser.setBindEmail(email);
                } else if (type.equals(LightConstants.USER_BIND_TYPE_QQ)) {
                    sysUser.setBindQq(email.split("@")[0]);
                }
                if (sysUser.save(flush:true)) {
                    r.setResult(Constants.REST_RESULT_SUCCESS);
                    r.setData(sysUser.getId());
                    r.setMessage("绑定成功");
                    RedisClusterUtils.del(LightConstants.CACHE_BIND_PREFIX+v);
                } else {
                    StringBuffer error = new StringBuffer();
                    sysUser.getErrors().getAllErrors().each {
                        error.append(it);
                    }
                    LogUtil.logError("验证绑定失败 - {v:${v}} - ${error}");
                    r.setResult(Constants.REST_RESULT_FAILURE);
                    r.setMessage("绑定失败");
                    r.setError(error.toString());
                }
            }
        } catch (Exception e) {
            LogUtil.logError("验证绑定失败 - {v:${v}} - ${e.getMessage()}");
            r.setResult(Constants.REST_RESULT_FAILURE);
            r.setMessage("绑定失败");
            r.setError(e.getMessage());
        }

        return r;
    }

    public boolean bindUnique(String type, String value) {
        if (StringUtils.isEmpty(value)) {
            return true;
        }
        List<SysUser> uList = null;
        if (type.equals(LightConstants.USER_BIND_TYPE_EMAIL)) {
            uList = SysUser.findAll("from SysUser where bindEmail = ? and isDeleted = false", value);
        } else if (type.equals(LightConstants.USER_BIND_TYPE_QQ)) {
            uList = SysUser.findAll("from SysUser where bindQq = ? and isDeleted = false", value);
        } else if (type.equals(LightConstants.USER_BIND_TYPE_MOBILE)) {
            uList = new ArrayList<>();
            List<SysUser> l = SysUser.findAll("from SysUser where bindMobile = ? and isDeleted = false", value);
            if (l != null && !l.isEmpty()) {
                uList.addAll(l);
            }
            l = SysUser.findAll("from SysUser where loginName = ? and isDeleted = false", value);
            if (l != null && !l.isEmpty()) {
                uList.addAll(l);
            }
        } else if (type.equals(LightConstants.USER_BIND_TYPE_WECHAT)) {
            uList = SysUser.findAll("from SysUser where bindWechat = ? and isDeleted = false", value);
        }
        if (uList == null || uList.size() == 0) {
            return true;
        }
        boolean r = false;
        for (SysUser u : uList) {
            if (u.getState().equals(Constants.USER_STATE_ENABLED)) {
                return false;
            }
            if (u.getState().equals(Constants.USER_STATE_UNACTIVATED)) {
                if (!r && (new Date().getTime() - u.getCreateAt().getTime()) > UserService.limit) {
                    r = true;
                }
            }
        }
        return r;
    }

    public ApiRest removeBind(String userId, String type) {
        ApiRest r = new ApiRest();
        try {
            if (StringUtils.isEmpty(userId) || StringUtils.isEmpty(type)) {
                return ApiRest.INVALID_PARAMS_ERROR;
            }
            SysUser sysUser = SysUser.find("from SysUser where id = ?", BigInteger.valueOf(Long.valueOf(userId)));
            if (type.equals(LightConstants.USER_BIND_TYPE_EMAIL)) {
                sysUser.setBindEmail(null);
            } else if (type.equals(LightConstants.USER_BIND_TYPE_WECHAT)) {
                sysUser.setBindWechat(null);
            } else if (type.equals(LightConstants.USER_BIND_TYPE_QQ)) {
                sysUser.setBindQq(null);
            } else if (type.equals(LightConstants.USER_BIND_TYPE_MOBILE)) {
                sysUser.setBindMobile(null);
            } else {
                return ApiRest.INVALID_PARAMS_ERROR;
            }
            if (sysUser.save(flush:true)) {
                r.setResult(Constants.REST_RESULT_SUCCESS)
                r.setMessage("解绑成功")
            } else {
                StringBuffer error = new StringBuffer();
                sysUser.getErrors().getAllErrors().each {
                    error.append(it);
                }
                r.setResult(Constants.REST_RESULT_FAILURE);
                r.setMessage("解绑失败");
                r.setError(error.toString());
            }
        } catch (Exception e) {
            LogUtil.logError("解除绑定失败 - {userId:${userId}, type:${type}} - ${e.getMessage()}");
            r.setResult(Constants.REST_RESULT_FAILURE);
            r.setMessage("解绑失败");
            r.setError(e.getMessage());
        }
        return r;
    }

    private void userLoginLog(String sessionId, SysUser user) {
//        try {
//            if (user != null && StringUtils.isNotEmpty(sessionId)) {
//                SysLoginLog loginLog = SysLoginLog.findBySessionId(sessionId);
//                if (loginLog == null) {
//                    loginLog = new SysLoginLog();
//                    loginLog.setUserId(user.getId());
//                    loginLog.setLoginName(user.getLoginName());
//                    loginLog.setName(user.getName());
//                    loginLog.setLoginAt(new Date());
//                    loginLog.setLoginIp(user.getLastLoginIp());
//                    loginLog.setSessionId(sessionId);
//                    loginLog.save(flush: true);
//                } else if (loginLog.getLogouAt() != null) {
//                    LogUtil.logInfo("用户登录日志异常 - session["+sessionId+"] user["+user.getId()+"] - 该session用户已经登出，session未销毁");
//                } else {
//                    LogUtil.logInfo("用户登录日志 - session["+sessionId+"] user["+user.getId()+"] - 重复登录");
//                }
//            }
//        } catch (Exception e) {
//            LogUtil.logError("用户登录日志错误 - " + e.getMessage());
//        }
    }

//    private void userLogoutLog(String sessionId) {
////        SysLoginLog loginLog = SysLoginLog.findBySessionId(sessionId);
//        if (loginLog != null) {
//            loginLog.setLogouAt(new Date());
//            loginLog.save(flush: true);
//        } else {
//            LogUtil.logInfo("用户登录日志异常 - session["+sessionId+"] - 未记录该session信息");
//        }
//    }

}
