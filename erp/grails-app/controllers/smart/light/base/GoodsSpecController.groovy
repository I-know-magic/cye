package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import grails.converters.JSON

//TODO 修改类注释
/**
 * GoodsSpecController
 * @author CodeGen
 * @generate at 2016-11-29 10:25:13
 */
class GoodsSpecController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    GoodsSpecService goodsSpecService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/goodsSpec/view")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = goodsSpecService.queryGoodsSpecList(params)
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
            result = goodsSpecService.create()
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
            result = goodsSpecService.edit(id)
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
            GoodsSpec goodsSpec = new GoodsSpec(params)
            result = goodsSpecService.save(goodsSpec)
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
            GoodsSpec goodsSpec = new GoodsSpec(params)
            result = goodsSpecService.save(goodsSpec)
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
            result = goodsSpecService.delete(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    def queryBox(){
        def list = goodsSpecService.getBoxList(params)
        GoodsSpec baseTerminal = new GoodsSpec(id: 0, specName: '-- 请选择 --');
        list.add(0, baseTerminal)
        render list as JSON
    }


}
