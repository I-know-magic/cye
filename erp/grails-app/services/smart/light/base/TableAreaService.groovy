package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import smart.light.web.vo.TableAreaVo

//TODO 修改类注释
/**
 * TableAreaService
 * @author CodeGen
 * @generate at 2016-11-20 16:24:57
 */
@Transactional
class TableAreaService {

    /**
     * 查询TableArea列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryTableAreaList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from TableArea t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from TableArea t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def codeName = params.codeName
            if (codeName) {
                query.append(" and t.name like '%" + codeName+ "%'");
                queryCount.append(" and  t.name like '%" + codeName+ "%'")

            }
            def list = TableArea.executeQuery(query.toString(), namedParams, queryParams)
            def count = TableArea.executeQuery(queryCount.toString(), namedParams)

            List<TableAreaVo> voList = []
            list.each { it ->
                TableAreaVo vo = new TableAreaVo();
                vo.id=it.id;
                vo.name=it.name;
                vo.tablenum=TableInfo.findAllByAreaIdAndIsDeleted(it.id,false).size();
                voList << vo
            }
            map.put("total", count.size() > 0 ? count.size() : 0)
            map.put("rows", voList)
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
     * 新增或更新TableArea
     * @param tableArea
     * @return
     */
    def save(TableArea tableArea) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (tableArea.id) {
                if (tableArea.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oTableArea = TableArea.findById(tableArea.id)
                //TODO 复制对象属性值
                oTableArea.name=tableArea.name
                LightConstants.setFiledValue(oTableArea.class,true,oTableArea);
                oTableArea.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(tableArea.class,false,tableArea);
                tableArea.branchId=new BigInteger("1");
                tableArea.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增TableArea
     * @param id TableArea主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            TableArea tableArea = new TableArea()
            result.object = tableArea

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑TableArea
     * @param id TableArea主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                TableArea tableArea = TableArea.findById(Integer.parseInt(id))
                result.object = tableArea
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
     * 删除TableArea，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    TableArea tableArea = TableArea.findById(Integer.parseInt(id))
                    tableArea.isDeleted = true
                    tableArea.save flush: true
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
