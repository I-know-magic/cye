package smart.light.web.base



/**
 * 广告牌
 */
//
class BaseBillBoard {

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
     * 广告牌编码
     */
    String baseBillBoardCode
    /**
     * 设备地址
     */
    String baseBillBoardDevaddr

    Date createAt
    Date lastUpdateAt
    String createBy
    String lastUpdateBy
    boolean isDeleted
    BigInteger id

}
