package smart.light.saas



/**
 * 商户信息表
 */
//
class Tenant {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 对应的用户ID，sys_user.id
     */
    BigInteger userId
    /**
     * 商户ID，8位纯数字
     */
    String code
    /**
     * 商户名称
     */
    String name
    /**
     * 详细地址
     */
    String address
    /**
     * 所在省份区划代码
     */
    String province
    /**
     * 所在地市区划代码
     */
    String city
    /**
     * 所在区县区划代码
     */
    String county
    /**
     * 手机号
     */
    String phoneNumber
    /**
     * 联系人
     */
    String linkman
    /**
     * 行业：1-快餐店
     */
    Integer business
    /**
     * 一级业态：1-餐饮，2-零售
     */
    String business1
    /**
     * 二级业态
     */
    String business2
    /**
     * 三级业态
     */
    String business3
    /**
     * 
     */
    String email
    /**
     * 
     */
    String qq
    /**
     * 状态：0-未激活，1-启用，2-停用
     */
    Integer status
    /**
     * 缴费额（指商户激活以来，支付的软件费总金额）
     */
    BigDecimal paidTotal
    /**
     * 当前激活的软件版本ID，goods.id
     */
    BigInteger goodsId
    /**
     * 备注
     */
    String remark
    /**
     * 是否是测试环境下的账号-1为测试账号-0为正式账号
     */
    boolean isTest
    /**
     * 安全收银账号
     */
    String cashierName
    /**
     * 安全收银密码
     */
    String cashierPwd
    /**
     * 商户logo存储路径
     */
    String imgUrl

    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted

}
