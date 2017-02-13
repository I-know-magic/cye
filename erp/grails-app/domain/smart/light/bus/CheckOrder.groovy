package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 盘点单
 */
//@TenantFilter(column = "tenant_id")
class CheckOrder {

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
     * 
     */
    String code
    /**
     * 仓库id
     */
    BigInteger storageId
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
     * 
     */
    BigDecimal checkQuantity
    /**
     * 
     */
    BigDecimal checkAmount
    /**
     * 
     */
    BigDecimal reallyQuantity

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId
    Integer status
    /**
     * 审核人
     */
    String auditName
    /**
     * 审核时间
     */
    Date auditAt

    Date checkAt
}
