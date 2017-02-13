package smart.light.web.vo

/**
 * Created by zcl on 16/4/27.
 */
class BusChargingPileHisDataVo {

    String baseBoundDevicecCode

    String baseAreaName
    /**
     * 设备地址
     */
    String baseChargingPileDevaddr
    /**
     * 电压
     */
    BigDecimal busChargingPileHisDataVoltage
    /**
     * 电流
     */
    BigDecimal busChargingPileHisDataElectric
    /**
     * 功率
     */
    BigDecimal busChargingPileHisDataPower
    /**
     * 电量
     */
    BigDecimal busChargingPileHisDataElectricity
    /**
     * 终端抄读时间
     */
    Date busChargingPileHisDataQueryTime
    /**
     * 数据冻结时间
     */
    Date busChargingPileHisDataDayTime



}
