package smart.light.web.login

import com.smart.common.util.LogUtil
import grails.converters.JSON
import org.apache.commons.lang.StringUtils
import org.springframework.web.multipart.MultipartFile
//import smart.light.web.base.BaseTerminalService
//import smart.light.web.bus.BusBoundDeviceDataService
//import smart.light.web.bus.BusTerminalDataService
//import smart.light.web.bus.TreplossDataService


/**
 * 首页Controller
 * hexiaohong on 2015/10/26.
 */
class HomeController {
//    //集中器实时数据
//    BusTerminalDataService busTerminalDataService;
//    //终端实时数据
//    BusBoundDeviceDataService busBoundDeviceDataService;
//    //线损数据\用电量\分电量
//    TreplossDataService treplossDataService;

    /**
     * 初始化首页
     */
    def index() {
        render view: "/homePage/homePage"
    }
    /**
     * 初始化登陆信息
     * @param sessionId 登陆session id
     */
    def initLogin() {
        try {

        } catch (Exception e) {
            LogUtil.logError("####### initLogin: " + e.getMessage())
            e.printStackTrace()
        }
    }
    def queryTerminalData(){
        try {
            def map=busTerminalDataService.queryTerminalData(params);
            render map as JSON;
        } catch (Exception e) {
            LogUtil.logError("####### queryTerminalData: " + e.getMessage())
            e.printStackTrace()
        }
    }
    def queryDeviceData(){
        try {
            def map=busBoundDeviceDataService.queryDeviceData(params);
            render map as JSON;
        } catch (Exception e) {
            LogUtil.logError("####### queryTerminalData: " + e.getMessage())
            e.printStackTrace()
        }
    }
    def queryLossData(){
        try {
            def map=treplossDataService.queryLossData(params);
            render map as JSON;
        } catch (Exception e) {
            LogUtil.logError("####### queryLossData: " + e.getMessage())
            e.printStackTrace()
        }
    }
    def queryDeviceTotalData(){
        try {
            def map=treplossDataService.queryDeviceTotalData(params);
            render map as JSON;
        } catch (Exception e) {
            LogUtil.logError("####### queryDeviceTotalData: " + e.getMessage())
            e.printStackTrace()
        }
    }
    def queryPillTotalData(){
        try {
            def map=treplossDataService.queryPillTotalData(params);
            render map as JSON;
        } catch (Exception e) {
            LogUtil.logError("####### queryPillTotalData: " + e.getMessage())
            e.printStackTrace()
        }
    }
    def queryBillTotalData(){
        try {
            def map=treplossDataService.queryBillTotalData(params);
            render map as JSON;
        } catch (Exception e) {
            LogUtil.logError("####### queryBillTotalData: " + e.getMessage())
            e.printStackTrace()
        }
    }

}

