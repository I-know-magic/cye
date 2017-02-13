package smart.light.web.vo

/**
 * 商品库存VO
 */
class StoreVo {
    BigInteger goodsId
    String barCode
    String goodsName
    String categoryName
    String goodsUnitName
    /**
     * 售价
     */
    BigDecimal salePrice
    BigDecimal purchasingPrice

    BigInteger storeId

    /**
     *
     */
    String memo
    /**
     * 门店Id
     */
    BigInteger branchId
    /**
     * 仓库Id
     */
    BigInteger storageId
    /**
     * 库存数量
     */
    BigDecimal quantity
    /**
     * 成本
     */
    BigDecimal avgAmount
    /**
     * 出入库时间
     */
    Date storeAt
    /**
     * 库存金额
     */
    BigDecimal storeAmount

    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
