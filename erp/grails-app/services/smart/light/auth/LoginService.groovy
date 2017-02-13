package smart.light.auth

import api.AuthApi
import api.common.ApiRest
import com.smart.common.Constants
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils


@Transactional
class LoginService extends BaseServiceImpl{
    AuthService authService;
    /**
     * 商户员工登录认证
     * 如果tenantCode、staffName与staffPwd其一为null或空，不调用登陆服务
     * @param tenantCode 商户ID
     * @param staffName 员工用户名
     * @param staffPwd 员工密码
     * @param sessionId
     * @param ip
     * @return
     */

    public ApiRest tenantEmployeeLogin(final String staffName, final String staffPwd, final String sessionId, String ip) {
        String name = StringUtils.trimToEmpty(staffName);
//        String pwd = StringUtils.trimToEmpty(staffPwd);
        String sid = StringUtils.trimToEmpty(sessionId);
        def ret = null;
        if (name && staffPwd && sid) {
            try {
                ret = new ApiRest();
                ret.result = Constants.REST_RESULT_SUCCESS;
                ret.message = '登录成功';
//                ret = AuthApi.generalLogin(name, staffPwd, ip, sid)
//                String loginName, String loginPass, String userType, String ip, String sessionId, String tenantCode
                ret = authService.login(staffName,staffPwd,null,ip,sessionId,null)
//                def userType = RedisClusterUtils.getFromSession(sessionId, SessionConstants.KEY_USER_TYPE)
                def userType = LightConstants.getFromSession(sessionId, SessionConstants.KEY_USER_TYPE)
                if(userType && userType=="3"){
                    ret.result = Constants.REST_RESULT_FAILURE;
                    ret.message = 'app用户无法登录后台系统！';

                }
            } catch (Exception ie) {
                ret = new ApiRest();
                ret.result = Constants.REST_RESULT_FAILURE;
                ret.message = '登陆认证服务暂停';
                LogUtil.logError('AuthApi.agentLogin服务异常:' + ie.message);
            }
        } else {
            ret = new ApiRest();
            ret.result = Constants.REST_RESULT_FAILURE
            ret.message = '用户名或密码错误'
        }
        return ret;

    }

}
