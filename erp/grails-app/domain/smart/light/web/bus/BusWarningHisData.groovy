package smart.light.web.bus



/**
 * 
 */
//
class BusWarningHisData {

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
    Integer busWarningHisDataWarningState
    /**
     * 类型：1主灯2辅灯
     */
    Integer busWarningHisDataDevType
    /**
     * 集中器地址
     */
    String baseTerminalAddr
    /**
     * 终端序号-测量点号（1-2040
     */
    Integer baseBoundDeviceNo

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
