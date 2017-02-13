package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import grails.transaction.Transactional

//TODO 修改类注释
/**
 * GoodsSpecService
 * @author CodeGen
 * @generate at 2016-11-29 10:25:13
 */
@Transactional
class GoodsSpecService {

    /**
     * 查询GoodsSpec列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryGoodsSpecList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from GoodsSpec t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from GoodsSpec t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = GoodsSpec.executeQuery(query.toString(), namedParams, queryParams)
            def count = GoodsSpec.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新GoodsSpec
     * @param goodsSpec
     * @return
     */
    def save(GoodsSpec goodsSpec) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (goodsSpec.id) {
                if (goodsSpec.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oGoodsSpec = GoodsSpec.findById(goodsSpec.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue(GoodsSpec.class,true,oGoodsSpec);
                oGoodsSpec.specName=goodsSpec.specName
                oGoodsSpec.specName2=goodsSpec.specName2
                oGoodsSpec.price=goodsSpec.price
                oGoodsSpec.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(GoodsSpec.class,false,goodsSpec);
                goodsSpec.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增GoodsSpec
     * @param id GoodsSpec主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            GoodsSpec goodsSpec = new GoodsSpec()
            result.object = goodsSpec

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑GoodsSpec
     * @param id GoodsSpec主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                GoodsSpec goodsSpec = GoodsSpec.findById(Integer.parseInt(id))
                result.object = goodsSpec
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
     * 删除GoodsSpec，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    GoodsSpec goodsSpec = GoodsSpec.findById(Integer.parseInt(id))
                    goodsSpec.isDeleted = true
                    goodsSpec.save flush: true
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
    def getBoxList(def params){
        return GoodsSpec.executeQuery('from GoodsSpec  where isDeleted=false ')
    }
}
