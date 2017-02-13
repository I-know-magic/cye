package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import smart.light.web.vo.BusBoundDeviceHisDataVo
import smart.light.web.vo.TableInfoVo

//TODO 修改类注释
/**
 * TableInfoService
 * @author CodeGen
 * @generate at 2016-11-20 16:25:08
 */
@Transactional
class TableInfoService {

    /**
     * 查询TableInfo列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryTableInfoList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from TableInfo t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from TableInfo t where isDeleted=false ")
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
            def areaId = params.areaId
            if (areaId) {
                query.append(" and t.areaId  =" + new BigInteger(areaId)+ "");
                queryCount.append(" and  t.areaId = " + new BigInteger(areaId) + "")

            }
            def list = TableInfo.executeQuery(query.toString(), namedParams, queryParams)
            def count = TableInfo.executeQuery(queryCount.toString(), namedParams)

            List<TableInfoVo> voList = []
            list.each { it ->
                TableInfoVo vo = new TableInfoVo();
                vo.id=it.id;
                vo.areaId=it.areaId;
                vo.name=it.name;
//                vo.state=it.state;
//                vo.submitTime=it.submitTime;
//                vo.billSeqNo=it.billSeqNo;
                vo.branchId=it.branchId;
                vo.tenantId=it.tenantId;
                vo.areaName=TableArea.findById(it.areaId)?.name;
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
     * 新增或更新TableInfo
     * @param tableInfo
     * @return
     */
    def save(TableInfo tableInfo) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (tableInfo.id) {
                if (tableInfo.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oTableInfo = TableInfo.findById(tableInfo.id)
                //TODO 复制对象属性值
                oTableInfo.name=tableInfo.name
                oTableInfo.areaId=tableInfo.areaId
                LightConstants.setFiledValue(oTableInfo.class,true,oTableInfo);
                oTableInfo.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue(tableInfo.class,false,tableInfo);
                tableInfo.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增TableInfo
     * @param id TableInfo主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create(params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            TableInfoVo tableInfo = new TableInfoVo()
            tableInfo.areaId=new BigInteger(params["areaId"])
            tableInfo.areaName=params["areaName"]
            result.object = tableInfo

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑TableInfo
     * @param id TableInfo主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                TableInfo tableInfo = TableInfo.findById(Integer.parseInt(id))
                TableInfoVo tableInfoVo=new TableInfoVo()
                tableInfoVo.areaId=tableInfo.areaId
                tableInfoVo.id=tableInfo.id
                tableInfoVo.name=tableInfo.name
                tableInfoVo.areaName=TableArea.findById(tableInfo.areaId)?.name
                result.object = tableInfoVo
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
     * 删除TableInfo，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    TableInfo tableInfo = TableInfo.findById(Integer.parseInt(id))
                    tableInfo.isDeleted = true
                    tableInfo.save flush: true
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
