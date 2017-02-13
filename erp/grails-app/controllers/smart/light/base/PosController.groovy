package smart.light.base

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.CacheUtils
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import smart.light.saas.Branch

//TODO 修改类注释
/**
 * PosController
 * @author CodeGen
 * @generate at 2016-06-12 15:40:24
 */
class PosController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    PosService posService

    /**
     * 显示功能页面
     */
    def index() {
        def branchId =LightConstants.getBranchId()
        def branch = Branch.get(branchId)
        render(view: "/pos/view", model: ['branch': branch])
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = posService.queryPosList(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
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
            result = posService.create()
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
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
            result = posService.edit(id)
            /*result.object.password = ''*/
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 获取pos完整信息
     */
    def find(){
        ResultJSON result
        try {
            String id = params.id;
            result = posService.find(id)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
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
            Pos pos = new Pos(params)
            pos.tenantId = LightConstants.getFromSession(session.id,SessionConstants.KEY_TENANT_ID)?.asType(BigInteger)
            pos.tenantCode = LightConstants.getFromSession(session.id,SessionConstants.KEY_TENANT_CODE)
            result = posService.save(pos)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
            LogUtil.logError(e, params)
        }
        result.object = null
        render result
    }

    /**
     * 更新
     */
    def update() {
        ResultJSON result
        try {
            Pos pos = new Pos(params)
            result = posService.updateStatus(pos.id,pos.status,pos.password)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 更新mm
     */
    def updatePassword() {
        ResultJSON result
        try {
            Pos pos = new Pos(params)
            result = posService.updatePassword(pos.id,pos.password)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 重置门店
     */
    def resetBranch() {
        ResultJSON result
        try {
            Pos pos = new Pos(params)
            result = posService.resetBranch(pos.id)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
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
            result = posService.delete(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e){
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 查询pos编码
     */
    def getNextPosCode(){
        def tenantId = LightConstants.getFromSession(session.id,SessionConstants.KEY_TENANT_ID)?.asType(BigInteger)
        def res = ['posCode':SerialNumberGenerate.nextSerialNumber(3,posService.getMaxPosCode(tenantId)), 'status':'1']
        render res as JSON
    }

}
