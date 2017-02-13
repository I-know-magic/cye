package smart.light.saas



/**
 * 部门
 */
//
class SysEmp {

    static constraints = {

    }
    static mapping = {
        table 'employee'

    }

    /**
     * 用户ID，sys_user.id（只有设置了用户ID的员工可以登录系统）
     */
    BigInteger userId
    BigInteger tenantId
    BigInteger branchId
    /**
     * 登录帐号，sys_user.login_name（冗余字段）
     */
    String loginName
    /**
     * 地址
     */
    String addr
    /**
     * 姓名
     */
    String name

    /**
     * 电话
     */
    String phone
    String passwordForLocal

    /**
     * 备注
     */
    String memo

    BigInteger id

    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted

}
