package api

import api.common.ApiConfig
import api.common.ApiRest
import api.util.ApiBaseServiceUtils

/**
 * Created by lvpeng on 2015/10/24.
 */
class MapApi extends ApiBaseServiceUtils {

    public static ApiRest baiduCalculateDistance(String origin, String destination) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("origin", origin);
        m.put("destination", destination);
        return restGet(ApiConfig.MAP_BAIDU_CALCULATE_DISTANCE_URL, m);
    }

    public static ApiRest baiduCalculateDistance(String[] origin, String[] destination) {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < origin.length; i++) {
            if (i != 0) {
                buffer.append("###");
            }
            buffer.append(origin[i]);
        }
        String originStr = buffer.toString();

        buffer = new StringBuffer();
        for (int i = 0; i < destination.length; i++) {
            if (i != 0) {
                buffer.append("###");
            }
            buffer.append(destination[i]);
        }
        String destinationStr = buffer.toString();

        return baiduCalculateDistance(originStr, destinationStr);
    }

    public static ApiRest baiduConverCoord(String lat, String lng) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("lat", lat);
        m.put("lng", lng);
        return restGet(ApiConfig.MAP_BAIDU_CONVER_COORD_URL, m);
    }

    public static ApiRest baiduConverCoord(String coord) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("coord", coord);
        return restGet(ApiConfig.MAP_BAIDU_CONVER_COORD_URL, m);
    }
}
