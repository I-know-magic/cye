package api

import org.apache.commons.lang.StringUtils
import org.grails.web.json.JSONObject
import api.common.ApiConfig
import api.common.ApiConstants
import api.util.ApiBaseServiceUtils
import api.common.ApiRest
import api.util.ApiJsonUtils
import api.util.ApiWebSecurityUtils
import api.util.ApiWebUtils

/**
 * 认证工具类
 * Created by lvpeng on 2015/4/23.
 */
public class AuthApi extends ApiBaseServiceUtils {

    /**
     * 统一登录方法
     * @param loginName 帐号
     * @param loginPass 密码
     * @param ip 用户ip地址
     * @param sessionId Session Id
     * @param tenantCode 商户号
     * @param userType 用户类型
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    private static ApiRest _login(String loginName, String loginPass, String ip, String sessionId, String tenantCode, Integer userType) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("loginName",loginName);
        m.put("loginPass",loginPass);
        m.put("userType",String.valueOf(userType));
        m.put("sessionId",sessionId);
        m.put("lastLoginIp",ip);
        m.put("tenantCode",tenantCode);
        String r = ApiWebUtils.doGet(ApiConfig.AUTH_LOGIN_URL, m);
        ApiRest rest = new ApiRest(ApiJsonUtils.json2Map(r));
        if (rest.getResult().equals(ApiConstants.REST_RESULT_SUCCESS)) {
            List<String> authorities = new ArrayList<String>();
            for (Integer rId : (List<Integer>)rest.getData()) {
                if (rId != null && rId.intValue() != 0) {
                    authorities.add("ROLE_" + rId);
                }
            }
            try {
                ApiWebSecurityUtils.Auth(loginName, authorities, sessionId);
            } catch (Exception e) {
                throw new Exception("登录授权出错：" + e.getMessage() + "。可能没有配置spring-security。")
            }

        }
        return rest;
    }

    /**
     * 商户登录认证
     * @param loginName 帐号
     * @param loginPass 密码
     * @param ip 用户ip地址
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     */
    public static ApiRest tenantLogin(String loginName, String loginPass, String ip, String sessionId) throws IOException, ClassNotFoundException {
        return _login(loginName, loginPass, ip, sessionId, null, ApiConstants.USER_TYPE_TENANT);
    }

    /**
     * 代理商登录认证
     * @param loginName 帐号
     * @param loginPass 密码
     * @param ip 用户ip地址
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     */
    public static ApiRest agentLogin(String loginName, String loginPass, String ip, String sessionId) throws IOException, ClassNotFoundException {
        return _login(loginName, loginPass, ip, sessionId, null, ApiConstants.USER_TYPE_AGENT);
    }

    /**
     * 商户员工登录认证
     * @param loginName 帐号
     * @param loginPass 密码
     * @param ip 用户ip地址
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     */
    public static ApiRest tenantEmployeeLogin(String loginName, String loginPass, String ip, String sessionId, String tenantCode) throws IOException, ClassNotFoundException {
        return _login(loginName, loginPass, ip, sessionId, tenantCode, ApiConstants.USER_TYPE_TENANT_EMPLOYEE);
    }

    /**
     * 运维登录认证
     * @param loginName 帐号
     * @param loginPass 密码
     * @param ip 用户ip地址
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     */
    public static ApiRest operationLogin(String loginName, String loginPass, String ip, String sessionId) throws IOException, ClassNotFoundException {
        return _login(loginName, loginPass, ip, sessionId, null, ApiConstants.USER_TYPE_OPERATION);
    }

    /**
     * 通用登录方法，不验证登录用户类型
     * @param loginName 帐号
     * @param loginPass 密码
     * @param ip 用户ip地址
     * @param sessionId Session Id
     * @return ApiRest
     */
    public static ApiRest generalLogin(String loginName, String loginPass, String ip, String sessionId) {
        return _login(loginName, loginPass, ip, sessionId, null, ApiConstants.USER_TYPE_GENERAL);
    }

    /**
     * 密码重置
     * @param userId 用户Id
     * @param newPass 新密码
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest resetPassword(BigInteger userId, String newPass) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("newPass",newPass);
        String r = ApiWebUtils.doGet(ApiConfig.RESET_PASSWORD_URL, m);
        return new ApiRest(ApiJsonUtils.json2Map(r));
    }

    @Deprecated
    public static ApiRest resetPassword(int userId, String newPass) throws IOException, ClassNotFoundException {
        return resetPassword(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))), newPass);
    }

    /**
     * 修改密码
     * @param userId 用户Id
     * @param oldPass 旧密码
     * @param newPass 新密码
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest changePassword(BigInteger userId, String oldPass, String newPass) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("oldPass",oldPass);
        m.put("newPass",newPass);
        String r = ApiWebUtils.doGet(ApiConfig.CHANGE_PASSWORD_URL, m);
        return new ApiRest(ApiJsonUtils.json2Map(r));
    }
    @Deprecated
    public static ApiRest changePassword(int userId, String oldPass, String newPass) throws IOException, ClassNotFoundException {
        return changePassword(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))), oldPass, newPass);
    }

    /**
     * 登出
     * @param userId 用户Id
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest logout(String sessionId) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("sessionId",sessionId);
        String r = ApiWebUtils.doGet(ApiConfig.LOGOUT_URL, m);
        ApiRest rest = new ApiRest(ApiJsonUtils.json2Map(r));
        return rest
    }
    @Deprecated
    public static ApiRest logout(BigInteger userId, String sessionId) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("sessionId",sessionId);
        String r = ApiWebUtils.doGet(ApiConfig.LOGOUT_URL, m);
        return new ApiRest(ApiJsonUtils.json2Map(r));
    }
    @Deprecated
    public static ApiRest logout(int userId, String sessionId) throws IOException, ClassNotFoundException {
        return logout(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))), sessionId);
    }

    /**
     * 用户绑定手机
     * @param userId 用户Id
     * @param number 电话号码
     * @param authCode 验证码
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest bindMobile(String userId, String number, String authCode, String sessionId) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("number",String.valueOf(number));
        m.put("authCode",String.valueOf(authCode));
        m.put("sessionId",sessionId);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_MOBILE_URL, m);
        return new ApiRest(ApiJsonUtils.json2Map(r));
    }
    /**
     * 用户绑定手机
     * @param userId 用户Id
     * @param number 电话号码
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest bindMobile(String userId, String number) throws IOException, ClassNotFoundException {
        return bindMobile(userId, number, "-1", "-1");
    }

    /**
     * 用户绑定微信
     * @param userId 用户Id
     * @param wechatId 微信号
     * @param sessionId Session Id
     * @return ApiRest
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static ApiRest bindWechat(String userId, String wechatId, String sessionId) throws IOException, ClassNotFoundException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("wechatId",String.valueOf(wechatId));
        m.put("sessionId",sessionId);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_WECHAT_URL, m);
        return new ApiRest(ApiJsonUtils.json2Map(r));
    }

    /**
     * 根据id查询用户信息，支持批量查询
     * userIds以英文逗号分隔，满足where id in (userIds)的格式要求
     * @param userIds 用户Ids
     * @return ApiRest
     */
    public static ApiRest listSysUser(String userIds) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("ids",String.valueOf(userIds));
        return restGet(ApiConfig.USER_LIST_URL, m);
    }

    /**
     * 设置用户启用/禁用状态，未激活的用户不可进行此操作
     * @param userId 用户Id
     * @param isEnabled 启用/禁用状态
     * @return ApiRest
     */
    public static ApiRest enableSysUser(BigInteger userId, boolean isEnabled) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("isEnabled",String.valueOf(isEnabled));
        return restGet(ApiConfig.USER_SET_ENABLED_URL, m);
    }

    /**
     * 修改用户名
     * @param userId 用户Id
     * @param name 用户名
     * @return ApiRest
     */
    public static ApiRest saveUserName(BigInteger userId, String name) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        m.put("name",String.valueOf(name));
        return restGet(ApiConfig.USER_SET_NAME_URL, m);
    }

    /**
     * 删除用户帐号
     * @param userId 用户Id
     * @return ApiRest
     */
    public static ApiRest deleteSysUser(BigInteger userId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        return restGet(ApiConfig.USER_DELETE_URL, m);
    }

    /**
     * 查询角色列表
     * @param packageName 子系统默认包名，不可为空
     * @param tenantId 商户id，可为空
     * @param branchId 门店id，可为空
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest listSysRole(String packageName, BigInteger tenantId, BigInteger branchId, BigInteger sysUserId,
                                   Integer offset, Integer rows, String param) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("packageName",String.valueOf(packageName));
        if(tenantId != null) {
            m.put("tenantId", String.valueOf(tenantId));
        }
        if(branchId != null) {
            m.put("branchId", String.valueOf(branchId));
        }
        if(sysUserId != null) {
            m.put("sysUserId", String.valueOf(sysUserId));
        }
        if (StringUtils.isNotEmpty(param)) {
            m.put("param", param);
        }
        if (offset != null) {
            m.put("offset", String.valueOf(offset))
        }
        if (rows != null) {
            m.put("rows", String.valueOf(rows))
        }
        return restGet(ApiConfig.ROLE_LIST_URL, m);
    }

    /**
     * 查询角色列表
     * @param packageName 子系统默认包名
     * @param tenantId 商户id
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest listSysRole(String packageName, BigInteger tenantId, Integer offset, Integer rows) {
        return listSysRole(packageName, tenantId, null, null, offset, rows, null);
    }

    /**
     * 查询角色列表，不适用于多租户的系统
     * @param packageName 子系统默认包名
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest listSysRole(String packageName, Integer offset, Integer rows) {
        return listSysRole(packageName, null, null, null, offset, rows, null);
    }

    /**
     * 查询角色列表，不适用于多租户的系统
     * @param packageName 子系统默认包名
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest listSysRole(String packageName, Integer offset, Integer rows, String param) {
        return listSysRole(packageName, null, null, null, offset, rows, param);
    }

    /**
     * 查询角色列表，不适用于多租户的系统
     * @param packageName 子系统默认包名
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest listSysRole(String packageName, BigInteger sysUserId, Integer offset, Integer rows, String param) {
        return listSysRole(packageName, null, null, sysUserId, offset, rows, param);
    }

    /**
     * 查询角色列表，不适用于多租户的系统
     * @param packageName 子系统默认包名
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest listSysRole(String packageName, BigInteger sysUserId) {
        return listSysRole(packageName, null, null, sysUserId, null, null, null);
    }

    /**
     * 保存角色信息
     * @param role JSON格式的角色信息(SysRole as JSON)
     * @return ApiRest
     */
    public static ApiRest saveSysRole(JSONObject role) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("role",String.valueOf(role));
        return restGet(ApiConfig.ROLE_SAVE_URL, m);
    }

    /**
     * 查询角色信息
     * @param tenantId 商户Id
     * @param roleId 角色Id
     * @return ApiRest
     */
    public static ApiRest findSysRole(BigInteger tenantId, BigInteger roleId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("tenantId",String.valueOf(tenantId));
        m.put("roleId",String.valueOf(roleId));
        return restGet(ApiConfig.ROLE_FIND_URL, m);
    }

    /**
     * 查询角色信息
     * @param roleId 角色Id
     * @return ApiRest
     */
    public static ApiRest findSysRole(BigInteger roleId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("roleId",String.valueOf(roleId));
        return restGet(ApiConfig.ROLE_FIND_URL, m);
    }

    /**
     * 删除角色信息
     * @param tenantId 商户Id
     * @param roleId 角色Id
     * @return ApiRest
     */
    public static ApiRest deleteSysRole(BigInteger tenantId, BigInteger roleId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("tenantId",String.valueOf(tenantId));
        m.put("roleId",String.valueOf(roleId));
        ApiRest r = restGet(ApiConfig.ROLE_DELETE_URL, m);
        ApiWebSecurityUtils.loadResource(r, String.valueOf(tenantId));
        return r;
    }

    /**
     * 删除角色信息
     * @param roleId 角色Id
     * @return ApiRest
     */
    public static ApiRest deleteSysRole(BigInteger roleId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("roleId",String.valueOf(roleId));
        ApiRest r = restGet(ApiConfig.ROLE_DELETE_URL, m);
        ApiWebSecurityUtils.loadResource(r, null);
        return r;
    }

    /**
     * 查询角色权限信息
     * @param tenantId 商户Id
     * @param roleId 角色Id
     * @return ApiRest
     */
    public static ApiRest listSysRolePrivilege(BigInteger tenantId, BigInteger roleId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("tenantId",String.valueOf(tenantId));
        m.put("roleId",String.valueOf(roleId));
        return restGet(ApiConfig.ROLE_LIST_PRIVILEGE_URL, m);
    }

    /**
     * 查询角色权限信息
     * @param roleId 角色Id
     * @return
     */
    public static ApiRest listSysRolePrivilege(BigInteger roleId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("roleId",String.valueOf(roleId));
        return restGet(ApiConfig.ROLE_LIST_PRIVILEGE_URL, m);
    }

    /**
     * 查询指定子系统的功能权限列表
     * @param packageName 系统包名
     * @return ApiRest
     */
    public static ApiRest listPrivilege(String packageName) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("packageName",String.valueOf(packageName));
        return restGet(ApiConfig.ROLE_LIST_PRIVILEGE_URL, m);
    }

    /**
     * 保存角色权限信息
     * @param tenantId 商户Id
     * @param roleId 角色Id
     * @param privilegeIds 权限id列表，以逗号分隔
     * @return ApiRest
     */
    public static ApiRest saveSysRolePrivilege(BigInteger tenantId, BigInteger roleId, String privilegeIds) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("tenantId",String.valueOf(tenantId));
        m.put("roleId",String.valueOf(roleId));
        m.put("ids",String.valueOf(privilegeIds));
        ApiRest r = restGet(ApiConfig.ROLE_SAVE_PRIVILEGE_URL, m);
        ApiWebSecurityUtils.loadResource(r, String.valueOf(tenantId));
        return r;
    }

    /**
     * 保存角色权限信息
     * @param roleId 角色Id
     * @param privilegeIds 权限id列表，以逗号分隔
     * @return ApiRest
     */
    public static ApiRest saveSysRolePrivilege(BigInteger roleId, String privilegeIds) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("roleId",String.valueOf(roleId));
        m.put("ids",String.valueOf(privilegeIds));
        ApiRest r = restGet(ApiConfig.ROLE_SAVE_PRIVILEGE_URL, m);
        ApiWebSecurityUtils.loadResource(r, null);
        return r;
    }

    /**
     * 获取对应系统的权限角色（oauth2）
     * @param packageName 系统包名
     * @return ApiRest
     * @throws IOException
     */
    public static ApiRest loadResourceDefine(String packageName) throws IOException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("packageName", packageName);
        String r = ApiWebUtils.doGet(ApiConfig.LOAD_RESOURCE_DEFINE_URL, m);
        return new ApiRest(r);
    }
    /**
     * 获取对应系统的权限角色（oauth2）
     * @param packageName 系统包名
     * @param tenantId 商户Id
     * @return ApiRest
     * @throws IOException
     */
    public static ApiRest loadResourceDefine(String packageName, String tenantId) throws IOException {
        Map<String,String> m = new HashMap<String,String>();
        m.put("packageName", packageName);
        m.put("tenantId", tenantId);
        String r = ApiWebUtils.doGet(ApiConfig.LOAD_RESOURCE_DEFINE_URL, m);
        return new ApiRest(r);
    }

    /**
     * 向绑定邮箱发送验证信息
     * @param userId 用户Id
     * @param email 邮箱
     * @param callback 回调地址（发送到用户邮箱的地址）
     * @return ApiRest
     */
    public static ApiRest bindEmail(String userId, String email, String callback) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("email", email);
        m.put("id", String.valueOf(userId));
        m.put("callback", callback);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_EMAIL_URL, m);
        return new ApiRest(r);
    }

    /**
     * 向绑定qq的邮箱发送验证信息
     * @param userId 用户Id
     * @param qq QQ号码
     * @param callback 回调地址（发送到用户QQ邮箱的地址）
     * @return ApiRest
     */
    public static ApiRest bindQq(String userId, String qq, String callback) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("qq", qq);
        m.put("id", String.valueOf(userId));
        m.put("callback", callback);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_QQ_URL, m);
        return new ApiRest(r);
    }

    /**
     * 验证绑定信息
     * @param v 绑定信息
     * @return ApiRest
     */
    public static ApiRest verifyBind(String v) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("v", v);
        String r = ApiWebUtils.doGet(ApiConfig.VERIFY_BIND_URL, m);
        return new ApiRest(r);
    }

    /**
     * 判断邮箱是否唯一
     * @param value 邮箱地址
     * @return ApiRest
     */
    public static boolean bindEmailUnique(String value) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("value", value);
        m.put("type", ApiConstants.USER_BIND_TYPE_EMAIL);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_UNIQUE_URL, m);
        return new ApiRest(r).getData().toString().equals("true");
    }

    /**
     * 判断QQ是否唯一
     * @param value QQ号码
     * @return ApiRest
     */
    public static boolean bindQqUnique(String value) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("value", value);
        m.put("type", ApiConstants.USER_BIND_TYPE_QQ);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_UNIQUE_URL, m);
        return new ApiRest(r).getData().toString().equals("true");
    }

    /**
     * 判断手机号是否唯一
     * @param value 电话号码
     * @return ApiRest
     */
    public static boolean bindMobileUnique(String value) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("value", value);
        m.put("type", ApiConstants.USER_BIND_TYPE_MOBILE);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_UNIQUE_URL, m);
        return new ApiRest(r).getData().toString().equals("true");
    }

    /**
     * 判断微信号是否唯一
     * @param value 微信号
     * @return ApiRest
     */
    public static boolean bindWechatUnique(String value) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("value", value);
        m.put("type", ApiConstants.USER_BIND_TYPE_WECHAT);
        String r = ApiWebUtils.doGet(ApiConfig.BIND_UNIQUE_URL, m);
        return new ApiRest(r).getData().toString().equals("true");
    }

    /**
     * 解绑邮箱
     * @param userId 用户Id
     * @return ApiRest
     */
    public static ApiRest removeEmailBind(BigInteger userId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId", String.valueOf(userId));
        m.put("type", ApiConstants.USER_BIND_TYPE_EMAIL);
        String r = ApiWebUtils.doGet(ApiConfig.REMOVE_BIND_URL, m);
        return new ApiRest(r);
    }
    @Deprecated
    public static ApiRest removeEmailBind(int userId) {
        return removeEmailBind(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))));
    }

    /**
     * 解绑qq
     * @param userId 用户Id
     * @return ApiRest
     */
    public static ApiRest removeQqBind(BigInteger userId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId", String.valueOf(userId));
        m.put("type", ApiConstants.USER_BIND_TYPE_QQ);
        String r = ApiWebUtils.doGet(ApiConfig.REMOVE_BIND_URL, m);
        return new ApiRest(r);
    }
    @Deprecated
    public static ApiRest removeQqBind(int userId) {
        return removeQqBind(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))));
    }

    /**
     * 解绑手机号
     * @param userId 用户Id
     * @return ApiRest
     */
    public static ApiRest removeMobileBind(BigInteger userId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId", String.valueOf(userId));
        m.put("type", ApiConstants.USER_BIND_TYPE_MOBILE);
        String r = ApiWebUtils.doGet(ApiConfig.REMOVE_BIND_URL, m);
        return new ApiRest(r);
    }
    @Deprecated
    public static ApiRest removeMobileBind(int userId) {
        return removeMobileBind(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))));
    }

    /**
     * 解绑微信号
     * @param userId 用户Id
     * @return ApiRest
     */
    public static ApiRest removeWechatBind(BigInteger userId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId", String.valueOf(userId));
        m.put("type", ApiConstants.USER_BIND_TYPE_WECHAT);
        String r = ApiWebUtils.doGet(ApiConfig.REMOVE_BIND_URL, m);
        return new ApiRest(r);
    }
    @Deprecated
    public static ApiRest removeWechatBind(int userId) {
        return removeWechatBind(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))));
    }

    /**
     * 获取最大RoleCode
     * @param packageName 系统包名
     * @return ApiRest
     */
    public static ApiRest maxRoleCode(String packageName) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("packageName", packageName);
        String r = ApiWebUtils.doGet(ApiConfig.MAX_ROLE_CODE_URL, m);
        return new ApiRest(r);
    }
    /**
     * 获取最大RoleCode
     * @param packageName 系统包名
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest maxRoleCode(String packageName, BigInteger tenantId, BigInteger branchId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("packageName", packageName);
        m.put("tenantId", tenantId != null ? String.valueOf(tenantId) : null);
        m.put("branchId", branchId != null ? String.valueOf(branchId) : null);
        String r = ApiWebUtils.doGet(ApiConfig.MAX_ROLE_CODE_URL, m);
        return new ApiRest(r);
    }

    /**
     * 保存用户角色
     * @param userId 用户Id
     * @param roleIds 角色Ids，多个用英文逗号分割
     * @return ApiRest
     */
    public static ApiRest saveSysUserRole(BigInteger userId, String roleIds) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId", String.valueOf(userId));
        m.put("roleIds", roleIds);
        String r = ApiWebUtils.doGet(ApiConfig.SAVE_ROLE_URL, m);
        ApiRest rest = new ApiRest(r);
        ApiWebSecurityUtils.loadResource(rest, null);
        return rest;
    }
    @Deprecated
    public static ApiRest saveSysUserRole(int userId, String roleIds) {
        return saveSysUserRole(BigInteger.valueOf(Long.valueOf(String.valueOf(userId))), roleIds);
    }

    /**
     * 用户全部角色
     * @param userId 用户Id
     * @return ApiRest
     */
    public static ApiRest listSysUserRole(BigInteger userId) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userId",String.valueOf(userId));
        return restGet(ApiConfig.LIST_USER_ROLE_URL, m);
    }
    @Deprecated
    public static ApiRest listSysUserRole(int userId) {
        return listSysUserRole(BigInteger.valueOf(Long.valueOf(userId)));
    }

    /**
     * 角色名唯一判断
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @param roleName 角色名称
     * @return ApiRest
     */
    public static boolean roleNameUnique(BigInteger tenantId, BigInteger branchId, String roleName) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("tenantId", tenantId != null ? String.valueOf(tenantId) : null);
        m.put("branchId", branchId != null ? String.valueOf(branchId) : null);
        m.put("roleName", roleName);
        ApiRest r = restGet(ApiConfig.ROLE_UNIQUE_URL, m);
        if (r.isSuccess) {
            if (r.data != null && r.data.toString().equals("true")) {
                return true;
            }
        }
        return false;
    }

    /**
     * 查询pos权限
     * @param userIds 用户Ids，多个用英文逗号分割
     * @return ApiRest
     */
    public static ApiRest posRes(String userIds) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("userIds", userIds);
        return restGet(ApiConfig.POS_RES_URL, m);
    }

    /**
     * 微信扫码登录获取登录token
     * @return ApiRest
     */
    public static ApiRest wechatInitToken() {
        Map<String,String> m = new HashMap<String,String>();
        m.put("type", "1");
        return restGet(ApiConfig.WECHAT_INIT_TOKEN_URL, m);
    }

    /**
     * 微信扫码注册获取token
     * @return
     */
    public static ApiRest wechatRegisterToken() {
        Map<String,String> m = new HashMap<String,String>();
        m.put("type", "2");
        return restGet(ApiConfig.WECHAT_INIT_TOKEN_URL, m);
    }

    /**
     * 微信登录验证
     * @param token 验证码
     * @param sessionId Session Id
     * @param ip 用户IP地址
     * @return ApiRest
     */
    public static ApiRest wechatLoginVerify(String token, String sessionId, String ip) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("token", token);
        m.put("sessionId", sessionId);
        m.put("ip", ip);
        return restGet(ApiConfig.WECHAT_LOGIN_VERIFY_URL, m);
    }
}
