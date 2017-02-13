package smart.light.saas


/**
 * 权限定义表
 */
class SysPrivilege {

    static constraints = {

    }
    static mapping = {
        table 's_privilege'
        sysRoles column: 'privilege_id', joinTable: 's_role_privilege_r'
//        goodses column: 'privilege_id', joinTable: 's_goods_privilege_r'
        res lazy: false
        op lazy: false
    }
    static belongsTo = SysRole;
    static hasMany = [sysRoles:SysRole];

    /**
     * 资源
     */
    SysRes res
    /**
     * 操作
     */
    SysOperate op
    /**
     * 是否不进行权限控制，0-否（默认）1-是。为1时，不做权限控制。
     */
    boolean isFree

    BigInteger id

}
