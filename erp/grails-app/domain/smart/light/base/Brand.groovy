package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * 品牌
 */
//@TenantFilter(column = "tenant_id")
class Brand {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 编码
     */
    String code
    /**
     * 名称
     */
    String name
    /**
     * 状态：0正常1停用
     */
    Integer state
    /**
     * 助记码
     */
    String mnemonic
    /**
     * 备注
     */
    String memo

    BigInteger id
    BigInteger tenantId
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted

}
