package api.util;

import grails.core.GrailsApplication;
import grails.util.Holders;
import org.apache.commons.lang.StringUtils;

/**
 * 配置文件工具类
 * Created by lvpeng on 2015/4/27.
 */
public class ApiPropertyUtils {

    public static Map<String, String> get(String filePath) throws IOException {
        return get(new File(filePath));
    }

    public static Map<String, String> get(File propFile) throws IOException {
        return _get(propFile);
    }

    public static String get(String filePath, String key) throws IOException {
        Map<String, String> propMap = get(filePath);
        if (propMap != null) {
            return propMap.get(key);
        }
        return null;
    }

    public static String get(File propFile, String key) throws IOException {
        Map<String, String> propMap = get(propFile);
        if (propMap != null) {
            return propMap.get(key);
        }
        return null;
    }

    private static Map<String, String> _get(File propFile) throws IOException {
        FileInputStream is = null;
        if (propFile != null && propFile.exists() && propFile.isFile()) {
            is = new FileInputStream(propFile);
            Properties prop = new Properties();
            prop.load(is);
            if (!prop.isEmpty()) {
                Map<String, String> m = new HashMap<String, String>();
                for (Object o : prop.keySet()) {
                    m.put(o.toString(), prop.getProperty(o.toString()));
                }
                is.close();
                return m;
            }
        }
        if (is != null) {
            is.close();
        }
        return null;
    }

    /**
     * 获取默认配置文件所有值
     * @return
     * @throws IOException
     */
    public static Map<String, String> getDefault() throws IOException {
        return _get(getDefaultFile());
    }

    /**
     * 从默认配置文件中获取对应值
     * @param key
     * @return
     * @throws IOException
     */
    public static String getDefault(String key) throws IOException {
        Map<String, String> propMap = getDefault();
        if (propMap != null) {
            return propMap.get(key);
        }
        return null;
    }

    public static boolean put(String filePath, String key, String value) throws IOException {
        return put(new File(filePath), key, value);
    }

    public static boolean put(File propFile, String key, String value) throws IOException {
        return _put(propFile, key, value);
    }

    private static boolean _put(File propFile, String key, String value) throws IOException {
        if (propFile != null && propFile.exists() && propFile.isFile()) {
            Properties prop = new Properties();
            FileInputStream is = new FileInputStream(propFile);
            prop.load(is);
            prop.setProperty(key, value);
            FileOutputStream os = new FileOutputStream(propFile);
            prop.store(os, null);
            is.close();
            os.flush();
            os.close();
            return true;
        }
        return false;
    }

    private static File getDefaultFile() throws IOException {
        GrailsApplication application = Holders.getGrailsApplication();
        String properties = null;
        if (application != null && application.getConfig() != null) {
            properties = application.getConfig().getProperty("properties");
        }
        File defaultFile = null;
        if  (StringUtils.isNotEmpty(properties)) {
            defaultFile = application.getParentContext().getResource("WEB-INF/classes/" + properties).getFile();
            if (defaultFile == null || !defaultFile.exists() || !defaultFile.isFile()) {
                defaultFile = new File(System.getProperty("user.dir") + "/grails-app/conf/" + properties);
            }
        }
        if (defaultFile != null && defaultFile.exists() && defaultFile.isFile()) {
            return defaultFile;
        }
        return null;
    }

    /**
     * 保存键值对到默认配置文件中
     * @param key
     * @param value
     * @return
     * @throws IOException
     */
    public static boolean putDefault(String key, String value) throws IOException {
        return _put(getDefaultFile(), key, value);
    }

}
