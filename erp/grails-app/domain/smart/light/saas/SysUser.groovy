package smart.light.saas

/**
 * 系统用户表
 */

class SysUser {

    static constraints = {

    }
    static mapping = {
        table 's_user'
        sysRoles column: 'user_id', joinTable: 's_user_role_r'
    }
    static hasMany = [sysRoles:SysRole]
    /**
     * 登录帐号
     */
    String loginName
    /**
     * 登录密码（32位md5加密）
     */
    String loginPass
    /**
     * 用户类型（1-商户；2-代理商；3-商户员工；4-营运人员；5-维护人员；6-顾客）
     */
    Integer userType
//    /**
//     * 邀请码（此字段已停用）
//     */
//    String inviteCode
    /**
     * 用户绑定的手机号
     */
    String bindMobile
    /**
     * 用户绑定的微信号OpenID
     */
    String bindWechat
    /**
     * 用户绑定的qq号
     */
    String bindQq
    /**
     * 用户绑定的邮箱
     */
    String bindEmail
    /**
     * 用户状态（0-未激活；1-启用；2-停用）未激活的帐号为无效帐号，3分钟后可重复注册
     */
    Integer state
    /**
     * 姓名
     */
    String name
    /**
     * 登录次数
     */
    Integer loginCount
    /**
     * 上次登录时间
     */
    Date lastLoginTime
    /**
     * 上次登录IP
     */
    String lastLoginIp
    /**
     * 备注
     */
    String remark

    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted

}
