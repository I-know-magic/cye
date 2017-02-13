package api.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Json工具类
 * Created by lvpeng on 2015/4/24.
 */
public class ApiJsonUtils {

    /**
     * json 字符串转 Map
     * @param jsonStr
     * @return
     */
    public static Map<String, String> json2Map(String jsonStr) {
        return json2Map(str2Json(jsonStr));
    }

    /**
     * JSONObject 对象转 Map
     * @param json
     * @return
     */
    public static Map<String, String> json2Map(JSONObject json) {
        Map<String, String> map = (Map<String, String>)JSONObject.toBean(json, LinkedHashMap.class);
        return map;
    }

    /**
     * json 字符串转 JSONObject
     * @param jsonStr
     * @return
     */
    public static JSONObject str2Json(String jsonStr) {
        return JSONObject.fromObject(jsonStr);
    }

    /**
     * json 字符串转 List
     * @param jsonStr
     * @return
     */
    public static List<String> json2List(String jsonStr) {
        return json2List(str2JsonArr(jsonStr));
    }

    /**
     * JSONArray 对象转 List
     * @param json
     * @return
     */
    public static List<String> json2List(JSONArray json) {
        List<String> list = new ArrayList<String>();
        list.addAll(JSONArray.toCollection(json));
        return list;
    }

    /**
     * List 转 json 字符串
     * @param list
     * @return
     */
    public  static String list2json(List<String> list) {
        return JSONArray.fromObject(list).toString();
    }

    /**
     * json 字符串转 JSONArray
     * @param jsonStr
     * @return
     */
    public static JSONArray str2JsonArr(String jsonStr) {
        return JSONArray.fromObject(jsonStr);
    }
}
