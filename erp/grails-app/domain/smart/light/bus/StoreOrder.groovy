package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * （出入库）单据
 */
//@TenantFilter(column = "tenant_id")
class StoreOrder {

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
     * 单号规则见用例
     */
    String code
    /**
     * 制单人
     */
    BigInteger makeBy
    /**
     * 制单人姓名
     */
    String makeName

    /**
     * 制单时间
     */
    Date makeAt
    /**
     * 审核人
     */
    String auditName
    /**
     * 审核时间
     */
    Date auditAt

    Date storeOrderAt
    /**
     * 
     */
    BigDecimal quantity
    /**
     * 
     */
    BigDecimal amount
    /**
     * 1入库2出库
     */
    Integer orderType

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId
    Integer status

}
