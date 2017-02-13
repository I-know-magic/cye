package smart.light.web.base



/**
 * 充电桩
 */
//
class BaseChargingPile {

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
     * 充电桩地址
     */
    String baseChargingPileAddr
    /**
     * 设备地址
     */
    String baseChargingPileDevaddr

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
