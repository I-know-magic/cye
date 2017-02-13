package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import com.smart.light.exporter.poi.WebXlsExporter
import smart.light.web.base.BaseBoundDevice
import smart.light.web.vo.BillItemVo

//TODO 修改类注释
/**
 * BillItemController
 * @author CodeGen
 * @generate at 2016-11-20 16:24:26
 */
class BillItemController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    BillItemService billItemService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/billItem/view")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = billItemService.reportBillItemDay(params)
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
            result = billItemService.create()
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
            result = billItemService.edit(id)
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
            BillItem billItem = new BillItem(params)
            result = billItemService.save(billItem)
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
            BillItem billItem = new BillItem(params)
            result = billItemService.save(billItem)
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
            result = billItemService.delete(params)
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
            result = billItemService.reportBillItemDay(params)
            def exportBoundDevice = result.jsonMap['rows']

//            HSSFWorkbook workbook=ExcelExportUtil.exportExcel(new ExportParams("集中控制器", "终端设备档案明细"),BaseBoundDevice.class,exportBoundDevice);
//            workbook.write(response.getOutputStream());
            new WebXlsExporter().with {
                titles = ['类别', '品名', '口味', '价格','数量','金额'];
                sheetName = '销售统计'
                setHeader(response, request, "销售统计");
                def categoryId=0;
                def temp=categoryId;
                doExport(response.outputStream, exportBoundDevice) { List cols, BillItemVo billItemVo ->
                    int c = 0
                    categoryId=billItemVo.categoryId;
                    if(temp!=categoryId){
                        temp=categoryId;
                    }
                    if(billItemVo){
                        cols[c++].setCellValue(billItemVo.catName.toString())
                        cols[c++].setCellValue(billItemVo.goodsName.toString())
                        cols[c++].setCellValue(billItemVo.taste.toString())
                        cols[c++].setCellValue(billItemVo.price.toString())
                        cols[c++].setCellValue(billItemVo.qty.toString())
                        cols[c++].setCellValue(billItemVo.sum.toString())
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
