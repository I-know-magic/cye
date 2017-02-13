package smart.light.web.vo

/**
 * Created by zcl on 16/4/22.
 */
class BusBoundDeviceHisDataVo {

    /**
     * 报警状态：默认0正常，1损坏
     */
    Integer busBoundDeviceDataWaringState

    /**
     * 亮度
     */
    Integer busBoundDeviceHisDataValue
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
     * 终端抄读时间
     */
    Date busBoundDeviceHisDataQueryTime
    /**
     * 数据冻结时间
     */
    Date busBoundDeviceHisDataDayTime

    String baseBoundDevicecAddr

    String baseBoundDevicecCode

    String baseAreaName

    BigInteger id

}
