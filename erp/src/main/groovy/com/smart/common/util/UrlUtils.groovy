package com.smart.common.util

/**
 *
 * hexiaohong on 2015/11/3.
 */
class UrlUtils {
    /**
     * 解析ControllerAndAction
     * @param url
     * @return
     */
    public static String resolveControllerAndAction(String url){
        if (url == null){
            return null;
        }
        int markIndex = url.indexOf("?")
        if (markIndex != -1){
            url = url.substring(0,markIndex)
        }
        def items = url.split("/")
        String targetUrl = ""
        if (items.length >= 2){
            String controllerName = items[items.length-2] == "" ? "": "/" + items[items.length-2]
            String actionName = items[items.length-1] == "" ? "": "/" + items[items.length-1]
            targetUrl = controllerName + actionName
        }
        return targetUrl
    }
}
