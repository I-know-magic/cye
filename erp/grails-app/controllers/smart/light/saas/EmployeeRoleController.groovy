package smart.light.saas

import com.smart.common.Constants
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import grails.transaction.Transactional
import org.apache.commons.lang.time.DateUtils
import smart.light.auth.EmployeeRoleService


/**
 * 角色管理
 *
 */
class EmployeeRoleController {
    EmployeeRoleService employeeRoleService

    /**
     * 查询角色
     * @return
     */
    def query() {
        ResultJSON result
        try {
            result = employeeRoleService.queryRoles(params)
        } catch (ServiceException se) {
            result=new ResultJSON(se.getMessage(),false)
            LogUtil.logError(se, params)
        } catch (Exception e) {
            result=new ResultJSON(e.getMessage(),false)
            LogUtil.logError(e, params)
        }
        render result;
    }

    /**
     * 查询角色szq
     * @return
     */
    def queryTwo() {
        ResultJSON result
        try {
               result = employeeRoleService.queryRoles( params)



        } catch (ServiceException se) {
            LogUtil.logError(se, params)
            result = new ResultJSON(e)
        } catch (Exception e) {
            LogUtil.logError(e, params)
            result = new ResultJSON(e)
        }

        render result;

    }

    /**
     * 查询角色编码
     * @return
     */
    def getRoleCodeAuto() {
        def roleCodeResult
        try {
            roleCodeResult = employeeRoleService.getRoleCodeAuto()
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        def roleCode = ['roleCode': roleCodeResult]
        render roleCode as JSON
    }

    /**
     * 打开角色列表
     * @return
     */
    def index() {
//        def isHeader = SystemHelper.checkBranchType()
        render(view: '/sysRole/index', model: ['isHeader': true])
    }


    /**
     * 保存
     */
    def save() {
        ResultJSON result
        def branchTypeBefore
        try {
            SysRole role = new SysRole(params)
            role.packageName = Constants.PACKAGE_NAME
            role.isDeleted = false
            role.createBy = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_NAME)
            result = employeeRoleService.save(role)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
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
            BigInteger tenantId
            result = employeeRoleService.edit(null, id)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
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
            SysRole sysRole = new SysRole(params)
            sysRole.packageName = Constants.PACKAGE_NAME//默认数据
            sysRole.isDeleted = false
            result = employeeRoleService.save(sysRole)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
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
            result = employeeRoleService.delete(params, null)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 查询角色的权限
     * @return
     */
    def queryRolePrivilege() {
        ResultJSON result
        try {
//            BigInteger tenantId = CacheUtils.getFromSession(session.id, SessionConstants.KEY_TENANT_ID).asType(BigInteger)
            BigInteger roleId = params['roleId'].asType(BigInteger)
            result = employeeRoleService.queryRolePrivilege(null, roleId)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result.jsonMap.zt as JSON
    }
    /**
     * 获取系统权限
     */
    def querySysPrivilegeAsZTree() {
        try {
            render employeeRoleService.querySysPrivileges() as JSON
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        return
    }
    /**
     * 保存角色权限
     * @return
     */
    def saveRolePrivilege() {
        ResultJSON result = new ResultJSON(success: false, msg: '操作异常')
        try {
            BigInteger roleId = params['roleId'].asType(BigInteger)
            String privilegeIds = params['privilegeIds']
            result = employeeRoleService.saveRolePrivilege(null, roleId, privilegeIds)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

}
