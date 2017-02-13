package smart.light.bus

import com.smart.common.annotation.TenantFilter

/**
 * 销售账单流水
 */
//@TenantFilter(column = "tenant_id")
class Sale {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * POS数据主键ID
     */
    BigInteger clientId
    /**
     * 所属门店，默认为0，代表总部
     */
    BigInteger branchId
    /**
     * 销售账单号
     */
    String saleCode
    /**
     * 
     */
    BigInteger posId
    /**
     * POS号(冗余字段)
     */
    String posCode
    /**
     * 销售合计
（所有单品计价的合计 商品原价*数量）
     */
    BigDecimal totalAmount
    /**
     * 折扣额
     */
    BigDecimal discountAmount
    /**
     * 赠送额
     */
    BigDecimal giveAmount
    /**
     * 长款金额
     */
    BigDecimal longAmount
    /**
     * 抹零额
     */
    BigDecimal truncAmount
    /**
     * 是否免单
     */
    boolean isFreeOfCharge
    /**
     * 所有服务费的合计，属于加收项目
包括座位费、加工费等
单项加工费另表保存
     */
    BigDecimal serviceFee
    /**
     * 实收金额=total_amount-discount_amount-give_amount-trunc_amount=sum(sale_payment.pay_total)-long_amount
     */
    BigDecimal receivedAmount
    /**
     * 收银员
     */
    BigInteger cashier
    /**
     * 结账时间
     */
    Date checkoutAt
    /**
     * 促销活动
     */
    BigInteger promotionId
    /**
     * 是否退货 0：销售 1 ：退货
     */
    boolean isRefund
    /**
     * 订单状态
0-录入
1-已提交
2-（卖方）已确认
3-（卖方）已拒绝
4-已支付
5-已取消
     */
    Integer orderStatus
    /**
     * 0-未发货
1-已发货
2-已收货
     */
    Integer deliveryStatus
    /**
     * 
     */
    String saleOrderCode
    /**
     * 订单类型：0-pos订单
     */
    Integer saleType

    BigInteger id
    BigInteger tenantId
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted

}
