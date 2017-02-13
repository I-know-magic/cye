package smart.light.web.bus



/**
 * 集中控制器报警设置
 */
//
class BusTerminalWarningSet {

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
     * 功率上限
     */
    BigDecimal busTerminalWarningPowerUpper
    /**
     * 功率下限
     */
    BigDecimal busTerminalWarningPowerLimit
    /**
     * 集中器地址
     */
    String baseTerminalAddr

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
