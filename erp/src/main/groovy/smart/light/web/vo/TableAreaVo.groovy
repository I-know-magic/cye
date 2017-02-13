package smart.light.web.vo
/**
 * 门店Vo
 * lvpeng on 2015/9/23.
 */
class TableAreaVo {
    /**
     *
     */
    String name
    Integer tablenum
    /**
     *
     */
    BigInteger branchId

    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger tenantId
}
