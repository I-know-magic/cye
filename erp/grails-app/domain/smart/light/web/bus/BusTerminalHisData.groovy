package smart.light.web.bus



/**
 * 集中控制器历史数据信息
 */
//
class BusTerminalHisData {

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
     * 总控开关（拉合闸状态  0无状态，1拉闸，2合闸，3异常状态）
     */
    Integer busTerminalHisDataSwitch
    /**
     * 回路状态（8位二进制，异常为1）
     */
    String busTerminalHisDataLoop
    /**
     * 控制模式：1继电器控制，2载波广播控制
     */
    Integer busTerminalHisDataModel
    /**
     * 在线状态 0在线1不在线
     */
    Integer busTerminalHisDataState

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
