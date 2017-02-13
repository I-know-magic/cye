package smart.light.web.vo

import com.smart.common.util.DateUtils
import net.sf.json.JSONObject


/**

 */
class KafkaStoreParam {

    BigInteger tenantId

    BigInteger branchId

    BigInteger goodsId

    BigDecimal price

    BigDecimal quantity

    String code

    int occurType

    String billCreateTime

    private final SendMessage = [:]


    public JSONObject getSendMessage() {
        SendMessage.tenantId = tenantId
        SendMessage.branchId = branchId
        SendMessage.goodsId = goodsId
        SendMessage.price = price
        SendMessage.quantity = quantity
        SendMessage.code = code
        SendMessage.occurType = occurType
        SendMessage.billCreateTime = billCreateTime
        return JSONObject.fromObject(SendMessage)
    }
    public void setBillCreateTime(Date occurAt){
        this.billCreateTime = DateUtils.formatData('yyyy-MM-dd HH:mm:ss',occurAt)
    }
}
