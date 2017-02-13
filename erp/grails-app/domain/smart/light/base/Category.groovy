package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * 商品分类
 */
//@TenantFilter(column = "tenant_id")
class Category {

    static constraints = {

    }
    static mapping = {

    }

    static transients = ['mnemonics','createBy','createAt','lastUpdateBy','lastUpdateAt']
    /**
     * 商品分类码
     */
    String catCode
    /**
     * 商品分类名称
     */
    String catName
    String catName2
    /**
     * 助记码
     */
    String mnemonics
    String parentName
    /**
     * 上级分类ID
外键
     */
    BigInteger parentId
    /**
     * 
     */
    Integer categoryType

    BigInteger id
    BigInteger tenantId
    BigInteger branchId=new BigInteger("1")
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted

}
