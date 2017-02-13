package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.DateUtils
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import grails.transaction.Transactional
import smart.light.web.vo.KafkaStoreParam
import smart.light.web.vo.StoreAccountVo

//TODO 修改类注释
/**
 * StoreAccountService
 * @author CodeGen
 * @generate at 2016-06-12 15:43:43
 */
@Transactional
class StoreAccountService extends BaseServiceImpl {
    StoreOrderProcessService storeOrderProcessService
    StoreService storeService
    /**
     * 查询StoreAccount列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    def queryStoreAccountList(Map params, String sessionId) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            StringBuilder query = new StringBuilder()
            def namedParams = new HashMap()
            def max = params['rows'] ? params['rows'] : 20
            def offset = params['page'] ? (Integer.parseInt(params['page']) - 1) * Integer.parseInt(max) : 0
            def sql = 'SELECT * FROM v_store_account_goods sa WHERE 1=1 '
            def count = 'SELECT COUNT(*) FROM v_store_account_goods  sa WHERE 1=1 '
            def goodsInfo = params.goodsInfo//菜品编码或名称
            def branchInfo = params.branchInfo
            def categoryInfo = params.categoryInfo
            def goodsId = params.goodsId
            def occurType = params.occurType
            def barCode=params.barCode
            def tenantId = LightConstants.getTenantId()
            query.append(" and sa.tenant_id=:tenantId")
            namedParams.put("tenantId", tenantId)
            if (goodsInfo != null && goodsInfo != "") {
                query.append(" and (sa.bar_code like '%" + goodsInfo + "%' or sa.goods_name like '%" + goodsInfo + "%') ")
            }
            if (branchInfo != null && branchInfo != "") {
                query.append(" and sa.branch_id=:branchId ")
                namedParams.put("branchId", new BigInteger(branchInfo))
            } else {
                def branchId = LightConstants.getBranchId()
                query.append(" and sa.branch_id= " + branchId)
            }
            if (categoryInfo != null && categoryInfo != "") {
                query.append(" and sa.category_id=:categoryInfo")
                namedParams.put("categoryInfo", new BigInteger(categoryInfo))
            }
            if (occurType != null && occurType != "0") {
                query.append(" and sa.occur_type=:occurType")
                namedParams.put("occurType", Integer.parseInt(occurType))
            }
            def startDate = params.startDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
            def endDate = params.endDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
            def number = params.number;
            if(barCode && Integer.parseInt(number) < 2){
                query.append(" and sa.bar_code="+barCode)
            }else{
                if ((endDate =~ /\d+/).matches()) {
                    query.append(" and sa.occur_at <= '${params.endDate}:00' ")
                } else {
                    query.append(" and sa.occur_at <= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                }
                if ((startDate =~ /\d+/).matches()) {
                    query.append(" and sa.occur_at >= '${params.startDate}:00' ")
                } else {
                    query.append(" and sa.occur_at >= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                }
            }
            query.append("  order by sa.occur_at desc")

            def sq = getSession().createSQLQuery(sql + query.toString())
            def cq = getSession().createSQLQuery(count + query.toString())
            sq.setMaxResults(max?.asType(int))
            sq.setFirstResult(offset?.asType(int))
            namedParams.eachWithIndex { def entry, int i ->
                sq.setParameter(entry.key, entry.value.toString())
                cq.setParameter(entry.key, entry.value.toString())
            }
            def total = cq.list()[0]
            def storeAccounts = []
            def dataList = []
            if (total > 0) {
                dataList = sq.list()
            }
            dataList.each {
                StoreAccountVo vo = new StoreAccountVo()
                int i = 0
                vo.barCode = it[i++]
                vo.goodsName = it[i++]
                vo.occurIncurred = it[i++]
                vo.occurQuantity = it[i++]
                vo.occurAmount = it[i++]
                vo.storeIncurred = it[i++]
                vo.storeQuantity = it[i++]
                vo.storeAmount = it[i++]
                vo.occurType = it[i++]
                vo.occurAt = it[i++]
                vo.orderCode = it[i]
                storeAccounts << vo
            }
            result.isSuccess = true
            result.jsonMap = ['rows': storeAccounts, 'total': total]
            return result

        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

    /**
     * 台账保存（接口消息）
     * @param param
     */
    def saveStoreAccount(KafkaStoreParam param) {
        try {
            storeOrderProcessService.sendMessage(param.getSendMessage())
            return true
        } catch (Exception e) {
            throw new ServiceException("1001", "保存台账错误：单据编码${param.code}", e.message)
        }
    }
    /**
     * 生成库存流水
     */
    def save(Map params){
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        def isSave = false
        try {
            LogUtil.logInfo("参数="+(params as JSON).toString());
            def occurType=Integer.parseInt(params['occurType']);
            //更新实际库存
            def res = storeService.save(params)
            LogUtil.logInfo("更新库存完毕!");
            def occurAt=params['occurAt'];
            def branchId=params['branchId']
            def tenantId=params['tenantId']
            def goodsId=params['goodsId']
            def occurQuantity=params['occurQuantity']
            if (occurType==1){
                occurAt=DateUtils.StrToDate(params['occurAt']);
                branchId=new BigInteger(params['branchId'])
                tenantId=new BigInteger(params['tenantId'])
                goodsId=new BigInteger(params['goodsId'])
                occurQuantity=new BigDecimal(params['occurQuantity'])
            }
            if(res.isSuccess){
                StoreAccount storeAccount=new StoreAccount(
                        branchId:branchId,//门店id
                        tenantId:tenantId,//商户id
                        orderCode:params['orderCode'],//单据号
                        occurType:occurType,//发生类型
                        barCode:params['barCode'],//条码
                        goodsName:params['goodsName'],//商品名称
                        occurAt:occurAt,//发生时间
                        goodsId:goodsId,//发生时间
                        occurQuantity:occurQuantity,//实际数量
                        storeQuantity:res.object.quantity,//库存数量
                        createBy:params['createBy'],//库存数量
                        createAt:new Date()
                );
                storeAccount.save flush: true;
                result.isSuccess=true;
                result.msg='已生成库存流水';
                LogUtil.logInfo("已生成库存流水!")
            }else{
                LogUtil.logInfo("更新库存错误!")
            }
        } catch (Exception e) {
            LogUtil.logError(e, params)
            throw new ServiceException('00001', '生成库存流水错误：', e.message)
        } finally {
            return result;
        }
        return result;
    }

}
