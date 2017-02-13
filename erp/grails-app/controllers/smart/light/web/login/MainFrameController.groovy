package smart.light.web.login

import api.common.ApiRest
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import smart.light.saas.SysOperate
import smart.light.saas.SysPrivilege
import smart.light.saas.SysRes

/**
 * 主页
 */
class MainFrameController {

    /**
     * 显示主页
     * @param id
     * @return
     */
    def mainFrame() {

        List<SysPrivilege> childrenMenuList = new ArrayList<SysPrivilege>();
        def tenantId = LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_ID)
        def tenantName = LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_NAME)
        def code =LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_CODE)
//        def tenantTime = LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_TIME)
        def userName = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_NAME)
        def userType = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_TYPE)
        if(!userType){
            userType="0";
        }

//        def logincount = LightConstants.getFromSession(session.id, "_user_login_count")
//        def branchName = LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_NAME)
        def loginName = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_LOGIN_NAME)
        List<Object> menus = ApiRest.toList(LightConstants.getFromSession(session.id, "_menu_tree"))
        session.setAttribute("op",menus as JSON)
        LightConstants.setToSession(session.id,"op",(menus as JSON).toString())
        ResultJSON resultJSON = createmenu(menus)
//        def menus=[]
        def parentMenuList
        def sysMap
        def opMap
        if (resultJSON.isSuccess) {
            parentMenuList = resultJSON.jsonMap.menu.get("menu")
            sysMap = resultJSON.jsonMap.view
            opMap = resultJSON.jsonMap.op
            LogUtil.logInfo("权限数据大小="+parentMenuList.size())

        }
//        def tenantId = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_ID)
//        def branchName =LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_NAME)
        render(view: '/mainFrame/mainFrame',model: ['branchName':tenantName,'loginName':loginName,'tenantCode': tenantId,'userName': userName,'parentMenuList': parentMenuList, "sysMap": sysMap, 'menu': menus,'userType':userType,'tenantCode': code]) //, model: ['branchName':branchName,'tenantCode': code, 'tenantTime': tenantTime, 'userName': userName, 'tenantName': tenantName,'userType':userType ,'parentMenuList': parentMenuList, "sysMap": sysMap, 'menu': menus])
//
    }



//    def initTenantInfo(){
//        def businessId
//        def provinceId
//        def cityId
//        def countryId
//        def addressDetail
//        def type
//        def sessionId
//        if(params.businessId){
//            businessId= params.businessId
//        }
//        if(params.provinceId){
//            provinceId = params.provinceId
//        }
//        if(params.cityId){
//            cityId = params.cityId
//        }
//        if(params.countryId){
//            countryId = params.countryId
//        }
//        if(params.addressDetail){
//            addressDetail = params.addressDetail
//        }
//        if(params.sessionId){
//            sessionId = params.sessionId
//            type = CacheUtils.getFromSession(sessionId,"_business1")
//        }
////        if(params.type){
////            type = params.type
////        }
//
//        render (view: '/init/initTenantInfo',model: [businessId:businessId,provinceId:provinceId,cityId:cityId,countryId:countryId,addressDetail:addressDetail,type:type,sessionId:sessionId])
//    }
//    def initCategory(){
//        def businessId
//        def provinceId
//        def cityId
//        def countryId
//        def addressDetail
//        def type
//        def sessionId
//        if(params.businessId){
//            businessId= params.businessId
//        }
//        if(params.provinceId){
//            provinceId = params.provinceId
//        }
//        if(params.cityId){
//            cityId = params.cityId
//        }
//        if(params.countryId){
//            countryId = params.countryId
//        }
//        if(params.addressDetail){
//            addressDetail = params.addressDetail
//        }
//        if(params.type){
//            type = params.type
//        }
//        if(params.sessionId){
//            sessionId = params.sessionId
//        }
//
//        render (view: '/init/initCategoryType',model: [businessId:businessId,provinceId:provinceId,cityId:cityId,countryId:countryId,addressDetail:addressDetail,type: type,sessionId:sessionId])
//    }
//    def initGoosUnit(){
//        def businessId
//        def provinceId
//        def cityId
//        def countryId
//        def addressDetail
//        def type
//        def sessionId
//        if(params.businessId){
//            businessId= params.businessId
//        }
//        if(params.provinceId){
//            provinceId = params.provinceId
//        }
//        if(params.cityId){
//            cityId = params.cityId
//        }
//        if(params.countryId){
//            countryId = params.countryId
//        }
//        if(params.addressDetail){
//            addressDetail = params.addressDetail
//        }
//        if(params.type){
//            type = params.type
//        }
//        if(params.sessionId){
//            sessionId = params.sessionId
//        }
//        render (view: '/init/initGoodsUnit',model: [businessId:businessId,provinceId:provinceId,cityId:cityId,countryId:countryId,addressDetail:addressDetail,type: type,sessionId: sessionId])
//    }
//    def initGoodsSpec(){
//        def businessId
//        def provinceId
//        def cityId
//        def countryId
//        def addressDetail
//        def type
//        def sessionId
//        if(params.businessId){
//            businessId= params.businessId
//        }
//        if(params.provinceId){
//            provinceId = params.provinceId
//        }
//        if(params.cityId){
//            cityId = params.cityId
//        }
//        if(params.countryId){
//            countryId = params.countryId
//        }
//        if(params.addressDetail){
//            addressDetail = params.addressDetail
//        }
//        if(params.type){
//            type = params.type
//        }
//        if(params.sessionId){
//            sessionId = params.sessionId
//        }
//        render (view: '/init/initGoodsSpec',model: [businessId:businessId,provinceId:provinceId,cityId:cityId,countryId:countryId,addressDetail:addressDetail,type: type,sessionId: sessionId])
//    }
//
//    def getInitInfo(){
//        def businessId
//        if(params.businessId){
//            businessId= params.businessId
//        }
//        int type = Integer.parseInt(params.type)
//        def hql = "from BusinessDataTemplate b where b.type ="+type+" and b.isDeleted = 0 and b.businessId="+businessId
//        def result = BusinessDataTemplate.executeQuery(hql)
//        render result as JSON
//    }
//    def initFinesh(){
//        ResultJSON resultJSON
//        try{
//            def sessionId
//            if(params.sessionId){
//                sessionId = params.sessionId
//            }
//            def tenantId = CacheUtils.getFromSession(sessionId,"_tenant_id")
//            def businessId
//            def provinceId
//            def cityId
//            def countryId
//            def addressDetail
//            if(params.businessId){
//                businessId = params.businessId
//            }
//            if(params.provinceId){
//                provinceId = params.provinceId
//            }
//            if(params.cityId){
//                cityId = params.cityId
//            }
//            if(params.countryId){
//                countryId = params.countryId
//            }
//            if(params.addressDetail){
//                addressDetail = params.addressDetail
//            }
//            resultJSON = loginService.initFinesh(tenantId,businessId,provinceId,cityId,countryId,addressDetail)
//        }catch (Exception e){
//            resultJSON = new ResultJSON(e)
//            resultJSON.isSuccess = false
//            resultJSON.setMsg("初始化商户信息异常！")
//            LogUtil.loginfo(e.message)
//        }
//        render resultJSON
//    }
//    def goLogin(){
//        def sessionId
//        if(params.sessionId){
//            sessionId = params.sessionId
//        }
//        redirect(url: PropertyUtils.getDefault("verifyBind.url")+"/mainFrame/tenantMainFrame?sessionId="+sessionId)
//    }


    def createmenu(List<Object> l) {
        ResultJSON resultJSON = new ResultJSON()
        Map<String, List<SysRes>> mapMenu = new HashMap<String, List<SysRes>>()
        Map<String, List<SysRes>> mapView = new HashMap<String, List<SysRes>>()
        Map<String, List<SysOperate>> mapOp = new HashMap<String, List<SysOperate>>()
        List<SysRes> listMenu = new ArrayList<SysRes>()
        try {
            for (int i = 0; i < l.size(); i++) {
                Map<String, Object> map = l.get(i)
                SysRes sysRes = setSysRes(map)
                listMenu.add(sysRes)
                List<Object> resList = map.get("resList")
                List<SysRes> listsysmenu = new ArrayList<SysRes>()
                for (Map<String, Object> childmap : resList) {
                    SysRes childsysRes = setSysRes(childmap)
                    listsysmenu.add(childsysRes)
                    List<Object> ops = childmap.get("opList")
                    List<SysOperate> oplist = new ArrayList<SysOperate>()
                    for (Map<String, Object> opmap : ops) {
                        oplist.add(setOp(opmap))
                    }
                    mapOp.put(childsysRes.id.toString(), oplist)
                }
                mapView.put(sysRes.id.toString(), listsysmenu)
            }
            mapMenu.put("menu", listMenu)
            resultJSON.jsonMap.put("menu", mapMenu)
            resultJSON.jsonMap.put("view", mapView)
            resultJSON.jsonMap.put("op", mapOp)
        } catch (Exception e) {
            resultJSON.isSuccess = false
            resultJSON.msg = "读取菜单错误!"
        }

        return resultJSON
    }

    def setSysRes(Map<String, Object> map) {
        SysRes sysRes = new SysRes()
        try {
            sysRes.parentId = map.get("parentId")?.asType(BigInteger)
            sysRes.id = map.get("resId")?.asType(BigInteger)
            sysRes.resName = map.get("resName")
            sysRes.packageName = map.get("packageName")
            sysRes.controllerName = map.get("controllerName")
            if (map.get("memo")) {
                def objArr = map.get("memo").split("#")
                sysRes.packageName = objArr[0]
                sysRes.memo = objArr[1]
            }
        } catch (Exception e) {
            LogUtil.logError("读取资源错误::"+e.getMessage())
        }
        return sysRes
    }

    def setOp(Map<String, Object> map) {
        SysOperate sysOperate = new SysOperate()
        sysOperate.actionName = map.get("actionName")
        sysOperate.opName = map.get("opName")
        sysOperate.id = map.get("id")?.asType(BigInteger)
        return sysOperate
    }
    def getMap(){
        render(view: "/map/mapcontrol")
    }
}
