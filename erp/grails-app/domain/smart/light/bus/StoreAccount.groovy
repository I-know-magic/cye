package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 库存流水
 */
//@TenantFilter(column = "tenant_id")
class StoreAccount {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    String memo
    /**
     * 门店Id
     */
    BigInteger branchId
    /**
     * 发生成本
     */
    BigDecimal occurIncurred
    /**
     * 发生数量
     */
    BigDecimal occurQuantity
    /**
     * 
     */
    BigDecimal occurAmount
    /**
     * 商品Id
     */
    BigInteger goodsId
    /**
     * 发生时间
     */
    Date occurAt
    /**
     * 库存成本
     */
    BigDecimal storeIncurred
    /**
     * 库存数量
     */
    BigDecimal storeQuantity
    /**
     * 
     */
    BigDecimal storeAmount
    /**
     * 发生类型1 pos销售 2 POS退货 3入库 4出库 5盘点
     */
    Integer occurType
    /**
     * 单据号
     */
    String orderCode
    /**
     * 发生时间
     */
    Date storeAccountAt

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
