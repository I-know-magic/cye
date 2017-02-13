package smart.light.saas

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import grails.converters.JSON

//TODO 修改类注释
/**
 * SysEmpController
 * @author CodeGen
 * @generate at 2016-04-12 15:11:43
 */
class SysEmpController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    SysEmpService sysEmpService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/sysEmp/view")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = sysEmpService.querySysEmpList(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 新增
     */
    def create() {
        ResultJSON result
        try {
            result = sysEmpService.create()
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 修改
     */
    def edit() {
        ResultJSON result
        try {
            String id = params.id;
            result = sysEmpService.edit(id)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存
     */
    def save() {
        ResultJSON result
        try {
            SysEmp sysEmp = new SysEmp(params)
            result = sysEmpService.save(sysEmp)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 更新
     */
    def update() {
        ResultJSON result
        try {
            SysEmp sysEmp = new SysEmp(params)
            result = sysEmpService.save(sysEmp)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 删除
     */
    def delete() {
        ResultJSON result
        try {
            result = sysEmpService.delete(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }/**
     * 重置密码
     */
    def resetpass() {
        ResultJSON result
        try {
            //TODO params 需要传递 userid
            BigInteger id = new BigInteger(params['employeeId'])
            SysEmp employee = SysEmp.findById(id)
            BigInteger userId = employee.userId
            String pass = "888888"//重置密码需要录入新密码
            result = sysEmpService.resetpass(userId, pass)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 查询员工分类
     */
    def queryEmpBox() {
        def list = sysEmpService.getEmpList(params)
        SysEmp tabCarInfo = new SysEmp(id: null, name: '-- 请选择 --');
        list.add(0, tabCarInfo)
        render list as JSON
    }

    /**
     * 设置角色
     * @return
     */
    def role() {
        render view: "role", model: ['userId': params['userId']]
    }

    /**
     * 查询用户的角色数据
     * @return
     */
    def selectedRole() {
        ResultJSON result
        try {
            result = sysEmpService.selectedRole(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 保存角色
     * @return
     */
    def employeeRoles() {

        ResultJSON result
        try {
            //TODO params 需要传递三个参数 userid Employeeid state
            BigInteger id = new BigInteger(params['userId'])
            SysEmp employee = SysEmp.findById(id)
            BigInteger userId = employee.userId
            String roles = params['roleIds']
            result = sysEmpService.employeeRoles(userId.intValue(), roles)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

}
