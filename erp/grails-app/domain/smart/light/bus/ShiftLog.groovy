package smart.light.bus



/**
 * 
 */
//
class ShiftLog {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    BigInteger userId
    /**
     * 登录帐号
     */
    String userName
    /**
     * 
     */
    Date loginTime
    /**
     * 
     */
    Date handoverTime
    /**
     * 
     */
    String shiftDate
    /**
     * 
     */
    String shiftName

    BigInteger id
    boolean isDeleted

}
