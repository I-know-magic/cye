package smart.light.web.vo

/**
 * CheckOrderDetailVo
 * hexiaohong on 2015/9/7.
 */
class CheckOrderDetailVo {
    /**
     *
     */
    String memo

    BigInteger branchId

    BigDecimal purchasePrice

    BigDecimal quantity

    BigInteger checkOrderId

    String code

    BigInteger goodsId

    BigDecimal reallyQuantity

    BigDecimal checkQuantity

    BigDecimal checkAmount

    BigInteger id
    Date createAt
    String createBy
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

    String barCode
    String goodsName
    String categoryName
    String goodsUnitName
    BigDecimal salePrice
}
