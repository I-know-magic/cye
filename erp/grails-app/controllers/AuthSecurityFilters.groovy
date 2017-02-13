import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.util.LogUtil
import com.smart.common.util.PropertyUtils
import com.smart.common.util.UrlUtils
import org.apache.commons.lang.StringUtils
import org.grails.web.errors.GrailsExceptionResolver


import javax.servlet.http.HttpSession

class AuthSecurityFilters {

    def GrailsExceptionResolver grailsExceptionResolver
    def filters = {
        authSecurity(controller: '*', action: '*') {
            before = {
//                HttpSession session = request.getSession();
//                LogUtil.logInfo("####### request 内容: ${request.getRequestURI()}")
////                System.out.println("####### request 内容: ${request.getRequestURI()}")
//                String uri = UrlUtils.resolveControllerAndAction(request.getRequestURI())
//                LogUtil.logInfo("####### uri 内容: ${uri}")
//                if (
//                        uri == "" ||
//                        uri == "/erp" ||
//                        uri == "/storeAccount/save" ||
//                        uri.contains("/error") ||
//                        uri.contains("/login") ||
//                        uri.contains("/mainFrame") ||
//                        uri.contains("/home") ||
//                        uri.contains("/storeAccount") ||
////                        uri == "/district/qryDistrictByPid" ||
//                        uri.contains("WebService")
//                ) {
//                    System.out.println("#########: uri="+uri)
//                    System.out.println("#########: true")
//
//                    return true
//                }
//                try{
//                    if (RedisClusterUtils.getFromSession(session.id).size() == 0) {
//                        redirect(controller: "error",action: "index")
//                        System.out.println("#########: uri-false="+uri)
//                        System.out.println("#########: false")
//                        return false
//                    }
//                }catch (Exception e){
//                    LogUtil.logError("AuthSecurityFilters-erroe",e.getMessage())
//                }

                return true;
            }
            after = {

            }
            afterView = {

            }
        }
    }
}
