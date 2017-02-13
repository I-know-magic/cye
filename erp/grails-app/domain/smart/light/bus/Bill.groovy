package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 账单
 */
//@TenantFilter(column = "tenant_id")
class Bill {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    String billNo
    /**
     * 
     */
    BigInteger userId
    /**
     * 
     */
    BigInteger tableId
    /**
     * 
     */
    String tableName
    /**
     * 
     */
    boolean isTakeout
    /**
     * 
     */
    BigInteger vipId
    /**
     * 
     */
    String vipCode
    /**
     * 
     */
    Integer personCount
    /**
     * 
     */
    BigDecimal itemTotal
    /**
     * 
     */
    BigDecimal payTotal
    /**
     * 
     */
    boolean isPaid
    /**
     * 
     */
    Date createTime
    /**
     * 
     */
    Date submitTime
    /**
     * 
     */
    Date cancelTime
    /**
     * 
     */
    Date payTime
    /**
     * 
     */
    String seqNo
    /**
     * 
     */
    BigInteger branchId

    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger tenantId

}
