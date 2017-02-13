package smart.light.auth

import com.smart.common.service.impl.BaseServiceImpl
import grails.transaction.Transactional
import grails.validation.ValidationErrors
import grails.validation.ValidationException
import org.apache.commons.lang.StringUtils
import org.hibernate.Query
import org.hibernate.Session
import api.RegisterApi
import api.common.ApiRest
import smart.light.saas.SysPrivilege
import smart.light.saas.SysRole
import smart.light.saas.SysUser

/**
 * Created by Administrator on 2015/9/6.
 */
@Transactional
class RegisterAllService extends BaseServiceImpl {

    UserService userService;
    AuthService authService;

    /**
     * 完整注册，各类型用户注册具体参数请查看RegisterApi具体调用方法
     * @param map
     * @return
     */
    public ApiRest register(Map map) {
        ApiRest r = new ApiRest();
//        String userType = map["userType"];
//        String isTest = map["isTest"];
//        map["id"] = null;
//        try {
//            if (StringUtils.isNotEmpty(userType)) {
//
//                /******************** 【数据预处理】 开始 ********************/
//                if (userType.equals(Constants.USER_TYPE_TENANT.toString())) {
//
//                    /******************** 商户注册数据 ********************/
//                    //代理商数据
//                    if (StringUtils.isNotEmpty((String)map["inviteCode"])) {
//                        Agent agent = Agent.findByCode((String)map["inviteCode"]);
//                        if (agent != null) {
//                            map["agentId"] = agent.id;
//                        }
//                    }
//                    //商品数据
//                    String goodsCode = null;
//                    if ("2".equals(map["business1"])) {
//                        goodsCode = PropertyUtils.getDefault("retail_goods_code");
//                    } else {
//                        goodsCode = PropertyUtils.getDefault("goods_code");
//                    }
//                    Goods goods = Goods.findByGoodsCode(goodsCode);
//                    if (goods != null) {
//                        map["goodsId"] = goods.id;
//                    }
//                    //商户帐号为商户code
//                    map["loginName"] = IDCreator.newTenantID(isTest == null ? 0 : Integer.valueOf(isTest));
//                    if (map["isTest"] == null) {
//                        map["isTest"] = "0";
//                    }
//                } else if (userType.equals(Constants.USER_TYPE_AGENT.toString())) {
//
//                    /******************** 代理商注册数据 ********************/
//                    map["phoneNumber"] = map["agent"]["mobile"];
//                    map["linkman"] = map["agent"]["linkman"];
//                    map["loginName"] = IDCreator.newAgentID(isTest == null ? 0 : Integer.valueOf(isTest));
//                    map["agent"]["isTest"] = map["isTest"];
//                } else if (userType.equals(Constants.USER_TYPE_TENANT_EMPLOYEE.toString())) {
//
//                    /******************** 商户员工注册数据 ********************/
//                    if (StringUtils.isNotEmpty((String)map["tenantCode"])) {
//                        BigInteger tenantId = BigInteger.valueOf(Long.valueOf((String)map["tenantId"]));
//                        Tenant tenant = Tenant.get(tenantId);
//                        String code = newEmployeeCode(tenantId, tenant.business1);
//                        if (StringUtils.isEmpty(code)) {
//                            r.isSuccess = false;
//                            r.message = "商户员工初始化失败";
//                            r.error = "员工号初始化失败";
//                            throw new Exception();
//                        }
//                        map["code"] = code;
//                        map["loginName"] = RegisterApi.tenantEmployeeLoginName(code, (String)map["tenantCode"]);
//                        map["loginPass"] = "888888";
//                        map["name"]= map["linkman"];
//                    } else {
//                        LogUtil.logInfo("员工注册，商户号为空 ${map.toString()}");
//                        r.isSuccess = false;
//                        r.message = "商户号无效";
//                        throw new Exception();
//                    }
//                } else if (userType.equals(Constants.USER_TYPE_OPERATION.toString())) {
//
//                    /******************** 运维注册数据 ********************/
//                } else if (userType.equals(Integer.valueOf(7).toString())) {//TODO 使用common中常量
//
//                    /******************** 慧掌柜商户注册数据 ********************/
//                    //商品数据
//                    String goodsCode = null;
//                    if ("2".equals(map["business1"])) {
//                        goodsCode = PropertyUtils.getDefault("retail_goods_code");
//                    } else {
//                        goodsCode = PropertyUtils.getDefault("goods_code");
//                    }
//                    Goods goods = Goods.findByGoodsCode(goodsCode);
//                    if (goods != null) {
//                        map["goodsId"] = goods.id;
//                    }
//                    map["loginName"] = IDCreator.newTenantHZGID(isTest == null ? 0 : Integer.valueOf(isTest));
//                    map["linkman"] = map["tenantName"];
//                } else if (userType.equals(Integer.valueOf(8).toString())) {//TODO 使用common中常量
//
//                    /******************** 慧掌柜商户员工注册数据 ********************/
//                }
//                Date now = new Date();
//                map["createAt"] = now;
//                map["lastUpdateAt"] = now;
//                map["bindMobile"] = map["phoneNumber"];
//                map["bindEmail"] = map["email"];
//                /******************** 【数据预处理】 结束 ********************/
//
//                /******************** 初始化用户数据 ********************/
//                SysUser user = new SysUser(map);
//                user.name = map["linkman"];
//                r = saveSysUser(user);
//                if (!r.isSuccess) {
//                    throw new Exception();
//                }
//                map["userId"] = user.id;
//
//                if (userType.equals(Constants.USER_TYPE_TENANT.toString())) {
//
//                    /******************** 商户注册 ********************/
//
//                    /********** 初始化商户数据 **********/
//                    Tenant tenant = new Tenant(map);
//                    tenant.code = user.loginName;
//                    tenant.name = map["tenantName"];
//                    tenant.type = 1;//TODO 使用Common包中常量
//                    r = saveTenant(tenant);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                    map["tenantId"] = tenant.id;
//                    /********** 初始化微信数据 **********/
//                    StringBuffer url = new StringBuffer();
//                    url.append(PropertyUtils.getDefault("initWechatInfoURL"));
//                    url.append(tenant.code);
//                    map["url"] = url.toString();
//                    WxWechatInfo wxWechatInfo = new WxWechatInfo(map);
//                    r = saveWechat(wxWechatInfo);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                    /********** 初始化ERP数据 **********/
//                    r = saveErpInfo(tenant.id.toString(), user.loginName, user.id.toString(), tenant.name, user.bindMobile, tenant.linkman, tenant.business1);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                    map["branchId"] = r.data;
//                    /********** 初始化角色数据 **********/
//                    r = saveSysRole(tenant.id, (BigInteger)map["branchId"], user, tenant.business1);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                    /********** 初始化软件购买数据 **********/
//                    TenantGoods tenantGoods = new TenantGoods(map)
//                    r = saveTenantGoods(tenantGoods);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                } else if (userType.equals(Constants.USER_TYPE_AGENT.toString())) {
//
//                    /******************** 代理商注册 ********************/
//
//                    /********** 初始化代理商数据 **********/
//                    Agent agent = new Agent((Map)map["agent"]);
//                    agent.code = user.loginName;
//                    agent.userId = user.id;
//                    agent.phoneNumber = map["phoneNumber"];
//                    r = saveAgent(agent);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                } else if (userType.equals(Constants.USER_TYPE_TENANT_EMPLOYEE.toString())) {
//
//                    /******************** 商户员工注册 ********************/
//
//                    /********** 初始化商户员工数据 **********/
//                    map["phone"] = map["phoneNumber"];
//                    Employee employee = new Employee(map);
//                    employee.passwordForLocal = user.loginPass;
//                    employee.state = 1;
//                    Tenant tenant = Tenant.get(employee.tenantId);
//                    r = saveEmployee(employee, tenant.business1);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                } else if (userType.equals(Constants.USER_TYPE_OPERATION.toString())) {
//
//                    /******************** 运维注册 ********************/
//                } else if (userType.equals(Integer.valueOf(7).toString())) {//TODO 使用common中常量
//
//                    /******************** 慧掌柜商户注册 ********************/
//
//                    /********** 初始化商户数据 **********/
//                    Tenant tenant = new Tenant(map);
//                    tenant.code = user.loginName;
//                    tenant.name = map["tenantName"];
//                    tenant.type = 2;//TODO 使用Common包中常量
//                    r = saveTenant(tenant);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                } else if (userType.equals(Integer.valueOf(8).toString())) {//TODO 使用common中常量
//
//                    /******************** 慧掌柜商户员工注册 ********************/
//
//                    /********** 初始化商户员工数据 **********/
//                    map["phone"] = map["phoneNumber"];
//                    Tenant tenant = Tenant.findByCodeAndIsDeleted((String)map["inviteCode"], false);
//                    map["tenantId"] = tenant.id;
//                    map["branchId"] = BigInteger.valueOf(0);
//                    map["code"] = newEmployeeCode(tenant.id, tenant.business1);
//                    Employee employee = new Employee(map);
//                    employee.state = 0;
//                    r = saveEmployee(employee, tenant.business1);
//                    if (!r.isSuccess) {
//                        throw new Exception();
//                    }
//                }
//                r.data = user;
//                r.isSuccess = true;
//                r.message = "注册完成";
//            } else {
//                r.isSuccess = false;
//                r.message = "用户类型无效";
//            }
//        } catch(Exception e) {
//            if (r.message == null) {
//                r.isSuccess = false;
//                r.message = "注册失败";
//                r.error = e.message;
//            }
//            LogUtil.logError("用户注册失败 - ${map} - ${r.toString()}");
//            throw new ValidationException(r.toJson(), new ValidationErrors(r));
//        }
        return r;
    }

    /**
     * 初始化用户数据
     * @param user
     * @return
     */
    public ApiRest saveSysUser(SysUser user) {
        ApiRest r = new ApiRest();
        try {
            if (user != null) {
                if (StringUtils.isNotEmpty(user.getLoginName())) {
                    if (userService.loginNameIsUnique(user.getLoginName(), null)) {
                        if (authService.bindUnique(Constants.USER_BIND_TYPE_MOBILE, user.getBindMobile())) {
                            user.loginPass = user.loginPass.encodeAsMD5();
                            user.state = Constants.USER_STATE_ENABLED;
                            user.loginCount = 0;
                            if(user.name == null) user.name = user.loginName;//TODO 数据库中这两个字段长度不一致，name较短
                            if (user.validate()) {
                                user.save();
                                r.isSuccess = true;
                                r.message = "用户数据初始化成功";
                            } else {
                                StringBuffer error = new StringBuffer();
                                user.errors.allErrors.each {
                                    error.append(it);
                                }
                                r.isSuccess = false;
                                r.message = "用户数据初始化失败";
                                r.error = error.toString();
                                LogUtil.logError("用户 ${user.loginName} 初始化失败 - ${error.toString()}");
                            }
                        } else {
                            r.isSuccess = false;
                            r.message = "手机号已注册";
                            LogUtil.logInfo("用户 ${user.loginName} 手机号 ${user.bindMobile} 已注册");
                        }
                    } else {
                        r.isSuccess = false;
                        r.message = "帐号已注册";
                        LogUtil.logInfo("用户 ${user.loginName} 帐号已注册");
                    }
                } else {
                    r.isSuccess = false;
                    r.message = "帐号无效";
                    LogUtil.logError("用户数据初始化失败 - 无帐号信息");
                }
            } else {
                r.isSuccess = false;
                r.message = "用户数据无效";
                LogUtil.logError("用户数据初始化失败 - 无用户数据");
            }
        } catch (Exception e) {
            r.isSuccess = false;
            r.message = "用户数据初始化失败";
            r.error = e.message;
            LogUtil.logError("用户 ${user != null ? user.loginName : '未知'} 初始化失败 - ${e.message}");
        }
        return r;
    }

    /**
     * 初始化商户数据
     * @param tenant
     * @return
     */
//    public ApiRest saveTenant(Tenant tenant) {
//        ApiRest r = new ApiRest();
//        try {
//            if (tenant != null) {
//                tenant.status = 1;//TODO 使用Common包中常量
//                tenant.paidTotal = 0;
//                if (tenant.business == null || tenant.business.intValue() == 0) {tenant.business = 1;}
//                if (tenant.phoneNumber == null) {
//                    tenant.phoneNumber = "";
//                }
//                if (tenant.linkman == null) {
//                    tenant.linkman = "";
//                }
//                if (tenant.isTest == null) {
//                    tenant.isTest = false;
//                }
//                if (tenant.validate()) {
//                    tenant.save();
//                    r.isSuccess = true;
//                    r.message = "商户数据初始化成功";
//                } else {
//                    StringBuffer error = new StringBuffer();
//                    tenant.errors.allErrors.each {
//                        error.append(it);
//                    }
//                    r.isSuccess = false;
//                    r.message = "商户数据初始化失败";
//                    r.error = error.toString();
//                    LogUtil.logError("商户 ${tenant.name} ${tenant.code} 初始化失败 - ${error.toString()}");
//                }
//            } else {
//                r.isSuccess = false;
//                r.message = "商户数据无效";
//                LogUtil.logError("商户初始化失败 - 初始化数据无效");
//            }
//        } catch (Exception e) {
//            r.isSuccess = false;
//            r.message = "商户数据初始化失败";
//            r.error = e.message;
//            LogUtil.logError("商户 ${tenant != null ? (tenant.name + ' ' + tenant.code) : '未知'} 初始化失败 - ${e.message}");
//        }
//        return r;
//    }
//
//    /**
//     * 初始化员工数据
//     * @param employee
//     * @return
//     */
//    public ApiRest saveEmployee(Employee employee, String business) {
//        ApiRest r = new ApiRest();
//        try {
//            if (employee != null) {
//                if (employee.name == null) {employee.name = employee.loginName;}
//                if (employee.validate()) {
//                    if ("2".equals(business)) {
//                        employee.retail.save();
//                    } else {
//                        employee.save();
//                    }
//                    r.isSuccess = true;
//                    r.message = "员工数据初始化成功";
//                } else {
//                    StringBuffer error = new StringBuffer();
//                    employee.errors.allErrors.each {
//                        error.append(it);
//                    }
//                    r.isSuccess = false;
//                    r.message = "员工数据初始化失败";
//                    r.error = error.toString();
//                    LogUtil.logError("员工 ${employee != null ? (employee.loginName + ' ' + employee.code) : '未知'} 初始化失败 - ${error.toString()}");
//                }
//            } else {
//                r.isSuccess = false;
//                r.message = "商户员工数据无效";
//                LogUtil.logError("员工初始化失败 - 初始化数据无效}");
//            }
//        } catch(Exception e) {
//            r.isSuccess = false;
//            r.message = "商户员工数据初始化失败";
//            r.error = e.message;
//            LogUtil.logError("员工 ${employee != null ? (employee.loginName + ' ' + employee.code) : '未知'} 初始化失败 - ${e.message}");
//        }
//        return r;
//    }
//
//    /**
//     * 初始化代理商数据
//     * @param agent
//     * @return
//     */
//    public ApiRest saveAgent(Agent agent) {
//        ApiRest r = new ApiRest();
//        try {
//            if (agent != null) {
//                agent.status = 1;
//                if (agent.validate()) {
//                    agent.save();
//                    r.isSuccess = true;
//                    r.message = "代理商数据初始化成功";
//                } else {
//                    StringBuffer error = new StringBuffer();
//                    agent.errors.allErrors.each {
//                        error.append(it);
//                    }
//                    r.isSuccess = false;
//                    r.message = "代理商数据初始化失败";
//                    r.error = error.toString();
//                    LogUtil.logError("代理商 ${agent != null ? (agent.name + ' ' + agent.code) : '未知'} 初始化失败 - ${error.toString()}");
//                }
//            } else {
//                r.isSuccess = false;
//                r.message = "代理商数据无效";
//                LogUtil.logError("代理商初始化失败 - 初始化数据无效}");
//            }
//        } catch(Exception e) {
//            r.isSuccess = false;
//            r.message = "代理商数据初始化失败";
//            r.error = e.message;
//            LogUtil.logError("代理商 ${agent != null ? (agent.name + ' ' + agent.code) : '未知'} 初始化失败 - ${e.message}");
//        }
//        return r;
//    }
//
//    /**
//     * 初始化ERP数据
//     * @param tenantId
//     * @param loginName
//     * @param userid
//     * @param branchName
//     * @param phone
//     * @param contacts
//     * @return
//     */
//    public ApiRest saveErpInfo(String tenantId, String loginName, String userid, String branchName, String phone, String contacts, String business){
//        ApiRest r = new ApiRest();
//        try {
//            SysUser.withTransaction { status ->
//                if ("1".equals(business)) {
//                    Branch.withSession { Session session ->
//                        Query query = session.createSQLQuery("CALL init_tenant(?,?,?,?,?,?,@branchId)");
//                        query.setParameter(0,tenantId);
//                        query.setParameter(1,userid);
//                        query.setParameter(2,loginName);
//                        query.setParameter(3,branchName);
//                        query.setParameter(4,phone);
//                        query.setParameter(5,contacts);
//                        List list = query.list()
//                        BigInteger branchId = (BigInteger)list.get(0);
//                        if(branchId != -1) {
//                            r.isSuccess = true;
//                            r.data = branchId;
//                        } else{
//                            status.setRollbackOnly();
//                            r.isSuccess = false;
//                            r.message = "ERP数据初始化失败";
//                            LogUtil.logError("ERP数据初始化失败 - 存储过程执行异常");
//                        }
//                    }
//                } else if ("2".equals(business)) {
//                    Branch.retail.withSession { Session session ->
//                        Query query = session.createSQLQuery("CALL init_tenant(?,?,?,?,?,?,@branchId)");
//                        query.setParameter(0,tenantId);
//                        query.setParameter(1,userid);
//                        query.setParameter(2,loginName);
//                        query.setParameter(3,branchName);
//                        query.setParameter(4,phone);
//                        query.setParameter(5,contacts);
//                        List list = query.list();
//                        BigInteger branchId = (BigInteger)list.get(0);
//                        if(branchId != -1) {
//                            r.isSuccess = true;
//                            r.data = branchId;
//                        } else{
//                            status.setRollbackOnly();
//                            r.isSuccess = false;
//                            r.message = "ERP数据初始化失败";
//                            LogUtil.logError("ERP数据初始化失败 - 存储过程执行异常");
//                        }
//                    }
//                } else {
//                    r.isSuccess = false;
//                    r.message = "未知业态";
//                    LogUtil.logError("ERP数据初始化失败 - 未知业态");
//                }
//            }
//        } catch (Exception e) {
//            r.isSuccess = false;
//            r.message = "ERP数据初始化失败";
//            r.error = e.message;
//            LogUtil.logError("ERP数据初始化失败 - ${e.message}");
//        }
//        return r;
//    }

    /**
     * 初始化角色数据
     * @param tenantId
     * @param userid
     * @param branchId
     * @return
     */
    public ApiRest saveSysRole(BigInteger tenantId, BigInteger branchId, SysUser sysUser, String business){
        ApiRest r = new ApiRest();
        try {
            List<SysRole> roleList = SysRole.findAllByTenantId(BigInteger.valueOf(0));
            String sqlString = null;
            if ("1".equals(business)) {
                sqlString = "select * from template_role_privilege_r where role_id in(1,2,3,4)";//去除 5（区域经理）
            } else if ("2".equals(business)) {
                sqlString = "select * from template_role_privilege_r where role_id in(2,6)";
            } else {
                r.isSuccess = false;
                r.message = "角色数据初始化失败";
                r.error = "未知业态";
                return r;
            }
            Query query = getSession().createSQLQuery(sqlString);
            Iterator it = query.list().iterator();
            StringBuffer privilege1 = new StringBuffer();
            StringBuffer privilege2 = new StringBuffer();
            StringBuffer privilege3 = new StringBuffer();
            StringBuffer privilege4 = new StringBuffer();
            //StringBuffer privilege5 = new StringBuffer();
            StringBuffer privilege6 = new StringBuffer();

            java.sql.Date limitDate = new java.sql.Date(DateUtils.getSpace(Integer.parseInt(PropertyUtils.getDefault("limitDate"))).getTime());

            while(it.hasNext()){
                Object[] o = (Object[])it.next();
                switch (Integer.valueOf(o[0].toString())){
                    case 1:
                        privilege1.append(o[1].toString()+",");
                        break;
                    case 2:
                        privilege2.append(o[1].toString()+",");
                        break;
                    case 3:
                        privilege3.append(o[1].toString()+",");
                        break;
                    case 4:
                        privilege4.append(o[1].toString()+",");
                        break;
                    /*case 5:
                        privilege5.append(o[1].toString()+",");
                        break;*/
                    case 6:
                        privilege6.append(o[1].toString()+",");
                        break;
                }
            }

            Date now = new Date();
            for (int i = 0; i < roleList.size(); i++) {
                switch (Integer.valueOf(roleList.get(i).roleCode.toString())){
                    //创建门店的管理员角色，并赋予商户
                    case 1 :
                        SysRole sysRole = roleList.get(i);
                        SysRole newSysRole = new SysRole();
                        newSysRole.tenantId = tenantId;
//                        newSysRole.branchId = branchId;
                        newSysRole.createAt = now;
                        newSysRole.lastUpdateAt = now;
                        newSysRole.roleCode = sysRole.roleCode;
                        newSysRole.roleName = sysRole.roleName;
                        newSysRole.createBy = sysRole.createBy;
                        newSysRole.lastUpdateBy = sysRole.lastUpdateBy;
//                        newSysRole.roleType = sysRole.roleType;
                        newSysRole.isDeleted = false;

                        if ("1".equals(business)) {
                            newSysRole.packageName = "saas.web";
                            if(privilege1.length()>1) {
                                String privilege1Final = privilege1.toString().substring(0, privilege1.length() - 1);
                                List<SysPrivilege> sysPrivilegeList = SysPrivilege.findAll("from SysPrivilege s where s.id in (" + privilege1Final + ")");
                                for (SysPrivilege sp : sysPrivilegeList) {
                                    newSysRole.addToSysPrivileges(sp);
                                }
                            }
                        } else if ("2".equals(business)) {
                            newSysRole.packageName = "saas.retail";
                            if(privilege6.length()>1) {
                                String privilege1Final = privilege6.toString().substring(0, privilege6.length() - 1);
                                List<SysPrivilege> sysPrivilegeList = SysPrivilege.findAll("from SysPrivilege s where s.id in (" + privilege1Final + ")");
                                for (SysPrivilege sp : sysPrivilegeList) {
                                    newSysRole.addToSysPrivileges(sp);
                                }
                            }
                        }
                        newSysRole.addToSysUsers(sysUser);
                        newSysRole.save(flush: false);

                        break;
                    //创建门店的收银员角色，并赋予商户
                    case 2 :
                        SysRole sysRole = roleList.get(i);
                        SysRole newSysRole = new SysRole();
                        newSysRole.tenantId = tenantId;
                        newSysRole.branchId = branchId;
                        newSysRole.createAt = now;
                        newSysRole.lastUpdateAt = now;
                        newSysRole.roleCode = sysRole.roleCode;
                        newSysRole.roleName = sysRole.roleName;
                        newSysRole.createBy = sysRole.createBy;
                        newSysRole.lastUpdateBy = sysRole.lastUpdateBy;
                        newSysRole.roleType = sysRole.roleType;
                        if ("1".equals(business)) {
                            newSysRole.packageName = "saas.web";
                        } else if ("2".equals(business)) {
                            newSysRole.packageName = "saas.retail";
                        }
                        newSysRole.isDeleted = false;
                        newSysRole.addToSysUsers(sysUser);
                        newSysRole.save(flush: false);
                        if(privilege2.length()>1) {
                            String privilege2Final = privilege2.toString().substring(0, privilege2.length() - 1);
                            List<SysPrivilege> sysPrivilegeList = SysPrivilege.findAll("from SysPrivilege s where s.id in (" + privilege2Final + ")");
                            for (SysPrivilege sp : sysPrivilegeList) {
                                newSysRole.addToSysPrivileges(sp);
                            }
                        }

                        break;
                    //创建门店的服务员角色
                    case 3 :
                        if ("1".equals(business)) {
                            SysRole sysRole = roleList.get(i);
                            SysRole newSysRole = new SysRole();
                            newSysRole.tenantId = tenantId;
                            newSysRole.branchId = branchId;
                            newSysRole.createAt = now;
                            newSysRole.lastUpdateAt = now;
                            newSysRole.roleCode = sysRole.roleCode;
                            newSysRole.roleName = sysRole.roleName;
                            newSysRole.createBy = sysRole.createBy;
                            newSysRole.lastUpdateBy = sysRole.lastUpdateBy;
                            newSysRole.roleType = sysRole.roleType;
                            newSysRole.packageName = "saas.web";
                            newSysRole.isDeleted = false;
                            newSysRole.save(flush: false);
                            if(privilege3.length()>1) {
                                String privilege3Final = privilege3.toString().substring(0, privilege3.length() - 1);
                                List<SysPrivilege> sysPrivilegeList = SysPrivilege.findAll("from SysPrivilege s where s.id in (" + privilege3Final + ")");
                                for (SysPrivilege sp : sysPrivilegeList) {
                                    newSysRole.addToSysPrivileges(sp);
                                }
                            }
                        }

                        break;
                    //创建门店的店长角色
                    case 4 :
                        if ("1".equals(business)) {
                            SysRole sysRole = roleList.get(i);
                            SysRole newSysRole = new SysRole();
                            newSysRole.tenantId = tenantId;
                            newSysRole.branchId = branchId;
                            newSysRole.createAt = now;
                            newSysRole.lastUpdateAt = now;
                            newSysRole.roleCode = sysRole.roleCode;
                            newSysRole.roleName = sysRole.roleName;
                            newSysRole.createBy = sysRole.createBy;
                            newSysRole.lastUpdateBy = sysRole.lastUpdateBy;
                            newSysRole.roleType = sysRole.roleType;
                            newSysRole.packageName = "saas.web";
                            newSysRole.isDeleted = false;
                            newSysRole.save(flush: false);
                            if(privilege4.length()>1) {
                                String privilege4Final = privilege4.toString().substring(0, privilege4.length() - 1);
                                List<SysPrivilege> sysPrivilegeList = SysPrivilege.findAll("from SysPrivilege s where s.id in (" + privilege4Final + ")");
                                for (SysPrivilege sp : sysPrivilegeList) {
                                    newSysRole.addToSysPrivileges(sp);
                                }
                            }
                        }

                        break;
                    //创建门店的区域经理角色
                    /*case 5 :
                        SysRole sysRole = roleList.get(i);
                        SysRole newSysRole = new SysRole();
                        newSysRole.tenantId = tenantId;
                        newSysRole.branchId = branchId;
                        newSysRole.createAt = now;
                        newSysRole.lastUpdateAt = now;
                        newSysRole.roleCode = sysRole.roleCode;
                        newSysRole.roleName = sysRole.roleName;
                        newSysRole.createBy = sysRole.createBy;
                        newSysRole.lastUpdateBy = sysRole.lastUpdateBy;
                        newSysRole.roleType = sysRole.roleType;
                        newSysRole.packageName = "saas.web";
                        newSysRole.isDeleted = false;
                        newSysRole.save(flush: false);
                        if(privilege5.length()>1) {
                            String privilege5Final = privilege5.toString().substring(0, privilege5.length() - 1);
                            List<SysPrivilege> sysPrivilegeList = SysPrivilege.findAll("from SysPrivilege s where s.id in (" + privilege5Final + ")");
                            for (SysPrivilege sp : sysPrivilegeList) {
                                newSysRole.addToSysPrivileges(sp);
                            }
                        }
                        break;*/
                }
            }
            r.isSuccess = true;
            r.message = "角色数据初始化成功";
        } catch (Exception e){
            r.isSuccess = false;
            r.message = "角色数据初始化失败";
            r.error = e.message;
            LogUtil.logError("用户 loginName:${sysUser != null ? sysUser.loginName : '未知'} - tenantId:${tenantId} - branchId:${branchId} 角色初始化失败 - ${e.message}");
        }
        return r;
    }

    /**
     * 初始化商户购买商品数据
     * @param tenantGoods
     * @return
     */
//    public ApiRest saveTenantGoods(TenantGoods tenantGoods) {
//        ApiRest r = new ApiRest();
//        try {
//            if (tenantGoods != null) {
//                tenantGoods.limitDate = new java.sql.Date(DateUtils.getSpace(Integer.parseInt(PropertyUtils.getDefault("limitDate"))).getTime());
//                if (tenantGoods.validate()) {
//                    tenantGoods.save();
//                    r.isSuccess = true;
//                    r.message = "商户购买商品初始化成功";
//                } else {
//                    StringBuffer error = new StringBuffer();
//                    tenantGoods.errors.allErrors.each {
//                        error.append(it);
//                    }
//                    r.isSuccess = false;
//                    r.message = "商户购买商品数据初始化失败";
//                    r.error = error.toString();
//                    LogUtil.logError("商户 tenantId:${tenantGoods.tenantId} - branchId:${tenantGoods.branchId} - goodsId:${tenantGoods.goodsId} 购买商品初始化失败 - ${error.toString()}");
//                }
//            } else {
//                r.isSuccess = false;
//                r.message = "商户购买商品数据无效";
//                LogUtil.logError("商户购买商品初始化失败 - 初始化数据无效}");
//            }
//        } catch(Exception e) {
//            r.isSuccess = false;
//            r.message = "商户购买商品初始化失败";
//            r.message = e.message;
//            LogUtil.logError("商户 ${tenantGoods != null ? ('tenantId:'+tenantGoods.tenantId+' - branchId:'+tenantGoods.branchId+' - goodsId:'+tenantGoods.goodsId) : '未知'} 购买商品初始化失败 - ${e.message}");
//        }
//        return r;
//    }
//
//    /**
//     * 初始化微信数据
//     * @param wxWechatInfo
//     * @return
//     */
//    public ApiRest saveWechat(WxWechatInfo wxWechatInfo) {
//        ApiRest r = new ApiRest();
//        try {
//            if (wxWechatInfo != null) {
//                wxWechatInfo.token = UUIDUtil.generateUUIDBy32();
//                wxWechatInfo.isDefault = true;
//                if (wxWechatInfo.validate()) {
//                    wxWechatInfo.save();
//                    r.isSuccess = true;
//                    r.message = "微信初始化成功";
//                } else {
//                    StringBuffer error = new StringBuffer();
//                    wxWechatInfo.errors.allErrors.each {
//                        error.append(it);
//                    }
//                    r.isSuccess = false;
//                    r.message = "微信初始化失败";
//                    r.error = error.toString();
//                    LogUtil.logError("微信初始化失败 - userId:${wxWechatInfo.userId} - name:${wxWechatInfo.name} - ${error.toString()}");
//                }
//            } else {
//                r.isSuccess = false;
//                r.message = "微信数据无效";
//                LogUtil.logError("微信初始化失败 - 初始化数据无效}");
//            }
//        } catch (Exception e) {
//            r.isSuccess = false;
//            r.message = "微信初始化失败";
//            r.error = e.message;
//            LogUtil.logError("微信初始化失败 - ${wxWechatInfo != null ? ('userId:'+wxWechatInfo.userId+' - name:'+wxWechatInfo.name) : '未知'} - ${e.message}");
//        }
//        return r;
//    }
//
//    /**
//     * 获取新的员工编码
//     * @param tenantId
//     * @return
//     */
//    public String newEmployeeCode(BigInteger tenantId, String business) {
//        String newCode = null;
//        List l = null;
//        if ("1".equals(business)) {
//            l = Employee.executeQuery("select max(code) from Employee where tenantId = ?", tenantId);
//        } else if ("2".equals(business)) {
//            l = Employee.retail.executeQuery("select max(code) from Employee where tenantId = ?", tenantId);
//        }
//        if (l != null && !l.isEmpty()) {
//            String maxCode = (String)l.get(0);
//            newCode = SerialNumberGenerate.nextSerialNumber(4, maxCode);
//        }
//        return newCode;
//    }

}
