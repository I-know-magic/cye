package smart.light.web.vo
/**
 * 门店Vo
 * lvpeng on 2015/9/23.
 */
class AppraiseVo {
    /**
     * 订单号-UUID
     */
    String orderid
    /**
     * 订单提交时间
     */
    Date orderposttime
    /**
     * 最晚抵达时间-要货时间
     */
    Date arrivedtime
    /**
     * 订单状态-默认0  1为系统工具自动监测车辆进入客户区域视为系统检测已送达
     */
    Integer orderstatus=0
    /**
     * 默认0   1-司机app按送达按钮，代表司机确认送达
     */
    Integer orderdriverconfirm=0
    /**
     * 0-默认  1客户确认签收
     */
    Integer ordercustomerconfirm=0
    /**
     * 0-未评价  1-5代表评价5个级别－当用户评价后，客户确认签收置1
     */
    Integer ordercustomergood=0
    /**
     * 司机确认送达时间
     */
    Date orderdriverconfirmtime
//    /**
//     * 客户id
//     */
//    BigInteger customerid
    /**
     * 货物数量-单位立方
     */
    Integer ordergoodsnum=0

    BigInteger id
    BigInteger cid
    BigInteger carid
    BigInteger catid
    BigInteger driverid
    boolean isDeleted=false
    String customername
    String catName
    String customerphone
    String customeraddress
    String customercompany
    String carno
    String drivername
    BigDecimal avgnum
}
