package api.common;

/**
 * Created by lvpeng on 2015/4/20.
 */
public class ApiConstants {

    private static final String HTTP_HEAD = "http://";
    private static final String HTTPS_HEAD = "https://";

    public static final String CHARSET_UTF8 = "UTF-8";
    public static final String CHARSET_GBK = "GBK";

    public static final String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

    public static final String FORMAT_JSON = "json";
    public static final String FORMAT_XML = "xml";

    public static final Integer USER_TYPE_GENERAL = 0;
    public static final Integer USER_TYPE_TENANT = 1;
    public static final Integer USER_TYPE_AGENT = 2;
    public static final Integer USER_TYPE_TENANT_EMPLOYEE = 3;
    public static final Integer USER_TYPE_OPERATION = 4;
    public static final Integer USER_TYPE_TENANT_HZG = 7;
    public static final Integer USER_TYPE_EMPLOYEE_HZG = 8;

    public static final Integer USER_STATE_UNACTIVATED = 0;
    public static final Integer USER_STATE_ENABLED = 1;
    public static final Integer USER_STATE_DISABLED = 2;

    public static final String REST_RESULT_SUCCESS = "SUCCESS";
    public static final String REST_RESULT_FAILURE = "FAILURE";
    public static final String REST_RESULT_RESET = "RESET";

    public static final String SECURITY_DEFAULT_PASSWORD = "0";
    public static final String SECURITY_GRANTED_AUTHORITY = "SECURITY_GRANTED_AUTHORITY";

    public static final String TENANT_EMPLOYEE_SEPARATOR = ":";

    public static final String USER_BIND_TYPE_EMAIL = "email";
    public static final String USER_BIND_TYPE_QQ = "qq";
    public static final String USER_BIND_TYPE_MOBILE = "mobile";
    public static final String USER_BIND_TYPE_WECHAT = "wechat";
    public static final String QQ_EMAIL_SUFFIX = "@qq.com";

    public static final String ROLE_COLE_ADMIN = "01";
    public static final String ROLE_COLE_CASHIER = "02";

}
