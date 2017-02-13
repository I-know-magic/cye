package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import grails.converters.JSON
import smart.light.saas.Branch

//TODO 修改类注释
/**
 * StoreController
 * @author CodeGen
 * @generate at 2016-06-12 15:43:36
 */
class StoreController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    StoreService storeService

    def index() {
        def branchId = LightConstants.getBranchId();
        def branch = Branch.findById(branchId)
        render(view: "/store/index", model: ["branch": branch, backParams: params['backParams']])
    }
    /**
     * 查询列表
     */
    def list() {
        ResultJSON result
        try {
            String sessionId = session.id
            result = storeService.queryStoreList(params, sessionId)

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
     * 查询管理库存商品的库存信息
     * 当前登录账号对应门店和商户
     * @return
     * @author hxh
     */
    def queryGoodsStoreList() {
        def storeList = []
        try {
            storeList = storeService.queryGoodsStoreList()
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render storeList as JSON
    }


}
