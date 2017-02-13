package smart.light.bus

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import smart.light.base.TableInfo
import smart.light.base.TableInfoService

//TODO 修改类注释
/**
 * TableInfoController
 * @author CodeGen
 * @generate at 2016-11-20 16:25:08
 */
class TableInfodataController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    TableInfoService tableInfoService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/tableInfo/viewdata")
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

}
