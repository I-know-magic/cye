package smart.light.web.base



/**
 * 集中控制器
 */
//
class BaseTerminal {

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
     * 集中器地址
     */
    String baseTerminalAddr
    /**
     * sms卡号
     */
    String baseTerminalSms
    /**
     * 经度
     */
    String baseTerminalLng
    /**
     * 纬度
     */
    String baseTerminalLat
    /**
     * 区域id，叶子节点
     */
    BigInteger baseAreaId

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
