package com.smart.common.util;

import com.smart.common.Redis.RedisClusterUtils;
import org.apache.catalina.Session;
import org.apache.commons.collections.map.HashedMap;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.http.HttpSession;
import java.io.ByteArrayOutputStream;
import java.lang.reflect.Field;
import java.math.BigInteger;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lvpeng on 16/4/12.
 */
public class LightConstants {
    public static String USER_BIND_TYPE_EMAIL = "_bind_email";
    public static String USER_BIND_TYPE_QQ = "_bind_qq";
    public static String USER_BIND_TYPE_MOBILE = "_bind_mobile";
    public static String USER_BIND_TYPE_WECHAT = "_bind_wechat";
    public static String CACHE_BIND_PREFIX = "_bind_prefix";
    public static String DIRVER_TYPE = "dirver_type";
    public static String DIRVER_PROCODE = "dirver_procode";
    public static String KEY_JOB_TYPE = "job_type";
    public static String KEY_SMART_LIGHT_MSA = "smart_light_msa";
    public static String KEY_SMART_LIGHT_PASS = "smart_light_pass";
    public static String KEY_SMART_LIGHT_MSG_TYPE = "smart_light_msg_type";
    public static String KEY_SMART_LIGHT_TIMEOUT = "smart_light_timeout";
    public static String KEY_SMART_LIGHT_SOCKET_CLASS = "smart_light_socket_class";
    public static String KEY_SMART_LIGHT_MAX_TRY_TIME = "smart_light_max_try_time";
    public static String KEY_SMART_LIGHT_FLAG_TEST = "smart_light_socket_flag_test";
    public static String KEY_SMART_LIGHT_SOCKET_URL = "smart_light_socket_url";

    private static Map<String,Map<String,String>> reidsMap=new HashMap<String,Map<String,String>>();
    private static Map<String,String> smap=new HashMap<String,String>();
//    HttpSession session=request.getSession();
    public static String KEY_TER_DEVICE_DATA = "_key_ter_device_data_";
    private static String hexStr = "0123456789ABCDEF";
    private static String[] binaryArray =
            {"0000", "0001", "0010", "0011",
                    "0100", "0101", "0110", "0111",
                    "1000", "1001", "1010", "1011",
                    "1100", "1101", "1110", "1111"};

    public static void createFiledValue(Class t) {

    }

    public static void updateFiledValue(Class t) {

    }

    public static void setReidsMap(String key ,Map value){
        reidsMap.put(key,value);
    }
    public static Map getReidsMap(String key){
        return reidsMap.get(key);
    }
    public static void setSMap(String key ,String value){
        smap.put(key,value);
    }
    public static String getSMap(String key){
        return smap.get(key);
    }
    public static String setToSession(String sessionId, String key, String value){
        setSMap(key,value);
        setReidsMap(sessionId,smap);
        return null;
    }
    public static String setToSession(String sessionId, Map<String,String> map) {
        setReidsMap(sessionId,map);
        return null;
    }
    public static String getFromSession(String sid,String key){
        smap=getReidsMap(sid);
        return getSMap(key);
    }
    public static String querySid(){
        String sid=RequestContextHolder.currentRequestAttributes().getSessionId();
        return sid;
    }
    public static BigInteger getBranchId(){
        String sid=querySid();
//        return new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_BRANCH_ID));
        return new BigInteger(getFromSession(sid, SessionConstants.KEY_BRANCH_ID));
    }
    public static BigInteger getTenantId(){
        String sid=querySid();
//        return new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_TENANT_ID));
        return new BigInteger(getFromSession(sid, SessionConstants.KEY_TENANT_ID));
    }
    public static BigInteger getUserId(){
        String sid=querySid();
//        return new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_USER_ID));
        return new BigInteger(getFromSession(sid, SessionConstants.KEY_USER_ID));
    }
    public static String getUserName(){
        String sid=querySid();
//        return RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_USER_NAME);
        return getFromSession(sid, SessionConstants.KEY_USER_NAME);
    }

    public static void setFiledValue(Class<?> t, boolean isUpdate,Object obj) {
        try {
                String sid=querySid();
                Field ftid=t.getDeclaredField("tenantId");
                ReflectionUtils.makeAccessible(ftid);
//                ftid.set(obj,new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_TENANT_ID)));
                ftid.set(obj,new BigInteger(getFromSession(sid, SessionConstants.KEY_TENANT_ID)));
                if(isUpdate){
                    Field fupat=t.getDeclaredField("lastUpdateAt");
                    Field fupby=t.getDeclaredField("lastUpdateBy");
                    ReflectionUtils.makeAccessible(fupat);
                    ReflectionUtils.makeAccessible(fupby);
                    fupat.set(obj,new Date());
//                    fupby.set(obj,RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_USER_NAME));
                    fupby.set(obj,getFromSession(sid, SessionConstants.KEY_USER_NAME));
                }else{
                    Field fcat=t.getDeclaredField("createAt");
                    Field fcby=t.getDeclaredField("createBy");
                    ReflectionUtils.makeAccessible(fcat);
                    ReflectionUtils.makeAccessible(fcby);
                    fcat.set(obj,new Date());
//                    fcby.set(obj,RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_USER_NAME));
                    fcby.set(obj,getFromSession(sid, SessionConstants.KEY_USER_NAME));
                }
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

    }

    /**
     * 获取当前登录用户的部门id
     * session中获取
     *
     * @return
     */
    public static BigInteger loginDeptId() {
        return new BigInteger("1");
    }

    /**
     * 转换为string并按照4位分割
     * @param stringList
     * @return
     */
    public static String listToString(List<String> stringList) {
        if (stringList == null) {
            return null;
        }
        StringBuilder result = new StringBuilder();
        boolean flag = false;
        for (int i = stringList.size() - 1; i >= 0; i--) {
            result.append(stringList.get(i));
            if (i != 0 && i % 4 == 0) {
                result.append("-");
            }
        }
        return result.toString();
    }

    public static String String2hexString(String str) {
        String[] strs = str.split("-");
        String result = "";
        for (String string : strs) {
            String hex = Integer.toString(Integer.parseInt(string, 2), 16);
            result += hex;
        }
        return result;
    }
    /**
     *
     * @param
     * @return 转换为二进制字符串
     */
    public static String bytes2BinaryStr(byte[] bArray){

        String outStr = "";
        int pos = 0;
        for(byte b:bArray){
            //高四位
            pos = (b&0xF0)>>4;
            outStr+=binaryArray[pos];
            //低四位
            pos=b&0x0F;
            outStr+=binaryArray[pos];
        }
        return outStr;

    }
    /**
     *
     * @param bytes
     * @return 将二进制转换为十六进制字符输出
     */
    public static String BinaryToHexString(byte[] bytes){

        String result = "";
        String hex = "";
        for(int i=0;i<bytes.length;i++){
            //字节高4位
            hex = String.valueOf(hexStr.charAt((bytes[i]&0xF0)>>4));
            //字节低4位
            hex += String.valueOf(hexStr.charAt(bytes[i]&0x0F));
            result +=hex+" ";
        }
        return result;
    }
    /**
     *
     * @param hexString
     * @return 将十六进制转换为字节数组
     */
    public static byte[] HexStringToBinary(String hexString){
        //hexString的长度对2取整，作为bytes的长度
        int len = hexString.length()/2;
        byte[] bytes = new byte[len];
        byte high = 0;//字节高四位
        byte low = 0;//字节低四位

        for(int i=0;i<len;i++){
            //右移四位得到高位
            high = (byte)((hexStr.indexOf(hexString.charAt(2*i)))<<4);
            low = (byte)hexStr.indexOf(hexString.charAt(2*i+1));
            bytes[i] = (byte) (high|low);//高地位做或运算
        }
        return bytes;
    }
    public static void main(String[] args) {
        String str = "0ee8";
        System.out.println("转换为二进制：\n"+ByteUtil.bytes2BinaryStr(ByteUtil.hexStringToByteArray(str)));
    }

}
