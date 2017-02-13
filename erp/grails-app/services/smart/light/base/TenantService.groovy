package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import grails.transaction.Transactional
import smart.light.saas.Tenant

//TODO 修改类注释
/**
 * TenantService
 * @author CodeGen
 * @generate at 2016-06-12 15:40:42
 */
@Transactional
class TenantService {

    /**
     * 查询Tenant列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryTenantList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from Tenant t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from Tenant t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = Tenant.executeQuery(query.toString(), namedParams, queryParams)
            def count = Tenant.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新Tenant
     * @param tenant
     * @return
     */
    def save(Tenant tenant) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (tenant.id) {
                if (tenant.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oTenant = Tenant.findById(tenant.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue(oTenant.class,true);
                oTenant.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(tenant.class,false);
                tenant.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增Tenant
     * @param id Tenant主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            Tenant tenant = new Tenant()
            result.object = tenant

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑Tenant
     * @param id Tenant主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Tenant tenant = Tenant.findById(Integer.parseInt(id))
                result.object = tenant
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
     * 删除Tenant，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Tenant tenant = Tenant.findById(Integer.parseInt(id))
                    tenant.isDeleted = true
                    tenant.save flush: true
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
