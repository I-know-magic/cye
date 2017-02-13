package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import smart.light.web.vo.StoreVo

import java.sql.CallableStatement
import java.sql.Connection

//TODO 修改类注释
/**
 * StoreService
 * @author CodeGen
 * @generate at 2016-06-12 15:43:36
 */
@Transactional
class StoreService extends  BaseServiceImpl{

    /**
     * 查询Store列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    def queryStoreList(Map params, String sessionId) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            StringBuilder query = new StringBuilder()
            def namedParams = new HashMap()
            def max = params['rows'] ? params['rows'] : 20
            def offset = params['page'] ? (Integer.parseInt(params['page']) - 1) * Integer.parseInt(max) : 0
            def sql = 'SELECT * FROM v_store_goods sg WHERE 1=1 '
            def count = 'SELECT COUNT(*) FROM v_store_goods  sg WHERE 1=1 '
            def goodsInfo = params.goodsInfo//菜品编码或名称
            def branchInfo = params.branchInfo
            def categoryInfo = params.categoryInfo
            def tenantId =LightConstants.getTenantId()
            query.append(" and sg.tenant_id=:tenantId")
            namedParams.put("tenantId", tenantId)
            if (goodsInfo != null && goodsInfo != "") {
                query.append(" and (sg.goods_code like '%" + goodsInfo + "%' or sg.goods_name like '%" + goodsInfo + "%') ")
            }
            if (branchInfo != null && branchInfo != "") {
                query.append(" and sg.branch_id=:branchId ")
                namedParams.put("branchId", new BigInteger(branchInfo))
            } else {
                def branchId = LightConstants.getBranchId()
                query.append(" and sg.branch_id= " + branchId)
            }
            if (categoryInfo != null && categoryInfo != "") {
                query.append(" and sg.category_id=:categoryInfo")
                namedParams.put("categoryInfo", new BigInteger(categoryInfo))
            }
            def sq = getSession().createSQLQuery(sql + query.toString())
            def cq = getSession().createSQLQuery(count + query.toString())
            sq.setMaxResults(max?.asType(int))
            sq.setFirstResult(offset?.asType(int))
            namedParams.eachWithIndex { def entry, int i ->
                sq.setParameter(entry.key, entry.value.toString())
                cq.setParameter(entry.key, entry.value.toString())
            }
            def total = cq.list()[0]
            def stores = []
            def dataList = []
            if (total > 0) {
                dataList = sq.list()
            }
            dataList.each {
                StoreVo vo = new StoreVo()
                int i = 0
                vo.barCode = it[i++]
                vo.goodsName = it[i++]
                vo.categoryName = it[i++]
                vo.goodsUnitName = it[i++]
                vo.avgAmount = it[i++]
                vo.salePrice = it[i++]
                vo.quantity = it[i++]
                vo.storeAmount = it[i]
                stores << vo

            }
            result.isSuccess = true
            result.jsonMap = ['rows': stores, 'total': total]

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

    /**
     * 查询管理库存商品的库存信息
     * 当前登录账号对应门店和商户
     * @param param
     * @author hxh
     */
    def queryGoodsStoreList(){
        try {
            Connection conn = session.connection();
            String sql = "CALL proc_goods_store_info(?,?,?,?,?,?)"
            CallableStatement cs = conn.prepareCall(sql);
            cs.setObject(1,LightConstants.getTenantId())
            cs.setObject(2,LightConstants.getBranchId())
            cs.setObject(3,0)
            cs.setObject(4,null)
            cs.setObject(5,null)
            cs.setObject(6,null)
            List<StoreVo> resList = []
            if(cs.execute()){
                def rs = cs.getResultSet()
                while (rs.next()){
                    def vo = new StoreVo()
                    int i = 1
                    vo.goodsId = rs.getObject(i++)
                    vo.barCode = rs.getObject(i++)
                    vo.goodsName = rs.getObject(i++)
                    vo.categoryName = rs.getObject(i++)
                    vo.goodsUnitName = rs.getObject(i++)
                    vo.salePrice = rs.getObject(i++)
                    vo.storeId = rs.getObject(i++)
                    vo.quantity = rs.getObject(i++)
                    vo.avgAmount = rs.getObject(i++)
                    vo.storeAmount = rs.getObject(i++)
                    vo.storeAt = rs.getObject(i++)
                    vo.branchId = rs.getObject(i++)
                    vo.tenantId = rs.getObject(i++)
                    vo.purchasingPrice = rs.getObject(i)
                    resList << vo
                }
            }else{
                Validate.isTrue(false,"用户[${LightConstants.getUserId()}]执行proc_goods_store_info错误")
            }
            return resList
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }
    /**
     * 保存或修改库存数量
     */
    def save(Map params){
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        def tenantId=params['tenantId'];
//        def goodsId=new BigInteger(params['goodsId']);
        def goodsId=params['goodsId'];
        Store store;
        LogUtil.logInfo("tenantId="+tenantId);
        LogUtil.logInfo("goodsId="+goodsId);
        def occurType=Integer.parseInt(params['occurType']);
        LogUtil.logInfo("occurType="+occurType);

        if(occurType==1){
            store=Store.findByTenantIdAndGoodsIdAndIsDeleted(new BigInteger(tenantId),new BigInteger(goodsId),false);
            LogUtil.logInfo("查询store==1");

        }else{
            store=Store.findByTenantIdAndGoodsIdAndIsDeleted(tenantId,goodsId,false);
            LogUtil.logInfo("查询store");
        }

//        if(occurType==3){
//            params['storeQuantity']=params['occurQuantity']
//        }

        if(store){
            if(occurType==4){
                store.quantity=store.quantity-params['occurQuantity'];
            }else if(occurType==1){
                if(params['occurQuantity']){
                    store.quantity=store.quantity+Integer.parseInt(params['occurQuantity']);
                }
            }else{
                store.quantity=store.quantity+params['occurQuantity'];
            }
            store.lastUpdateAt=new Date();
            store.lastUpdateBy=params['createBy'];
            store.save flush: true;
        }else {
            store=new Store();
            if(occurType==1){
                LogUtil.logInfo("查询无结果==1");
                store.tenantId=new BigInteger(tenantId);
                store.goodsId=new BigInteger(goodsId);
                store.branchId=new BigInteger(params['branchId']);
                store.quantity=new BigDecimal("0");

            }else{
                LogUtil.logInfo("查询无结果");

                store.tenantId=tenantId;
                store.goodsId=goodsId;
                store.branchId=params['branchId'];
                store.quantity=params['storeQuantity'];

            }
            store.createBy=params['createBy'];
            store.isDeleted=false;
            store.createAt=new Date();
            store.save flush: true;
        }
        result.isSuccess=true;
        result.msg='库存修改成功';
        result.object=store;
        return result
    }
}

