package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.DateUtils
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional

//TODO 修改类注释
/**
 * HandoverLogService
 * @author CodeGen
 * @generate at 2016-11-20 16:39:32
 */
@Transactional
class HandoverLogService  extends BaseServiceImpl{

    /**
     * 查询HandoverLog列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryHandoverLogList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from HandoverLog t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from HandoverLog t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = HandoverLog.executeQuery(query.toString(), namedParams, queryParams)
            def count = HandoverLog.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新HandoverLog
     * @param handoverLog
     * @return
     */
    def save(HandoverLog handoverLog) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (handoverLog.id) {
                if (handoverLog.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oHandoverLog = HandoverLog.findById(handoverLog.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue(oHandoverLog.class,true);
                oHandoverLog.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(handoverLog.class,false);
                handoverLog.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增HandoverLog
     * @param id HandoverLog主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            HandoverLog handoverLog = new HandoverLog()
            result.object = handoverLog

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑HandoverLog
     * @param id HandoverLog主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                HandoverLog handoverLog = HandoverLog.findById(Integer.parseInt(id))
                result.object = handoverLog
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
     * 删除HandoverLog，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    HandoverLog handoverLog = HandoverLog.findById(Integer.parseInt(id))
//                    handoverLog.isDeleted = true
                    handoverLog.delete()
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
    @Transactional(readOnly = true)
    def reportHandoverLogDay(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            StringBuilder query = new StringBuilder()
            StringBuilder querycount = new StringBuilder()
            def namedParams = new HashMap()

            def max = params['rows'] ? params['rows'] : 20
            def offset = params['page'] ? (Integer.parseInt(params['page']) - 1) * Integer.parseInt(max) : 0
            def sql = 'SELECT h.group_name, h.item_label, h.item_value, s.user_id, s.user_name, s.login_time, s.handover_time, h.sort_no, h.item_key, h.id, h.shift_id, s.shift_date FROM handover_log h LEFT JOIN shift_log s ON s.id = h.shift_id WHERE 1=1 '
            def count = 'SELECT count(1) FROM handover_log h LEFT JOIN shift_log s ON s.id = h.shift_id WHERE 1=1   '
            params.each { k, v ->
                if('codeName'.equals(k)&&v){
                    query.append(' AND (h.group_name like :catName ) ')
                    querycount.append(' AND (h.group_name like :catName ) ')
                    namedParams.catName = "%$v%"
                }
            }
            def startDate = params.startDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
            def endDate = params.endDate?.replaceAll(':', '')?.replaceAll('-', '')?.replaceAll(' ', '')
            if ((endDate =~ /\d+/).matches()) {
                query.append(" and s.handover_time <= '${params.endDate}:00' ")
                querycount.append(" and s.handover_time <= '${params.endDate}:00' ")
            } else {
                query.append(" and s.handover_time <= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                querycount.append(" and s.handover_time <= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
            }
            if ((startDate =~ /\d+/).matches()) {
                query.append(" and s.login_time >= '${params.startDate}:00' ")
                querycount.append(" and s.login_time >= '${params.startDate}:00' ")
            } else {
                query.append(" and s.login_time >= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
                querycount.append(" and s.login_time >= '${DateUtils.formatData('yyyy-MM-dd HH:mm:ss', new java.util.Date())}'")
            }
//            query.append(" GROUP BY g.category_id, bi.item_id, g.goods_name, bi.taste, bi.price ")
//            querycount.append(" GROUP BY g.category_id, bi.item_id, g.goods_name, bi.taste, bi.price ) t ")
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
            dataList.each {
                HandoverLog vo = new HandoverLog()
                int i = 0
                vo.groupName = it[i++]
                vo.itemLabel = it[i++]
                vo.itemValue = it[i++]

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
}
