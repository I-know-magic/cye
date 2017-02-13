package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/26.
 */
class BusEnergySetVo {
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
    BigInteger baseTerDateSetId
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
    /**
     * 分组名称
     */
    String baseGroupName
    String baseGroupCode
}
