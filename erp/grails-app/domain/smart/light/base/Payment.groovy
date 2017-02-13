package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * 支付方式
 */
//@TenantFilter(column = "tenant_id")
class Payment {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * '支付代码'
CSH 现金
CRD 银行卡
ZFB 支付宝
WZF 微信支付
JFD 积分抵现
CZF 储值支付
     */
    String paymentCode
    /**
     * '支付名称'
     */
    String paymentName
    /**
     * 0-正常
1-停用
     */
    Integer paymentStatus
    /**
     * 货币ID

0-默认货币,人民币
     */
    BigInteger currencyId
    /**
     * 所属门店，默认为0，代表总部
     */
    BigInteger branchId
    /**
     * 0否1是
     */
    boolean isScore
    /**
     * 0否1是
     */
    boolean isChange
    /**
     * 0否1是
     */
    boolean isMemo
    /**
     * 0否1是
     */
    boolean isSale
    /**
     * 固定面值
     */
    BigDecimal fixValue
    /**
     * 单笔限次
     */
    Integer fixNum
    /**
     * 支付类型
     */
    Integer paymentType
    /**
     * 是否代金券：0否1是
     */
    boolean isVoucher

    BigInteger id
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted
    BigInteger tenantId

}
