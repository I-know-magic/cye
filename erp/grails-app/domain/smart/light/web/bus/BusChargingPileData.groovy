package smart.light.web.bus



/**
 * 
 */
//
class BusChargingPileData {

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
    BigDecimal busChargingPileDataVoltage
    /**
     * 电流
     */
    BigDecimal busChargingPileDataElectric
    /**
     * 功率
     */
    BigDecimal busChargingPileDataPower
    /**
     * 电量
     */
    BigDecimal busChargingPileDataElectricity
    /**
     * 状态：0使用1空闲
     */
    Integer busChargingPileDataState
    /**
     * 报警状态：默认0正常，1损坏
     */
    Integer busChargingPileDataWarningState

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
