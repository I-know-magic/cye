package smart.light.web.vo

/**
 * StoreOrderDetailVo
 *  on 2015/9/7.
 */
class StoreOrderDetailVo {

    String memo

    BigInteger branchId

    BigDecimal purchaseAmount

    BigDecimal quantity

    BigDecimal amount

    BigInteger storeOrderId

    String storeOrderCode

    BigInteger goodsId

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
