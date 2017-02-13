package smart.light.bus


import com.smart.common.annotation.TenantFilter

/**
 * 交接班日志表
 */
//@TenantFilter(column = "tenant_id")
class HandoverLog {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    BigInteger shiftId
    /**
     * 
     */
    String groupName
    /**
     * 
     */
    Integer sortNo
    /**
     * 
     */
    String itemKey
    /**
     * 
     */
    String itemLabel
    /**
     * 
     */
    String itemValue

    BigInteger id

}
