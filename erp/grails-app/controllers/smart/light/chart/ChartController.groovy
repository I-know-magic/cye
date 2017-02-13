package smart.light.chart

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import grails.converters.JSON
import smart.light.web.base.BaseArea
//import smart.light.web.base.BaseAreaService
import grails.converters.JSON
import smart.light.web.chart.ClsInfoSum

//TODO 修改类注释
/**
 * BaseAreaController
 * @author CodeGen
 * @generate at 2016-04-12 15:04:57
 */
class ChartController {

//    BaseChartService baseChartService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/chart/view")
    }
    def chartline() {
        render(view: "/chart/view-line")
    }
    def chartcolumn() {
        render(view: "/chart/view-column")
    }
    def chartpie() {
        render(view: "/chart/view-pie")
    }
    def chartloos() {
        render(view: "/chart/lossview")
    }
    def chartelectricity() {
        render(view: "/chart/electricityview")
    }
    def chartread() {
        render(view: "/chart/readview")
    }
    /**
     * demo
     * @return
     */
    def findcls(){
        def list=[];
        for(int i=0;i<10;i++){
            ClsInfoSum clsInfoSum = new ClsInfoSum();
            clsInfoSum.c_total=i;
            clsInfoSum.u_name=i+"-name";
            list.add(clsInfoSum);
        }
        render list as JSON
    }
    /**
     * demo
     * @return
     */
    def linedata(){
        def list=[];
        for(int i=1;i<10;i++){
            ClsInfoSum clsInfoSum = new ClsInfoSum();
            clsInfoSum.c_total=i;
            clsInfoSum.prt_date="2016-05-0"+i;
            list.add(clsInfoSum);
        }
        render list as JSON
    }

//    def findLoss(){
//        ResultJSON result
//        try {
//            result = baseChartService.queryBaseTrepLoss(params)
//        } catch (ServiceException se) {
//            result = new ResultJSON(se.getCodeMessage(), false)
//            LogUtil.logError(se, params)
//        } catch (Exception e){
//            result = new ResultJSON(e)
//            LogUtil.logError(e, params)
//        }
//        render result
//    }


}
