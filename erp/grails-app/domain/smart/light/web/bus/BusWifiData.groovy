package smart.light.web.bus



/**
 * 
 */
//
class BusWifiData {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    String memo
    /**
     * 
     */
    BigInteger deptId
    /**
     * 报警状态：默认0正常，1损坏
     */
    Integer busWifiDataWarningState
    /**
     * 设备地址
     */
    String baseWifiDevaddr
    /**
     * wifiid
     */
    BigInteger baseWifiId

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
