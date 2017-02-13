package api.util

//import common.security.SaasFilterInvocationSecurityMetadataSource
import org.apache.commons.lang.StringUtils
import org.grails.web.util.WebUtils
import org.slf4j.Logger
import org.slf4j.LoggerFactory;
//import org.springframework.security.authentication.AuthenticationManager;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder
//import org.springframework.security.core.session.SessionRegistry;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.context.support.WebApplicationObjectSupport;
import api.common.ApiConstants;
import api.common.ApiRest

/**
 * 授权工具类，用于用户登陆后的授权。
 * Created by lvpeng on 2015/5/12.
 */
public class ApiWebSecurityUtils extends WebApplicationObjectSupport {
    private static Logger log = LoggerFactory.getLogger(ApiWebSecurityUtils.class);
    /**
     * 授权方法：登录成功后角色权限交由spring-secutity管理
     * @param loginName 登录名
     * @param authorities 权限集合
     * @return
     */
    public static ApiRest Auth(String loginName, Collection<String> authorities) {
        String sessionId = null;
        try {
            sessionId = RequestContextHolder.currentRequestAttributes().getSessionId()
        } catch (Exception e) {
            log.error("登录授权获取当前session失败", e);
        }
        return Auth(loginName, authorities, sessionId);
    }

    /**
     * 授权方法：登录成功后角色权限交由spring-secutity管理
     * @param loginName 登录名
     * @param authorities 权限集合
     * @param sessionId Session Id
     * @return
     */
    public static ApiRest Auth(String loginName, Collection<String> authorities, String sessionId) {
        ApiRest r = new ApiRest();
//        try {
//            AuthenticationManager authenticationManager = (AuthenticationManager) WebApplicationContextUtils.getRequiredWebApplicationContext(WebUtils.retrieveGrailsWebRequest().getServletContext()).getBean("authenticationManager");
//            RequestContextHolder.currentRequestAttributes().setAttribute(ApiConstants.SECURITY_GRANTED_AUTHORITY, authorities, RequestAttributes.SCOPE_SESSION);
//            UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(loginName, ApiConstants.SECURITY_DEFAULT_PASSWORD);
//            Authentication authentication = authenticationManager.authenticate(token);
//            SecurityContextHolder.getContext().setAuthentication(authentication);
//            SessionRegistry sessionRegistry = null;
//            try {
//                sessionRegistry = (SessionRegistry) WebApplicationContextUtils.getRequiredWebApplicationContext(WebUtils.retrieveGrailsWebRequest().getServletContext()).getBean("sessionRegistry");
//            } catch (Exception e) {}
//            if (sessionRegistry != null && sessionId != null) {
//                sessionRegistry.registerNewSession(sessionId, authentication.getPrincipal());
//            }
//            r.setResult(ApiConstants.REST_RESULT_SUCCESS);
//            r.setMessage("授权成功");
//        } catch (Exception e) {
//            log.error("登录授权失败", e);
//            r.setResult(ApiConstants.REST_RESULT_FAILURE);
//            r.setMessage("授权失败");
//            r.setError(e.getMessage() != null ? e.getMessage() : (String)RequestContextHolder.currentRequestAttributes().getAttribute("exception",RequestAttributes.SCOPE_SESSION));
//        }
        return r;
    }

    /**
     * 加载权限
     * @param tenantId 商户id
     * @return
     */
    public static boolean loadResource(String tenantId) {
        boolean f = false;
        try {
//            f = SaasFilterInvocationSecurityMetadataSource.loadResource(tenantId);
        } catch (Exception e) {
            log.error("ApiWebSecurityUtils.loadResource(${tenantId})", e);
        }
        return f;
    }

    /**
     * 加载权限
     * @return
     */
    public static boolean loadResource() {
        boolean f = false;
        try {
//            f = SaasFilterInvocationSecurityMetadataSource.loadResource();
        } catch (Exception e) {
            log.error("ApiWebSecurityUtils.loadResource()", e);
        }
        return f;
    }

    static boolean loadResource(ApiRest rest, String tenantId) {
        try {
            if (rest != null && rest.isSuccess) {
                if (StringUtils.isEmpty(tenantId)) {
                    return loadResource();
                } else {
                    return loadResource(tenantId);
                }
            }
        } catch (Exception e) {
            log.error("ApiWebSecurityUtils.loadResource(${rest.toString()}, ${tenantId})", e);
        }
        return false;
    }

}
