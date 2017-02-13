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
 * StoreOrderService
 * @author CodeGen
 * @generate at 2016-06-12 15:43:51
 */
@Transactional
class StoreOrderService {
    StoreAccountService storeAccountService

    StoreOrderDetailService storeOrderDetailService
    StoreOrderProcessService storeOrderProcessService
    /**
     * 分页查询
     */
    def queryPager(Map<String, String> params) {
        ResultJSON result = new ResultJSON()
        def map = new HashMap<String, Object>()
        StringBuffer query = new StringBuffer("from StoreOrder t where t.isDeleted = false  and t.tenantId= :tenantId  ")
        StringBuffer queryCount = new StringBuffer("select count(t.id),sum(t.quantity),sum(t.amount) from StoreOrder t where t.isDeleted = false  and t.tenantId= :tenantId  ")
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
            if ('orderType'.equals(k) && (v =~ /\d+/).matches()) {
                query.append(' AND (t.orderType = :orderType) ')
                queryCount.append(' AND (t.orderType = :orderType) ')
                namedParams.orderType = v.asType(Integer)
            }
        }
        def startDate = params.startDate?.replaceAll('[: -]', '')
        def endDate = params.endDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
        if ((startDate =~ /\d+/).matches()) {
            query.append(' AND (t.makeAt >= :startDate ) ')
//            or t.auditAt >= :startDate
            queryCount.append(' AND (  t.makeAt >= :startDate ) ')
            namedParams.startDate = DateUtils.StrToDate("${params.startDate}:00")
        }
        if ((endDate =~ /\d+/).matches()) {
            query.append(' AND (t.makeAt <= :endDate ) ')
            queryCount.append(' AND (t.makeAt <= :endDate  ) ')
            namedParams.endDate = DateUtils.StrToDate("${params.endDate}:00")
        }
        query.append(' order by t.makeAt desc ')
        def count = StoreOrder.executeQuery(queryCount.toString(), namedParams)
        def list2 = []
        if (count[0][0] > 0) {
            list2 = StoreOrder.executeQuery(query.toString(), namedParams, queryParams)
            def xQuantity = new BigDecimal(0)
            def xAmount = new BigDecimal(0)
            for (int x = list2.size() - 1; x >= 0; x--) {
                xQuantity += list2.get(x).quantity
                xAmount += list2.get(x).amount
            }
            def footerList = []
            footerList << new StoreOrder(code: '小计', quantity: xQuantity, amount: xAmount)
            footerList << new StoreOrder(code: '合计', quantity: new BigDecimal(count[0][1]), amount: new BigDecimal(count[0][2]))
            map.footer = footerList
        }else{
            def footerList = []
            footerList << new StoreOrder(code: '小计', quantity: new BigDecimal("0.00"), amount: new BigDecimal("0.00"))
            footerList << new StoreOrder(code: '合计', quantity: new BigDecimal("0.00"), amount: new BigDecimal("0.00"))
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
     * 保存或修改出入库单
     * 未审核状态的单据可以修改
     * @param order 出入库单 not null
     * @param detailList 单据明细 not null and size > 0 and size < 100
     */
    def saveOrUpdate(StoreOrder order, List<StoreOrderDetail> detailList) {
        try {
            ResultJSON result = new ResultJSON(isSuccess: false, msg: '操作异常')
            Validate.notNull(order, 'order not null')
            Validate.isTrue(detailList?.size() > 0 && detailList.size() < 500, 'detailList not null and size > 0')
            //计算库存数量和金额
            def orderQu = new BigDecimal(0)
            def orderAm = new BigDecimal(0)
            detailList.each {
                it.amount = it.purchaseAmount * it.quantity
                orderQu += it.quantity
                orderAm += it.amount
            }
            order.quantity = orderQu
            order.amount = orderAm

            if (order.id == null) {
                // TODO
                order.status = 2
                order.makeBy = LightConstants.getUserId()
                order.makeName = LightConstants.getUserName()
                order.makeAt = new Date()
                order.branchId = LightConstants.getBranchId()
                order.tenantId = LightConstants.getTenantId();
//                order.storageId = Storage.findByTenantIdAndBranchId(LightConstants.getTenantId(), order.branchId).id
                if (order.validate()) {
                    order.save flush: true
                    detailList.each {
                        it.storeOrderId = order.id
                        it.branchId = order.branchId
                        it.tenantId = LightConstants.getTenantId();
                        it.storeOrderCode = order.code
                    }
                    def res = storeOrderDetailService.saveOrUpdateDetailList(detailList)
                    if (res.isSuccess) {
                        result.isSuccess = true
                        result.msg = '保存成功'
                        result.object = order
                    } else {
                        Validate.isTrue(false, res.msg)
                    }
                } else {
                    result.msg = '保存失败，数据错误'
                    def fields = []
                    order.errors.allErrors.each {
                        fields << "${it.field}=${it.rejectedValue},${it.defaultMessage}"
                    }
                    Validate.isTrue(false, fields.toString())
                }
            } else {
                StoreOrder oldOrder = StoreOrder.findByIdAndStatusAndBranchId(order.id, 2,LightConstants.getBranchId())
                Validate.notNull(oldOrder, '单据已审核或不存在')

                oldOrder.quantity = order.quantity
                oldOrder.amount = order.amount
                oldOrder.memo = order.memo
                if (oldOrder.validate()) {
                    oldOrder.save flush: true
                    detailList.each {
                        it.storeOrderId = oldOrder.id
                        it.branchId = oldOrder.branchId
                        it.storeOrderCode = oldOrder.code
                    }
                    def res = storeOrderDetailService.saveOrUpdateDetailList(oldOrder.id, detailList)
                    if (res.isSuccess) {
                        result.isSuccess = true
                        result.msg = '修改成功'
                        result.object = order
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
            throw new ServiceException('00001', '保存或修改出入库单据错误：', e.message)
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
            List<StoreOrder> orderList = []
            orderIds.eachWithIndex { BigInteger orderId, int i ->
                def order = StoreOrder.findByIdAndStatusAndBranchId(orderId, 2,LightConstants.getBranchId())
                if (order) {
                    num++
                    order.status = 1
//                    order.makeBy = LightConstants.getUserId()
                    order.auditName = LightConstants.getUserName()
                    order.auditAt = new Date()
                    order.storeOrderAt = order.auditAt
                    order.save flush: true
                    orderList << order
                }
            }
            //台账
            orderList.each {
                if(it.validate() && it.status == 1){
                    def params = new HashMap<String, String>()
                    params.storeOrderId = it.id
                    def details = storeOrderDetailService.queryDetailList(params)
                    def mesList = []
//                    details.each { detail ->
//                        def kafkaStoreParam = new KafkaStoreParam(tenantId: it.tenantId,
//                                branchId: it.branchId,goodsId: detail.goodsId,code: it.code,occurType: it.orderType == 1 ? 3 : 4,
//                                price: detail.purchaseAmount,quantity: detail.quantity, billCreateTime: it.storeOrderAt)
//                        mesList << kafkaStoreParam.getSendMessage()
//                    }
//                    storeOrderProcessService.sendMessageList(mesList)
                    details.each {detail ->
                        Goods goods=Goods.findById(detail.goodsId);
                        def occurType=it.orderType==1?"3":"4";
                        def order=['branchId':it.branchId,
                                   'tenantId':it.tenantId,
                                   'orderCode':it.code,
                                   'occurType':occurType,
                                   'barCode':goods?.barCode,
                                   'goodsName':goods?.goodsName,
                                   'occurAt':it.auditAt,
                                   'goodsId':detail.goodsId,
                                   'occurQuantity':detail.quantity,
                                   'storeQuantity':detail.quantity,
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
            throw new ServiceException('00001', '审核出入库单据错误：', e.message)
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
                def order = StoreOrder.findByIdAndStatusAndBranchId(orderId,2, LightConstants.getBranchId())
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
            throw new ServiceException('00001', '删除出入库单据错误：', e.message)
        }
    }
}
