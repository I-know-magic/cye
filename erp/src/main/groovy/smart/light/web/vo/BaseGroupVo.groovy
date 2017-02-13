package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/26.
 */
class BaseGroupVo {
    /**
     *
     */
    String memo
    /**
     *
     */
    BigInteger deptId
    /**
     * 分组名称
     */
    String baseGroupName
    /**
     * 编号：范围01-16
     */
    String baseGroupCode

    /**
     * 集中器地址
     */
    String baseTerminalAddr
    String devices
    String glen
    String deviceCodes
    /**
     * 集中控制器id
     */
    BigInteger baseTerminalId

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id


}
