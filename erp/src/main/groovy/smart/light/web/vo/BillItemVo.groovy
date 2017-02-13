package smart.light.web.vo

/**
 * Created by Administrator on 2015/9/2.
 */
class BillItemVo {

    BigInteger billId

    String billSeqNo
    /**
     *
     */
    BigInteger itemId
    /**
     *
     */
    Integer qty
    /**
     *
     */
    Integer sendQty
    /**
     *
     */
    BigDecimal price
    /**
     *
     */
    BigDecimal sum
    /**
     *
     */
    String taste
    /**
     *
     */
    String memo
    /**
     *
     */
    Date addTime
    /**
     *
     */
    Date submitTime
    /**
     *
     */
    Date confirmTime
    /**
     *
     */
    Date cancelTime
    /**
     *
     */
    Date printTime
    /**
     *
     */
    Date sendTime
    /**
     *
     */
    String state
    /**
     *
     */
    String seqNo
    /**
     *
     */
    BigInteger branchId

    BigInteger categoryId
    String catName
    String goodsName


    BigInteger id
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted
    BigInteger tenantId

    String billNo
    String tableId
    String tableName

    BigDecimal itemTotal
    BigDecimal payTotal
    Date payTime


}
