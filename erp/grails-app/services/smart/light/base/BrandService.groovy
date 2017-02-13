package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional

//TODO 修改类注释
/**
 * BrandService
 * @author CodeGen
 * @generate at 2016-06-12 15:38:35
 */
@Transactional
class BrandService {

    /**
     * 查询Brand列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryBrandList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from Brand t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from Brand t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = Brand.executeQuery(query.toString(), namedParams, queryParams)
            def count = Brand.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新Brand
     * @param brand
     * @return
     */
    def save(Brand brand) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (brand.id) {
                if (brand.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oBrand = Brand.findById(brand.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue(oBrand.class,true);
                oBrand.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(brand.class,false);
                brand.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增Brand
     * @param id Brand主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            Brand brand = new Brand()
            result.object = brand

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑Brand
     * @param id Brand主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Brand brand = Brand.findById(Integer.parseInt(id))
                result.object = brand
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
     * 删除Brand，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Brand brand = Brand.findById(Integer.parseInt(id))
                    brand.isDeleted = true
                    brand.save flush: true
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
