package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil

//TODO 修改类注释
/**
 * TableInfoController
 * @author CodeGen
 * @generate at 2016-11-20 16:25:08
 */
class TableInfoController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    TableInfoService tableInfoService

    /**
     * 显示功能页面
     */
    def index() {
        def areaId = params['areaId'] == null ? '-1' : params['areaId']
        def areaName = params['areaName'] == null ? '-1' : params['areaName']
        def backUrl = params['backUrl'] == null ? '' : params['backUrl']
        areaId = backUrl == '' ? '-1' : areaId
        areaName = backUrl == '' ? '-1' : areaName
        render(view: "/tableInfo/view", model: ["areaId":areaId,"areaName":areaName,"backUrl":backUrl] )

    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = tableInfoService.queryTableInfoList(params)
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
            result = tableInfoService.create(params)
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
            result = tableInfoService.edit(id)
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
            TableInfo tableInfo = new TableInfo(params)
            result = tableInfoService.save(tableInfo)
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
            TableInfo tableInfo = new TableInfo(params)
            result = tableInfoService.save(tableInfo)
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
            result = tableInfoService.delete(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

}
