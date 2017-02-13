package smart.light.web.bus



/**
 * 充电桩历史信息
 */
//
class BusChargingPileHisData {

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

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
