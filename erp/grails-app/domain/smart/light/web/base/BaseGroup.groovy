package smart.light.web.base



/**
 * 分组
 */
//
class BaseGroup {

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
     * 分组名称
     */
    String baseGroupName
    /**
     * 编号：范围01-16
     */
    String baseGroupCode
    /**
     * 集中控制器id
     */
    BigInteger baseTerminalId

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
