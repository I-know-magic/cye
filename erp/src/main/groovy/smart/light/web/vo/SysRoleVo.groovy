package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/26.
 */
class SysRoleVo {
    /**
     * 子系统默认包名，用于区分子系统
     */
    String packageName
    /**
     * 门店id
     */
    BigInteger branchId
    /**
     * 角色编码
     */
    String roleCode
    /**
     * 角色名称
     */
    String roleName
    String  branchName
    BigInteger id
    BigInteger tenantId
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted

}
