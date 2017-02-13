package api

import api.common.ApiConfig
import api.util.ApiBaseServiceUtils
import api.common.ApiRest

import java.text.DateFormat
import java.text.SimpleDateFormat

/**
 * 支付工具类
 * Created by lvpeng on 2015/7/15.
 */
class PayApi extends ApiBaseServiceUtils {

    /**
     * 支付宝条码支付
     * @param outTradeNo 订单号，卖家客户端唯一
     * @param subject 订单主题
     * @param totalFee 订单金额
     * @param dynamicId 支付条码，从支付宝手机端扫码获取
     * @param sellerEmail 卖家邮箱帐号
     * @return ApiRest
     */
    public static ApiRest alipayBar(String outTradeNo, String subject, String totalFee, String dynamicId, String sellerEmail) {
        return alipayBar(outTradeNo, subject, totalFee, dynamicId, sellerEmail, null);
    }
    public static ApiRest alipayBar(String outTradeNo, String subject, String totalFee, String dynamicId, String sellerEmail, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        m.put("subject", subject);
        m.put("total_fee", totalFee);
        m.put("dynamic_id", dynamicId);
        m.put("seller_email", sellerEmail);
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restPost(ApiConfig.PAY_ALIPAY_BAR_URL, m);
    }

    /**
     * 支付宝条码支付
     * @param outTradeNo 订单号，卖家客户端唯一
     * @param subject 订单主题
     * @param totalFee 订单金额
     * @param dynamicId 支付条码，从支付宝手机端扫码获取
     * @return ApiRest
     */
    public static ApiRest alipayBar(String outTradeNo, String subject, String totalFee, String dynamicId) {
        return alipayBar(outTradeNo, subject, totalFee, dynamicId, "");
    }
    public static ApiRest alipayBar(String outTradeNo, String subject, String totalFee, String dynamicId, BigInteger tenantId) {
        return alipayBar(outTradeNo, subject, totalFee, dynamicId, null, tenantId);
    }

    /**
     * 订单轮询查询，用于 需买家确认支付的情况
     * @param outTradeNo 订单号，卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest alipayQueryRetry(String outTradeNo) {
        return alipayQueryRetry(outTradeNo, null);
    }
    public static ApiRest alipayQueryRetry(String outTradeNo, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_ALIPAY_QUERY_RETRY_URL, m);
    }

    /**
     * 订单查询
     * @param outTradeNo 订单号，卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest alipayQuery(String outTradeNo) {
        return alipayQuery(outTradeNo, null);
    }
    public static ApiRest alipayQuery(String outTradeNo, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_ALIPAY_QUERY_URL, m);
    }

    /**
     * 订单撤销
     * 如果交易不存在，直接返回撤销成功；
     * 如果交易存在，且交易状态为待付款，则关闭交易；
     * 如果交易存在，切交易状态为已付款，则对交易进行全额退款；
     * 如果交易存在，且交易状态为成功结束，无法进行逆向资金操作，则返回撤销失败。
     * @param outTradeNo 订单号，卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest alipayCancel(String outTradeNo) {
        return alipayCancel(outTradeNo, null);
    }
    public static ApiRest alipayCancel(String outTradeNo, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_ALIPAY_CANCEL_URL, m);
    }

    /**
     * 订单退款
     * @param outTradeNo 订单号，卖家客户端唯一
     * @param outRequestNo 退款号，每次退款唯一
     * @param refundAmount 退款金额
     * @return ApiRest
     */
    public static ApiRest alipayRefund(String outTradeNo, String outRequestNo, String refundAmount) {
        return alipayRefund(outTradeNo, outRequestNo, refundAmount, null);
    }
    public static ApiRest alipayRefund(String outTradeNo, String outRequestNo, String refundAmount, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        m.put("out_request_no", outRequestNo);
        m.put("refund_amount", refundAmount);
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_ALIPAY_REFUND_URL, m);
    }

    /**
     * 微信刷卡支付
     * @param authCode 支付条码：从微信手机端扫码获取
     * @param body 订单详情：商品或支付单简要描述
     * @param attach 附加数据：附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
     * @param outTradeNo 订单号：卖家客户端唯一
     * @param totalFee 订单金额：订单总金额，单位为分，只能为整数
     * @param deviceInfo 设备号：终端设备号(门店号或收银设备ID)，注意：PC网页或公众号内支付请传"WEB"
     * @param ip 终端IP
     * @param timeStart 交易起始时间：格式为yyyyMMddHHmmss
     * @param timeExpire 交易结束时间：格式为yyyyMMddHHmmss
     * @param goodsTag 商品标记：商品标记，代金券或立减优惠功能的参数
     * @return ApiRest
     */
    public static ApiRest wxpayScan(String authCode, String body, String attach, String outTradeNo, int totalFee, String deviceInfo, String ip, String timeStart, String timeExpire, String goodsTag, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("auth_code", authCode);
        m.put("body", body);
        m.put("out_trade_no", outTradeNo);
        m.put("total_fee", String.valueOf(totalFee));
        m.put("ip", ip);
        if (attach != null) {
            m.put("attach", attach);
        }
        if (deviceInfo != null) {
            m.put("device_info", deviceInfo);
        }
        if (timeStart != null) {
            m.put("time_start", timeStart);
        }
        if (timeExpire != null) {
            m.put("time_expire", timeExpire);
        }
        if (goodsTag != null) {
            m.put("goods_tag", goodsTag);
        }
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restPost(ApiConfig.PAY_WXPAY_SCAN_URL, m);
    }
    public static ApiRest wxpayScan(String authCode, String body, String attach, String outTradeNo, int totalFee, String deviceInfo, String ip, String timeStart, String timeExpire, String goodsTag) {
        return wxpayScan(authCode, body, attach, outTradeNo, totalFee, deviceInfo, ip, timeStart, timeExpire, goodsTag, null);
    }

    /**
     * 微信刷卡支付（必填字段）
     * @param authCode 支付条码：从微信手机端扫码获取
     * @param body 订单详情：商品或支付单简要描述
     * @param outTradeNo 订单号：卖家客户端唯一
     * @param totalFee 订单金额：订单总金额，单位为分，只能为整数
     * @param ip 终端IP
     * @return ApiRest
     */
    public static ApiRest wxpayScan(String authCode, String body, String outTradeNo, int totalFee, String ip, BigInteger tenantId) {
        return wxpayScan(authCode, body, null, outTradeNo, totalFee, null, ip, null, null, null, tenantId);
    }
    public static ApiRest wxpayScan(String authCode, String body, String outTradeNo, int totalFee, String ip) {
        return wxpayScan(authCode, body, null, outTradeNo, totalFee, null, ip, null, null, null);
    }

    /**
     * 微信刷卡支付查询
     * @param transactionId 微信支付订单号
     * @param outTradeNo 订单号：卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest wxpayScanQuery(String transactionId, String outTradeNo, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        if (transactionId != null) {
            m.put("transaction_id", transactionId);
        }
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_WXPAY_SCAN_QUERY_URL, m);
    }
    public static ApiRest wxpayScanQuery(String transactionId, String outTradeNo) {
        return wxpayScanQuery(transactionId, outTradeNo, null);
    }

    /**
     * 微信刷卡支付查询
     * @param outTradeNo 订单号：卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest wxpayScanQuery(String outTradeNo, BigInteger tenantId) {
        return wxpayScanQuery(null, outTradeNo, tenantId);
    }
    public static ApiRest wxpayScanQuery(String outTradeNo) {
        return wxpayScanQuery(null, outTradeNo);
    }

    /**
     * 微信刷卡支付撤销
     * @param transactionId 微信支付订单号
     * @param outTradeNo 订单号：卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest wxpayScanReverse(String transactionId, String outTradeNo, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        if (transactionId != null) {
            m.put("transaction_id", transactionId);
        }
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_WXPAY_SCAN_REVERSE_URL, m);
    }
    public static ApiRest wxpayScanReverse(String transactionId, String outTradeNo) {
        return wxpayScanReverse(transactionId, outTradeNo, null);
    }

    /**
     * 微信刷卡支付撤销
     * @param outTradeNo 订单号：卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest wxpayScanReverse(String outTradeNo) {
        return wxpayScanReverse(null, outTradeNo);
    }
    public static ApiRest wxpayScanReverse(String outTradeNo, BigInteger tenantId) {
        return wxpayScanReverse(null, outTradeNo, tenantId);
    }
    /**
     * 微信下单接口（用于生成二维码）
     * @param body 商品描述：商品或支付单简要描述
     * @param detail 商品详情：商品名称明细列表
     * @param attach 附加数据：附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
     * @param outTradeNo 订单号：卖家客户端唯一
     * @param totalFee 订单金额：订单总金额，单位为分，只能为整数
     * @param ip 终端IP
     * @param timeStart 交易起始时间：格式为yyyyMMddHHmmss
     * @param timeExpire 交易结束时间：格式为yyyyMMddHHmmss
     * @param goodsTag 商品标记：商品标记，代金券或立减优惠功能的参数
     * @param productId 商品ID：trade_type=NATIVE，此参数必传。此id为二维码中包含的商品ID，商户自行定义
     * @param notifyUrl 通知地址：接收微信支付异步通知回调地址
     * @return ApiRest
     */
    public static ApiRest wxpayUnifiedorder(String body, String detail, String attach, String outTradeNo, int totalFee, String ip, String timeStart, String timeExpire, String goodsTag, String productId, String notifyUrl, BigInteger tenantId, BigInteger orderId, BigInteger submitBy) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("body", body);
        m.put("out_trade_no", outTradeNo);
        m.put("total_fee", String.valueOf(totalFee));
        m.put("ip", ip);
        m.put("product_id", productId);
        m.put("notify_url", notifyUrl);
        if (detail != null) {
            m.put("detail", detail);
        }
        if (attach != null) {
            m.put("attach", attach);
        }
        if (timeStart != null) {
            m.put("time_start", timeStart);
        }
        if (timeExpire != null) {
            m.put("time_expire", timeExpire);
        }
        if (goodsTag != null) {
            m.put("goods_tag", goodsTag);
        }
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        if (orderId != null) {
            m.put("orderId", orderId.toString());
        }
        if (submitBy != null) {
            m.put("submitBy", submitBy.toString());
        }
        return restPost(ApiConfig.PAY_WXPAY_UNIFIEDORDER_URL, m);
    }

    public static ApiRest wxpayUnifiedorder(String body, String detail, String attach, String outTradeNo, int totalFee, String ip, String timeStart, String timeExpire, String goodsTag, String productId, String notifyUrl) {
        return wxpayUnifiedorder(body, detail, attach, outTradeNo, totalFee, ip, timeStart, timeExpire, goodsTag, productId, notifyUrl, null, null, null);
    }

    /**
     * 微信下单接口
     * @param body 商品描述：商品或支付单简要描述
     * @param outTradeNo 订单号：卖家客户端唯一
     * @param totalFee 订单金额：订单总金额，单位为分，只能为整数
     * @param ip ip 终端IP
     * @param productId 商品ID：trade_type=NATIVE，此参数必传。此id为二维码中包含的商品ID，商户自行定义
     * @param notifyUrl 通知地址：接收微信支付异步通知回调地址
     * @return ApiRest
     */
    public static ApiRest wxpayUnifiedorder(String body, String outTradeNo, int totalFee, String ip, String productId, String notifyUrl) {
        return wxpayUnifiedorder(body, null, null, outTradeNo, totalFee, ip, null, null, null, productId, notifyUrl);
    }
    public static ApiRest wxpayUnifiedorder(String body, String outTradeNo, int totalFee, String ip, String productId, String notifyUrl, BigInteger orderId, BigInteger submitBy) {
        return wxpayUnifiedorder(body, null, null, outTradeNo, totalFee, ip, null, null, null, productId, notifyUrl, null, orderId, submitBy);
    }
    public static ApiRest wxpayUnifiedorder(String body, String outTradeNo, int totalFee, String ip, String productId, String notifyUrl, BigInteger tenantId) {
        return wxpayUnifiedorder(body, null, null, outTradeNo, totalFee, ip, null, null, null, productId, notifyUrl, tenantId, null, null);
    }

    /**
     * 微信订单关闭接口
     * @param outTradeNo 订单号：卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest wxpayCloseorder(String outTradeNo, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_WXPAY_CLOSEORDER_URL, m);
    }
    public static ApiRest wxpayCloseorder(String outTradeNo) {
        return wxpayCloseorder(outTradeNo, null);
    }

    /**
     * 微信申请退款
     * @param transactionId 微信订单号
     * @param outTradeNo 商户订单号：卖家客户端唯一
     * @param outRefundNo 商户退款单号：卖家客户端唯一
     * @param totalFee 订单金额：订单总金额，单位为分，只能为整数
     * @param refundFee 退款金额：退款总金额,单位为分,可以做部分退款
     * @return ApiRest
     */
    public static ApiRest wxpayRefund(String transactionId, String outTradeNo, String outRefundNo, int totalFee, int refundFee, String opUserId, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        m.put("out_refund_no", outRefundNo);
        m.put("total_fee", String.valueOf(totalFee));
        m.put("refund_fee", String.valueOf(refundFee));
        m.put("op_user_id", opUserId);
        if (transactionId != null) {
            m.put("transaction_id", transactionId);
        }
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_WXPAY_REFUND_URL, m);
    }
    public static ApiRest wxpayRefund(String transactionId, String outTradeNo, String outRefundNo, int totalFee, int refundFee, String opUserId) {
        return wxpayRefund(transactionId, outTradeNo, outRefundNo, totalFee, refundFee, opUserId, null);
    }

    /**
     * 微信申请退款
     * @param outTradeNo 商户订单号：卖家客户端唯一
     * @param outRefundNo 商户退款单号：卖家客户端唯一
     * @param totalFee 订单金额：订单总金额，单位为分，只能为整数
     * @param refundFee 退款金额：退款总金额,单位为分,可以做部分退款
     * @return ApiRest
     */
    public static ApiRest wxpayRefund(String outTradeNo, String outRefundNo, int totalFee, int refundFee, String opUserId, BigInteger tenantId) {
        return wxpayRefund(null, outTradeNo, outRefundNo, totalFee, refundFee, opUserId, tenantId);
    }
    public static ApiRest wxpayRefund(String outTradeNo, String outRefundNo, int totalFee, int refundFee, String opUserId) {
        return wxpayRefund(null, outTradeNo, outRefundNo, totalFee, refundFee, opUserId);
    }

    /**
     * 微信退款结果查询
     * @param transactionId 微信订单号
     * @param outTradeNo 商户订单号：卖家客户端唯一
     * @param outRefundNo 商户退款单号：卖家客户端唯一
     * @param refundId 微信退款单号：微信生成的退款单号，在申请退款接口有返回
     * @return ApiRest
     */
    public static ApiRest wxpayRefundQuery(String transactionId, String outTradeNo, String outRefundNo, String refundId, BigInteger tenantId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("out_trade_no", outTradeNo);
        m.put("out_refund_no", outRefundNo);
        if (transactionId != null) {
            m.put("transaction_id", transactionId);
        }
        if (refundId != null) {
            m.put("refund_id", refundId);
        }
        if (tenantId != null) {
            m.put("tenantId", tenantId.toString());
        }
        return restGet(ApiConfig.PAY_WXPAY_REFUND_QUERY_URL, m);
    }
    public static ApiRest wxpayRefundQuery(String transactionId, String outTradeNo, String outRefundNo, String refundId) {
        return wxpayRefundQuery(transactionId, outTradeNo, outRefundNo, refundId, null);
    }

    /**
     * 微信退款结果查询
     * @param outTradeNo 商户订单号：卖家客户端唯一
     * @param outRefundNo 商户退款单号：卖家客户端唯一
     * @return ApiRest
     */
    public static ApiRest wxpayRefundQuery(String outTradeNo, String outRefundNo, BigInteger tenantId) {
        return wxpayRefundQuery(null, outTradeNo, outRefundNo, null, tenantId);
    }
    public static ApiRest wxpayRefundQuery(String outTradeNo, String outRefundNo) {
        return wxpayRefundQuery(null, outTradeNo, outRefundNo, null);
    }

    /**
     * 银行转账支付请求提交
     * @param orderId 订单Id
     * @param orderTotal 订单总额
     * @param payTotal 应付金额
     * @param accountName 支付账号信息：企业名称
     * @param accountBank 支付账号信息：开户银行
     * @param accountNo 支付账号信息：账号卡号
     * @param submitAt 支付请求提交时间
     * @param submitBy 提交用户id
     * @param submitUserLoginName 提交用户账号，对应商户号或代理商号
     * @param submitUserName 提交用户姓名，对应商户名称或代理商名称
     * @param submitUserType 提交用户类型：1-商户，2-代理商；暂不支持其他类型
     * @param invalidAt 请求有效期（失效日期，过期不可确认支付）
     * @return ApiRest
     */
    public static ApiRest bankTransferPay(BigInteger orderId, BigDecimal orderTotal, BigDecimal payTotal, String accountName,
                                          String accountBank, String accountNo, BigInteger submitBy,
                                          String submitUserLoginName, String submitUserName, Integer submitUserType, Date invalidAt) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Map<String, String> m = new HashMap<String, String>();
        m.put("payType", "6");
        m.put("orderId", orderId.toString());
        m.put("orderTotal", orderTotal.toString());
        m.put("payTotal", payTotal.toString());
        m.put("accountName", accountName);
        m.put("accountBank", accountBank);
        m.put("accountNo", accountNo);
        m.put("submitBy", submitBy.toString());
        m.put("submitUserLoginName", submitUserLoginName);
        m.put("submitUserName", submitUserName);
        m.put("submitUserType", submitUserType.toString());
        m.put("invalidAtStr", dateFormat.format(invalidAt));
        return restPost(ApiConfig.PAY_LOG_URL, m);
    }

    /**
     * 支付确认
     * @param orderId 订单Id
     * @param confirmBy 支付确认用户id
     * @param confirmUserName 支付确认用户姓名
     * @return ApiRest
     */
    public static ApiRest confirmPay(BigInteger orderId, BigInteger confirmBy, String confirmUserName) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("orderId", orderId.toString());
        m.put("confirmBy", confirmBy.toString());
        m.put("confirmUserName", confirmUserName);
        return restPost(ApiConfig.CONFIRM_PAY_LOG_URL, m);
    }

    /**
     * 获取支付宝支付链接
     * @return String
     */
    public static ApiRest getAlipayDirectPayUrl(String orderNo, String subject, String body, String totalFee, String notifyUrl, BigInteger orderId, BigInteger submitBy) {
        return getAlipayDirectPayUrl(orderNo, subject, body, totalFee, null, notifyUrl, orderId, submitBy);
    }
    public static ApiRest getAlipayDirectPayUrl(String orderNo, String subject, String body, String totalFee, String returnUrl, String notifyUrl, BigInteger orderId, BigInteger submitBy) {
        Map<String, String> m = new HashMap();
        m.put("orderNo", orderNo);
        m.put("subject", subject);
        m.put("body", body);
        m.put("totalFee", totalFee);
        m.put("notifyUrl", notifyUrl);
        if (returnUrl != null) {
            m.put("returnUrl", returnUrl);
        }
        if (orderId != null) {
            m.put("orderId", orderId.toString());
        }
        if (submitBy != null) {
            m.put("submitBy", submitBy.toString());
        }
        return restPost(ApiConfig.PAY_ALIPAY_DIRECT_PAY_URL, m);
    }
    public static ApiRest getAlipayDirectPayUrl(String orderNo, String subject, String body, String totalFee, String notifyUrl) {
        return getAlipayDirectPayUrl(orderNo, subject, body, totalFee, notifyUrl, null, null);
    }

    public static ApiRest findPayLog(String orderNo) {
        Map<String, String> m = new HashMap();
        m.put("orderNo", orderNo);
        return restGet(ApiConfig.FIND_PAY_LOG_URL, m);
    }
}
