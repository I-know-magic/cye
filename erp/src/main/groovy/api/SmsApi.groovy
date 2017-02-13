package api

import api.common.ApiConfig
import api.util.ApiBaseServiceUtils
import api.common.ApiRest

/**
 * 短信功能类
 * Created by liuhongbin1 on 2015/6/15.
 */
public class SmsApi extends ApiBaseServiceUtils {
    /**
     * 发送短信
     * @param number 短信接收号码，支持群发，多个号码以英文（,）间隔
     * @param content 短信内容
     * @return ApiRest
     */
    public static ApiRest SmsSend(String number, String content) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("number", number);
        m.put("content", content);
        return restGet(ApiConfig.SMS_SEND_URL, m);
    }

    /**
     * 查询短信发送回执
     * @return 成功或失败
     */
    public static Boolean SmsReport() {
        ApiRest rest = restGet(ApiConfig.SMS_REPORT_URL, null);
        if(rest.getIsSuccess()) {
            return true;
        } else {
            throw new Exception(rest.getMessage());
        }
    }

    /**
     * 获取短信剩余条数
     * @return 成功返回条数，失败返回-1
     */
    public static Integer SmsRemain() {
        ApiRest rest = restGet(ApiConfig.SMS_REMAIN_URL, null);
        if(rest.getIsSuccess()) {
            return Integer.parseInt(rest.getData().toString());
        } else {
            throw new Exception(rest.getMessage());
        }
    }

    /**
     * 发送短信验证码
     * @param number 电话号码
     * @param sessionId Session Id
     * @return ApiRest
     */
    public static ApiRest SmsSendAuthCode(String number, String sessionId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("number", number);
        m.put("sessionId", sessionId);
        return restGet(ApiConfig.SMS_SEND_AUTH_CODE_URL, m);
    }

    /**
     * 验证短信验证码，验证码只在指定的session内有效
     * @param number 电话号码
     * @param code 验证码
     * @param sessionId Session Id
     * @return ApiRest
     */
    public static ApiRest SmsVerifyAuthCode(String number, String code, String sessionId) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("number", number);
        m.put("code", code);
        m.put("sessionId", sessionId);
        return restGet(ApiConfig.SMS_VERIFY_AUTH_CODE_URL, m);
    }

    /**
     * 用于代理商审核通过后，发送帐号信息
     * @param number 接收帐号信息的手机号
     * @param account 帐号
     * @param password 密码（明文）
     * @return ApiRest
     */
    public static ApiRest SmsSendAgentAccount(String number, String account, String password) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("number", number);
        m.put("account", account);
        m.put("password", password);
        return restGet(ApiConfig.SMS_SEND_AGENT_ACCOUNT_URL, m);
    }

    /**
     * 用于重置密码后，发送新的随机密码
     * @param number 接收帐号信息的手机号
     * @param password 密码（明文）
     * @return ApiRest
     */
    public static ApiRest SmsSendResetPassword(String number, String password) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("number", number);
        m.put("password", password);
        return restGet(ApiConfig.SMS_SEND_RESET_PASSWORD_URL, m);
    }

    /**
     * 根据模板发送短信
     * @param number
     * @param template
     * @param content
     * @return
     */
    public static ApiRest sendByTemplate(String number, String template, String[] content) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("number", number);
        m.put("template", template);
        StringBuffer buffer = new StringBuffer();
        if (content != null) {
            for (int i = 0; i < content.length; i++) {
                if (i != 0) {
                    buffer.append("###");
                }
                buffer.append(content[i]);
            }
        }
        m.put("content", buffer.toString());
        return restGet(ApiConfig.SMS_SEND_TEMPLATE_URL, m);
    }

}
