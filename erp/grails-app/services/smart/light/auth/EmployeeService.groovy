package smart.light.auth

import api.AuthApi
import api.common.ApiRest
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.IDCreator
import com.smart.common.util.LightConstants
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import smart.light.auth.AuthService
import smart.light.auth.RoleService
import smart.light.auth.UserService

import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import org.hibernate.SQLQuery
import smart.light.saas.Branch
import smart.light.saas.SysEmp


//TODO 修改类注释
/**
 * EmployeeService
 * @author CodeGen
 * @generate at 2015-06-24 11:50:23
 */
@Transactional
class EmployeeService extends BaseServiceImpl {
    UserService userService;
    RoleService roleService;
    AuthService authService;
    BranchService branchService;
    /**
     * 查询Employee列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryEmployeeList(Map params) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from SysEmp t where isDeleted=false and t.tenantId= :tenantId   ")
            StringBuffer queryCount = new StringBuffer("select count(t) from SysEmp t where  isDeleted=false and t.tenantId= :tenantId   ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            String sid=LightConstants.querySid();
//            namedParams.tenantId = new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_TENANT_ID));
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

            params.each { k, v ->
                if ('codeName'.equals(k) && v) {
                    query.append(' AND (t.code like :code or t.name like :name) ')
                    queryCount.append(' AND (t.code like :code or t.name like :name) ')
                    namedParams.name = "%$v%"
                    namedParams.code = "%$v%"
                }
            }
            if (params.branchId) {
                query.append(" and branchId=:branchId")
                queryCount.append(" and t.branchId=:branchId")
                namedParams.put("branchId", params.branchId)
            }
            def list = SysEmp.executeQuery(query.toString(), namedParams, queryParams)
            def count = SysEmp.executeQuery(queryCount.toString(), namedParams)
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
        return result
    }

    /**
     * 新增或更新Employee
     * @param employee
     * @return
     * @update: hxh 每个门店只能修改本门店的员工
     */
    def save(SysEmp employee) throws ServiceException {
        ResultJSON result = new ResultJSON()
        def ApiRest
        try {
            if (!employee.validate()) {
                result.success = false
                employee.errors.allErrors.each {
                    result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
                }
                result.object = employee
            } else if (employee.id != null) {

                def oEmployee = SysEmp.findById(employee.id)
                Validate.notNull(oEmployee,'员工不存在')
                oEmployee.name = employee.name
//                oEmployee.code = employee.code
                oEmployee.phone = employee.phone
                oEmployee.save flush: true
                result.setMsg("修改员工信息成功")
            } else {
                String loginName = IDCreator.newTenantID(0)
                Map sysUserMap = new HashMap();
                sysUserMap["loginName"] = loginName;
                employee.loginName = loginName;
                //帐号类型：1客户
                sysUserMap["userType"] = "3";
                //默认密码，客户登录后应有修改密码入口
                sysUserMap["loginPass"] = "888888";
                //姓名
                sysUserMap["name"] = employee.name;
                sysUserMap["bindMobile"] = employee.phone;
//                ApiRest rest=roleService.find(null,2);
//                List<SysRole> list=rest.data;
//                sysUserMap["sysRoles"]=list;
                ApiRest rest = userService.register(sysUserMap);
                //绑定角色
                if (rest.isSuccess) {
                    if (rest.data) {
                        employee.userId = rest.data;
                    }
                    String sql = "INSERT INTO s_user_role_r (user_id, role_id) VALUES ('" + rest.data + "', '1')"
                    SQLQuery query = getSession().createSQLQuery(sql);
                    query.executeUpdate();
                } else {
                    LogUtil.logError("客户保存失败 - ${rest.data} - ${rest.error}");
                }

                //保存客户信息
                employee.save flush: true
                result.setMsg("员工帐号添加成功，可使用账户:${loginName}，密码：888888登录系统！")
            }

        } catch (Exception e) {
            ServiceException se = new ServiceException("210204", "调用注册员工接口错误", e.message)
            throw se
        }
        return result
    }

    /**
     * 新增Employee
     * @param id Employee主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create(BigInteger branchId) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            if (branchId) {
                SysEmp employee = new SysEmp()
                employee.branchId = branchId
                result.object = employee
            } else {
                throw new Exception("未知错误")
            }


        } catch (Exception e) {
            ServiceException se = new ServiceException("103", "添加失败", e.message)
            throw se
        }
        return result
    }

    /**
     * 编辑Employee
     * @param id Employee主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            if (id) {
                SysEmp employee = SysEmp.findById(Integer.parseInt(id))
                result.object = employee
            } else {
                throw new Exception("无效的id")
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("104", "编辑失败", e.message)
            throw se
        }
        return result
    }

    /**
     * 删除Employee，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        ResultJSON result = new ResultJSON()
        try {
            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    SysEmp employee = SysEmp.findById(Integer.parseInt(id))
                    def ApiRest = deleteSysUser(employee.userId)
                    if (ApiRest.isSuccess) {
                        employee.isDeleted = true
                        employee.save flush: true
                        result.isSuccess = true
                        result.setMsg("删除成功")
                    } else {
                        result.isSuccess = false
                        result.setMsg("删除失败")

                    }

                }
            }


        } catch (Exception e) {
            ServiceException se = new ServiceException("105", "删除数据失败", e.message)
            throw se
        }
        return result
    }
    /**
     * 校验商户内编码唯一
     * @param code
     * @param tenantId
     * @param employeeId
     * @return
     */
    def checkCode(String code, BigInteger employeeId) {
        ResultJSON result = new ResultJSON()
        try {
            String hql = " from SysEmp e where e.code='" + code + "'";
            def list = SysEmp.executeQuery(hql);
            int count = list.size();

            if (count == 0) {
                result.success = "true";
            } else if (count == 1) {
                if (employeeId) {
                    if (employeeId.compareTo(list[0].id) == 0) {
                        result.success = "true";
                    } else {
                        result.success = "false";
                    }
                } else {
                    result.success = "false";
                }

            } else {
                result.success = "false";
            }


        } catch (Exception e) {
            ServiceException se = new ServiceException("106", "商户内编码唯一校验失败", e.message)
            throw se

        }
        return result;
    }


    def getEmployee(String userId) {
        def ApiRest = AuthApi.listSysUser(userId)
        SaaSApi.parseRestData(ApiRest, SysUser)
        SysEmp employee = SysEmp.findByUserId(new BigInteger(userId))
        employee.name = ApiRest.data[0].getAt("name")
//        employee.phone=ApiRest.data[0].getAt("bindMobile")
        return employee


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
        def ApiRest = AuthApi.saveSysUserRole(userId, roleIds)
        return ApiRest
    }

    def selectedRole(int userId) {
        ResultJSON result = new ResultJSON()
        try {
            def ApiRest = AuthApi.listSysRole(Constants.PACKAGE_NAME, BigInteger.valueOf(Long.valueOf(userId)))
            def map = new HashMap<String, Object>()
            List<BigInteger> roleIdList = new ArrayList<BigInteger>()
            if (ApiRest.isSuccess) {
                SaaSApi.parseRestData(ApiRest, SysRole)
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
     * 启用禁用：
     * @param userId 账户Id
     * @param employeeId 员工id
     * @param state 状态 1启用2停用
     * @return
     */
    def enableEmployee(BigInteger userId, BigInteger employeeId, int state) {
        ResultJSON result = new ResultJSON()
        try {
            def ApiRest = enableSysUser(userId, state)
            if (ApiRest.isSuccess) {
                SysEmp employee = SysEmp.findById(employeeId)
                if (state == 1) {
                    employee.state = 2
                } else if (state == 2) {
                    employee.state = 1
                }

                employee.save flush: true
                result.isSuccess = true
                if (state == 2) {
                    result.setMsg("启用成功")
                } else if (state == 1) {
                    result.setMsg("禁用成功")
                }
            } else {
                result.isSuccess = false
                result.setMsg(ApiRest.message)
            }

        } catch (Exception e) {
            ServiceException se = new ServiceException("210202", "调用启用禁用接口错误", e.message)
            throw se
        }
        return result

    }

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
    /**
     * 修改云平台密码
     * @param userId
     * @param oldPass
     * @param newPass
     * @return
     */
    def doChangePwd(BigInteger userId, String oldPass, String newPass) {
        ResultJSON result = new ResultJSON()
        try {
            int uId = userId.intValue()
            def ApiRest = AuthApi.changePassword(uId, oldPass, newPass)
            if (ApiRest.isSuccess) {
                result.isSuccess = true
                result.setMsg("云平台密码修改成功!")
            } else  {
                result.isSuccess = false
                result.setMsg(ApiRest.message)
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("210211", "调用修改密码接口错误", e.message)
            throw se
        }
        return result
    }
    /**
     * 修改POS登录密码
     */
    def doChangePOSPwd(BigInteger userId, String oldPass, String newPass) {
        ResultJSON result = new ResultJSON()
        try {
            SysEmp employee = SysEmp.findByUserId(userId)
            String tempPwd = employee.passwordForLocal;
            if (tempPwd == oldPass.encodeAsMD5()) {
                employee.passwordForLocal = newPass.encodeAsMD5()
                employee.save()
                result.msg = "密码修改成功!"
                result.isSuccess = true;
            } else {
                result.msg = "旧密码输入错误！"
                result.isSuccess = false;

            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("210212", "修改POS登录密码失败", e.message)
            throw se
        }
        return result
    }

    def doAccountSetting(SysEmp employee) throws ServiceException {
        ResultJSON result = new ResultJSON()
        def ApiRest
        try {
            if (employee.id) {
                if (employee.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oEmployee = SysEmp.findById(employee.id)
                //TODO 调用接口修改员工姓名
                ApiRest = saveUserName(oEmployee.userId, employee.name)
                if (ApiRest.isSuccess) {
                    oEmployee.name = employee.name
                    oEmployee.sex = employee.sex
                    oEmployee.birthday = employee.birthday
//                    oEmployee.phone = employee.phone
                    oEmployee.headPortraitBig = employee.headPortraitBig
                    oEmployee.save flush: true
                    result.setMsg("修改员工信息成功")
                    result.isSuccess = true
                } else {
                    result.isSuccess = false
                    result.setMsg("修改员工信息失败!")
                }

            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("210213", "修改员工信息失败", e.message)
            throw se
        }
        return result

    }

    /**
     * 调用接口启用禁用用户
     * @param userId
     * @param state
     */
    def enableSysUser(BigInteger userId, int state) {
        boolean flag = true
        if (state == 1)
            flag = false
        ApiRest ApiRest = AuthApi.enableSysUser(userId, flag);
        SaaSApi.parseRestData(ApiRest, SysUser)
        return ApiRest
    }
    /**
     * 调用接口注册员工用户
     * @param userId
     * @param state
     */
    def registerSysUser(String loginName, String loginPass, String name, String tenantCode, String branchId, String createBy) {
        ApiRest ApiRest = RegisterApi.tenantEmployeeRegister(loginName, loginPass, name, tenantCode, branchId, createBy)
        return ApiRest
    }

    def activate(int userId) {
        ApiRest ApiRest = RegisterApi.activate(userId)
        return ApiRest
    }

    /**
     * 删除用户
     */
    def deleteSysUser(BigInteger userId) {
        ApiRest ApiRest = userService.delete(userId)
        return ApiRest
    }
    /**
     * 删除用户
     */
    def saveUserName(BigInteger userId, String name) {
        ApiRest ApiRest = userService.saveUserName(userId, name)
        return ApiRest
    }

    def bindEmail(int userId, String email, String callback) {
        def ApiRest = AuthApi.bindEmail(userId.toString(), email, callback)
        return ApiRest
    }

    def bindQq(int userId, String qq, String callback) {
        def ApiRest = AuthApi.bindQq(userId.toString(), qq, callback)
        return ApiRest
    }

    def bindMobile(String userId, String number, String authCode, String sessionId) {
        def ApiRest = AuthApi.bindMobile(userId, number, authCode, sessionId)
        return ApiRest
    }

    def removeEmailBind(int userId) {
        def ApiRest = AuthApi.removeEmailBind(userId)
        return ApiRest
    }

    def removeQqBind(int userId) {
        def ApiRest = AuthApi.removeQqBind(userId)
        return ApiRest
    }

    def removeMobileBind(int userId) {
        try {
            def ApiRest = AuthApi.removeMobileBind(userId)
            if (ApiRest.isSuccess) {
                SysEmp e = SysEmp.findByUserId(userId)
                if (e) {
                    e.phone = ""
                    e.save flush: true
                }
            }
            return ApiRest
        } catch (Exception e) {
            ServiceException se = new ServiceException("210214", "解除电话绑定错误", e.message)
            throw se
        }

    }

    def bindEmailUnique(String value) {
        def ApiRest = AuthApi.bindEmailUnique(value)
        return ApiRest
    }

    def bindQqUnique(String value) {
        def ApiRest = AuthApi.bindQqUnique(value)
        return ApiRest
    }

    def bindMobileUnique(String value) {
        def ApiRest = AuthApi.bindMobileUnique(value)
        return ApiRest
    }

    def verifyBind(String v) {
        def ApiRest = AuthApi.verifyBind(v)
        return ApiRest
    }
    /**
     * 验证验证码
     * @param number
     * @param code
     * @param sessionId
     * @return
     */
    def SmsVerifyAuthCode(String number, String code, String sessionId) {
        def ApiRest = SmsApi.SmsVerifyAuthCode(number, code, sessionId)
        return ApiRest
    }
    /**
     * 发送验证码
     * @param number
     * @param sessionId
     * @return
     */
    def SmsSendAuthCode(String number, String sessionId) {
        def ApiRest = SmsApi.SmsSendAuthCode(number, sessionId)

        return ApiRest
    }

    def findbyUserId(BigInteger userId) {
        return SysEmp.findByUserId(userId)

    }

    def findbyUser(BigInteger userId, BigInteger tenantId) {
        ResultJSON resultJSON = new ResultJSON()
        try {
//            LogUtil.logInfo("######登录userId "+userId+"######登录商户id"+SystemHelper.getTenantId())
            def employee = SysEmp.findByUserId(userId)
            if (employee) {
                def branchId = employee?.branchId
                resultJSON.jsonMap.put("empcode", employee?.code)
                Branch branch = branchService.findbyid(branchId)
                if (branch) {
                    def branchType = branch?.branchType
                    def branchName = branch?.name
                    resultJSON.jsonMap.put("branchId", branchId)
                    resultJSON.jsonMap.put("branchType", branchType)
                    resultJSON.jsonMap.put("branchName", branchName)
                    //调用接口读取有效期
                    def ret = findBranchLimitDate(tenantId, branchId)
                    if (ret.isSuccess) {
                        String limitdata = ret.data
                        if(limitdata=="1900-01-01 00:00:00"){
                                resultJSON.jsonMap.put("limitdata", "无限期")
                        }else{
                            if (DateUtils.StrToDate(limitdata) > new Date()) {
                                resultJSON.jsonMap.put("limitdata", DateUtils.formatData("yyyy年MM月dd日", DateUtils.StrToDate(limitdata)))
                            } else {
                                resultJSON.isSuccess = false
                                resultJSON.msg = "门店已超过使用期限，请续费!"
                                resultJSON.jsonMap.put("isOrder", true)
                                resultJSON.jsonMap.put("errortype", 4)
                            }
                        }

                    } else{
                        resultJSON.isSuccess = false
                        resultJSON.msg = ret.message
                    }

                } else {
                    resultJSON.isSuccess = false
                    resultJSON.msg = "门店不存在！"
                    resultJSON.jsonMap.put("errortype", 1)
                }

            } else {
                resultJSON.isSuccess = false
                resultJSON.msg = "用户不存在！"
                resultJSON.jsonMap.put("errortype", 2)
            }

        } catch (Exception e) {
            resultJSON.jsonMap.put("errortype", 3)
            ServiceException se = new ServiceException("210213", "登录时读取门店失败", e.message)
            throw se
        }
        return resultJSON
    }

    def getByEmphone(String phone) {
        String sql = "select * from v_employee where phone='" + phone + "'"
        List<SysEmp> ems = getSession().createSQLQuery(sql).list();
//       BeanUtils.copyProperties(SysEmp.class,ems)
        if (ems && ems.size() > 0) {
            SysEmp e = new SysEmp()
            List<Object> l = ems.get(0)
            e.id = l.get(0)
            e.tenantId = l.get(1)
            e.branchId = l.get(2)
            e.userId = l.get(3)
            e.loginName = l.get(4)
            e.code = l.get(5)
            return e
        }
        return null
    }

    def saveEmpPhone(String userid, String phone) {
        ResultJSON result = new ResultJSON()
        try {
            def oEmployee = SysEmp.findByUserId(userid?.asType(BigInteger))
            oEmployee.phone = phone
            oEmployee.save flush: true
            result.isSuccess = true
        } catch (Exception e) {
            result.isSuccess = false
            result.msg = "保存失败！"
        }
        return result
    }
    /**
     * 查询商户-门店使用期限
     * @param number
     * @param sessionId
     * @return
     */
    def findBranchLimitDate(BigInteger tenantId, BigInteger branchId) {
        def ApiRest = SaaSApi.findBranchLimitDate(tenantId, branchId)

        return ApiRest
    }

    def queryEmpList(BigInteger branchId) {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()
            StringBuffer query = new StringBuffer("from SysEmp t where 1=1")
            def queryParams = new HashMap()
            def namedParams = new HashMap()
            query.append('AND t.branchId= :branchId')
            namedParams.branchId = branchId
            def list = SysEmp.executeQuery(query.toString(), namedParams, queryParams)
            map.put("rows", list)
            if (list.size() == 0) {
                result.setMsg("无数据")
            }
            result.jsonMap = map
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("101", "查询失败", e.message)
            throw se
        }
    }
    /**
     * 查询最大的员工编码
     * @return
     */
    def queryCode() {

        def hql = "SELECT MAX(b.code) FROM SysEmp AS b"
        String max
        Branch.withSession { s ->
            max = s.createQuery(hql).list().get(0)
        }
        def code = SerialNumberGenerate.nextSerialNumber(4, max)
        return code
    }
}
