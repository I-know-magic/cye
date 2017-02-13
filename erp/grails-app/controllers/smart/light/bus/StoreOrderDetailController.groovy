package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil

//TODO 修改类注释
/**
 * StoreOrderDetailController
 * @author CodeGen
 * @generate at 2016-06-12 15:44:20
 */
class StoreOrderDetailController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    StoreOrderDetailService storeOrderDetailService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/storeOrderDetail/view")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = storeOrderDetailService.queryStoreOrderDetailList(params)
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
            result = storeOrderDetailService.create()
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
            result = storeOrderDetailService.edit(id)
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
            StoreOrderDetail storeOrderDetail = new StoreOrderDetail(params)
            result = storeOrderDetailService.save(storeOrderDetail)
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
            StoreOrderDetail storeOrderDetail = new StoreOrderDetail(params)
            result = storeOrderDetailService.save(storeOrderDetail)
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
            result = storeOrderDetailService.delete(params)
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
