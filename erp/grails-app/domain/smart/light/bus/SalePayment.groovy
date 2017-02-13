package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 支付单流水
 */
//@TenantFilter(column = "tenant_id")
class SalePayment {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 付款单号
     */
    String salePaymentCode
    /**
     * 销售流水号
     */
    String saleCode
    /**
     * 支付方式
外键
     */
    BigInteger paymentId
    /**
     * 支付代码
     */
    String paymentCode
    /**
     * 应付金额
     */
    BigDecimal payTotal
    /**
     * 实付金额
     */
    BigDecimal amount
    /**
     * 
     */
    BigInteger posId
    /**
     * 找零金额
     */
    BigDecimal changeAmount
    /**
     * 
     */
    String memo
    /**
     * 收银员
     */
    BigInteger cashier
    /**
     * 付款时间
     */
    Date paymentAt
    /**
     * 是否退货 0：销售 1 ：退货
     */
    boolean isRefund
    /**
     * 所属门店，默认为0，代表总部
     */
    BigInteger branchId

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
