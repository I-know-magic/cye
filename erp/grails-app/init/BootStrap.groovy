import com.smart.common.Constants
import grails.converters.JSON
import smart.light.base.Goods

class BootStrap {

    def init = { servletContext ->
        JSON.registerObjectMarshaller(Date) {
            return it?.format(Constants.DATE_TIME_FORMAT)

        }
//        JSON.registerObjectMarshaller(Goods) {
//            def returnArray = [:]
//            returnArray['goodsName'] = it.goodsName
//            returnArray['teststr'] = it.teststr
//            return returnArray
//        }
    }
    def destroy = {
    }
}
