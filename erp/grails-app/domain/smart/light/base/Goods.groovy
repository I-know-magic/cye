package smart.light.base

import com.smart.common.annotation.TenantFilter
import grails.converters.JSON
import org.hibernate.Transaction

import javax.persistence.Transient

/**
 * 商品
 */
//@TenantFilter(column = "tenant_id")
class Goods {


    static constraints = {

    }
    static mapping = {

    }

    static transients = ['teststr']
    /**
     * 商品分类
外键
     */
    BigInteger categoryId
    BigInteger categorySid
    /**
     * 商品名称
     */
    String goodsName
    String goodsName2
    String tastes

    /**
     * 条码
     */
    String barCode
    /**
     * 规格
     */
    String spec
    /**
     * 进价
     */
    BigDecimal purchasingPrice
    /**
     * 零售价
     */
    BigDecimal salePrice
    /**
     * 单位
     */
    BigInteger goodsUnitId
    /**
     * 会员价1
     */
    BigDecimal vipPrice1=salePrice
    /**
     * 会员价2
     */
    BigDecimal vipPrice2=salePrice
    /**
     * 商品状态
        0-正常
        1-停售
     */
    Integer goodsStatus
    /**
     * 品牌id
     */
//    BigInteger brandId
    /**
     * 商品简称
     */
    String shortName
    /**
     * 助记码
     */
    String mnemonic
    /**
     * 图片路径
     */
    String photo
    /**
     * 是否有折扣0否1是
     */
    boolean isDsc
    /**
     * 是否管理库存0否1是
     */
    boolean isStore
    /**
     * 备注
     */
    String memo
    String memo2
    /**
     * 已不使用
     */
    Integer priceType

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId
    BigInteger branchId=new BigInteger("1")
//    String goodsUnitName;

    String teststr

    String categoryName
    String tastesIds="0"
}
