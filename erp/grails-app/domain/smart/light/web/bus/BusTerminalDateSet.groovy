package smart.light.web.bus



/**
 * 时段任务设置
 */
//
class BusTerminalDateSet {

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
     * 集中控制器id
     */
    BigInteger baseTerminalId
    /**
     * 名字
     */
    String busTerminalDateSetName
    /**
     * 序号
     */
    Integer busTerminalDateSetNo
    /**
     * 优先级 默认0 普通 1紧急
     */
    Integer busTerminalDateSetLevel
    /**
     * 开灯时间（时分秒）
     */
    Date busTerminalDateSetOpen
    /**
     * 关灯时间
     */
    Date busTerminalDateSetClose
    /**
     * 有效时间起（年月日时分秒）
     */
    Date busTerminalDateSetBegin
    /**
     * 有效时间止
     */
    Date busTerminalDateSetEnd
    /**
     * 年通用类型：0通用1不通用，默认0
     */
    Integer busTerminalDateSetIsYear
    /**
     * 是否默认数据 0否1是
     */
    Integer busTerminalDateSetDefault

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
