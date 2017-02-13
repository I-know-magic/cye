package smart.light.saas

import api.AuthApi
import api.SaaSApi
import api.common.ApiRest
import com.smart.common.Constants
import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.IDCreator
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.hibernate.SQLQuery
import smart.light.auth.AuthService
import smart.light.auth.RoleService
import smart.light.auth.UserService
import smart.light.web.vo.SysEmpVo

//TODO 修改类注释
/**
 * SysEmpService
 * @author CodeGen
 * @generate at 2016-04-12 15:11:43
 */
@Transactional
class SysEmpService extends BaseServiceImpl{
    UserService userService;
    RoleService roleService;
    AuthService authService;
    /**
     * 查询SysEmp列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def querySysEmpList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from SysEmp t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from SysEmp t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件
            def kindId = params.kindId
            if (kindId != null && kindId != "-1") {
                query.append(" and ( t.deptId=:kindId )")
                queryCount.append(" and ( t.deptId=:kindId )")
                namedParams.put("kindId", new BigInteger(kindId))
            }
            params.each { k, v ->
                if('codeName'.equals(k)&&v){
                    query.append(' AND (t.name like :name or t.phone like :phone) ')
                    queryCount.append(' AND (t.name like :name or t.phone like :phone) ')
                    namedParams.name = "%$v%"
                    namedParams.phone = "%$v%"
                }
            }
            def list = SysEmp.executeQuery(query.toString(), namedParams, queryParams)
            def count = SysEmp.executeQuery(queryCount.toString(), namedParams)
            List<SysEmpVo> voList = []
            list.each { def it ->
                SysEmpVo vo = new SysEmpVo();
                vo.id=it.id;
                vo.name=it.name;
                vo.addr=it.addr;
                vo.phone=it.phone;
                vo.memo=it.memo;
                vo.userId=it.userId;
                vo.deptId=it.deptId;
                vo.loginName=it.loginName;
                vo.isDeleted=it.isDeleted;
                SysDept sysDept=SysDept.findById(it.deptId);
                vo.deptName=sysDept?.name;
                voList << vo
            }
            map.put("total", count.size() > 0 ? count[0] : 0)
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
     * 新增或更新SysEmp
     * @param sysEmp
     * @return
     */
    def save(SysEmp sysEmp) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (sysEmp.id) {
                if (sysEmp.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oSysEmp = SysEmp.findById(sysEmp.id)
                //TODO 复制对象属性值
                oSysEmp.name=sysEmp.name;
                oSysEmp.addr=sysEmp.addr;
                oSysEmp.phone=sysEmp.phone;
                LightConstants.setFiledValue(SysEmp.class,true);
                oSysEmp.save flush: true
                result.setMsg("编辑成功")
            } else {
                //生成登录帐号名称，保存s_user
                String loginName=IDCreator.newTenantID(1)
                Map sysUserMap=new HashMap();
                sysUserMap["loginName"]=loginName;
                sysEmp.loginName=loginName;
                //帐号类型：1路灯局人员
                sysUserMap["userType"]="1";
                //默认密码，客户登录后应有修改密码入口
                sysUserMap["loginPass"]="888888";
                //姓名
                sysUserMap["name"]=sysEmp.name;
                sysUserMap["bindMobile"]=sysEmp.phone;
                ApiRest rest = userService.register(sysUserMap);
                //绑定一个默认角色
                if(rest.isSuccess){
                    if(rest.data){
                        sysEmp.userId=rest.data;
                    }
                    String sql = "INSERT INTO s_user_role_r (user_id, role_id) VALUES ('"+rest.data+"', '2')"
                    SQLQuery query = getSession().createSQLQuery(sql);
                    query.executeUpdate();
                }else {
                    LogUtil.logError("员工保存失败 - ${rest.data} - ${rest.error}");
                }
                LightConstants.setFiledValue(SysEmp.class,false);
                sysEmp.save flush: true
                result.setMsg("员工添加成功，可使用账户:${loginName}，密码：888888登录系统！")

            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增SysEmp
     * @param id SysEmp主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            SysEmp sysEmp = new SysEmp()
            result.object = sysEmp

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑SysEmp
     * @param id SysEmp主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                SysEmp sysEmp = SysEmp.findById(Integer.parseInt(id))
                result.object = sysEmp
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
     * 删除SysEmp，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    SysEmp sysEmp = SysEmp.findById(Integer.parseInt(id))
                    ApiRest rest=userService.setEnabled(sysEmp.userId,false);
                    if(rest.isSuccess){
                        sysEmp.isDeleted = true
                        sysEmp.save flush: true
                    }else {
                        LogUtil.logError("员工删除失败 - ${rest.data} - ${rest.error}");
                    }
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
    /**
     * 重置密码
     * @param userId
     * @param pass
     * @return
     */
    def resetpass(BigInteger userId, String pass) {
        ResultJSON result = new ResultJSON()
        try {
            //TODO 接口可能改为录入新密码重置
            def ApiRest = authService.resetPassword(userId.toString(), pass);
            if (ApiRest.isSuccess) {
                result.isSuccess = true
                result.setMsg("密码重置成功!")
            } else {
                result.isSuccess = false
                result.setMsg(ApiRest.message)
            }

        } catch (Exception e) {

            ServiceException se = new ServiceException("210203", "调用重置密码接口错误", e.message)
            throw se
        }
        return result
    }
    def getEmpList(def params){
        return SysEmp.executeQuery('from SysEmp  where isDeleted=false')
    }
    def queryEmpsByDept(def deptId){
        return SysEmp.executeQuery('from SysEmp  where isDeleted=false and deptId='+deptId)
    }
    def selectedRole(def params) {
        ResultJSON result = new ResultJSON()
        try {
            BigInteger tenantId = (params["tenantId"] == null) ? null : BigInteger.valueOf(Long.valueOf(params["tenantId"]))
            BigInteger branchId = (params["branchId"] == null) ? null : BigInteger.valueOf(Long.valueOf(params["branchId"]))
            BigInteger sysUserId = (params["userId"] == null) ? null : BigInteger.valueOf(Long.valueOf(params["userId"]))
            Integer offset = (params["offset"] == null) ? -1 : Integer.valueOf(params["offset"])
            Integer rows = (params["rows"] == null) ? -1 : Integer.valueOf(params["rows"])
            def ApiRest = roleService.list(Constants.PACKAGE_NAME, sysUserId, offset, rows, params["param"])
            def map = new HashMap<String, Object>()
            List<BigInteger> roleIdList = new ArrayList<BigInteger>()
            if (ApiRest.isSuccess) {
//                SaaSApi.parseRestData(ApiRest, SysRole)
                for (int i = 0; i < ApiRest.data.size(); i++) {
                    roleIdList.add(ApiRest.data[i].getAt("id"))
                }
                map.put("rows", roleIdList)
                result.jsonMap = map
                result.isSuccess = true
            } else  {
                result.isSuccess = false
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("210213", "调用接口设置角色错误", e.message)
            throw se
        }
        return result
    }
    /**
     * 保存角色
     * @param userid
     * @param roles
     * @return
     * @throws ServiceException
     */
    def employeeRoles(int userid, String roles) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            def ApiRest = saveSysUserRole(userid, roles)
            if (ApiRest.isSuccess) {
                result.isSuccess = true
                result.setMsg("角色设置成功")
            } else {
                result.isSuccess = false
                result.setMsg("角色设置失败")
            }

        } catch (Exception e) {
            ServiceException se = new ServiceException("210213", "调用接口设置角色错误", e.message)
            throw se
        }
        return result
    }
    def saveSysUserRole(int userId, String roleIds) {
        def ApiRest = roleService.saveRole(userId, roleIds)
        return ApiRest
    }

}
