package api.common;

import net.sf.json.JSONArray;
import net.sf.json.JSONNull;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils

/**
 * Created by lvpeng on 2015/5/6.
 * Rest接口返回结果封装对象
 */
public class ApiRest {

    /**
     * 只能通过GET提交信息
     */
    public static final ApiRest REST_GET_ERROR = new ApiRest(false, "只能通过GET提交信息");
    /**
     * 只能通过POST提交信息
     */
    public static final ApiRest REST_POST_ERROR = new ApiRest(false, "只能通过POST提交信息");
    /**
     * 未定义的异常信息
     */
    public static final ApiRest UNKNOWN_ERROR = new ApiRest(false, "未定义的异常信息");
    /**
     * 参数无效
     */
    public static final ApiRest INVALID_PARAMS_ERROR = new ApiRest(false, "参数无效");

    private String result;
    private String message;
    private String error;
    private Object data;
    private Class clazz;
    private String code = "0";
    private String url;

    public ApiRest() {

    }

    public ApiRest(Boolean isSuccess, String message) {
        this(isSuccess, message, null);
    }

    public ApiRest(Boolean isSuccess, String message, String error) {
        this(isSuccess, message, error, null);
    }

    public ApiRest(Boolean isSuccess, String message, String error, String url) {
        this(isSuccess, message, error, url, null);
    }

    public ApiRest(Boolean isSuccess, String message, String error, String, Object data) {
        this.result = isSuccess ? ApiConstants.REST_RESULT_SUCCESS : ApiConstants.REST_RESULT_FAILURE;
        this.message = message;
        this.error = error;
        this.url = url;
        this.data = data;
    }

    public ApiRest(Map<String, String> map) throws ClassNotFoundException {
        jsonNull2Null(map);
        this.result = map.get("result");
        this.message = map.get("message");
        this.error = map.get("error");
        this.data = map.get("data");
        this.clazz = map.get("clazz") != null ? Class.forName(map.get("clazz")) : null;
        if (map.get("code") != null) {
            this.code = map.get("code");
        }
        this.url = map.get("url");
    }

    public ApiRest(String result, String message, String error, Object data, Class clazz) {
        this.result = result;
        this.message = message;
        this.error = error;
        this.data = data;
        this.clazz = clazz;
    }

    public ApiRest(String result, String message, String error, Object data) {
        this.result = result;
        this.message = message;
        this.error = error;
        this.data = data;
    }

    public ApiRest(String result, String message, String error) {
        this.result = result;
        this.message = message;
        this.error = error;
    }

    public ApiRest(String result, String message) {
        this.result = result;
        this.message = message;
    }

    public ApiRest(String json) {
        JSONObject jsonObj = JSONObject.fromObject(json);
        this.result = jsonObj.get("result") instanceof JSONNull ? null : (String)jsonObj.get("result");
        this.message = jsonObj.get("message") instanceof JSONNull ? null : (String)jsonObj.get("message");
        this.error = jsonObj.get("error") instanceof  JSONNull ? null : (String)jsonObj.get("error");
        this.url = jsonObj.get("url") instanceof  JSONNull ? null : (String)jsonObj.get("url");
        Object data = jsonObj.get("data");
        if (data != null && data instanceof JSONObject) {
            this.data = toMap((JSONObject) data);
        } else if (data != null && data instanceof JSONArray) {
            this.data = toList((JSONArray) data);
        } else if (data instanceof JSONNull) {
            this.data = null;
        } else {
            this.data = data;
        }
        this.clazz = data != null ? data.getClass() : null;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Class getClazz() {
        return clazz;
    }

    public void setClazz(Class clazz) {
        this.clazz = clazz;
    }

    String getCode() {
        return code
    }

    void setCode(String code) {
        this.code = code
    }

    public void setIsSuccess(Boolean isSuccess) {
        this.result = isSuccess ? ApiConstants.REST_RESULT_SUCCESS : ApiConstants.REST_RESULT_FAILURE;
    }

    public Boolean getIsSuccess() {
        return this.result.equals(ApiConstants.REST_RESULT_SUCCESS);
    }

    String getUrl() {
        return url
    }

    void setUrl(String url) {
        this.url = url
    }

    /**
     * 将 JSONNull 转换为 null
     * @param map
     */
    private void jsonNull2Null(Map<String, String> map) {
        for (String k : map.keySet()) {
            if ((Object) map.get(k) instanceof JSONNull) {
                map.put(k, null);
            }
        }
    }

    /**
     * JSONObject 对象转 Map
     * @param mapJson
     * @return
     */
    protected static Map<String, Object> toMap(JSONObject mapJson) {
        Map<String, Object> map = new LinkedHashMap<String, Object>();
        for (Object key : mapJson.keySet()) {
            Object value = mapJson.get(key);
            if (value instanceof JSONObject) {
                map.put(key.toString(), toMap((JSONObject)value));
            } else if (value instanceof JSONArray) {
                map.put(key.toString(), toList((JSONArray) value));
            } else if (value instanceof JSONNull) {
                map.put(key.toString(), null);
            } else {
                map.put(key.toString(), value);
            }
        }
        return map;
    }

    /**
     * JSONArray 对象转 List
     * @param arrayJson
     * @return
     */
    protected static List<Object> toList(JSONArray arrayJson) {
        List<Object> list = new ArrayList<Object>();
        for (Object value : arrayJson) {
            if (value instanceof JSONObject) {
                list.add(toMap((JSONObject)value));
            } else if (value instanceof JSONArray) {
                list.add(toList((JSONArray) value));
            } else if (!(value instanceof JSONNull)) {
                list.add(value);
            }
        }
        return list;
    }

    /**
     * json 字符串转 Map
     * @param mapJson
     * @return
     */
    public static Map<String, Object> toMap(String mapJson) {
        if (StringUtils.isEmpty(mapJson)) {
            return null;
        }
        JSONObject jsonObject = JSONObject.fromObject(mapJson);
        return toMap(jsonObject);
    }

    /**
     * json 字符串转 List
     * @param arrayJson
     * @return
     */
    public static List<Object> toList(String arrayJson) {
        if (StringUtils.isEmpty(arrayJson)) {
            return null;
        }
        JSONArray jsonArray = JSONArray.fromObject(arrayJson);
        return toList(jsonArray);
    }


    @Override
    public String toString() {
        return "ApiRest{" +
                "result='" + result + '\'' +
                ", message='" + message + '\'' +
                ", error='" + error + '\'' +
                ", data=" + data +
                ", clazz=" + clazz +
                ", code='" + code + '\'' +
                ", url='" + url + '\'' +
                '}';
    }

    public String toJson() {
        return JSONObject.fromObject(this).toString();
    }
}
