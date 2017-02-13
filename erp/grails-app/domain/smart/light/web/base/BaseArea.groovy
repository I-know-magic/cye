package smart.light.web.base



/**
 * 区域
 */
//
class BaseArea {

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
     * 区域属性：1线路2台区，通过配置读取写入
     */
    Integer baseAreaType
    /**
     * 名称
     */
    String baseAreaName
    /**
     * 父节点id
     */
    BigInteger baseAreaPid
    /**
     * 父节点名称
     */
    String baseAreaPname
    /**
     * 员工id，区域管理者
     */
    BigInteger empId

    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
