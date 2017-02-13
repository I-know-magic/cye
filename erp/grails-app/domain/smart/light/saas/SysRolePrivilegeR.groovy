package smart.light.saas


/**
 * 角色权限关系表
 */

class SysRolePrivilegeR {

    static constraints = {

    }
    static mapping = {
        table 's_role_privilege_r'

    }

    /**
     * 角色
     */
    SysRole role
    /**
     * 权限
     */
    SysPrivilege privilege
    /**
     * 有效日期
     */
    java.sql.Date limitDate
    /**
     * 是否禁用,0-启用，1-禁用
     */
    boolean isDisable

}
