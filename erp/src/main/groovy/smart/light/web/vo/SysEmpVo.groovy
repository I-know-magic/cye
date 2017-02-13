package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/26.
 */
class SysEmpVo {
    /**
     * 名称
     */
    String name
    /**
     * 地址
     */
    String addr
    /**
     * 电话
     */
    String phone
    /**
     * 备注
     */
    String memo
    /**
     * 登录用户id
     */
    BigInteger userId
    /**
     * 父资源
     */
    BigInteger deptId
    /**
     * 登录账号
     */
    String loginName
    String deptName

    BigInteger id
    boolean isDeleted
}
