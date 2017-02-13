package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/25.
 */
class LineVo {

    /**
     *
     */
    String wd
    /**
     *
     */
    String jd
    /**
     * auto
     */
    String linename
    /**
     * 0-关闭  1-开启
     */
    Integer status

    BigInteger carid
    String carno

    BigInteger id
    boolean isDeleted=false

}
