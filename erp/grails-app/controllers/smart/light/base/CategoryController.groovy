package smart.light.base

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.PinYinHelper
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import org.apache.commons.lang.StringUtils

//TODO 修改类注释
/**
 * CategoryController
 * @author CodeGen
 * @generate at 2016-06-12 15:39:40
 */
class CategoryController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    CategoryService categoryService
    GoodsService goodsService
    /**
     * 显示功能页面
     */
    def index() {
//        def isHeader = SystemHelper.checkBranchType()
        render view: '/category/index'//,model: [isHeader:isHeader]
    }

    /**
     * 查询列表
     */
    def list() {
        ResultJSON result
        try {
            result = categoryService.queryCategoryList(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 加载zTree的数据
     * @return
     */
    def loadZTree() {
        def isHavePackage = params.isHavePackage
        def isHaveMaterial = params.isHaveMaterial
        def result = categoryService.getZTreeJson(isHavePackage,isHaveMaterial)
        render result as JSON
    }
    /**
     * 加载Tree的数据
     * @return
     */
    def loadTreeData() {
        def result = categoryService.getJson()
        render result as JSON
//        render result

    }
    /**
     * 菜品的菜品分类树
     * @return
     */
    def loadNoRootTreeData() {
        def result = categoryService.getJson()
        result[0].text = '--请选择--'
        render result as JSON
    }

    /**
     * 查询菜品分类
     */
    def queryCategoryBox() {
        def list = categoryService.getCategoryList()
        Category category = new Category(id: null, catName: '-- 请选择 --');
        list.add(0, category)
        render list as JSON
    }

    /**
     * 保存
     */
    def save() {
        ResultJSON result
        try {
            Category category = new Category(params)
            category.mnemonics = PinYinHelper.stringFirstLetter(StringUtils.trimToEmpty(category.catName))
//            category.tenantId = new BigInteger(RedisClusterUtils.getFromSession(session.id, SessionConstants.KEY_TENANT_ID))
            category.tenantId = new BigInteger(LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_ID))
            def categoryId
            if (category.id) {
                categoryId = category.id
            }
            def isRepeat = categoryService.checkCode(category.catName, category.tenantId, categoryId)
            if (isRepeat.success == "false") {
                result = isRepeat
                result.msg = "分类名称重复，添加分类失败！"
                render result
                return
            }
            if (params['oneCode'] !="null"&& params['oneCode'] != "undefined") {
                result = categoryService.save(category, params['oneCode'])
            } else {
                result = categoryService.save(category, null)
            }


        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 新增
     * @return
     */
    def create() {
//        ResultJSON result=new ResultJSON();
//        Category category=new Category();
//        category.catCode=params.catCode;
//        category.parentName=params.parentName;
//
//        result.object=category;
//        render result
        ResultJSON result
        render false
    }
    /**
     * 修改
     * @return
     */
    def update() {
        ResultJSON result
        try {
            Category category = new Category(params)

            result = categoryService.save(category)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 修改页面
     */
    def edit() {
        ResultJSON result
        try {
            String id = params.id;
            result = categoryService.edit(id)
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
            result = categoryService.delete(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 获得一级分类的编码
     * @return
     */
    def getMaxOneCode() {
        def oneCodeResult = SerialNumberGenerate.getNextCode(2, categoryService.getMaxOneCode())
        def catCode = ['catCode': oneCodeResult]
        render catCode as JSON

    }
    /**
     * 获得二级分类的编码
     * @return
     */
    def getMaxTwoCodeByCatCode() {
        def oneCode = params['oneCode']
        def twoCodeResult
        if (oneCode) {
            def code = categoryService.getMaxTwoCodeByCatCode(oneCode)
            if (code) {
                twoCodeResult = SerialNumberGenerate.getNextCatTwoCode(code)
            } else {
                twoCodeResult = SerialNumberGenerate.getNextCatTwoCode(oneCode + "00")
            }
        }
        def catCode = ['catCode': twoCodeResult]
        render catCode as JSON
    }
    def queryCatGoods(){
        ResultJSON result
        try {
            def catId=params["id"]
            if(catId)
                result= goodsService.queryGoodsByCatId(new BigInteger(catId))
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
            result=new ResultJSON(se)
        } catch (Exception e) {
            LogUtil.logError(e, params)
            result=new ResultJSON(e)
        }
        render result

    }

}
