package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import smart.light.saas.Branch

//TODO 修改类注释
/**
 * StoreAccountController
 * @author CodeGen
 * @generate at 2016-06-12 15:43:43
 */
class StoreAccountController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    static allowedMethods = [save: "POST"]

    StoreAccountService storeAccountService

    def index() {
        def barCode = params['barCode'] == null ? '' : params['barCode']
        def backUrl = params['backUrl'] == null ? '' : params['backUrl']
        def backTitle = params['backTitle'] == null ? '' : params['backTitle']

        def branchId = LightConstants.getBranchId();
        def branch = Branch.findById(branchId)
        render(view: "/storeAccount/index", model: ["branch": branch, 'barCode': barCode, 'backUrl': backUrl,
                                                    'backTitle': backTitle, 'backParams': params['backParams'],
                                                    'saBackParams': params['saBackParams'], 'sBackParams': params['sBackParams']])
    }
    /**
     * 查询列表
     */
    def list() {
        ResultJSON result
        try {
            String sessionId = session.id
            result = storeAccountService.queryStoreAccountList(params, sessionId)
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
     * 跳转菜品分类界面
     */
    def showGoodCate() {

        render view: "/storeAccount/myGoodCateGory"
    }
    /**
     * 保存
     */
    def save() {
        ResultJSON result
        try {
            result = storeAccountService.save(params)
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
