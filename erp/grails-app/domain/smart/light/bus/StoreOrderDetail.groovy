package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 单据明细
 */
//@TenantFilter(column = "tenant_id")
class StoreOrderDetail {

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
     * 单价
     */
    BigDecimal purchaseAmount
    /**
     * 数量
     */
    BigDecimal quantity
    /**
     * 
     */
    BigDecimal amount
    /**
     * 入库单Id
     */
    BigInteger storeOrderId
    /**
     * 商品Id
     */
    BigInteger goodsId

    BigInteger id
    Date createAt
    String createBy
    String storeOrderCode
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
