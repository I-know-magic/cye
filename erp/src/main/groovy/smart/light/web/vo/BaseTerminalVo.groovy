package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/26.
 */
class BaseTerminalVo {
    /**
     * 区域名称
     */
    String baseAreaName
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
     * sms卡号
     */
    String baseTerminalSms
    /**
     * 经度
     */
    String baseTerminalLng
    /**
     * 纬度
     */
    String baseTerminalLat
    /**
     * 区域id，叶子节点
     */
    BigInteger baseAreaId

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id
}
