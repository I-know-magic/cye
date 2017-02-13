package smart.light.web.bus



/**
 * 集中器节能设置
 */
//
class BusTerminalEnergySet {

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
     * 
     */
    Date busTerminalEnergySetBegin
    /**
     * 结束时间
     */
    Date busTerminalEnergySetEnd
    /**
     * 分组id
     */
    BigInteger baseGroupId
    /**
     * 
     */
    Integer busTerminalEnergySetType
    /**
     * 亮度值
     */
    Integer busTerminalEnergySetValue

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
