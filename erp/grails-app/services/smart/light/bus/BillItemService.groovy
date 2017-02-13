package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.DateUtils
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import smart.light.web.vo.BillItemVo
import smart.light.web.vo.StoreAccountVo

//TODO 修改类注释
/**
 * BillItemService
 * @author CodeGen
 * @generate at 2016-11-20 16:24:26
 */
@Transactional
class BillItemService extends BaseServiceImpl{

    /**
     * 查询BillItem列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryBillItemList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from BillItem t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from BillItem t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = BillItem.executeQuery(query.toString(), namedParams, queryParams)
            def count = BillItem.executeQuery(queryCount.toString(), namedParams)
            map.put("total", count.size() > 0 ? count[0] : 0)
            map.put("rows", list)
            if (list.size() == 0) {
                result.setMsg("无数据")
            }

            result.jsonMap = map
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

    /**
     * 新增或更新BillItem
     * @param billItem
     * @return
     */
    def save(BillItem billItem) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (billItem.id) {
                if (billItem.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oBillItem = BillItem.findById(billItem.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue(oBillItem.class,true);
                oBillItem.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(billItem.class,false);
                billItem.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增BillItem
     * @param id BillItem主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            BillItem billItem = new BillItem()
            result.object = billItem

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑BillItem
     * @param id BillItem主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                BillItem billItem = BillItem.findById(Integer.parseInt(id))
                result.object = billItem
            } else {
                throw new Exception("无效的id")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1004", "编辑失败", e.message)
            throw se
        }
    }

    /**
     * 删除BillItem，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    BillItem billItem = BillItem.findById(Integer.parseInt(id))
                    billItem.isDeleted = true
                    billItem.save flush: true
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
//    销售日报
    @Transactional(readOnly = true)
    def reportBillItemDay(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            StringBuilder query = new StringBuilder()
            StringBuilder querycount = new StringBuilder()
            def namedParams = new HashMap()

            def max = params['rows'] ? params['rows'] : 20
            def offset = params['page'] ? (Integer.parseInt(params['page']) - 1) * Integer.parseInt(max) : 0
            def sql = 'SELECT bi.item_id, g.category_id, c.cat_name, g.goods_name, bi.taste, bi.price, sum(bi.qty), sum(bi.sum) FROM bill_item bi JOIN goods g ON bi.item_id = g.id JOIN category c ON g.category_id = c.id WHERE bi.cancel_time IS NULL '
            def count = 'SELECT count(1) FROM ( SELECT bi.item_id, g.category_id, c.cat_name, g.goods_name, bi.taste, bi.price, sum(bi.qty), sum(bi.sum) FROM bill_item bi JOIN goods g ON bi.item_id = g.id JOIN category c ON g.category_id = c.id WHERE bi.cancel_time IS NULL  '
//            def goodsInfo = params.goodsInfo//菜品编码或名称
//            def branchInfo = params.branchInfo
//            def categoryInfo = params.categoryInfo
//            def goodsId = params.goodsId
//            def occurType = params.occurType
//            def barCode=params.barCode
//            def tenantId = LightConstants.getTenantId()
            params.each { k, v ->
                if('codeName'.equals(k)&&v){
                    query.append(' AND (c.cat_name like :catName ) ')
                    querycount.append(' AND (c.cat_name like :catName ) ')
                    namedParams.catName = "%$v%"
                }
            }
            def startDate = params.startDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
            def endDate = params.endDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
                if ((endDate =~ /\d+/).matches()) {
                    query.append(" and bi.create_at <= '${params.endDate}:00' ")
                    querycount.append(" and bi.create_at <= '${params.endDate}:00' ")
                } else {
                    query.append(" and bi.create_at <= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                    querycount.append(" and bi.create_at <= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                }
                if ((startDate =~ /\d+/).matches()) {
                    query.append(" and bi.create_at >= '${params.startDate}:00' ")
                    querycount.append(" and bi.create_at >= '${params.startDate}:00' ")
                } else {
                    query.append(" and bi.create_at >= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                    querycount.append(" and bi.create_at >= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                }
            query.append(" GROUP BY g.category_id, bi.item_id, g.goods_name, bi.taste, bi.price ")
            querycount.append(" GROUP BY g.category_id, bi.item_id, g.goods_name, bi.taste, bi.price ) t ")
            def sq = getSession().createSQLQuery(sql + query.toString())
            def cq = getSession().createSQLQuery(count + querycount.toString())
            if(params['rows']){
                sq.setMaxResults(max?.asType(int))
                sq.setFirstResult(offset?.asType(int))
            }

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
            BigDecimal tPrice =new BigDecimal("0")
            BigDecimal tNum =new BigDecimal("0")
            dataList.each {
                BillItemVo vo = new BillItemVo()
                int i = 0
                vo.itemId = it[i++]
                vo.categoryId = it[i++]
                vo.catName = it[i++]
                vo.goodsName = it[i++]
                vo.taste = it[i++]
                vo.price = it[i++]
                vo.qty = it[i++]
                vo.sum = it[i++]
//                if(vo.sum){
                    tPrice=tPrice.add(vo.sum)
                    tNum=tNum.add(vo.qty)
//                }

                storeAccounts << vo
            }
            def footer=[];
            if(dataList.size()>0){
                BillItemVo vototal = new BillItemVo(catName:"合计",qty:tNum,sum:tPrice)
                footer << vototal
            }

            result.isSuccess = true
            result.jsonMap = ['rows': storeAccounts, 'total': total,footer:footer]
            return result

        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

}
