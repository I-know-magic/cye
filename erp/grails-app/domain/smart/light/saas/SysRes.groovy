package smart.light.saas

/**
 * 系统资源
 */
class SysRes {

    static constraints = {

    }
    static mapping = {
        table 's_res'

    }

    /**
     * 子系统默认包名，用于区分子系统
     */
    String packageName
    /**
     * 排序字段
     */
    String resCode
    /**
     * 资源名称
     */
    String resName
    /**
     * Controller名称
     */
    String controllerName
    /**
     * 备注
     */
    String memo
    /**
     * 父资源
     */
    BigInteger parentId
    /**
     * 资源状态 0-正常,1-停用
     */
    Integer resStatus

    BigInteger id


}
