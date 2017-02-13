package smart.light.web.vo

/**
 * Created by Administrator on 2015/9/2.
 */
class StoreAccountVo {
    String barCode
    String goodsName
    /**
     * 发生成本
     */
    BigDecimal occurIncurred
    /**
     * 发生数量
     */
    BigDecimal occurQuantity
    /**
     * 发生金额
     */
    BigDecimal occurAmount
    /**
     * 库存成本
     */
    BigDecimal storeIncurred
    /**
     * 库存数量
     */
    BigDecimal storeQuantity
    /**
     * 库存金额
     */
    BigDecimal storeAmount
    /**
     * 发生类型
     */
    Integer occurType
    /**
     *  发生时间
     */
    Date occurAt
    /**
     * 单据号
     */
    String orderCode

}
