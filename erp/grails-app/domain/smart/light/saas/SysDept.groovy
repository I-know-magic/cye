package smart.light.saas



/**
 * 部门
 */
//
class SysDept {

    static constraints = {

    }
    static mapping = {
        table 's_dept'

    }

    /**
     * 部门名称
     */
    String name
    /**
     * 父节点名称
     */
    String parentName
    /**
     * 编码
     */
    String code
    /**
     * 备注
     */
    String memo
    /**
     * 父资源
     */
    BigInteger parentId

    BigInteger id

}
