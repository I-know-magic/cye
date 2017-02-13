package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * 商品单位
 */
//@TenantFilter(column = "tenant_id")
class GoodsUnit {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 编码
     */
    String unitCode
    /**
     * 名称
     */
    String unitName
    /**
     * 助记码
     */
    String mnemonic

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
