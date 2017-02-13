package com.smart.common.util

import net.sf.json.JSONArray

/**
 * Created by lvpeng on 16/4/22.
 */
class JSONUtils {
    /**
     * JSONArray 转为对象集合
     * @param json
     * @param clazz
     * @return
     */
    public static JsonToListClass(String json,Class clazz){
        JSONArray jsonarray = JSONArray.fromObject(json);
        List list = (List)JSONArray.toCollection(jsonarray, clazz);
        return list;
    }
}
