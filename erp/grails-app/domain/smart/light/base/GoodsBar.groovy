package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * 商品条码
 */
//@TenantFilter(column = "tenant_id")
class GoodsBar {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 商品的id
     */
    BigInteger goodsId
    /**
     * 条码
     */
    String barCode

    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger tenantId

}
