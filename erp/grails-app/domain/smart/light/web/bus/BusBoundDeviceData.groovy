package smart.light.web.bus



/**
 * 终端设备实时信息
 */
//
class BusBoundDeviceData {

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
    BigDecimal busBoundDeviceDataVoltage
    /**
     * 电流
     */
    BigDecimal busBoundDeviceDataElectric
    /**
     * 功率
     */
    BigDecimal busBoundDeviceDataPower
    /**
     * 电量
     */
    BigDecimal busBoundDeviceDataElectricity
    /**
     * 开关状态0开1关
     */
    Integer busBoundDeviceDataSwich
    /**
     * 类型：1主灯2辅灯
     */
    Integer busBoundDeviceDataDevType
    /**
     * 亮度
     */
    Integer busBoundDeviceDataValue
    /**
     * 报警状态：默认0正常，1损坏
     */
    Integer busBoundDeviceDataWaringState

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
