package smart.light.web.base



/**
 * 摄像头
 */
//
class BaseCamera {

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
     * 摄像头ip
     */
    String baseCameraIp
    /**
     * 厂家
     */
    String baseCameraFactory

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
