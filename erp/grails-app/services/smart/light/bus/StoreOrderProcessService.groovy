package smart.light.bus

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.PropertyUtils
import net.sf.json.JSONObject

/**
 * Created by lvpeng on 2015/9/8.
 */
class StoreOrderProcessService {

    def sendMessage(JSONObject jsonObject) {
        try {
            //订阅库存计算队列并发送消息
            LightConstants.lpush(PropertyUtils.getDefault("redis_topics"),jsonObject.toString())
            LogUtil.logInfo('订阅库存计算队列送消息:' + jsonObject.toString())
        } catch (Exception e) {
            LogUtil.logError("KafkaStoreService-sendMessage 错误：" + e.message)
            throw new ServiceException('订阅库存计算队列并发送消息错误：' + jsonObject.toString())
        }

    }

    def  sendMessageList(List<JSONObject> jsonObjects) {
        try {
            //订阅库存计算队列并发送消息
            jsonObjects?.each {
                LightConstants.lpush(PropertyUtils.getDefault("redis_topics"),it.toString())
                LogUtil.logInfo('订阅库存计算队列送消息:' + it.toString())
            }
        } catch (Exception e) {
            LogUtil.logError("KafkaStoreService-sendMessage 错误：" + e.message)
            e.printStackTrace()
            throw new ServiceException('订阅库存计算队列并发送消息错误：')
        }
    }

}
