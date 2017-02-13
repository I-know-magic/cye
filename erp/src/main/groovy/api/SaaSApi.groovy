package api

import org.grails.web.json.JSONObject
import api.common.ApiConfig
import api.common.ApiConstants
import api.util.ApiBaseServiceUtils
import api.common.ApiRest
import api.util.ApiWebSecurityUtils
import api.util.ApiWebUtils

/**
 * Saas服务接口访问功能类
 * Created by liuhongbin1 on 2015/6/24.
 */
public class SaaSApi extends ApiBaseServiceUtils {

    /**
     * 通过商户ID查询商户信息及当前使用的软件产品信息
     * @param tenantId 商户Id
     * @return ApiRest
     */
    public static ApiRest findTenantById(BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("id", tenantId.toString());
        return restGet(ApiConfig.SAAS_FIND_TENANT_URL, m);
    }

    /**
     * 通过绑定的微信号查询商户信息及当前使用的软件产品信息
     * @param wechat 微信号
     * @return ApiRest
     */
    public static ApiRest findTenantByWechat(String wechat) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("wechat", wechat);
        return restGet(ApiConfig.SAAS_FIND_TENANT_URL, m);
    }

    /**
     * 通过商户CODE查询商户信息及当前使用的软件产品信息
     * @param code 商户号
     * @return ApiRest
     */
    public static ApiRest findTenantByCode(String code) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("code", code);
        return restGet(ApiConfig.SAAS_FIND_TENANT_URL, m);
    }

    /**
     * 通过商户微信公众号的OriginalId查询商户信息
     * @param originalId 微信公众号
     * @return ApiRest
     */
    public static ApiRest findTenantByTenantWechat(String originalId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("originalId", originalId);
        return restGet(ApiConfig.SAAS_FIND_TENANT_URL, m);
    }

    /**
     * 查询可购买的软件信息
     * @return ApiRest
     */
    public static ApiRest listProduct() {
        Map<String, String> m = new HashMap<String, String>();
        return restGet(ApiConfig.SAAS_PRODUCT_LIST_URL, m);
    }

    /**
     * 给商户添加门店时，同时给该门店开通软件试用期
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest addBranchProduct(BigInteger tenantId, BigInteger branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("add", "1");
        m.put("tenantId", String.valueOf(tenantId));
        m.put("branchId", String.valueOf(branchId));
        return restGet(ApiConfig.SAAS_BRANCH_PRODUCT_URL, m);
    }

    /**
     * 删除商户门店时，同时删除该门店的软件购买信息
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest deleteBranchProduct(BigInteger tenantId, BigInteger branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("delete", "1");
        m.put("tenantId", String.valueOf(tenantId));
        m.put("branchId", String.valueOf(branchId));
        return restGet(ApiConfig.SAAS_BRANCH_PRODUCT_URL, m);
    }

    /**
     * 查询指定门店的软件使用期限
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest findBranchLimitDate(BigInteger tenantId, BigInteger branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("limitDate", "1");
        m.put("tenantId", String.valueOf(tenantId));
        m.put("branchId", String.valueOf(branchId));
        return restGet(ApiConfig.SAAS_BRANCH_PRODUCT_URL, m);
    }

    /**
     * 保存商户信息
     * @param tenant 门店 JSONObject 对象
     * @return ApiRest
     */
    public static ApiRest saveTenant(JSONObject tenant) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("tenant",String.valueOf(tenant));
        return restGet(ApiConfig.SAAS_SAVE_TENANT_URL, m);
    }

    /**
     * 保存微信公众号信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String saveWechatInfo(Map<String,String> paramMap) {
        paramMap.put("methodKey","saveOrUpdate");
        return ApiWebUtils.doPost(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap, 0, 0);
    }

    /**
     * 更新微信公众号信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String updateWechatInfo(Map<String,String> paramMap) {
        paramMap.put("methodKey","saveOrUpdate");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap);
    }

    /**
     * 微信公众号信息列表
     * @param paramMap 微信数据
     * @return String
     */
    public static String listWechatInfo(Map<String,String> paramMap) {
        paramMap.put("methodKey","listWechatInfo");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap);
    }

    /**
     * 删除微信公众号信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String deleteWechatInfo(Map<String,String> paramMap) {
        paramMap.put("methodKey","deleteWechatInfo");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap);
    }

    /**
     * 查询微信公众号信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String findWechatInfo(Map<String,String> paramMap) {
        paramMap.put("methodKey","findWechatInfo");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap);
    }

    /**
     * 商户注册初始化微信配置
     * @param paramMap 微信数据
     * @return String
     */
    public static String initWechatInfoByTenant(Map<String,String> paramMap) {
        paramMap.put("methodKey","initWechatInfoByTenant");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap);
    }

    /**
     * 修改微信公众号信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String editByDefault(Map<String,String> paramMap) {
        paramMap.put("methodKey","editByDefault");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_INFO_URL, paramMap);
    }

    /**
     * 保存微信公众号菜单
     * @param paramMap 微信数据
     * @return String
     */
    public static String saveWechatMenu(Map<String,String> paramMap) {
        paramMap.put("methodKey","saveOrUpdate");
        return ApiWebUtils.doPost(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap, 0, 0);
    }

    /**
     * 微信公众号菜单列表
     * @param paramMap 微信数据
     * @return String
     */
    public static String listWechatMenu(Map<String,String> paramMap) {
        paramMap.put("methodKey","listWechatMenu");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap);
    }

    /**
     * 查询微信公众号菜单
     * @param paramMap 微信数据
     * @return String
     */
    public static String findWechatMenu(Map<String,String> paramMap) {
        paramMap.put("methodKey","findWechatMenu");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap);
    }

    /**
     * 查询微信公众号内链菜单
     * @param paramMap 微信数据
     * @return String
     */
    public static String findAllMenuInner(Map<String,String> paramMap) {
        paramMap.put("methodKey","findAllMenuInner");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap);
    }

    /**
     * 删除微信公众号菜单
     * @param paramMap 微信数据
     * @return String
     */
    public static String deleteWechatMenu(Map<String,String> paramMap) {
        paramMap.put("methodKey","deleteWechatMenu");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap);
    }

    /**
     * 应用菜单至微信数据库
     * @param paramMap 微信数据
     * @return String
     */
    public static String useMenuToWechat(Map<String,String> paramMap) {
        paramMap.put("methodKey","useMenuToWechat");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap);
    }

    /**
     * 更新微信公众号菜单
     * @param paramMap 微信数据
     * @return String
     */
    public static String updateWechatMenu(Map<String,String> paramMap) {
        paramMap.put("methodKey","saveOrUpdate");
        return ApiWebUtils.doPost(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap, 0, 0);
    }

    /**
     * 查询微信公众号菜单
     * @param paramMap 微信数据
     * @return String
     */
    public static String findMenuDefaultWechatInfo(Map<String,String> paramMap) {
        paramMap.put("methodKey","findMenuDefaultWechatInfo");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_MENU_URL, paramMap);
    }

    /**
     * 根据userId找到对应的所有公众号
     * @param paramMap 微信数据
     * @return String
     */
    public static String findWechatInfoListBySysUserId(Map<String,String> paramMap) {
        paramMap.put("methodKey","findWechatInfoListBySysUserId");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_REPLY_URL, paramMap);
    }

    /**
     * 查询及遍历所有微信回复配置
     * @param paramMap 微信数据
     * @return String
     */
    public static String indexWxReplyByTenant(Map<String,String> paramMap) {
        paramMap.put("methodKey","listWechatReply");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_REPLY_URL, paramMap);
    }

    /**
     * 根据ID查找微信回复配置对象
     * @param paramMap 微信数据
     * @return String
     */
    public static String editWxReplyByTenant(Map<String,String> paramMap) {
        paramMap.put("methodKey","findWechatReply");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_REPLY_URL, paramMap);
    }

    /**
     * 删除微信回复对象
     * @param paramMap 微信数据
     * @return String
     */
    public static String deleteWxReplyByTenant(Map<String,String> paramMap) {
        paramMap.put("methodKey","deleteWechatReply");
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_REPLY_URL, paramMap);
    }

    /**
     * 保存单个回复信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String saveWxReplyByTenant(Map<String,String> paramMap) {
        paramMap.put("methodKey","saveOrUpdate");
        return ApiWebUtils.doPost(ApiConfig.SAAS_WECHAT_REPLY_URL, paramMap, 0, 0);
    }

    /**
     * 修改单个回复信息
     * @param paramMap 微信数据
     * @return String
     */
    public static String updateWxReplyByTenant(Map<String,String> paramMap) {
        paramMap.put("methodKey","saveOrUpdate");
        return ApiWebUtils.doPost(ApiConfig.SAAS_WECHAT_REPLY_URL, paramMap, 0, 0);
    }

    /**
     * 初始化商户角色信息
     * @param sysUserId 用户Id
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest initTenantRole(String sysUserId, String tenantId, String branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("sysUserId", sysUserId);
        m.put("tenantId", tenantId);
        m.put("branchId", branchId);
        return restGet(ApiConfig.INIT_TENANT_ROLE_URL, m);
    }

    /**
     * 查询商户软件信息
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest findTenantGoods(String tenantId, String branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId);
        m.put("branchId", branchId);
        return restGet(ApiConfig.FIND_TENANT_GOODS_URL, m);
    }
    /**
     * 初始化商户信息
     * @param tenantId 商户Id
     * @param userid 用户Id
     * @param loginname 帐号
     * @return ApiRest
     */
    public static ApiRest initTenant(String tenantId, String userid,String loginname) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantid", tenantId);
        m.put("loginname", loginname);
        m.put("userid", userid);
        return restGet(ApiConfig.INIT_TENANT_URL, m);
    }

    /**
     * 查询用户
     * @param tenantId 商户id
     * @param branchIds 门店Ids，多个用英文逗号分割
     * @param roleCode 角色码
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest findUser(BigInteger tenantId, String branchIds, String roleCode, Integer offset, Integer rows) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId==null?null:String.valueOf(tenantId));
        m.put("branchIds", branchIds);
        m.put("roleCode", roleCode);
        m.put("offset", offset==null?null:String.valueOf(offset));
        m.put("rows", rows==null?null:String.valueOf(rows));
        return restGet(ApiConfig.FIND_USER_URL, m);
    }

    /**
     * 查询用户
     * @param tenantId 商户id
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest findUser(BigInteger tenantId, Integer offset, Integer rows) {
        return findUser(tenantId, null, null, offset, rows);
    }

    /**
     * 查询用户
     * @param tenantId 商户Id
     * @param branchIds 门店Ids，多个用英文逗号分割
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest findUser(BigInteger tenantId, String branchIds, Integer offset, Integer rows) {
        return findUser(tenantId, branchIds, null, offset, rows);
    }

    /**
     * 查询用户
     * @param tenantId 商户Id
     * @return ApiRest
     */
    public static ApiRest findUser(BigInteger tenantId) {
        return findUser(tenantId, null, null, null, null);
    }

    /**
     * 查询用户
     * @param tenantId 商户Id
     * @param branchIds 门店Ids，多个用英文逗号分割
     * @return ApiRest
     */
    public static ApiRest findUser(BigInteger tenantId, String branchIds) {
        return findUser(tenantId, branchIds, null, null, null);
    }

    /**
     * 查询门店收银员
     * @param tenantId 商户Id
     * @param branchIds 门店Ids，多个用英文逗号分割
     * @return ApiRest
     */
    public static ApiRest findCashier(BigInteger tenantId, String branchIds) {
        return findCashier(tenantId, branchIds, null, null);
    }

    /**
     * 查询门店收银员
     * @param tenantId 商户Id
     * @param branchIds 门店Ids，多个用英文逗号分割
     * @param offset 偏移量
     * @param rows 数据量
     * @return ApiRest
     */
    public static ApiRest findCashier(BigInteger tenantId, String branchIds, Integer offset, Integer rows) {
        return findUser(tenantId, branchIds, ApiConstants.ROLE_COLE_CASHIER, offset, rows);
    }

    /**
     * 查询微信消息模版
     * @param paramMap 微信数据
     * @return String
     */
    public static String findWxReplyTemplate(Map<String,String> paramMap) {
        return ApiWebUtils.doGet(ApiConfig.SAAS_WECHAT_REPLYTEMPLATE_URL, paramMap);
    }

    /**
     * 根据手机号查询用户
     * @param bindMobile 用户手机号
     * @return ApiRest
     */
    public static ApiRest findUserByBindMobile(String bindMobile) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("bindMobile", bindMobile);
        return restGet(ApiConfig.FIND_USER_ONE_URL, m);
    }

    /**
     * 通过微信号查用户
     * @param openId 微信号
     * @return ApiRest
     */
    public static ApiRest findSysUserByOpenId(String openId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("openId", openId);
        return restGet(ApiConfig.FIND_SYS_USER_BY_OPEN_ID_URL, m);
    }

    /**
     * 根据商户号查用户
     * @param tenantCode 商户号
     * @return ApiRest
     */
    public static ApiRest findSysUserByTenantCode(String tenantCode) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantCode", tenantCode);
        return restGet(ApiConfig.FIND_SYS_USER_BY_TENANT_CODE_URL, m);
    }

    /**
     * 验证用户密码是否匹配
     * @param userId 用户Id
     * @param password 用户密码
     * @return ApiRest
     */
    public static boolean verifyPassBySysUserId(BigInteger userId, String password) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("userId", String.valueOf(userId));
        m.put("password", String.valueOf(password));
        return restGet(ApiConfig.VERIFY_PASS_BY_SYS_USER_ID_URL, m).isSuccess;
    }

    /**
     * 初始化角色和员工信息
     * @param branchId 门店Id
     * @param tenantId 商户Id
     * @param tenantCode 商户号
     * @param discountAmount 优惠金额
     * @param discountRate 折扣率
     * @param createBy 创建人名称
     * @return ApiRest
     */
    public static ApiRest initBranch(BigInteger branchId, BigInteger tenantId, String tenantCode, Integer discountAmount, Integer discountRate, String createBy) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("branchId", branchId.toString());
        m.put("tenantId", tenantId.toString());
        m.put("tenantCode", tenantCode);
        m.put("discountAmount", String.valueOf(discountAmount));
        m.put("discountRate", String.valueOf(discountRate));
        m.put("createBy", createBy);
        ApiRest r = restGet(ApiConfig.INIT_BRANCH_URL, m);
        ApiWebSecurityUtils.loadResource(r, tenantId.toString());
        return r;
    }

    /**
     * 访问量记录
     * @param packageName
     * @param sessionId
     * @param remoteIp
     * @param userAgent
     * @param remark
     * @return
     */
    public static ApiRest visit(String packageName, String sessionId, String remoteIp, String userAgent, String remark) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("packageName", packageName);
        m.put("sessionId", sessionId);
        m.put("remoteIp", remoteIp);
        m.put("userAgent", userAgent);
        m.put("remark", remark);
        return restGet(ApiConfig.STAT_VISIT_URL, m);
    }

    /**
     * 保存商户收款账号信息
     * @param tenantId
     * @param alipayKey
     * @param alipayPartner
     * @param wechatPayKey
     * @param wechatPayAppid
     * @param wechatPayMchid
     * @return
     */
    public static ApiRest savePayAccount(BigInteger tenantId, String alipayKey, String alipayPartner, String wechatPayKey, String wechatPayAppid, String wechatPayMchid) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId.toString());
        m.put("alipayKey", alipayKey);
        m.put("alipayPartner", alipayPartner);
        m.put("wechatPayKey", wechatPayKey);
        m.put("wechatPayAppid", wechatPayAppid);
        m.put("wechatPayMchid", wechatPayMchid);
        return restPost(ApiConfig.SAVE_PAY_ACCOUNT_URL, m);
    }

    public static ApiRest findPayAccount(BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId.toString());
        return restGet(ApiConfig.FIND_PAY_ACCOUNT_URL, m);
    }

    /**
     * 分页查询消息列表
     * @param msgType 消息类型
     * @param offset 起始位置
     * @param rows 最大行数
     * @param sort 排序字段
     * @param order 升序/降序
     * @return
     */
    public static ApiRest listMessage(Integer msgType, Integer offset, Integer rows, String sort, String order) {
        Map<String, String> m = new HashMap<String, String>();
        if (msgType != null) {
            m.put("msgType", msgType.toString())
        }
        if (offset != null) {
            m.put("offset", offset.toString())
        }
        if (rows != null) {
            m.put("rows", rows.toString())
        }
        if (sort != null) {
            m.put("sort", sort)
        }
        if (order != null) {
            m.put("order", order)
        }
        return restGet(ApiConfig.MESSAGE_LIST_URL, m);
    }

}
