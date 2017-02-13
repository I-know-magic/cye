package smart.light.web.vo

/**
 * Created by zcl on 16/4/26.
 */
class BusWarningHisDataVo {


    /**
     *
     */
    String memo
    /**
     * 报警状态：默认0正常，1损坏
     */
    Integer busWarningHisDataWarningState
    /**
     * 类型：1主灯2辅灯
     */
    Integer busWarningHisDataDevType
    /**
     * 集中器地址
     */
    String baseTerminalAddr
    /**
     * 终端序号-测量点号（1-2040
     */
    Integer baseBoundDeviceNo
    String baseBoundDevicecLng
    String baseBoundDevicecLat
    Date createAt
    String createBy
    String baseAreaName
    String baseBoundDevicecCode
    String baseBoundDevicecAddr
    String name
    String phone
    boolean baseWarningHisDataConfirm
    String lastUpdateBy
    boolean isDeleted
    BigInteger id


}
