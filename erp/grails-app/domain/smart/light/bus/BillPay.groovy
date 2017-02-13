package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 
 */
//@TenantFilter(column = "tenant_id")
class BillPay {

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
    String payType
    /**
     * 
     */
    BigDecimal payMoney
    /**
     * 
     */
    BigDecimal exchange
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
