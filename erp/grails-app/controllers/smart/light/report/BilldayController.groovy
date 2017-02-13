package smart.light.report

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.DateUtils
import com.smart.common.util.LogUtil
import com.smart.light.exporter.poi.WebXlsExporter
import smart.light.bus.Bill
import smart.light.bus.BillService
import smart.light.web.vo.BillItemVo

//TODO 修改类注释
/**
 * BillController
 * @author CodeGen
 * @generate at 2016-11-20 16:24:16
 */
class BilldayController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    BillService billService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/report/billday")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = billService.reportBillDay(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 新增
     */
    def create() {
        ResultJSON result
        try {
            result = billService.create()
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 修改
     */
    def edit() {
        ResultJSON result
        try {
            String id = params.id;
            result = billService.edit(id)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存
     */
    def save() {
        ResultJSON result
        try {
            Bill bill = new Bill(params)
            result = billService.save(bill)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 更新
     */
    def update() {
        ResultJSON result
        try {
            Bill bill = new Bill(params)
            result = billService.save(bill)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 删除
     */
    def delete() {
        ResultJSON result
        try {
            result = billService.delete(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 导出
     */
    def exportExcel() {
        ResultJSON result
        try {
            result = billService.reportBillDay(params)
            def exportBoundDevice = result.jsonMap['rows']
            def total = result.jsonMap['total']

//            def lenght=exportBoundDevice.size()
//            HSSFWorkbook workbook=ExcelExportUtil.exportExcel(new ExportParams("集中控制器", "终端设备档案明细"),BaseBoundDevice.class,exportBoundDevice);
//            workbook.write(response.getOutputStream());
            new WebXlsExporter().with {
                titles = ['单号', '桌台', '类别', '品名','口味','价格','数量','金额','付款时间'];
                sheetName = '营业日报'
                setHeader(response, request, "营业日报");

                doExport(response.outputStream, exportBoundDevice) { List cols, BillItemVo billItemVo ->
                    int c = 0
//                    total=total-1;
//                    println "数量="+total
                    if(billItemVo && billItemVo.billNo && billItemVo.billNo!=null && billItemVo.billNo!="null"){
                        cols[c++].setCellValue(billItemVo.billNo.toString())
                        cols[c++].setCellValue(billItemVo.tableName.toString())
                        cols[c++].setCellValue(billItemVo.catName.toString())
                        cols[c++].setCellValue(billItemVo.goodsName.toString())
                        cols[c++].setCellValue(billItemVo.taste.toString())
                        cols[c++].setCellValue(billItemVo.price.toString())
                        cols[c++].setCellValue(billItemVo.qty.toString())
                        cols[c++].setCellValue(billItemVo.sum.toString())
                        if(billItemVo.payTime){
                            cols[c++].setCellValue(DateUtils.DateToStr(billItemVo.payTime))
                        }
                    }
                }
            }
            return ;
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            e.printStackTrace()
            LogUtil.logError(e, params)
        }
        render result
    }

}
