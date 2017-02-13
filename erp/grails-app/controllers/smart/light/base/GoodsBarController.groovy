package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil

//TODO 修改类注释
/**
 * GoodsBarController
 * @author CodeGen
 * @generate at 2016-06-12 15:39:58
 */
class GoodsBarController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    GoodsBarService goodsBarService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/goodsBar/view")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = goodsBarService.queryGoodsBarList(params)
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
            result = goodsBarService.create()
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
            result = goodsBarService.edit(id)
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
            GoodsBar goodsBar = new GoodsBar(params)
            result = goodsBarService.save(goodsBar)
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
            GoodsBar goodsBar = new GoodsBar(params)
            result = goodsBarService.save(goodsBar)
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
            result = goodsBarService.delete(params)
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
