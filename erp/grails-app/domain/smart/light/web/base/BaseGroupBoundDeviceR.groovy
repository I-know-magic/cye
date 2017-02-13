package smart.light.web.base



/**
 * 分组-终端设备
 */
//
class BaseGroupBoundDeviceR {

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
     * 分组id
     */
    BigInteger baseGroupId
    /**
     * 终端设备id
     */
    BigInteger baseBoundDeviceId

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted

}
