package smart.light.saas



/**
 * 定时任务表
 */
//
class JobScheduler {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    String memo
    /**
     * 频率
     */
    Integer rate
    /**
     * 
     */
    Date beginTime
    /**
     * 类型1-日冻结
     */
    Integer type

    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
