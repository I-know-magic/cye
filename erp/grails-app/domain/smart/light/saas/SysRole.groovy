package smart.light.saas

/**
 * 角色信息
 */
class SysRole {

    static constraints = {

    }
    static mapping = {
        table 's_role'
        sysPrivileges column: 'role_id', joinTable: 's_role_privilege_r'
        sysUsers column: 'role_id', joinTable: 's_user_role_r'
    }

    static hasMany = [sysPrivileges:SysPrivilege, sysUsers:SysUser]
    static belongsTo = SysUser;

    /**
     * 子系统默认包名，用于区分子系统
     */
    String packageName
//    /**
//     * 门店id
//     */
//    BigInteger branchId
    /**
     * 角色编码
     */
    String roleCode
    /**
     * 角色名称
     */
    String roleName
//    /**
//     * 角色类型
//     */
//    Integer roleType

    BigInteger id
    BigInteger tenantId
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted

}
