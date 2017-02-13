package smart.light.web.base



/**
 * 终端设备
 */
//
class BaseBoundDevice {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    String memo
    /**
     * 
     */
    BigInteger deptId
    /**
     * 终端序号-测量点号（1-2040
     */
    Integer baseBoundDeviceNo
    /**
     * 终端设备地址-测量点地址
     */
    String baseBoundDevicecAddr
    /**
     * 通信端口号 默认31
     */
    Integer baseBoundDevicePort
    /**
     * 协议类型：路灯07，配置项
     */
    String baseBoundDeviceProcode
    /**
     * 通信速率 ：默认3。1:600;2:1200;3:2400;4:4800;5:7200;6:9600;7:19200
     */
    Integer baseBoundDeviceSpeed
    /**
     * 采集器地址 ：默认0
     */
    String baseBoundDevicecColAddr
    /**
     * 集中控制器id
     */
    BigInteger baseTerminalId
    /**
     * 终端设备编号（自编码）
     */
    String baseBoundDevicecCode
    /**
     * 经度
     */
    String baseBoundDevicecLng
    /**
     * 纬度
     */
    String baseBoundDevicecLat
    /**
     * 是否总表0否1是
     */
    boolean isTop
    /**
     * 类型：1路灯2水表3热表4四表合一
     */
    Integer baseBoundDevicecType

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
