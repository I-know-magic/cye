package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/25.
 */
class CusSpeedVo {
/**
 * 速度限制
 */
    Integer limitd
    /**
     * 0-关闭  1-开启
     */
    Integer status
    /**
     *
     */
    BigInteger carid

    BigInteger id
    boolean isDeleted=false
    String carno
}
