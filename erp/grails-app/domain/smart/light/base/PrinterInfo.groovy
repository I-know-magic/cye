package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * 打印机信息
 */
//@TenantFilter(column = "tenant_id")
class PrinterInfo {

    static constraints = {

    }
    static mapping = {

    }
    static transients = ['createBy','createAt','lastUpdateBy','lastUpdateAt']

    /**
     * 
     */
    String printerName
    /**
     * 
     */
    String ipAddress
    /**
     * 
     */
    String groupIds
    /**
     * 0-账单；1-总单；2-分单
     */
    String printType
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
