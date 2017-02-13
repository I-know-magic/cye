package smart.light.bus


/**
 * 销售明细流水
 */
class SaleDetail {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 销售账单号
     */
    String saleCode
    /**
     * 商品
     */
    BigInteger goodsId
    /**
     * 促销活动
     */
    BigInteger promotionId
    /**
     * 数量
     */
    BigDecimal quantity
    /**
     * 售价
     */
    BigDecimal salePrice
    /**
     * 实际售价
     */
    BigDecimal salePriceActual
    /**
     * 应收合计
     */
    BigDecimal totalAmount
    /**
     * 是否免单或赠送
     */
    boolean isFreeOfCharge
    /**
     * 实收合计
     */
    BigDecimal receivedAmount
    /**
     * 是否冲销
     */
    boolean isRefund
    /**
     * 
     */
    boolean isPrinted
    /**
     * 
     */
    boolean isProduced
    /**
     * 
     */
    boolean isServed
    /**
     * 所属门店，默认为0，代表总部
     */
    BigInteger branchId
    /**
     * 折扣金额
     */
    BigDecimal discountAmount
    /**
     * 
     */
    BigDecimal discountAmount1

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
