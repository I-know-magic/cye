package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 销售日结转
 */
//@TenantFilter(column = "tenant_id")
class JzSaleDay {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 结转日期（YYYY-mm-dd）
     */
    String carDate
    /**
     * 
     */
    BigInteger branchId
    /**
     * 销售单数（销售数量）
     */
    BigInteger saleNum
    /**
     * 销售优惠单数
     */
    BigInteger saleDiscountNum
    /**
     * 销售抹零单数
     */
    BigInteger saleTruncNum
    /**
     * 销售赠送金额
     */
    BigInteger saleGiveNum
    /**
     * 退货单数（退货数量）
     */
    BigInteger returnNum
    /**
     * 退货优惠单数
     */
    BigInteger returnDiscountNum
    /**
     * 退货抹零单数
     */
    BigInteger returnTruncNum
    /**
     * 退货赠送金额
     */
    BigInteger returnGiveNum
    /**
     * 销售金额
     */
    BigDecimal saleAmount
    /**
     * 销售优惠金额
     */
    BigDecimal saleDiscountAmount
    /**
     * 销售抹零金额
     */
    BigDecimal saleTruncAmount
    /**
     * 销售赠送金额
     */
    BigDecimal saleGiveAmount
    /**
     * 退货金额
     */
    BigDecimal returnAmount
    /**
     * 退货优惠金额
     */
    BigDecimal returnDiscountAmount
    /**
     * 退货抹零金额
     */
    BigDecimal returnTruncAmount
    /**
     * 退货赠送金额
     */
    BigDecimal returnGiveAmount
    /**
     * 销售成本
     */
    BigDecimal saleGoodsCost
    /**
     * 总额
     */
    BigDecimal amount
    /**
     * 退货成本
     */
    BigDecimal returnGoodsCost

    BigInteger id
    BigInteger tenantId
    Date createAt
    boolean isDeleted

}
