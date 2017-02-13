package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 盘点单明细
 */
//@TenantFilter(column = "tenant_id")
class CheckOrderDetail {

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
     * 进价
     */
    BigDecimal purchasePrice
    /**
     * 库存数量
     */
    BigDecimal quantity
    /**
     * 入库单Id
     */
    BigInteger checkOrderId
    /**
     * 商品Id
     */
    BigInteger goodsId
    /**
     * 实际数量
     */
    BigDecimal reallyQuantity
    /**
     * 
     */
    BigDecimal checkQuantity
    /**
     * 
     */
    BigDecimal checkAmount

    BigInteger id
    Date createAt
    String createBy
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId
    String code

}
