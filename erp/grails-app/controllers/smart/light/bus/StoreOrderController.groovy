package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.IDCreator
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import grails.converters.JSON
import smart.light.auth.EmployeeService
import smart.light.saas.Branch
import smart.light.web.vo.StoreOrderDetailVo

//TODO 修改类注释
/**
 * StoreOrderController
 * @author CodeGen
 * @generate at 2016-06-12 15:43:51
 */
class StoreOrderController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    StoreOrderService storeOrderService
    EmployeeService employeeService
    StoreOrderDetailService storeOrderDetailService

    /**
     * 显示功能页面
     * @params categoryId 菜品类型ID
     */
    def index() {

        def branch = Branch.get(LightConstants.getBranchId())
        def orderType = params['orderType']?.asType(BigInteger)
        render view: '/storeOrder/storeOrderIndex', model: [orderType: orderType, branch: branch, backParams: params['backParams']]
    }

    /**
     * 初始化单据明细界面
     * @params opType 操作类型
     * 1 ——— 创建界面
     * 2 ——— 修改查看
     * 3 ——— 审核查看
     * -1 ———— 总部查看分店的单据
     * @params orderType 单据类型
     * 1 ——— 入库
     * 2 ——— 出库
     */
    def initForm() {
        BigInteger opType = params['opType']?.asType(Integer)
        BigInteger orderType = params['orderType']?.asType(Integer)
        def isFormStore = params['isFromStore'] ? params['isFromStore'] : false
        if (opType == 1) {
            String code
            session.setAttribute('_storeOrder_add_form_valid', 'add_form')
            if (session.getAttribute('_storeOrder_add_' + orderType) == null) {
                def branch = Branch.get(LightConstants.getBranchId())
                String wd = LightConstants.getTenantId().toString() + branch.id.toString()
                code = IDCreator.createStoreOrderCode(orderType, wd, branch.code)
                session.setAttribute('_storeOrder_add_' + orderType, code)
            } else {
                code = session.getAttribute('_storeOrder_add_' + orderType)
            }
            def pro = new StoreOrder(code: code)
            render view: '/storeOrder/storeOrderForm', model: [orderType: orderType,
                                                               opType   : opType, pro: pro, backParams: params['backParams'], isFromStore: isFormStore]
            return
        }
        if (opType >= 2) {
            def orderId = params['orderId'].asType(BigInteger)
            def orderCode = params['orderCode'] == null ? '' : params['orderCode']
            def backUrl = params['backUrl'] == null ? '' : params['backUrl']
            def backTitle = params['backTitle'] == null ? '' : params['backTitle']
            def storeOrder=StoreOrder.findByCode(orderCode)
            orderId = orderId ? orderId : storeOrder.id
            def order = StoreOrder.findById(orderId)
            if(order.branchId != LightConstants.getBranchId()){ // 总部不能操作分店数据，只能查看
                opType = -1
            }
            render view: '/storeOrder/storeOrderForm',
                    model: [orderType   : orderType, opType: opType, pro: order, backParams: params['backParams'], backUrl: backUrl, backTitle: backTitle,
                            saBackParams: params['saBackParams'], isFromStore: isFormStore, sBackParams: params['sBackParams']]
            return
        }
    }

    /**
     * 查询当前登录用户的对应门店的员工
     * @return json
     */
    def queryEmployeeAsJson() {
        def branchId = LightConstants.getBranchId()
        params.page = '1'
        params.rows = '100000'
        params.branchId=branchId;
        def res = employeeService.queryEmployeeList(params)
        List empList
        if (res.jsonMap.total > 0) {
            empList = res.jsonMap.rows
        } else {
            empList = []
        }
//        empList.each { def employee ->
//            employee.name = employee.code + '-' + employee.name
//        }
        empList.add(0, [userId: '', name: '全部',])
        render empList as JSON
    }

    /**
     * 分页查询
     */
    def queryPager() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        try {
            result = storeOrderService.queryPager(params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存或修改
     * @params orderType 单据类型
     * 1 ——— 入库
     * 2 ——— 出库
     * detailStr: goodsId1,purchaseAmount,quantity;goodsId2,purchaseAmount,quantity
     */
    def saveOrUpdate() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        BigInteger orderType = params['orderType']?.asType(Integer)
        def isSave = false
        try {
            def storeOrder = new StoreOrder(params)
            isSave = storeOrder.id == null ? true : false
            if (isSave && session.getAttribute('_storeOrder_add_form_valid') != null) {
                session.removeAttribute('_storeOrder_add_form_valid')
                storeOrder.code = session.getAttribute('_storeOrder_add_' + orderType)
            } else {
                storeOrder.code = null
            }
            def storeOrderDetails = []
            //解析明细
            String detailStr = params['detailStr']
            detailStr.split(';').each { details ->
                def detail = details.split(',')
                storeOrderDetails << new StoreOrderDetail(goodsId: detail[0],
                        purchaseAmount: new BigDecimal(detail[1]), quantity: new BigDecimal(detail[2]))
            }
            result = storeOrderService.saveOrUpdate(storeOrder, storeOrderDetails)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        } finally {
            if (result.isSuccess && isSave) {
                session.removeAttribute('_storeOrder_add_' + orderType)
                result.success = true
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
            def list = storeOrderDetailService.queryDetailList(params)
            def totalQm = new BigDecimal(0)
            def totalAm = new BigDecimal(0)
            def totalPm = new BigDecimal(0)
            list?.each {
                totalQm += it.quantity
                totalAm += it.amount
                totalPm += it.purchaseAmount
            }
            def footerList = []
            footerList << new StoreOrderDetailVo(barCode: '合计：', purchaseAmount: totalPm, quantity: totalQm, amount: totalAm)
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
            if (!session.getAttribute('store_order_audit')) {
                //设置审核表单不可提交
                session.setAttribute('store_order_audit', false)
                result = storeOrderService.auditOrderById(orderIds)
                result.success = true
            }
        } catch (Exception e) {
            LogUtil.logError(e, params)
        } finally {
            //设置审核表单可提交
            session.removeAttribute('store_order_audit')
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
            result = storeOrderService.deleteOrder(orderIds)
            result.success = true
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
}
