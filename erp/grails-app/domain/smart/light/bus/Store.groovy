package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 库存表
 */
//@TenantFilter(column = "tenant_id")
class Store {

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
     * 仓库Id
     */
    BigInteger storageId
    /**
     * 商品Id
     */
    BigInteger goodsId
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
     * 
     */
    BigDecimal storeAmount

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
