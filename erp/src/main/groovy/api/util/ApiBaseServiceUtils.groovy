package api.util

import grails.util.GrailsNameUtils
import grails.util.Holders
import org.apache.tools.ant.util.DateUtils
import org.grails.web.json.JSONObject
import org.springframework.util.ReflectionUtils
import api.common.ApiRest

import java.lang.reflect.Field
import java.text.SimpleDateFormat

/**
 * 服务接口功能类的基类
 * Created by liuhongbin1 on 2015/6/24.
 */
class ApiBaseServiceUtils {

    protected static String getValidClass(String className) {
        try {
            Class.forName(className)
            return className
        } catch (Exception e) {
            String shortName = GrailsNameUtils.getShortName(className)
            String ret = className
            Holders.findApplication().allClasses.each {
                if(shortName.equals(GrailsNameUtils.getShortName(it))) {
                    ret = it.name
                }
            }
            return ret
        }
    }

    //TODO jsonToObject应该移到JSONUtils类中，目前所使用的JSON类不兼容
    /**
     * 将JSON字符串转换为指定类型的对象
     * @param json
     * @param clazz
     * @return
     */
    public static Object jsonToObject(String json, Class<?> clazz) {
        JSONObject jsonObject = new JSONObject(json)
        jsonObject.keys().each {
            Object obj = jsonObject.get(it)
            if(obj instanceof JSONObject) {
                if (obj.containsKey("class")) {
                    String cls = getValidClass(obj.get("class"))
                    jsonObject.put(it, jsonToObject(obj.toString(), Class.forName(cls)))
                }
            }
        }

        Object ret = clazz.newInstance()
        Field[] fields = clazz.getDeclaredFields()
        fields.each {
            if(jsonObject.containsKey(it.name) && !jsonObject.isNull(it.name)) {
                Object value = jsonObject.get(it.name);
                switch (it.type) {
                    case Class:
                        value = Class.forName(value.toString())
                        break
                    case BigInteger:
                        value = BigInteger.valueOf(Long.valueOf(value))
                        break
                    case BigDecimal:
                        value = BigDecimal.valueOf(value)
                        break
                    case Date:
                        if(value.toString().contains('T')) {
                            value = DateUtils.parseIso8601DateTime(value)
                        } else {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                            value = sdf.parse(value);
                        }

                        break
                    case Set:
                        return
                }
                ReflectionUtils.makeAccessible(it)
                ReflectionUtils.setField(it, ret, value)
            }
        }
        return ret
    }

    /**
     * 将传入的Rest对象中的Domain转换成指定类型，支持单个Domain和ArrayList
     * @param rest
     * @param clazz
     * @return
     */
    public static boolean parseRestData(ApiRest rest, Class<?> clazz) {
        if(rest.clazz.equals(clazz)) {
            rest.data = jsonToObject(rest.data.toString(), clazz)
        } else if(rest.clazz.equals(ArrayList)) {
            List<Object> list = rest.data
            for(int i = 0; i < list.size(); i++) {
                list[i] = jsonToObject(list[i].toString(), clazz)
            }
            rest.data = list
        } else {
            return false
        }
        return true
    }

    /**
     * 将传入的Rest对象中的Domain转换成指定类型，支持Map，需指定map中每一项的类型
     * @param rest
     * @param map
     * @return
     */
    public static boolean parseRestData(ApiRest rest, Map<String, Class<?>> map) {
        Map dataMap = rest.data
        map.each {
            if(dataMap.containsKey(it.key)) {
                dataMap.put(it.key, jsonToObject(dataMap.get(it.key).toString(), it.value))
            }
        }
        rest.data = dataMap
        return true
    }

    /**
     * JSON字符串转换成Rest对象
     * @param json
     * @return
     */
    protected static ApiRest parseRest(String json) {
        ApiRest rest;
        try {
            rest = jsonToObject(json, ApiRest)
        } catch (Exception e) {
            rest = new ApiRest(json);
        }
        return rest
    }

    /**
     * 实现GET调用服务的公共方法
     * @param url
     * @param params
     * @return
     */
    protected static ApiRest restGet(String url, Map<String, String> params) {
        String r = ApiWebUtils.doGet(url, params);
        return parseRest(r);
    }

    /**
     * 实现POST调用服务的公共方法
     * @param url
     * @param params
     * @return
     */
    protected static ApiRest restPost(String url, Map<String, String> params) {
        String r = ApiWebUtils.doPost(url, params, 0, 0);
        return parseRest(r);
    }
}
