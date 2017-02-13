package smart.light.web.vo

/**
 * 门店Vo
 * lvpeng on 2015/9/23.
 */
class BranchVo {
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
     *
     */
    String geolocation
    /**
     *
     */
    BigInteger areaId
    /**
     *
     */
    BigInteger parentId
    /**
     * 状态0 停用1启用
     */
    Integer status = 1
    /**
     * 备注
     */
    String memo
    /**
     * 1实体店2网店3微店
     */
    Integer type
    /**
     * 是否微餐厅
     */
    boolean isTinyhall=false
    /**
     * 起送金额
     */
    BigDecimal amount
    /**
     * 范围
     */
    Integer takeoutRange=0
    /**
     * 送餐费
     */
    BigDecimal takeoutAmount
    /**
     * 外卖起送参数 0禁用1启用
     */

    boolean isTakeout
    /**
     * 配送时间段
     */
    String takeoutTime
    /**
     * 配送开始时间
     */
    String startTakeoutTime
    /**
     * 配送结束时间
     */
    String endTakeoutTime
    BigInteger id
    BigInteger tenantId
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    /**
     * 区域编码
     */
    String areaCode
    /**
     * 区域名称
     */
    String areaName
    /**
     * 区域父节点Id
     */
    String areaParentId
    boolean isBuffet
    boolean isInvite
    Integer shippingPriceType
}
