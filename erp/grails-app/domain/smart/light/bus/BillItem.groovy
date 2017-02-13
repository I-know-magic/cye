package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 
 */
//@TenantFilter(column = "tenant_id")
class BillItem {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    BigInteger billId
    /**
     * 
     */
    String billSeqNo
    /**
     * 
     */
    BigInteger itemId
    /**
     * 
     */
    Integer qty
    /**
     * 
     */
    Integer sendQty
    /**
     * 
     */
    BigDecimal price
    /**
     * 
     */
    BigDecimal sum
    /**
     * 
     */
    String taste
    /**
     * 
     */
    String memo
    /**
     * 
     */
    Date addTime
    /**
     * 
     */
    Date submitTime
    /**
     * 
     */
    Date confirmTime
    /**
     * 
     */
    Date cancelTime
    /**
     * 
     */
    Date printTime
    /**
     * 
     */
    Date sendTime
    /**
     * 
     */
    String state
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
