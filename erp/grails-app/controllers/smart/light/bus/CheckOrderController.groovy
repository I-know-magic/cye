package smart.light.bus

import com.itextpdf.text.Document
import com.itextpdf.text.Font
import com.itextpdf.text.PageSize
import com.itextpdf.text.Paragraph
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.DateUtils
import com.smart.common.util.IDCreator
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.light.exporter.itextpdf.PdfUtils
import com.smart.light.exporter.itextpdf.WebPdfExporter
import smart.light.saas.Branch
import smart.light.web.vo.CheckOrderDetailVo

import java.text.DecimalFormat

//TODO 修改类注释
/**
 * CheckOrderController
 * @author CodeGen
 * @generate at 2016-06-12 15:42:56
 */
class CheckOrderController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    CheckOrderService checkOrderService
    CheckOrderDetailService checkOrderDetailService
    StoreService storeService

    /**
     * 打开页面
     *
     */
    def index() {

        def branch = Branch.get(LightConstants.getBranchId())
        render view: '/checkOrder/checkOrderIndex',
                model: [branch: branch, backParams: params['backParams']]
    }
    /**
     * 初始化单据明细界面
     * @params opType 操作类型
     * 1 ——— 创建界面
     * 2 ——— 修改查看
     * 3 ——— 审核查看
     */
    def initForm() {
        BigInteger opType = params['opType']?.asType(Integer)
        BigInteger orderType = new BigInteger("3")
        def isFormStore = params['isFromStore'] ? params['isFromStore'] :false
        if (opType == 1) {
            String code
            session.setAttribute('_checkOrder_add_form_valid', 'add_form')
            if (session.getAttribute('_checkOrder_add_') == null) {
                def branch = Branch.get(LightConstants.getBranchId())
                String wd = LightConstants.getTenantId().toString() + branch.id.toString()
                code = IDCreator.createStoreOrderCode(orderType, wd, branch.code)
                session.setAttribute('_checkOrder_add_', code)
            } else {
                code = session.getAttribute('_checkOrder_add_')
            }

            def branch = Branch.get(LightConstants.getBranchId())
            def pro = new CheckOrder(code: code)
            render view: '/checkOrder/checkOrderForm', model: [opType: opType, pro: pro, branch: branch, isFromStore: isFormStore]
            return
        }
        if (opType >= 2) {
            def orderId = params['orderId'].asType(BigInteger)
            def orderCode = params['orderCode'] == null ? '' : params['orderCode']
            def backUrl = params['backUrl'] == null ? '' : params['backUrl']
            def backTitle = params['backTitle'] == null ? '' : params['backTitle']
            def checkOrder = CheckOrder.findByCode(orderCode)
            orderId = orderId ? orderId : checkOrder.id
            def order = CheckOrder.findById(orderId)
            if(order.branchId != LightConstants.getBranchId()){ // 总部不能操作分店数据，只能查看
                opType = -1
            }
            render view: '/checkOrder/checkOrderForm',
                    model: [opType: opType, pro: order,  backParams: params['backParams'], backUrl: backUrl, backTitle: backTitle,
                            saBackParams: params['saBackParams'], isFromStore: isFormStore, sBackParams: params['sBackParams']]
            return
        }
    }

    /**
     * 分页查询
     */
    def queryPager() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        try {
            result = checkOrderService.queryPager(params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存或修改
     * detailStr: goodsId1,reallyQuantity;goodsId2,reallyQuantity
     */
    def saveOrUpdate() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        def isSave = false
        try {
            def checkOrder = new CheckOrder(params)
            isSave = checkOrder.id == null ? true : false
            if (isSave && session.getAttribute('_checkOrder_add_form_valid') != null) {
                session.removeAttribute('_checkOrder_add_form_valid')
                checkOrder.code = session.getAttribute('_checkOrder_add_')
            } else {
                checkOrder.code = null
            }
            def checkOrderDetails = []
            //解析明细
            String detailStr = params['detailStr']
            detailStr.split(';').each { details ->
                def detail = details.split(',')
                checkOrderDetails << new CheckOrderDetail(goodsId: detail[0], reallyQuantity: detail[1])
            }
            result = checkOrderService.saveOrUpdate(checkOrder, checkOrderDetails)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        } finally {
            if (result.isSuccess && isSave) {
                session.removeAttribute('_checkOrder_add_')
            }
        }
        result.jsonMap.order = result.object
        result.object = null
        render result
    }

    /**
     * 查询单据明细
     */
    def queryOrderDetails() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常', jsonMap: [:])
        try {
            def list = checkOrderDetailService.queryDetailList(params)
            def totalCq = new BigDecimal(0)
            def totalCa = new BigDecimal(0)
            def totalRq = new BigDecimal(0)
            list?.each {
                totalCq += it.checkQuantity
                totalCa += it.checkAmount
                totalRq += it.reallyQuantity
            }
            def footerList = []
            footerList << new CheckOrderDetailVo(barCode: '合计：', checkQuantity: totalCq, checkAmount: totalCa, reallyQuantity: totalRq)
            result.jsonMap.footer = footerList
            result.jsonMap.rows = list
            result.isSuccess = true
            result.msg = '查询成功'
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 审核单据
     */
    def auditOrder() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        try {
            List<BigInteger> orderIds = []
            String orderIdStr = params['orderId']
            orderIdStr?.split(',').each {
                orderIds << it.toBigInteger()
            }
            //check_order_audit == null 审核表单可提交
            if (!session.getAttribute('check_order_audit')) {
                //设置审核表单不可提交
                session.setAttribute('check_order_audit', false)
                result = checkOrderService.auditOrderById(orderIds)
                result.success = true

            }
        } catch (Exception e) {
            LogUtil.logError(e, params)
        } finally {
            //设置审核表单可提交
            session.removeAttribute('check_order_audit')
        }
        render result
    }

    /**
     * 删除
     * @return
     */
    def deleteOrder() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        try {
            List<BigInteger> orderIds = []
            String orderIdStr = params['orderId']
            orderIdStr?.split(',').each {
                orderIds << it.toBigInteger()
            }
            result = checkOrderService.deleteOrder(orderIds)
            result.success = true
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 打印盘点单
     * pdf打印
     */
    def printAsPdf() {
        try {
            String path = servletContext.getRealPath("/");
            def pdf = new PdfUtils(path + 'pdfFont/simsun.ttc')
            def branch = Branch.findById(LightConstants.getBranchId())
            def oderList = storeService.queryGoodsStoreList()
            def titleList = ['单据号:', params['orderCode'], '门店:', branch.name,
                             '制单人:', LightConstants.getUserName(), '制单时间:', DateUtils.formatData('yyyy-MM-dd HH:mm', new Date())]

            new WebPdfExporter().with {
                document = new Document(PageSize.A4, 20f, 20f, 20f, 0f)
                setHeader(response, request, '单品汇总')
                doExport(response.outputStream)
                setPdfAttributes()
                document.open()
                def titleFont = pdf.defaultFont()
                titleFont.setSize(16)
                titleFont.setStyle(Font.FontStyle.ITALIC.value)
                document.add(new Paragraph("盘点单据", titleFont));
                document.add(new Paragraph("    ", pdf.defaultFont()));
                //设置表头
                def table = pdf.explainTable(titleList as String[])
                def cell = new PdfPCell(new Paragraph('备注', pdf.defaultFont()))
                cell.setColspan(4)
                table.addCell(cell)
                //设置表格
                def title = ['序号', '编码', '名称', '分类', '单位', '售价', '库存数量', '实际数量']
                def tableList = pdf.defaultTable(title as String[]) { PdfPTable pTable ->
                    oderList.eachWithIndex { def obj, int i ->
                        pTable.addCell((i + 1).toString())
                        pTable.addCell(new Paragraph(obj.barCode.toString(), pdf.defaultFont()))
                        pTable.addCell(new Paragraph(obj.goodsName.toString(), pdf.defaultFont()))
                        pTable.addCell(new Paragraph(obj.categoryName.toString(), pdf.defaultFont()))
                        pTable.addCell(new Paragraph(obj.goodsUnitName.toString(), pdf.defaultFont()))
                        def sp = new DecimalFormat("###0.00").format(obj.salePrice)
                        pTable.addCell(new Paragraph(sp, pdf.defaultFont()))
                        def sq = obj.quantity == null ? '0.00' : new DecimalFormat("###0.00").format(obj.quantity)
                        pTable.addCell(new Paragraph(sq, pdf.defaultFont()))
                        pTable.addCell(new Paragraph('', pdf.defaultFont()))
                    }
                }
                table.setTotalWidth(540)
                table.setLockedWidth(true)
                tableList.setTotalWidth(540)
                tableList.setLockedWidth(true)
                document.add(table)
                document.add(tableList)
                document.close()
            }
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            params.exception = e.message
            LogUtil.logError(e, params)
        }
    }
}

