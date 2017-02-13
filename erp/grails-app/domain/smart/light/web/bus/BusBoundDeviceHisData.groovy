package smart.light.web.bus



/**
 * 终端设备历史信息
 */
//
class BusBoundDeviceHisData {

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
     * 终端序号-测量点号（1-2040
     */
    Integer baseBoundDeviceNo
    /**
     * 电压
     */
    BigDecimal busBoundDeviceHisDataVoltage
    /**
     * 电流
     */
    BigDecimal busBoundDeviceHisDataElectric
    /**
     * 功率
     */
    BigDecimal busBoundDeviceHisDataPower
    /**
     * 电量
     */
    BigDecimal busBoundDeviceHisDataElectricity
    /**
     * 开关状态0开1关
     */
    Integer busBoundDeviceHisDataSwich
    /**
     * 类型：1主灯2辅灯
     */
    Integer busBoundDeviceHisDataDevType
    /**
     * 亮度
     */
    Integer busBoundDeviceHisDataValue
    /**
     * 终端抄读时间
     */
    Date busBoundDeviceHisDataQueryTime
    /**
     * 数据冻结时间
     */
    Date busBoundDeviceHisDataDayTime

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
