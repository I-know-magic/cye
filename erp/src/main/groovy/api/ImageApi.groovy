package api

import api.common.ApiRest
import api.util.ApiBaseServiceUtils

/**
 * Created by lvpeng on 2015/10/14.
 */
class ImageApi extends ApiBaseServiceUtils {

    public static ApiRest send(String savePath, String absolutePath) {
        Map<String,String> m = new HashMap<String,String>();
        m.put("absolutePath", absolutePath);
        m.put("savePath", savePath);
        return restGet("http://localhost:9999/image/send", m);
    }

}
