package smart.light.web.vo

class OrderDetailVo {
    BigInteger orderid
    BigInteger categoryId
    String orderno
    BigInteger id
    boolean isDeleted=false
    BigDecimal quantity
    BigDecimal receiveQuantity
    Date createAt
    String createBy
    String lastUpdateBy
    Date lastUpdateAt
    String memo
    String catCode
    String catName
    Date arrivedtime
    BigInteger customerid
}
