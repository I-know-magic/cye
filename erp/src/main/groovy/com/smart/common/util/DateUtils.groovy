package com.smart.common.util

import java.text.SimpleDateFormat
/**
 * Created by lvpeng on 16/4/14.
 */
class DateUtils {
    /**
     * 获取当前天间隔n天日期
     * @param format 格式化
     * @param n 间隔天数
     * @return
     */
    public static String getSpaceDate(String format = 'yyyy-MM-dd', int n = 0) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH) + n);
        return dateFormat.format(calendar.getTime());
    }
    /**
     * 获取当前天间隔n天日期
     * @param n 间隔天数
     * @return
     */
    public static Date getSpace(int n) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH) + n);
        return calendar.getTime();
    }
    /**
     * 格式化时间
     * @param format
     * @param n
     * @return
     */
    public static String formatData(String format = 'yyyy-MM-dd', Date date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        return dateFormat.format(date);
    }
    /**
     * 日期转换成字符串
     * @param date
     * @return str
     */
    public static String DateToStr(Date date) {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = format.format(date);
        return str;
    }

/**
 * 字符串转换成日期
 * @param str
 * @return date
 */
    public static Date StrToDate(String str) {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = null;
        try {
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static void main(String[] a) {
        System.out.println(formatData("HH:mm",new Date()));

    }
}
