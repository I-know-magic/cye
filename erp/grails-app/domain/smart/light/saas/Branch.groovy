package smart.light.saas



/**
 * 门店信息（组织结构表，含总部、配送中心、分店）
 */

class Branch {

    static constraints = {
        name blank: false, maxSize: 30, nullable: false
        contacts maxSize: 20,nullable: false
        phone maxSize: 20,nullable: false
        branchType nullable: false, inList: [0, 1, 2]
        address nullable: false,maxSize: 50

    }
    static mapping = {

    }

    /**
     * 0总部1配送中心2分店
     */
    Integer branchType
    /**
     * 代码
     */
    String code
    /**
     * 名称
     */
    String name
    /**
     * 联系电话
     */
    String phone
    /**
     * 联系人
     */
    String contacts
    /**
     * 地址
     */
    String address
    /**
     * 状态0 停用1启用
     */
    Integer status
    /**
     * 备注
     */
    String memo

    BigInteger id
    BigInteger tenantId
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted=false

}
