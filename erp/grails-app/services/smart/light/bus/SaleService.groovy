package smart.light.bus

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional

//TODO 修改类注释
/**
 * SaleService
 * @author CodeGen
 * @generate at 2016-06-12 15:43:20
 */
@Transactional
class SaleService {

    /**
     * 查询Sale列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def querySaleList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from Sale t where isDeleted=false and t.tenantId= :tenantId  ")
            StringBuffer queryCount = new StringBuffer("select count(t) from Sale t where isDeleted=false and t.tenantId= :tenantId  ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件
            String sid=LightConstants.querySid();
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

            params.each { k, v ->
                if ('codeName'.equals(k) && v) {
                    query.append(' AND (t.saleCode like :code) ')
                    queryCount.append(' AND (t.saleCode like :code) ')
                    namedParams.code = "%$v%"
                }
            }
            def list = Sale.executeQuery(query.toString(), namedParams, queryParams)
            def count = Sale.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新Sale
     * @param sale
     * @return
     */
    def save(Sale sale) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (sale.id) {
                if (sale.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oSale = Sale.findById(sale.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue({className}.class,true);
                oSale.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue({className}.class,false);
                sale.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增Sale
     * @param id Sale主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            Sale sale = new Sale()
            result.object = sale

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑Sale
     * @param id Sale主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Sale sale = Sale.findById(Integer.parseInt(id))
                result.object = sale
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
     * 删除Sale，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Sale sale = Sale.findById(Integer.parseInt(id))
                    sale.isDeleted = true
                    sale.save flush: true
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
}
