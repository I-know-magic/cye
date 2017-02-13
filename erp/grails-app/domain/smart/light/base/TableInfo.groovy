package smart.light.base

import com.smart.common.annotation.TenantFilter
/**
 * 
 */
//@TenantFilter(column = "tenant_id")
class TableInfo {

    static constraints = {

    }
    static mapping = {

    }
    static transients = ['createBy','createAt','lastUpdateBy','lastUpdateAt']

    /**
     * 
     */
    BigInteger areaId
    /**
     * 
     */
    String name
    /**
     * 
     */
    String state
    /**
     * 
     */
    Date submitTime
    /**
     * 
     */
    String billSeqNo
    /**
     * 
     */
    BigInteger branchId=new BigInteger("1")

    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger tenantId

}
