package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import smart.light.web.vo.StoreOrderDetailVo

//TODO 修改类注释
/**
 * StoreOrderDetailService
 * @author CodeGen
 * @generate at 2016-06-12 15:44:20
 */
@Transactional
class StoreOrderDetailService extends BaseServiceImpl{

    /**
     * 保存或修改
     * @param detailList not null
     * @param orderId 单据id null 为保存否则为更新
     */
    def saveOrUpdateDetailList(BigInteger orderId = null, List<StoreOrderDetail> detailList) {
        try {
            Validate.notNull(detailList, 'detailList not null')
            ResultJSON result = new ResultJSON(isSuccess: true, jsonMap: [:],msg: '保存成功')
            if (orderId != null) {
                deleteDetailsByOrderId(orderId)
            }
            detailList.eachWithIndex { entry, i ->
                if (entry.validate()) {
                    if (i != 0 && i % 2 == 0) {
                        StoreOrderDetail.withSession {
                            it.flush()
                            it.clear()
                        }
                    }
                    entry.save flush: false
                    result.jsonMap.put("${i}", entry)
                } else {
                    def fields = []
                    entry.errors.allErrors.each {
                        fields << "${it.field}=${it.rejectedValue}"
                    }
                    result.msg = "${i}:${fields.toString()}"
                    result.isSuccess = false
                    return
                }
            }
            return result
        } catch (Exception se) {
            throw new ServiceException("1005", "保存或修改出入库明细失败", se.message)
        }
    }

    /**
     * 同单据id删除明细
     * @param orderId not null
     */
    def deleteDetailsByOrderId(BigInteger orderId) {
        try {
            Validate.notNull(orderId, 'orderId not null')
            def list = StoreOrderDetail.findAllByStoreOrderId(orderId)
            list?.each {
                it.isDeleted = true
                it.save flush: false
            }
            return list.size()
        } catch (Exception se) {
            throw new ServiceException("1005", "删除出入库明细失败", se.message)
        }
    }

    /**
     * 查询明细
     */
    def queryDetailList(Map<String, String> params){
        try {
            def queryParam = [:]
            def sb = new StringBuilder()
            params.each { k, v ->
                if ('storeOrderId'.equals(k) && (v =~ /\d+/).matches()) {
                    sb.append(" AND m.store_order_id=:storeOrderId ")
                    queryParam.storeOrderId = "$v"
                }
            }
            sb.append(" AND m.tenant_id= ${LightConstants.getTenantId()} ")
            String sql = "SELECT * FROM v_store_order_detail m WHERE 1=1" + sb.toString()
            def sq = getSession().createSQLQuery(sql)
            queryParam.eachWithIndex { Map.Entry<Object, Object> entry, int i ->
                sq.setParameter(entry.key, entry.value.toString())
            }
            def list = sq.list()
            List<StoreOrderDetailVo> detailList = []
            list?.each {
                int i = 0
                def vo = new StoreOrderDetailVo()
                vo.id = it[i++]
                vo.memo = it[i++]
                vo.tenantId = it[i++]
                vo.branchId = it[i++]
                vo.purchaseAmount = it[i++]
                vo.quantity = it[i++]
                vo.amount = it[i++]
                vo.storeOrderId = it[i++]
                vo.storeOrderCode = it[i++]

                vo.goodsId = it[i++]
                vo.barCode = it[i++]
                vo.goodsName = it[i++]
                vo.categoryName = it[i++]
                vo.goodsUnitName = it[i++]
                vo.salePrice = it[i]
                detailList << vo
            }
            return detailList
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }
}
