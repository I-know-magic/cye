package smart.light.web.base



/**
 * 
 */
//
class BaseWifi {

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
     * 终端设备id
     */
    BigInteger baseBoundDeviceId
    /**
     * ip
     */
    String baseWifiIp
    /**
     * 设备地址
     */
    String baseWifiDevaddr

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
