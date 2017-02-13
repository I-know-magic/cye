package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import com.smart.common.util.SerialNumberGenerate
import grails.converters.JSON

//TODO 修改类注释
/**
 * GoodsUnitController
 * @author CodeGen
 * @generate at 2016-06-12 15:40:06
 */
class GoodsUnitController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    GoodsUnitService goodsUnitService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/goodsUnit/index")
    }

    /**
     * 查询列表
     */
    def list() {
        ResultJSON result
        try {
            result = goodsUnitService.queryGoodsUnitList(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存/更新
     */
    def save() {
        ResultJSON result
        try {
            GoodsUnit goodsUnit = new GoodsUnit(params)
            def goodsUnitId
            if (goodsUnit.id) {
                goodsUnitId = goodsUnit.id
            }
            def isRepeat = goodsUnitService.checkCode(goodsUnit.unitName, goodsUnitId)
            if (isRepeat.success == "false") {
                result = isRepeat
                result.msg = "菜品单位名称重复，添加失败！"
                render result
                return
            }
            result = goodsUnitService.save(goodsUnit)
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
            result = goodsUnitService.edit(id)
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
    def del() {
        ResultJSON result
        try {
            result = goodsUnitService.delete(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
            result = new ResultJSON(se)
        } catch (Exception e) {
            LogUtil.logError(e, params)
            result = new ResultJSON(e)
        }
        render result
    }
    /**
     * 新增
     * @return
     */
    def create() {
        ResultJSON result
        try {
            result = goodsUnitService.create()
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 更新
     * @return
     */
    def update() {
        ResultJSON result
        try {
            GoodsUnit goodsUnit = new GoodsUnit(params)
            def goodsUnitId
            if (goodsUnit.id) {
                goodsUnitId = goodsUnit.id
            }
            def isRepeat = goodsUnitService.checkCode(goodsUnit.unitName, goodsUnitId)
            if (isRepeat.success == "false") {
                result = isRepeat
                result.msg = "菜品单位名称重复，添加失败！"
                render result
                return
            }
            result = goodsUnitService.save(goodsUnit)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 查询分类
     */
    def queryUnitBox() {
        def list = goodsUnitService.getGoodsUnitList()
        GoodsUnit goodsUnit = new GoodsUnit(id: null, unitName: '-- 请选择 --');
        list.add(0, goodsUnit)
        render list as JSON
    }
    /**
     * 查询菜品单位编码
     */
    def getGoodsUnitCode() {
        def code = ['unitCode': SerialNumberGenerate.getNextCode(2, goodsUnitService.getMaxGoodsUnitCode())]
        render code as JSON
    }

}
