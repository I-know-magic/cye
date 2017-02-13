package smart.light.web.login

import api.common.ApiRest
import com.smart.common.Constants
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.PropertyUtils
import com.smart.common.util.SessionConstants
import grails.converters.JSON
import org.apache.commons.lang.StringUtils
import smart.light.auth.AuthService
import smart.light.auth.EmployeeService
import smart.light.auth.LoginService
import smart.light.saas.SysEmp

import javax.servlet.http.Cookie

/**
 * 用户登录
 */
class LoginController {
    LoginService loginService
    AuthService authService
//    BranchService branchService
//    EmployeeService employeeService

    def index() {

    }

    /**
     * 获取验证码
     * @author hxh
     */
    def checkCode() {
        LightConstants.setToSession(session.id, SessionConstants.KEY_BRANCH_ID, "testredis")

        render(LightConstants.getFromSession(session.id, SessionConstants.KEY_BRANCH_ID))
//        def checkCode = SaasCheckCodeUtils.getDefaultCode()
//        String code = checkCode.codeText
//        CacheUtils.setToSession(session.id, SessionConstants.KEY_USER_CHECK_CODE, code)
//        render contentType: 'image/jpeg',
//                file: checkCode.byteArrayOutputStream.toByteArray(),
//                filename: "${code}.jpg"
    }
    /**
     * 异步校验验证码
     * @return validate
     * @author hxh
     */
    def asyValidateCode() {
        def checkCode = StringUtils.upperCase((String) params['yzCode'])
        if (validateCode(checkCode)) {
            render(['validate': true] as JSON)
        } else {
            render(['validate': false] as JSON)
        }
    }
    /**
     * 校验验证码 不区分大小写验证
     * @params 待校验的验证码
     */
    private boolean validateCode(String checkCode) {
        checkCode = StringUtils.upperCase(checkCode)

        def sessionCode = StringUtils.upperCase(LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_CHECK_CODE))
        if (sessionCode.equals(checkCode)) {
            return true
        } else {
            return false
        }
    }
    /**
     * 跳转登录页面
     * @param
     */

    def login() {
        //处理记住用户名

        render(view: '/login/login')

    }


    /**
     * 员工登录
     * 1.密码过期或第一次登陆跳转重置密码界面
     * 2.登陆成功跳转到商户主界面
     * 3.登陆失败返回登陆界面
     * @param
     */

    def employeeLogin() {
        String url=PropertyUtils.getDefault("home_url")
        try{
            String name = params['staffName']
            String pwd = params['staffPwd']
            String remoteIp = request.getRemoteAddr()
            def ret = loginService.tenantEmployeeLogin(name, pwd, session.id, remoteIp)
            //登陆成功
            if (Constants.REST_RESULT_SUCCESS.equals(ret.result)) {//C
                    Cookie cookie = new Cookie("_USER_NAME", name)
                    cookie.setMaxAge(Integer.parseInt(PropertyUtils.getDefault("cookie_max_age")))
                    cookie.setPath("/")
                    response.addCookie(cookie)
//                if(!ret.data||ret.data.size()==0){
//                    flash.message = "此类用户无法登录后台系统，请与管理员联系!"
//                    redirect(url: PropertyUtils.getDefault("home_url"))
//                    return
//                }

            }
//            //登陆失败
            if (Constants.REST_RESULT_FAILURE.equals(ret.result)) {
                flash.message = ret.message
                redirect(url: PropertyUtils.getDefault("home_url")+"/")
                return true
            }

        }catch (Exception e){
            flash.message = e.getMessage()
            redirect(url: PropertyUtils.getDefault("home_url")+"/")
            return true
        }

        redirect(url:url+"/mainFrame/mainFrame")
    }

    /**
     * 注销当前用户
     * @return 跳转到登录页面
     */
    def logout() {
        try{
            if (LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_ID)) {
//                "/auth/logout;
                authService.logout(session.id);
//                AuthApi.logout(session.id)
            }
            if(session){
                if(session.getAttribute("saas_ssessionid")){
                    authService.logout(session.getAttribute("saas_ssessionid"));
//                    AuthApi.logout(session.getAttribute("saas_ssessionid"))
                }
            }
            //跳转到登录页面
            redirect(url: PropertyUtils.getDefault("home_url")+"/")
            return  true
        }catch (Exception e){
            LogUtil.logError("###退出错误###"+e.getMessage())
            redirect(url: PropertyUtils.getDefault("home_url")+"/")
            return  true
        }

    }

//    /**
//     * 跳转到找回密码页面
//     * @return
//     */
//    def findpass() {
//        redirect(url: PropertyUtils.getDefault("repass.url"))
//    }
//    /**
//     * 跳转到商户注册
//     * @return
//     */
//    def register() {
//
//        redirect(url: PropertyUtils.getDefault("register.url"))
//    }
//
//    /**
//     * 验证绑定手机和邮箱
//     * 通过后发送邮件或短信验证码
//     */
//    @Override
//    String toString() {
//        return super.toString()
//    }
//
//    def validatebind() {
//        String Account = params['Account']
//        def result = loginService.validateAccount(Account, session.id)
//        if(result.isSuccess){
//            if( result.jsonMap.get("employee")){
//                CacheUtils.setToSession(session.id, "_resetpass_user_id", result.jsonMap.get("employee").userId + "")
//                CacheUtils.setToSession(session.id, "_resetpass_employee_code", result.jsonMap.get("employee").code + "")
//                CacheUtils.setToSession(session.id, "_resetpass_tenant_id", result.jsonMap.get("employee").tenantId + "")
//            }
//        }
//        render result
//    }
//    /**
//     * 验证验证码
//     */
//    def openresepass() {
//        String ValidateCode = params['ValidateCode']
//        String Account = params['Account']
//        def result = loginService.validateCode(Account, ValidateCode, session.id)
//        render result
//    }
//    /**
//     * 打开重设密码页面
//     * @return
//     */
//    def resetpass() {
//        def rettenant = SaaSApi.findTenantById(Integer.parseInt(params['tenantId']))
//        def tenantCode
//        if (Constants.REST_RESULT_SUCCESS.equals(rettenant.result)) {
//            //TODO rettenant获取
//            def tenant = rettenant.data["tenant"]
//            tenantCode = tenant.code
//        } else {
//            flash.message = rettenant.message
//            render view: "login/resetpass"
//            return
//
//        }
//        render(view: "login/resetpass", model: ['tenantId': params['tenantId'], 'userId': params['userId'], 'tenantCode': tenantCode])
//    }
//    /**
//     * 打开商户信息页面
//     * @return
//     */
//    def tenantinfo() {
//        //TODO 重置密码
//        def userid = CacheUtils.getFromSession(session.id, "_resetpass_user_id")
//        def tenandId = CacheUtils.getFromSession(session.id, "_resetpass_tenant_id")
//        def tenantCode
//        def loginName = CacheUtils.getFromSession(session.id, "_resetpass_employee_code")
//        def pass = params["ReTypePassword"]
//        if (userid && tenandId) {
//            def ret = AuthApi.resetPassword(Integer.parseInt(userid), pass)
//            if (Constants.REST_RESULT_SUCCESS.equals(ret.result)) {
//                //TODO 读取商户基本信息 根据商户Id
//                def rettenant = SaaSApi.findTenantById(Integer.parseInt(tenandId))
//                if (Constants.REST_RESULT_SUCCESS.equals(rettenant.result)) {
//                    //TODO rettenant获取
//                    def tenant = rettenant.data["tenant"]
//                    tenantCode = tenant.code
//                } else {
//                    flash.message = rettenant.message
//                }
//
//            } else {
//                flash.message = "错误信息：" + ret.message
//                render view: "resetpass"
//                return
//            }
//
//        } else {
//            flash.message = "错误信息：验证超时，请重新验证!"
//            render view: "login/findpass"
//            return
//        }
//        render view: "login/tenantinfo", model: ['tenantCode': tenantCode, 'loginName': loginName, 'pass': pass]
//    }
//    /**
//     * 展示商户基础信息页面可返回登录
//     * 显示商户号、帐号、密码并发送邮件或短信
//     */
//    def opentenantinfo() {
//
//        render(['flag': true, 'message': '您的商户信息是'] as JSON)
//    }
//    /**
//     * 续费跳转到saas续费页面
//     * @return
//     */
//    def ordernew() {
//        redirect(url: PropertyUtils.getDefault("order.url")+session.id)
//    }
//    /**
//     * 跳转到saas商户订单页面
//     */
//    def myOrder(){
//        redirect(url: PropertyUtils.getDefault("myOrder.url")+session.id)
//    }
//    /**
//     * 跳转saas首页
//     */
//    def saasHome(){
//        redirect(url: PropertyUtils.getDefault("web_index"))
//    }
//    /**
//     * 跳转用户帮助文档
//     */
//    def userDoc(){
//        redirect(url:PropertyUtils.getDefault("user_doc"))
//    }
//    authService.resetPassword(params["userId"], params["oldPass"], params["newPass"])
    def resetPassword(){
        ApiRest apiRest=authService.resetPassword(params["userId"], params["oldPass"], params["newPass"])
    }
    /**
     * 跳转到修改云平台密码页面
     * @return
     */
    def showChangePwd() {
        render view: "/login/changePwd"
    }

    //跳转plan简表
    def showplan(){
        //def cid = params.carid
        render (view: "/map/planDetail")
        //render (view: "/mainFrame/planDetail",model: ['carid':carid])
        //传参数至页面
    }
    /**
     * 跳转到修改POS登录密码页面
     * @return
     */
    def showChangePosPwd() {
        render view: "/login/changePosPwd"
    }
    /**
     * 修改用户密码
     * @return
     */
    def doChangePwd() {
        ResultJSON resultJSON=new ResultJSON()

        try {
            def userId
            if (LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_ID)) {
                userId = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_ID)
            }
            String oldPass = params['oldPwd']
            String newPass = params['newPwd']
            def ApiRest = authService.resetPassword(userId, oldPass, newPass)//.changePassword(userId, oldPass, newPass)
            if (ApiRest.isSuccess) {
                resultJSON.isSuccess = true
                resultJSON.setMsg("密码修改成功!")
            } else  {
                resultJSON.isSuccess = false
                resultJSON.setMsg(ApiRest.message)
            }
//            resultJSON = employeeService.doChangePwd(userId, oldPass, newPass)

        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render resultJSON
    }
    /**
     * 修改登录密码
     */
    def doChangePOSPwd() {
        ResultJSON resultJSON=new ResultJSON()
        try {
            def userId
            if (LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_ID)) {
                userId = LightConstants.getFromSession(session.id, SessionConstants.KEY_USER_ID)
            }
            String oldPass = params['oldPwd']
            String newPass = params['newPwd']
            def ApiRest = authService.resetPassword(userId, oldPass, newPass)
            if (ApiRest.isSuccess) {
                resultJSON.isSuccess = true
                resultJSON.setMsg("app密码修改成功!")
            } else  {
                resultJSON.isSuccess = false
                resultJSON.setMsg(ApiRest.message)
            }

        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render resultJSON

    }

}
