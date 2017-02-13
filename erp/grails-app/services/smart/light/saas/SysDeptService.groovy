package smart.light.saas

import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional

//TODO 修改类注释
/**
 * SysDeptService
 * @author CodeGen
 * @generate at 2016-04-12 15:11:33
 */
@Transactional
class SysDeptService {

    SysEmpService sysEmpService;
    /**
     * 查询SysDept列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def querySysDeptList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from SysDept t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from SysDept t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件
            def kindId = params.kindId
            if (kindId != null && kindId != "-1") {
                query.append(" and ( t.parentId=:kindId or t.id=:kindId)")
                queryCount.append(" and ( t.parentId=:kindId or t.id=:kindId)")
                namedParams.put("kindId", new BigInteger(kindId))
            }
            params.each { k, v ->
                if('codeName'.equals(k)&&v){
                    query.append(' AND (t.name like :name or t.code like :code) ')
                    queryCount.append(' AND (t.name like :name or t.code like :code) ')
                    namedParams.name = "%$v%"
                    namedParams.code = "%$v%"
                }
            }
            query.append(" order by t.code");
            def list = SysDept.executeQuery(query.toString(), namedParams, queryParams)
            def count = SysDept.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新SysDept
     * @param sysDept
     * @return
     */
    def save(SysDept sysDept) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            result=checkCode(sysDept.code);

            if (sysDept.id) {
                if (sysDept.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oSysDept = SysDept.findById(sysDept.id)
                //TODO 复制对象属性值
                oSysDept.parentId=sysDept.parentId;
                oSysDept.parentName=sysDept.parentName;
                oSysDept.name=sysDept.name;
                oSysDept.memo=sysDept.memo;
                LightConstants.setFiledValue(SysDept.class,true);
                if(oSysDept.code!=sysDept.code && result.isSuccess || oSysDept.code==sysDept.code){
                    oSysDept.code=sysDept.code;
                    oSysDept.save flush: true
                    result.isSuccess=true;
                    result.setMsg("编辑成功")
                }

            } else {
                if(result.isSuccess) {
                    LightConstants.setFiledValue(SysDept.class, false);
                    sysDept.save flush: true
                    result.setMsg("添加成功")
                }
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增SysDept
     * @param id SysDept主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            SysDept sysDept = new SysDept()
            result.object = sysDept

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑SysDept
     * @param id SysDept主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                SysDept sysDept = SysDept.findById(Integer.parseInt(id))
                result.object = sysDept
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
     * 删除SysDept，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    SysDept sysDept = SysDept.findById(Integer.parseInt(id))
                    List list=sysEmpService.queryEmpsByDept(Integer.parseInt(id))
                    if(list.size==0){
                        sysDept.isDeleted = true
                        sysDept.save flush: true
                        result.setMsg("删除成功!")
                    }else {
                        result.isSuccess=false;
                        result.setMsg("请先删除部门下的员工!")
                        break;
                    }

                }
            }
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
    /**
     * 获取tree数据
     * @return
     */
    def getZTreeJson() {
        StringBuffer query = new StringBuffer(" from SysDept t where isDeleted=false order by t.code");
        def namedParams = new HashMap();
        def list = SysDept.executeQuery(query.toString(), namedParams);
        SysDept obj = new SysDept();
        obj.id = -1;
        obj.name = "所有部门";
        list << obj;
        return list
    }
    def checkCode(def code) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            List<SysDept> sysDepts = SysDept.findAllByCode(code)
            if(sysDepts.size()==0){
                result.isSuccess=true;
                result.setMsg("验证成功!")
            }else {
                result.isSuccess=false;
                result.setMsg("编码重复!")
            }
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "验证部门编码错误", e.message)
            throw se
        }
    }
}
