package api.common

import api.util.ApiPropertyUtils

/**
 * Created by lvpeng on 2015/7/25.
 */
class ApiConfig {
    static {
        loadProperties();
    }

    public static void loadProperties() {
        Map<String, String> propMap = null;
        try {
            propMap = ApiPropertyUtils.getDefault();
        } catch (IOException e) {
            e.printStackTrace();
        }

        String webserviceConnect = null;
        String mapserviceConnect = null;
        String o2oWebServerConnect = null;
        String o2oWechatServerConnect = null;
        String saasServiceConnect = null;
        String jxcServiceConnect = null;
        String httpServiceConnect = null;

        if (propMap != null) {
            webserviceConnect = propMap.get("webservice.connect");
            mapserviceConnect = propMap.get("mapservice.connect");
            o2oWebServerConnect = propMap.get("o2o.web.service.connect");
            o2oWechatServerConnect = propMap.get("o2o.wechat.service.connect");
            saasServiceConnect = propMap.get("saas.service.connect");
            jxcServiceConnect = propMap.get("jxc.service.connect");
            httpServiceConnect = propMap.get("http.service.connect");
            if (httpServiceConnect == null) {httpServiceConnect = webserviceConnect;}
        }

        WS_HEAD = ApiConstants.HTTP_HEAD + webserviceConnect;
        MAP_HEAD = ApiConstants.HTTP_HEAD + mapserviceConnect;
        O2O_WEB_HEAD = ApiConstants.HTTP_HEAD + o2oWebServerConnect;
        O2O_WECHAT_HEAD = ApiConstants.HTTP_HEAD + o2oWechatServerConnect;
        SAAS_HEAD = ApiConstants.HTTP_HEAD + saasServiceConnect;
        JXC_HEAD = ApiConstants.HTTP_HEAD + jxcServiceConnect;
        HTTP_HEAD = ApiConstants.HTTP_HEAD + httpServiceConnect;

        /** webservice接口 */
        AUTH_LOGIN_URL = WS_HEAD + "/auth/login";

        RESET_PASSWORD_URL = WS_HEAD + "/auth/resetPassword";
        CHANGE_PASSWORD_URL = WS_HEAD + "/auth/changePassword";
        LOGOUT_URL = WS_HEAD + "/auth/logout";
        BIND_MOBILE_URL = WS_HEAD + "/auth/bindMobile";
        BIND_WECHAT_URL = WS_HEAD + "/auth/bindWechat";
        USER_REGISTER_URL = WS_HEAD + "/user/register";
        USER_REGISTER_FULL_URL = WS_HEAD + "/user/registerAll";
        USER_ACTIVATE_URL = WS_HEAD + "/user/activate";
        USER_LIST_URL = WS_HEAD + "/user/list";
        USER_SET_ENABLED_URL = WS_HEAD + "/user/setEnabled";
        USER_SET_NAME_URL = WS_HEAD + "/user/saveName";
        USER_DELETE_URL = WS_HEAD + "/user/del";
        LOGIN_NAME_IS_UNIQUE_URL = WS_HEAD + "/user/loginNameIsUnique";
        ROLE_LIST_URL = WS_HEAD + "/role/list";
        ROLE_SAVE_URL = WS_HEAD + "/role/save";
        ROLE_LIST_PRIVILEGE_URL = WS_HEAD + "/role/listPrivilege";
        ROLE_SAVE_PRIVILEGE_URL = WS_HEAD + "/role/savePrivilege";
        ROLE_FIND_URL = WS_HEAD + "/role/find";
        ROLE_DELETE_URL = WS_HEAD + "/role/del";
        SAAS_FIND_TENANT_URL = WS_HEAD + "/tenant/findTenant";
        SAAS_SAVE_TENANT_URL = WS_HEAD + "/tenant/save";
        SAAS_PRODUCT_LIST_URL = WS_HEAD + "/product/list";
        SAAS_BRANCH_PRODUCT_URL = WS_HEAD + "/tenant/branch";
        O2O_BRANCH_LIST_URL = WS_HEAD + "/branch/list";
        O2O_BRANCH_TREE_URL = WS_HEAD + "/branch/tree";
        O2O_ONLINE_MENU_CURRENT_URL = WS_HEAD + "/branch/findOnlineMenuCurrent";
        O2O_FIND_GOODS_URL = WS_HEAD + "/branch/findGoods";
        LOAD_RESOURCE_DEFINE_URL = WS_HEAD + "/auth/loadResourceDefine";
        BIND_QQ_URL = WS_HEAD + "/auth/bindQq";
        BIND_EMAIL_URL = WS_HEAD + "/auth/bindEmail";
        VERIFY_BIND_URL = WS_HEAD + "/auth/verifyBind";
        BIND_UNIQUE_URL = WS_HEAD + "/auth/bindUnique";
        REMOVE_BIND_URL = WS_HEAD + "/auth/removeBind";
        MAX_ROLE_CODE_URL = WS_HEAD + "/role/maxCode";
        SAVE_ROLE_URL = WS_HEAD + "/role/saveRole";
        LIST_USER_ROLE_URL = WS_HEAD + "/role/listUserRole";
        INIT_TENANT_ROLE_URL = WS_HEAD + "/tenant/initRole";
        FIND_TENANT_GOODS_URL = WS_HEAD + "/product/find";
        FIND_USER_URL = WS_HEAD + "/user/find";
        FIND_USER_ONE_URL = WS_HEAD + "/user/findOne";
        ROLE_UNIQUE_URL = WS_HEAD + "/role/roleUnique";
        POS_RES_URL = WS_HEAD + "/role/posRes";
        WECHAT_INIT_TOKEN_URL = WS_HEAD + "/wechat/initToken";
        WECHAT_LOGIN_VERIFY_URL = WS_HEAD + "/wechat/verifyInfoByWechatLogin";
        FIND_SYS_USER_BY_OPEN_ID_URL = WS_HEAD + "/wechat/findSysUserByOpenId";
        FIND_SYS_USER_BY_TENANT_CODE_URL = WS_HEAD + "/wechat/findSysUserByTenantCode";
        VERIFY_PASS_BY_SYS_USER_ID_URL = WS_HEAD + "/user/verifyPassBySysUserId";
        INIT_BRANCH_URL = WS_HEAD + "/branch/initBranch";
        STAT_VISIT_URL = WS_HEAD + "/stat/visit";
        O2O_FIND_CACHE_BY_TOKEN_URL = WS_HEAD + "/wechat/findCacheByToken";
        SAVE_PAY_ACCOUNT_URL = WS_HEAD + "/tenant/savePayAccount";
        FIND_PAY_ACCOUNT_URL = WS_HEAD + "/tenant/findPayAccount";
        MESSAGE_LIST_URL = WS_HEAD + "/message/list";

        MAP_DIRECTION_URL = MAP_HEAD + "/direction/v1";
        /** http-service接口 */
        MAIL_URL = HTTP_HEAD + "/mail";
        PAY_ALIPAY_BAR_URL = HTTP_HEAD + "/pay/alipayBar";
        PAY_ALIPAY_QUERY_URL = HTTP_HEAD + "/pay/alipayQuery";
        PAY_ALIPAY_QUERY_RETRY_URL = HTTP_HEAD + "/pay/alipayQueryRetry";
        PAY_ALIPAY_CANCEL_URL = HTTP_HEAD + "/pay/alipayCancel";
        PAY_ALIPAY_REFUND_URL = HTTP_HEAD + "/pay/alipayRefund";
        PAY_WXPAY_SCAN_URL = HTTP_HEAD + "/pay/wxpayScan";
        PAY_WXPAY_SCAN_QUERY_URL = HTTP_HEAD + "/pay/wxpayScanQuery";
        PAY_WXPAY_SCAN_REVERSE_URL = HTTP_HEAD + "/pay/wxpayScanReverse";
        PAY_WXPAY_UNIFIEDORDER_URL = HTTP_HEAD + "/pay/wxpayUnifiedorder";
        PAY_WXPAY_CLOSEORDER_URL = HTTP_HEAD + "/pay/wxpayCloseorder";
        PAY_WXPAY_REFUND_URL = HTTP_HEAD + "/pay/wxpayRefund";
        PAY_WXPAY_REFUND_QUERY_URL = HTTP_HEAD + "/pay/wxpayRefundQuery";
        PAY_LOG_URL = HTTP_HEAD + "/pay/payLog";
        CONFIRM_PAY_LOG_URL = HTTP_HEAD + "/pay/payLogConfirm";
        PAY_ALIPAY_DIRECT_PAY_URL = HTTP_HEAD + "/pay/alipayDirectPay";
        SMS_SEND_URL = HTTP_HEAD + "/sms/send";
        SMS_REPORT_URL = HTTP_HEAD + "/sms/report";
        SMS_REMAIN_URL = HTTP_HEAD + "/sms/remain";
        SMS_SEND_AUTH_CODE_URL = HTTP_HEAD + "/sms/sendAuthCode";
        SMS_VERIFY_AUTH_CODE_URL = HTTP_HEAD + "/sms/verifyAuthCode";
        SMS_SEND_AGENT_ACCOUNT_URL = HTTP_HEAD + "/sms/sendAgentAccount";
        SMS_SEND_RESET_PASSWORD_URL = HTTP_HEAD + "/sms/sendResetPassword";
        SMS_SEND_TEMPLATE_URL = HTTP_HEAD + "/sms/sendByTemplate";
        O2O_SEND_TEMPLATE_URL = HTTP_HEAD + "/wechat/sendTemplate";
        O2O_MAIN_PORT_URL = HTTP_HEAD + "/wechat/mainPort";
        O2O_PUSH_MENU_URL = HTTP_HEAD + "/wechat/pushMenu";
        O2O_OAUTH_ACCESS_TOKEN_URL = HTTP_HEAD + "/wechat/oAuthAccessToken";
        O2O_ASK_BASE_ACCESS_TOKEN_URL = HTTP_HEAD + "/wechat/askBaseAccessToken";
        O2O_ASK_JS_TICKET_URL = HTTP_HEAD + "/wechat/askJsTicket";
        O2O_JS_UNIFIED_ORDER_URL = HTTP_HEAD + "/wechat/jsUnifiedOrder";
        MAP_BAIDU_CALCULATE_DISTANCE_URL = HTTP_HEAD + "/map/baiduCalculateDistance";
        MAP_BAIDU_CONVER_COORD_URL = HTTP_HEAD + "/map/baiduConverCoord";
        FIND_PAY_LOG_URL = HTTP_HEAD + "/pay/findPayLog";

        /** web-portal接口 */
        INIT_TENANT_URL = JXC_HEAD + "/initTenant/inittenant";

        /** O2O-wechat接口 */
        O2O_SAVE_TAKEOUT_ORDER_BY_TEL_POS_URL = O2O_WECHAT_HEAD + "/frontTenantEatOrderTakeout/saveTakeOutOrderByPosTel";
        O2O_CHANGE_ORDER_STATUS_BY_TEL_POS_URL = O2O_WECHAT_HEAD + "/frontTenantEatOrderTakeout/changeOrderStatusByTelPOS";
        O2O_CHANGE_PAY_STATUS_BY_TEL_POS_URL = O2O_WECHAT_HEAD + "/frontTenantEatOrderTakeout/changePayStatusByTelPOS";
        O2O_LIST_ORDER_INFO_BY_TEL_POS_URL = O2O_WECHAT_HEAD + "/frontTenantEatOrderTakeout/listOrderInfoByTelPOS";
        O2O_SHOW_ORDER_DETAIL_BY_TEL_POS_URL = O2O_WECHAT_HEAD + "/frontTenantEatOrderTakeout/showOrderDetailByTelPOS";

        /** O2O-web接口 */
        O2O_VIP_QRY_VIP_LIST_URL = O2O_WEB_HEAD + "/vipInterface/qryVipList";
        O2O_VIP_DEL_VIPS_URL = O2O_WEB_HEAD + "/vipInterface/delVips";
        O2O_VIP_ADD_VIP_URL = O2O_WEB_HEAD + "/vipInterface/addVip";
        O2O_VIP_SAVE_VIP_URL = O2O_WEB_HEAD + "/vipInterface/saveVip";
        O2O_VIP_FIND_VIP_BY_PHONE_URL = O2O_WEB_HEAD + "/vipInterface/findVipByPhone";
        O2O_VIP_FIND_VIP_BY_OPEN_ID_URL = O2O_WEB_HEAD + "/vipInterface/findVipByOpenId";
        O2O_VIP_QRY_VIP_ADDR_URL = O2O_WEB_HEAD + "/vipInterface/qryVipAddr";
        O2O_VIP_ADD_ADDR_URL = O2O_WEB_HEAD + "/vipInterface/addAddr";
        O2O_VIP_SAVE_ADDR_URL = O2O_WEB_HEAD + "/vipInterface/saveAddr";
        O2O_VIP_DEL_ADDR_URL = O2O_WEB_HEAD + "/vipInterface/delAddr";
        O2O_VIP_SAVE_DEFAULT_ADDR_URL = O2O_WEB_HEAD + "/vipInterface/saveDefaultAddr";
        O2O_VIP_BIND_CHAT_URL = O2O_WEB_HEAD + "/vipInterface/bindChat";
        O2O_VIP_QRY_VIP_BY_ID_URL = O2O_WEB_HEAD + "/vipInterface/qryVipById";
        O2O_VIP_QRY_ADDR_BY_ID_URL = O2O_WEB_HEAD + "/vipInterface/qryAddrById";
        O2O_VIP_STORE_URL = O2O_WEB_HEAD + "/vipInterface/vipStore";
        O2O_VIP_QRY_STORE_RULE_URL = O2O_WEB_HEAD + "/vipInterface/qryStoreRule";
        O2O_VIP_UPLOAD_VIP_GLIDE_URL = O2O_WEB_HEAD + "/vipInterface/uploadVipGlide";
        O2O_VIP_EDIT_VIP_URL = O2O_WEB_HEAD + "/vipInterface/editVip";
        O2O_VIP_EDIT_ADDR_URL = O2O_WEB_HEAD + "/vipInterface/editAddr";

        /** saas-business接口 */
        SAAS_WECHAT_INFO_URL = SAAS_HEAD + "/wechat/info";
        SAAS_WECHAT_MENU_URL = SAAS_HEAD + "/wechat/menu";
        SAAS_WECHAT_REPLY_URL = SAAS_HEAD + "/wechat/reply";
        SAAS_WECHAT_REPLYTEMPLATE_URL = SAAS_HEAD + "/wechat/replyTemplate";
    }

    private static String WS_HEAD;
    private static String MAP_HEAD;
    private static String O2O_WEB_HEAD;
    private static String O2O_WECHAT_HEAD;
    private static String SAAS_HEAD;
    private static String JXC_HEAD;
    private static String HTTP_HEAD;

    /** webservice接口 */
    public static String AUTH_LOGIN_URL;
    public static String MAP_DIRECTION_URL;
    public static String RESET_PASSWORD_URL;
    public static String CHANGE_PASSWORD_URL;
    public static String LOGOUT_URL;
    public static String BIND_MOBILE_URL;
    public static String BIND_WECHAT_URL;
    public static String USER_REGISTER_URL;
    public static String USER_REGISTER_FULL_URL;
    public static String USER_ACTIVATE_URL;
    public static String USER_LIST_URL;
    public static String USER_SET_ENABLED_URL;
    public static String USER_SET_NAME_URL;
    public static String USER_DELETE_URL;
    public static String LOGIN_NAME_IS_UNIQUE_URL;
    public static String ROLE_LIST_URL;
    public static String ROLE_SAVE_URL;
    public static String ROLE_LIST_PRIVILEGE_URL;
    public static String ROLE_SAVE_PRIVILEGE_URL;
    public static String ROLE_FIND_URL;
    public static String ROLE_DELETE_URL;
    public static String SMS_SEND_URL;
    public static String SMS_REPORT_URL;
    public static String SMS_REMAIN_URL;
    public static String SMS_SEND_AUTH_CODE_URL;
    public static String SMS_SEND_AGENT_ACCOUNT_URL;
    public static String SMS_SEND_RESET_PASSWORD_URL;
    public static String SMS_VERIFY_AUTH_CODE_URL;
    public static String SMS_SEND_TEMPLATE_URL;
    public static String MAIL_URL;
    public static String SAAS_FIND_TENANT_URL;
    public static String SAAS_SAVE_TENANT_URL;
    public static String SAAS_PRODUCT_LIST_URL;
    public static String SAAS_BRANCH_PRODUCT_URL;
    public static String O2O_BRANCH_LIST_URL;
    public static String O2O_BRANCH_TREE_URL;
    public static String O2O_ONLINE_MENU_CURRENT_URL;
    public static String O2O_FIND_GOODS_URL;
    public static String LOAD_RESOURCE_DEFINE_URL;
    public static String BIND_QQ_URL;
    public static String BIND_EMAIL_URL;
    public static String VERIFY_BIND_URL;
    public static String BIND_UNIQUE_URL;
    public static String REMOVE_BIND_URL;
    public static String MAX_ROLE_CODE_URL;
    public static String SAVE_ROLE_URL;
    public static String LIST_USER_ROLE_URL;
    public static String PAY_ALIPAY_BAR_URL;
    public static String PAY_ALIPAY_QUERY_URL;
    public static String PAY_ALIPAY_QUERY_RETRY_URL;
    public static String PAY_ALIPAY_CANCEL_URL;
    public static String PAY_ALIPAY_REFUND_URL;
    public static String INIT_TENANT_ROLE_URL;
    public static String FIND_TENANT_GOODS_URL;
    public static String FIND_USER_URL;
    public static String FIND_USER_ONE_URL;
    public static String PAY_WXPAY_SCAN_URL;
    public static String PAY_WXPAY_SCAN_QUERY_URL;
    public static String PAY_WXPAY_SCAN_REVERSE_URL;
    public static String PAY_WXPAY_UNIFIEDORDER_URL;
    public static String PAY_WXPAY_CLOSEORDER_URL;
    public static String PAY_WXPAY_REFUND_URL;
    public static String PAY_WXPAY_REFUND_QUERY_URL;
    public static String ROLE_UNIQUE_URL;
    public static String POS_RES_URL;
    public static String WECHAT_INIT_TOKEN_URL;
    public static String WECHAT_LOGIN_VERIFY_URL;
    public static String FIND_SYS_USER_BY_OPEN_ID_URL;
    public static String FIND_SYS_USER_BY_TENANT_CODE_URL;
    public static String VERIFY_PASS_BY_SYS_USER_ID_URL;
    public static String INIT_BRANCH_URL;
    public static String O2O_SEND_TEMPLATE_URL;
    public static String PAY_LOG_URL;
    public static String CONFIRM_PAY_LOG_URL;
    public static String PAY_ALIPAY_DIRECT_PAY_URL;
    public static String STAT_VISIT_URL;
    public static String O2O_FIND_CACHE_BY_TOKEN_URL;
    public static String O2O_MAIN_PORT_URL;
    public static String O2O_PUSH_MENU_URL;
    public static String SAVE_PAY_ACCOUNT_URL;
    public static String FIND_PAY_ACCOUNT_URL;
    public static String O2O_OAUTH_ACCESS_TOKEN_URL;
    public static String O2O_ASK_BASE_ACCESS_TOKEN_URL;
    public static String O2O_ASK_JS_TICKET_URL;
    public static String O2O_JS_UNIFIED_ORDER_URL;
    public static String MAP_BAIDU_CALCULATE_DISTANCE_URL;
    public static String MAP_BAIDU_CONVER_COORD_URL;
    public static String MESSAGE_LIST_URL;
    public static String FIND_PAY_LOG_URL;
    /** web-portal接口 */
    public static String INIT_TENANT_URL;
    /** O2O接口 */
    public static String O2O_SAVE_TAKEOUT_ORDER_BY_TEL_POS_URL;
    public static String O2O_CHANGE_ORDER_STATUS_BY_TEL_POS_URL;
    public static String O2O_CHANGE_PAY_STATUS_BY_TEL_POS_URL;
    public static String O2O_LIST_ORDER_INFO_BY_TEL_POS_URL;
    public static String O2O_SHOW_ORDER_DETAIL_BY_TEL_POS_URL;
    public static String O2O_VIP_QRY_VIP_LIST_URL;
    public static String O2O_VIP_DEL_VIPS_URL;
    public static String O2O_VIP_ADD_VIP_URL;
    public static String O2O_VIP_SAVE_VIP_URL;
    public static String O2O_VIP_FIND_VIP_BY_PHONE_URL;
    public static String O2O_VIP_FIND_VIP_BY_OPEN_ID_URL;
    public static String O2O_VIP_QRY_VIP_ADDR_URL;
    public static String O2O_VIP_ADD_ADDR_URL;
    public static String O2O_VIP_SAVE_ADDR_URL;
    public static String O2O_VIP_DEL_ADDR_URL;
    public static String O2O_VIP_SAVE_DEFAULT_ADDR_URL;
    public static String O2O_VIP_BIND_CHAT_URL;
    public static String O2O_VIP_QRY_VIP_BY_ID_URL;
    public static String O2O_VIP_QRY_ADDR_BY_ID_URL;
    public static String O2O_VIP_STORE_URL;
    public static String O2O_VIP_QRY_STORE_RULE_URL;
    public static String O2O_VIP_UPLOAD_VIP_GLIDE_URL;
    public static String O2O_VIP_EDIT_VIP_URL;
    public static String O2O_VIP_EDIT_ADDR_URL;
    /** saas-business接口 */
    public static String SAAS_WECHAT_INFO_URL;
    public static String SAAS_WECHAT_MENU_URL;
    public static String SAAS_WECHAT_REPLY_URL;
    public static String SAAS_WECHAT_REPLYTEMPLATE_URL;

}
