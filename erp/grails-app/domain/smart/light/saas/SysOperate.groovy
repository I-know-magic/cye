package smart.light.saas

/**
 * 操作定义
 */
class SysOperate {

    static constraints = {

    }
    static mapping = {
        table 's_operate'

    }

    /**
     * 排序字段
     */
    String opCode
    /**
     * 操作名称
     */
    String opName
    /**
     * action名称
     */
    String actionName
    /**
     * 备注
     */
    String memo

    BigInteger id


}
