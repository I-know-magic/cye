package api

import api.common.ApiConfig
import api.util.ApiBaseServiceUtils
import api.common.ApiRest

/**
 * 邮件功能类
 * Created by liuhongbin1 on 2015/6/30.
 */
class MailApi extends ApiBaseServiceUtils {

    /**
     * 发送邮件
     * @param subject 邮件主题
     * @param content 邮件内容
     * @param mailTo 收件地址
     * @return ApiRest
     */
    public static ApiRest sendMail(String subject, String content, String mailTo) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("send", "1");
        m.put("subject", subject);
        m.put("content", content);
        m.put("mailTo", mailTo);
        return restGet(ApiConfig.MAIL_URL, m);
    }

    /**
     * 发送绑定邮箱的验证邮件
     * @param mailAddress 验证邮件接收地址
     * @param url 验证链接地址
     * @param hours 验证信息有效期，仅做邮件内容显示用
     * @return ApiRest
     */
    public static ApiRest sendBindMail(String mailAddress, String url, Integer hours) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("sendBindMail", "1");
        m.put("mailTo", mailAddress);
        m.put("url", url);
        m.put("hours", hours.toString());
        return restGet(ApiConfig.MAIL_URL, m);
    }

    /**
     * 发送绑定QQ的验证邮件
     * @param mailAddress 验证邮件接收地址
     * @param url 验证链接地址
     * @param hours 验证信息有效期，仅做邮件内容显示用
     * @return ApiRest
     */
    public static ApiRest sendBindQQ(String mailAddress, String url, Integer hours) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("sendBindQQ", "1");
        m.put("mailTo", mailAddress);
        m.put("url", url);
        m.put("hours", hours.toString());
        return restGet(ApiConfig.MAIL_URL, m);
    }

}
