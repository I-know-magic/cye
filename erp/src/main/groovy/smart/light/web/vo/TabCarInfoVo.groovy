package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/25.
 */
class TabCarInfoVo {
    /**
     * 车牌号
     */
    String carno
    /**
     * 所属配送区域id
     */
    BigInteger areaid
    /**
     * 车辆类型［1货车、2轿车］
     */
    Integer cartype
    /**
     * 手机sim卡号
     */
    String simno
    /**
     * 车辆颜色
     */
    String carcolor
    /**
     * 发动机编号
     */
    String carengineno
    /**
     * 车辆到期年检时间
     */
    Date carchecktime
    /**
     * 驾驶车辆司机编号
     */
    BigInteger cardriverid
    /**
     * 车辆保险到期时间
     */
    Date carsafetime
    /**
     * 行车证到期时间
     */
    Date cardrivetime
    /**
     * 车辆到期保养时间
     */
    Date carcaretime

    BigInteger id
    boolean isDeleted=false

    String drivername
    /**
     * 纬度-auto
     */
    String customerwd
    /**
     * 经度-auto
     */
    String customerjd
}
