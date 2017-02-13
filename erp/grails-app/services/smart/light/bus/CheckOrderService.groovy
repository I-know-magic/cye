package smart.light.bus

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.util.DateUtils
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import smart.light.base.Goods
import smart.light.web.vo.KafkaStoreParam

//TODO 修改类注释
/**
 * CheckOrderService
 * @author CodeGen
 * @generate at 2016-06-12 15:42:56
 */
@Transactional
class CheckOrderService {

    StoreService storeService
    CheckOrderDetailService checkOrderDetailService
    StoreAccountService storeAccountService
    StoreOrderProcessService storeOrderProcessService
    /**
     * 分页查询
     */
    def queryPager(Map<String, String> params) {
        ResultJSON result = new ResultJSON()
        def map = new HashMap<String, Object>()
        StringBuffer query = new StringBuffer("from CheckOrder t where t.isDeleted = false  and t.tenantId= :tenantId  ")
        StringBuffer queryCount = new StringBuffer("select count(t.id),sum(t.checkQuantity),sum(t.checkAmount) from CheckOrder t where t.isDeleted = false  and t.tenantId= :tenantId  ")
        def queryParams = new HashMap()
        if (params['rows'] && params['page']) {
            queryParams.max = params['rows'] ? params['rows'] : 20
            queryParams.offset = (Integer.parseInt(params['page']) - 1) * Integer.parseInt(queryParams['max'])
        }
        def namedParams = new HashMap()
        String sid=LightConstants.querySid();
        namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

        params.each { k, v ->
            if ('code'.equals(k) && v) {
                query.append(' AND (t.code like :code) ')
                queryCount.append(' AND (t.code like :code) ')
                namedParams.code = "%$v%"
            }
            if ('branchId'.equals(k) && (v =~ /\d+/).matches()) {
                query.append(' AND (t.branchId = :branchId) ')
                queryCount.append(' AND (t.branchId = :branchId) ')
                namedParams.branchId = v.asType(BigInteger)
            }
            if ('makeBy'.equals(k) && (v =~ /\d+/).matches()) {
                query.append(' AND (t.makeBy = :makeBy) ')
                queryCount.append(' AND (t.makeBy = :makeBy) ')
                namedParams.makeBy = v.asType(BigInteger)
            }
            if ('auditBy'.equals(k) && (v =~ /\d+/).matches()) {
                query.append(' AND (t.auditBy = :auditBy) ')
                queryCount.append(' AND (t.auditBy = :auditBy) ')
                namedParams.auditBy = v.asType(BigInteger)
            }
            if ('status'.equals(k) && (v =~ /\d+/).matches()) {
                query.append(' AND (t.status = :status) ')
                queryCount.append(' AND (t.status = :status) ')
                namedParams.status = v.asType(Integer)
            }
        }
        def startDate = params.startDate?.replaceAll('[: -]', '')
        def endDate = params.endDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
        if ((startDate =~ /\d+/).matches()) {
            query.append(' AND (t.makeAt >= :startDate or t.auditAt >= :startDate) ')
            queryCount.append(' AND (t.auditAt >= :startDate or t.makeAt >= :startDate) ')
            namedParams.startDate = DateUtils.StrToDate("${params.startDate}:00")
        }
        if ((endDate =~ /\d+/).matches()) {
            query.append(' AND (t.makeAt <= :endDate or t.auditAt <= :endDate) ')
            queryCount.append(' AND (t.makeAt <= :endDate or t.auditAt <= :endDate) ')
            namedParams.endDate = DateUtils.StrToDate("${params.endDate}:00")
        }
        query.append(' order by t.makeAt desc ')
        def count = CheckOrder.executeQuery(queryCount.toString(), namedParams)
        def list2 = []
        if (count[0][0] > 0) {
            list2 = CheckOrder.executeQuery(query.toString(), namedParams, queryParams)
            def xQuantity = new BigDecimal(0)
            def xAmount = new BigDecimal(0)
            for (int x = list2.size() - 1; x >= 0; x--) {
                xQuantity += list2.get(x).checkQuantity
                xAmount += list2.get(x).checkAmount
            }
            def footerList = []
            footerList << new CheckOrder(code: '小计', checkQuantity: xQuantity, checkAmount: xAmount)
            footerList << new CheckOrder(code: '合计', checkQuantity: new BigDecimal(count[0][1]), checkAmount: new BigDecimal(count[0][2]))
            map.footer = footerList
        }else{
            def footerList = []
            footerList << new CheckOrder(code: '小计', checkQuantity: new BigDecimal("0.00"), checkAmount: new BigDecimal("0.00"))
            footerList << new CheckOrder(code: '合计', checkQuantity: new BigDecimal("0.00"), checkAmount: new BigDecimal("0.00"))
            map.footer = footerList
        }
        map.put("total", count.size() > 0 ? count[0] : 0)
        map.put("rows", list2)
        if (list2.size() == 0) {
            result.setMsg("无数据")
        }
        result.jsonMap = map
        return result
    }

    /**
     * 保存或修改盘点单据
     * 未审核状态的单据可以修改
     * @param checkOrder not null
     * @param detailList not null and size > 0
     * @return
     */
    def saveOrUpdate(CheckOrder checkOrder, List<CheckOrderDetail> detailList) {
        try {
            ResultJSON result = new ResultJSON(isSuccess: false, msg: '操作异常')
            Validate.notNull(checkOrder, 'checkOrder not null')
            Validate.isTrue(detailList?.size() > 0, 'detailList not null and size > 0')
            //计算盘点

            def goodsStoreList = storeService.queryGoodsStoreList()
            def orderCq = new BigDecimal(0)
            def orderCa = new BigDecimal(0)
            detailList.each { detail ->
                def avgAmount = null
                def storeQuantity = null
                goodsStoreList.each { goodsStore ->
                    if (goodsStore.goodsId == detail.goodsId){
                        //商品没有库存 使用进价计算 库存数量0
                        avgAmount = goodsStore.storeId != null ? goodsStore.avgAmount : goodsStore.purchasingPrice
                        storeQuantity = goodsStore.storeId != null ? goodsStore.quantity : new BigDecimal(0)
                        return
                    }
                }
                //损益数量 = 实际数量 - 库存数量
                detail.checkQuantity = detail.reallyQuantity - storeQuantity
                //损益金额  = 损益数量 * 库存成本
//                detail.checkAmount = detail.checkQuantity * avgAmount
                //成本
                detail.purchasePrice = avgAmount
                detail.quantity = storeQuantity
                orderCq += detail.checkQuantity
//                orderCa += detail.checkAmount
            }
            checkOrder.checkQuantity = orderCq
            checkOrder.checkAmount = orderCa

            if(checkOrder.id == null){
                checkOrder.status = 2
                checkOrder.branchId = LightConstants.getBranchId()
                checkOrder.tenantId = LightConstants.getTenantId()
                checkOrder.makeBy = LightConstants.getUserId()
                checkOrder.makeName = LightConstants.getUserName()
                checkOrder.makeAt = new Date()
                if (checkOrder.validate()) {
                    checkOrder.save flush: true
                    detailList.each {
                        it.checkOrderId = checkOrder.id
                        it.branchId = checkOrder.branchId
                        it.tenantId = checkOrder.tenantId
                        it.code = checkOrder.code
                    }
                    def res = checkOrderDetailService.saveOrUpdateDetailList(detailList);

                    if (res.isSuccess) {
                        result.isSuccess = true
                        result.msg = '保存成功'
                        result.object = checkOrder
                    } else {
                        Validate.isTrue(false, res.msg)
                    }
                } else {
                    result.msg = '保存失败，数据错误'
                    def fields = []
                    checkOrder.errors.allErrors.each {
                        fields << "${it.field}=${it.rejectedValue},${it.defaultMessage}"
                    }
                    Validate.isTrue(false, fields.toString())
                }
            }else{
                CheckOrder oldOrder = CheckOrder.findByIdAndStatusAndBranchId(checkOrder.id,2, LightConstants.getBranchId())
                Validate.notNull(oldOrder, '单据已审核或不存在')

                oldOrder.checkQuantity = checkOrder.checkQuantity
                oldOrder.checkAmount = checkOrder.checkAmount
                oldOrder.memo = checkOrder.memo
                if (oldOrder.validate()) {
                    oldOrder.save flush: true
                    detailList.each {
                        it.checkOrderId = oldOrder.id
                        it.branchId = oldOrder.branchId
                        it.tenantId = oldOrder.tenantId
                        it.code = oldOrder.code
                    }
                    def res = checkOrderDetailService.saveOrUpdateDetailList(oldOrder.id, detailList)
                    if (res.isSuccess) {
                        result.isSuccess = true
                        result.msg = '修改成功'
                        result.object = checkOrder
                    } else {
                        Validate.isTrue(false, res.msg)
                    }
                } else {
                    result.msg = '修改失败，数据错误'
                    def fields = []
                    oldOrder.errors.allErrors.each {
                        fields << "${it.field}=${it.rejectedValue},${it.defaultMessage}"
                    }
                    Validate.isTrue(false, fields.toString())
                }
            }
            return result
        } catch (Exception e) {
            throw new ServiceException('00001', '保存或修改盘点单据错误：', e.message)
        }
    }

    /**
     * 审核
     * @param orderId not null
     */
    def auditOrderById(List<BigInteger> orderIds) {
        try {
            ResultJSON result = new ResultJSON(isSuccess: false, msg: '操作异常')
            Validate.notNull(orderIds, 'orderIds not null')
            int num = 0;
            List<CheckOrder> orderList = []
            orderIds.eachWithIndex { BigInteger orderId, int i ->
                CheckOrder order = CheckOrder.findByIdAndStatusAndBranchId(orderId,2, LightConstants.getBranchId())
                if (order) {
                    num++
                    order.status = 1
                    order.auditName = LightConstants.getUserName()
                    order.auditAt = new Date()
                    order.checkAt = order.auditAt
                    order.save flush: true
                    orderList << order
                }
            }
            //台账
            orderList.each {
                if(it.validate() && it.status == 1){
                    def params = new HashMap<String, String>()
                    params.checkOrderId = it.id
                    def details = checkOrderDetailService.queryDetailList(params)
                    def mesList = []
//                    details.each { detail ->
//                        def kafkaStoreParam = new KafkaStoreParam(tenantId: it.tenantId,
//                                branchId: it.branchId,goodsId: detail.goodsId,code: it.code,occurType: 2,
//                                price: new BigDecimal(0),quantity: detail.checkQuantity, billCreateTime: it.checkAt)
//                        mesList << kafkaStoreParam.getSendMessage()
//                    }
//                    storeOrderProcessService.sendMessageList(mesList)
                    details.each {detail ->
                        Goods goods=Goods.findById(detail.goodsId);
                        def order=['branchId':it.branchId,
                                    'tenantId':it.tenantId,
                                    'orderCode':it.code,
                                    'occurType':"5",
                                    'barCode':goods?.barCode,
                                    'goodsName':goods?.goodsName,
                                    'occurAt':it.auditAt,
                                    'goodsId':detail.goodsId,
                                    'occurQuantity':detail.checkQuantity,
                                    'storeQuantity':detail.reallyQuantity,
                                    'createBy':it.auditName,
                        ];
                        storeAccountService.save(order);
                    }
                }
            }
            result.isSuccess = true
            if (orderIds.size() > 1) {
                result.msg = "成功审核【${num}】条单据"
            } else {
                result.msg = "审核成功"
            }
            return result
        } catch (Exception e) {
            throw new ServiceException('00001', '审核盘点单据错误：', e.message)
        }
    }

    /**
     * 删除
     * @param orderId not null
     */
    def deleteOrder(List<BigInteger> orderIds) {
        try {
            ResultJSON result = new ResultJSON(isSuccess: false, msg: '操作异常')
            int num = 0;
            Validate.notNull(orderIds, 'orderIds not null')
            orderIds.eachWithIndex { BigInteger orderId, int i ->
                def order = CheckOrder.findByIdAndStatusAndBranchId(orderId, 2,LightConstants.getBranchId())
                if (order) {
                    num++
                    order.isDeleted = true
                    order.save flush: true
                }
            }
            result.isSuccess = true
            if (orderIds.size() > 1) {
                result.msg = "成功删除【${num}】条单据"
            } else {
                result.msg = "删除成功"
            }

            return result
        } catch (Exception e) {
            throw new ServiceException('00001', '删除盘点单据错误：', e.message)
        }
    }
}
