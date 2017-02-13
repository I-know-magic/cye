package api;

import api.common.ApiConfig
import api.common.ApiConstants
import api.common.ApiRest
import api.util.ApiJsonUtils
import api.util.ApiWebSecurityUtils
import api.util.ApiWebUtils;

/**
 * 注册工具类
 * Created by lvpeng on 2015/4/24.
 */
public class RegisterApi {

    /*public static void main(String[] args) {
        Map<String, String> map = new HashMap<>();
        map.put("loginName","lvpeng009");
        map.put("loginPass","lvpeng009");
        map.put("tenantName","天上人间");
        map.put("linkman","黑寡妇");
        map.put("phoneNumber","18557588599");
        ApiRest r = tenantRegisterFull(map);
        map.put("loginName","lvpeng002");
        map.put("loginPass","lvpeng002");
        map.put("agent.linkman","蝙蝠侠");
        map.put("agent.mobile","18523658745");
        map.put("agent.phoneNumber","053288887777");
        map.put("agent.formId","0");
        map.put("agent.name","青岛总代理");
        map.put("agent.provinceCode","0");
        map.put("agent.provinceName","山东");
        map.put("agent.cityCode","0");
        map.put("agent.cityName","青岛");
        map.put("agent.address","地中海一路");
        map.put("agent.scale","4");
        map.put("agent.salesArea","4");
        ApiRest r = agentRegisterFull(map);
        map.put("tenantId","121");
        map.put("tenantCode","61011067");
        map.put("branchId","33");
        map.put("linkman","什么店员2");
        map.put("phoneNumber","19632547855");
        ApiRest r = tenantEmployeeRegisterFull(map);
        map.put("loginName","lvpeng003");
        map.put("loginPass","lvpeng003");
        map.put("linkman","钢铁侠");
        map.put("phoneNumber","18547513546");
        ApiRest r = operationRegisterFull(map);
        map.put("tenantName","天上有个店");
        map.put("bindWechat","djafj@dff.com");
        map.put("loginPass","77889900");
        ApiRest r = tenantHZGRegisterFull(map);
        map.put("loginName","lvpeng5");
        map.put("loginPass","lvpeng5");
        map.put("inviteCode","71010802");
        ApiRest r = employeeHZGRegisterFull(map);
        println r.toJson();
    }*/

    /**
     * 注册统一方法
     * @param map 注册数据
     * @param type 注册用户类型
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    private static ApiRest _register(Map<String, String> map, String type) throws IOException, ClassNotFoundException {
        String r = null;
        if (type != null && "full".equals(type)) {
            r = ApiWebUtils.doGet(ApiConfig.USER_REGISTER_FULL_URL, map);
        } else {
            r = ApiWebUtils.doGet(ApiConfig.USER_REGISTER_URL, map);
        }
        ApiRest rest = new ApiRest(ApiJsonUtils.json2Map(r));
        ApiWebSecurityUtils.loadResource(rest, null);
        return rest;
    }

    /**
     * 商户注册方法（完整）
     * @param map 注册数据
     * {loginPass, tenantName, linkman, phoneNumber, business, business1, bindWechat, inviteCode[可选], createBy[可选]}
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest tenantRegisterFull(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_TENANT.toString());
        return _register(map, "full");
    }

    /**
     * 代理商注册方法（完整）
     * @param map 注册数据
     * {loginPass, agent.linkman, agent.mobile, agent.phoneNumber, agent.formId, agent.name, agent.provinceCode, agent.provinceName, agent.cityCode, agent.cityName, agent.address, agent.scale, agent.salesArea}
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest agentRegisterFull(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_AGENT.toString());
        return _register(map, "full");
    }

    /**
     * 商户员工注册方法（完整）
     * @param map 注册数据
     * {tenantId, tenantCode, branchId, linkman, phoneNumber}
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest tenantEmployeeRegisterFull(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_TENANT_EMPLOYEE.toString());
        return _register(map, "full");
    }

    /**
     * 运维人员注册方法（完整）
     * @param map 注册数据
     * {loginName, loginPass, linkman, phoneNumber}
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest operationRegisterFull(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_OPERATION.toString());
        return _register(map, "full");
    }

    /**
     * 惠掌柜商户注册方法（完整）
     * @param map 注册数据
     * {tenantName, bindWechat, loginPass}
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest tenantHZGRegisterFull(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_TENANT_HZG.toString());
        return _register(map, "full");
    }

    /**
     * 惠掌柜商户员工注册方法（完整）
     * @param map 注册数据
     * {loginName, loginPass, linkman, bindWechat, inviteCode}
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest employeeHZGRegisterFull(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_EMPLOYEE_HZG.toString());
        return _register(map, "full");
    }

    @Deprecated
    public static ApiRest tenantRegister(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_TENANT.toString());
        return _register(map, null);
    }
    @Deprecated
    public static ApiRest agentRegister(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_AGENT.toString());
        return _register(map, null);
    }
    @Deprecated
    public static ApiRest tenantEmployeeRegister(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_TENANT_EMPLOYEE.toString());
        return _register(map, null);
    }
    @Deprecated
    public static ApiRest operationRegister(Map<String, String> map) throws IOException, ClassNotFoundException {
        map.put("userType", ApiConstants.USER_TYPE_OPERATION.toString());
        return _register(map, null);
    }

    /**
     * 帐号唯一判断
     * @param loginName 帐号
     * @param tenantCode 商户号
     * @return boolean
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static boolean loginNameIsUnique(String loginName, String tenantCode) throws IOException, ClassNotFoundException {
        Map<String, String> map = new HashMap<String, String>();
        map.put("loginName", loginName);
        map.put("tenantCode", tenantCode);
        String json = ApiWebUtils.doGet(ApiConfig.LOGIN_NAME_IS_UNIQUE_URL, map);
        ApiRest r = new ApiRest(ApiJsonUtils.json2Map(json));
        if (r.getResult().equals(ApiConstants.REST_RESULT_SUCCESS) && r.getData().equals("true")) {
            return true;
        }
        return false;
    }

    /**
     * 帐号唯一判断
     * @param loginName 帐号
     * @return boolean
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static boolean loginNameIsUnique(String loginName) throws IOException, ClassNotFoundException {
        return loginNameIsUnique(loginName, null);
    }

    /**
     * 激活用户
     * @param userId 用户Id
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest activate(BigInteger userId) throws IOException, ClassNotFoundException {
        Map<String, String> map = new HashMap<String, String>();
        map.put("userId", String.valueOf(userId));
        String json = ApiWebUtils.doGet(ApiConfig.USER_ACTIVATE_URL, map);
        return new ApiRest(ApiJsonUtils.json2Map(json));
    }

    /**
     * 获得商户员工帐号
     * @param loginName 帐号
     * @param tenantCode 商户号
     * @return String
     */
    public static String tenantEmployeeLoginName(String loginName, String tenantCode) {
        return loginName + ApiConstants.TENANT_EMPLOYEE_SEPARATOR + tenantCode;
    }

    /**
     * 根绝员工帐号获得商户号
     * @param loginName 员工帐号
     * @return String
     */
    public static String getTenantCodeByTenantEmployeeLoginName(String loginName) {
        if (loginName.indexOf(ApiConstants.TENANT_EMPLOYEE_SEPARATOR) >= 0) {
            return loginName.split(ApiConstants.TENANT_EMPLOYEE_SEPARATOR)[1];
        }
        return null;
    }
}
