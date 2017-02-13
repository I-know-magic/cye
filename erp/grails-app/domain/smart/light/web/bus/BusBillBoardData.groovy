package smart.light.web.bus



/**
 * 广告牌实时信息
 */
//
class BusBillBoardData {

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
     * 广告牌编码
     */
    String baseBillBoardCode
    /**
     * 设备地址
     */
    String baseBillBoardDevaddr
    /**
     * 广告内容
     */
    String busBillBoardDataContent
    /**
     * 报警状态：默认0正常，1损坏
     */
    Integer busBillBoardDataWarningState

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
