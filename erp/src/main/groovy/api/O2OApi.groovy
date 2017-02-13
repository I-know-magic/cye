package api

import org.springframework.util.StringUtils
import api.common.ApiConfig
import api.util.ApiBaseServiceUtils
import api.common.ApiRest
import api.util.ApiWebUtils

/**
 * O2O服务接口访问功能类
 * Created by liuhongbin1 on 2015/6/26.
 */
class O2OApi extends ApiBaseServiceUtils {

    /**
     * 查询门店列表
     * @param tenantId 商户id，不可为空
     * @param code 门店编码，支持模糊查询，可为空
     * @param name 门店名称，支持模糊查询，可为空
     * @return ApiRest
     */
    public static ApiRest listBranch(BigInteger tenantId, String code, String name) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId.toString());
        if(!StringUtils.isEmpty(code)) {
            m.put("code", code);
        }
        if(!StringUtils.isEmpty(name)) {
            m.put("name", name);
        }
        return restGet(ApiConfig.O2O_BRANCH_LIST_URL, m);
    }

    /**
     * 查询门店列表
     * @param tenantId 商户id
     * @return ApiRest
     */
    public static ApiRest listBranch(BigInteger tenantId) {
        return listBranch(tenantId, null, null);
    }

    /**
     * 查询指定商户的门店树，数据按总部-区域1-门店11-门店12...门店1N-区域2-门店21...门店2N...顺序排列
     * @param tenantId 商户Id
     * @return ApiRest
     */
    public static ApiRest branchTree(BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId.toString());
        return restGet(ApiConfig.O2O_BRANCH_TREE_URL, m);
    }

    /**
     * 查询指定门店当前启用的菜牌
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @param isOnline 线上或线下
     * @return ApiRest
     */
    public static ApiRest findMenuCurrent(BigInteger tenantId, BigInteger branchId, Boolean isOnline) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId.toString());
        m.put("branchId", branchId.toString());
        if(isOnline) {
            return restGet(ApiConfig.O2O_ONLINE_MENU_CURRENT_URL, m);
        } else {
            return ApiRest.INVALID_PARAMS_ERROR
        }
    }

    /**
     * POS下单
     * @param json
     * @return ApiRest
     */
    public static String saveTakeoutOrderByTelPOS(Map m) {
        return ApiWebUtils.doPost(ApiConfig.O2O_SAVE_TAKEOUT_ORDER_BY_TEL_POS_URL, m, 0, 0);
    }

    /**
     * POS订单状态修改
     * @param orderStatusString
     * @return ApiRest
     */
    public static String changeOrderStatusByTelPOS(Map m) {
        return ApiWebUtils.doGet(ApiConfig.O2O_CHANGE_ORDER_STATUS_BY_TEL_POS_URL, m);
    }

    /**
     * POS支付状态修改
     * @param payStatusString
     * @return ApiRest
     */
    public static String changePayStatusByTelPOS(Map m) {
        return ApiWebUtils.doGet(ApiConfig.O2O_CHANGE_PAY_STATUS_BY_TEL_POS_URL, m);
    }

    /**
     * POS根据时间范围选择所有订单
     * @param m
     * @return ApiRest
     */
    public static String listOrderInfoByTelPOS(Map m) {
        return ApiWebUtils.doGet(ApiConfig.O2O_LIST_ORDER_INFO_BY_TEL_POS_URL, m);
    }

    /**
     * POS显示订单详情
     * @param m
     * @return ApiRest
     */
    public static String showOrderDetailByTelPOS(Map m) {
        return ApiWebUtils.doGet(ApiConfig.O2O_SHOW_ORDER_DETAIL_BY_TEL_POS_URL, m);
    }

    /**
     * 会员列表
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest qryVipList(String tenantId, String branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", tenantId);
        m.put("branchId", branchId);
        return restGet(ApiConfig.O2O_VIP_QRY_VIP_LIST_URL, m);
    }

    /**
     * 会员列表
     * @param tenantId 商户Id
     * @return ApiRest
     */
    public static ApiRest qryVipList(String tenantId) {
        return qryVipList(tenantId, null);
    }

    /**
     * 删除会员，多id用英文逗号分割
     * @param ids 会员Ids
     * @return ApiRest
     */
    public static ApiRest delVips(String ids) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("ids", ids);
        return restGet(ApiConfig.O2O_VIP_DEL_VIPS_URL, m);
    }

    /**
     * 添加会员
     * @param m branchId,vipName,sex(1:男,2:女),birthday(yyyy-MM-dd),phone,email,status[0:正常,1:停用],[vipCode]
     * @return ApiRest
     */
    public static ApiRest addVip(Map<String, String> m) {
        return restGet(ApiConfig.O2O_VIP_ADD_VIP_URL, m);
    }

    /**
     * 修改会员
     * @param m id,branchId,vipName,sex(1:男,2:女),birthday(yyyy-MM-dd),phone,email,status[0:正常,1:停用],[vipCode]
     * @return ApiRest
     */
    public static ApiRest saveVip(Map<String, String> m) {
        return restGet(ApiConfig.O2O_VIP_SAVE_VIP_URL, m);
    }

    /**
     * 根据手机号获取会员
     * @param phone 电话号码
     * @param tenantId 商户Id
     * @return ApiRest
     */
    public static ApiRest findVipByPhone(String phone, String tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("phone", phone);
        m.put("tenantId", tenantId);
        return restGet(ApiConfig.O2O_VIP_FIND_VIP_BY_PHONE_URL, m);
    }

    /**
     * 根据微信获取会员
     * @param openid 微信标识
     * @param tenantId 商户Id
     * @return ApiRest
     */
    public static ApiRest findVipByOpenId(String openid, String tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("openid", openid);
        m.put("tenantId", tenantId);
        return restGet(ApiConfig.O2O_VIP_FIND_VIP_BY_OPEN_ID_URL, m);
    }

    /**
     * 查询会员收货地址
     * @param vipId 会员Id
     * @return ApiRest
     */
    public static ApiRest qryVipAddr(String vipId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("vipId", vipId);
        return restGet(ApiConfig.O2O_VIP_QRY_VIP_ADDR_URL, m);
    }

    /**
     * 添加收货地址
     * @param m vipId,consignee,area[code-code-code 详情见表saas-web:district],address,mobilePhone,telPhone,isDefault[1:默认 0:非默认]
     * @return ApiRest
     */
    public static ApiRest addVipAddr(Map<String, String> m) {
        return restGet(ApiConfig.O2O_VIP_ADD_ADDR_URL, m);
    }

    /**
     * 修改收货地址
     * @param m id,vipId,consignee,area[code-code-code 详情见表saas-web:district],address,mobilePhone,telPhone,isDefault[1:默认 0:非默认]
     * @return ApiRest
     */
    public static ApiRest saveVipAddr(Map<String, String> m) {
        return restGet(ApiConfig.O2O_VIP_SAVE_ADDR_URL, m);
    }

    /**
     * 删除收货地址
     * @param ids 会员Ids，多个用英文逗号分割
     * @return ApiRest
     */
    public static ApiRest delVipAddr(String ids) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("ids", ids);
        return restGet(ApiConfig.O2O_VIP_DEL_ADDR_URL, m);
    }

    /**
     * 设置会员默认收货地址
     * @param vipId 会员Id
     * @param id 收货地址Id
     * @return ApiRest
     */
    public static ApiRest saveVipDefaultAddr(String vipId, String id) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("vipId", vipId);
        m.put("id", id);
        return restGet(ApiConfig.O2O_VIP_SAVE_DEFAULT_ADDR_URL, m);
    }

    /**
     * 会员微信绑定
     * @param vipId 会员Id
     * @param openId 微信标识
     * @return ApiRest
     */
    public static ApiRest bindVipChat(String vipId, String openId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("vipId", vipId);
        m.put("openId", openId);
        return restGet(ApiConfig.O2O_VIP_BIND_CHAT_URL, m);
    }

    /**
     * 获取会员
     * @param id 会员Id
     * @return ApiRest
     */
    public static ApiRest qryVipById(String id) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("id", id);
        return restGet(ApiConfig.O2O_VIP_QRY_VIP_BY_ID_URL, m);
    }

    /**
     * 获取会员收货地址
     * @param id 会员Id
     * @return ApiRest
     */
    public static ApiRest qryAddrById(String id) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("id", id);
        return restGet(ApiConfig.O2O_VIP_QRY_ADDR_BY_ID_URL, m);
    }

    /**
     * 查询商户/门店菜品
     * @param tenantId 商户Id
     * @param branchId 门店Id
     * @return ApiRest
     */
    public static ApiRest findGoods(BigInteger tenantId, BigInteger branchId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantId", String.valueOf(tenantId));
        if (branchId != null) {
            m.put("branchId", String.valueOf(branchId));
        }
        return restGet(ApiConfig.O2O_FIND_GOODS_URL, m);
    }

    /**
     * 微信模板消息发送
     * @param openId 接收模板消息的用户Id
     * @param wxWechatInfoId  公众号的Id
     * @param type 模板适用业务功能类型
     * @param templateKey 根据key的长度和功能，填写传递的参数数组
     * @param detailsUrl 详情链接
     * @return ApiRest
     */
    public static ApiRest sendTemplate(String openId, String wxWechatInfoId, String type, String[] templateKey, String detailsUrl) {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < templateKey.length; i++) {
            if (i != 0) {
                buffer.append("###");
            }
            buffer.append(templateKey[i]);
        }
        Map<String, String> m = new HashMap<String, String>();
        m.put("openId", openId);
        m.put("wxWechatInfoId", wxWechatInfoId);
        m.put("type", type);
        m.put("templateKey", buffer.toString());
        m.put("detailsUrl", detailsUrl);
        return restGet(ApiConfig.O2O_SEND_TEMPLATE_URL, m);
    }

    /**
     * 微信推送菜单
     * @param wxWechatInfoId
     * @return
     */
    public static ApiRest pushMenu(BigInteger wxWechatInfoId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("wxWechatInfoId", wxWechatInfoId.toString());
        return restGet(ApiConfig.O2O_PUSH_MENU_URL, m);
    }

    /**
     * 根据Token获取缓存数据
     * @param token
     * @return
     */
    public static ApiRest findCacheByToken(String token, String type) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("token", token);
        m.put("type", type);
        return restGet(ApiConfig.O2O_FIND_CACHE_BY_TOKEN_URL, m);
    }

    /**
     * 微信消息自动回复
     * @param signature
     * @param timestamp
     * @param nonce
     * @param echostr
     * @return
     */
    public static ApiRest mainPort(String signature, String timestamp, String nonce, String echostr) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("signature", signature);
        m.put("timestamp", timestamp);
        m.put("nonce", nonce);
        m.put("echostr", echostr);
        return restGet(ApiConfig.O2O_MAIN_PORT_URL, m);
    }

    /**
     * 获取会员
     * @param id
     * @return
     */
    public static ApiRest editVip(String id) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("id", id);
        return restGet(ApiConfig.O2O_VIP_EDIT_VIP_URL, m);
    }

    /**
     * 获取会员收货地址
     * @param id
     * @return
     */
    public static ApiRest editAddr(String id) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("id", id);
        return restGet(ApiConfig.O2O_VIP_EDIT_ADDR_URL, m);
    }

    /**
     * 会员充值
     * @param id
     * @param amount
     * @return
     */
    public static ApiRest vipStore(String vipId, String amount) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("vipId", vipId);
        m.put("amount", amount);
        return restGet(ApiConfig.O2O_VIP_STORE_URL, m);
    }

    /**
     * 查询储值规则
     * @param tenantCode
     * @return
     */
    public static ApiRest qryStoreRule(String tenantCode) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("tenantCode", tenantCode);
        return restGet(ApiConfig.O2O_VIP_QRY_STORE_RULE_URL, m);
    }

    /**
     * 会员流水上传
     * @param json
     * @return
     */
    public static ApiRest uploadVipGlide(String json) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("jsonData", json);
        return restGet(ApiConfig.O2O_VIP_UPLOAD_VIP_GLIDE_URL, m);
    }

    public static ApiRest oAuthAccessToken(String code, String appid, String secert, String originalId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("code", code);
        m.put("originalId", originalId);
        m.put("appid", appid);
        m.put("secert", secert);
        return restGet(ApiConfig.O2O_OAUTH_ACCESS_TOKEN_URL, m);
    }

    public static ApiRest askBaseAccessToken(String appid, String secret) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("appid", appid);
        m.put("secret", secret);
        return restGet(ApiConfig.O2O_ASK_BASE_ACCESS_TOKEN_URL, m);
    }

    public static ApiRest askJsTicket(String accessToken) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("accessToken", accessToken);
        return restGet(ApiConfig.O2O_ASK_JS_TICKET_URL, m);
    }

    public static ApiRest jsUnifiedOrder(Map<String, String> m) {
        return restGet(ApiConfig.O2O_JS_UNIFIED_ORDER_URL, m);
    }
}
