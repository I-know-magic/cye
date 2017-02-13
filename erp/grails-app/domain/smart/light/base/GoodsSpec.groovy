package smart.light.base
/**
 * 商品口味
 */
//@TenantFilter(column = "tenant_id")
class GoodsSpec {

    static constraints = {

    }
    static mapping = {

    }
    static transients = ['createBy','createAt','lastUpdateBy','lastUpdateAt']

    /**
     * 中文
     */
    String specName
    /**
     * 英文
     */
    String specName2
    /**
     * 价格
     */
    BigDecimal price
    /**
     * 
     */
    String crateBy
    /**
     * 
     */
    BigInteger branchId=new BigInteger("1")

    BigInteger id
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
