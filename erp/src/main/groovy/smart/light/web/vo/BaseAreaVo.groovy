package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/26.
 */
class BaseAreaVo {
    /**
     * 管理者名称
     */
    String empName
    /**
     *
     */
    String memo
    /**
     *
     */
    BigInteger deptId
    /**
     * 区域属性：1线路2台区，通过配置读取写入
     */
    Integer baseAreaType=1
    /**
     * 名称
     */
    String baseAreaName
    /**
     * 父节点id
     */
    BigInteger baseAreaPid
    //集中控制器id
    BigInteger tid
    /**
     * 父节点名称
     */
    String baseAreaPname
    //终端地址
    String baseTerminalAddr
    //终端sms
    String baseTerminalSms
    String lng
    String lat
    Integer isArea
    /**
     * 员工id，区域管理者
     */
    BigInteger empId
    //区域id
    BigInteger aid

    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger id


}
