package com.smart.common.util

/**
 * Created by lvpeng on 16/4/14.
 */
class SerialNumberGenerate {
    /**
     *
     * @param digit
     * @param curr
     * @return
     */
    public static String nextSerialNumber(int digit, String curr) {
        int d = digit >= 0 ? digit : 8
        curr = curr == null ? '0' : curr
        if (curr.length() > d) {
            return null
        }
        String number = number(d)
        String num = (Integer.parseInt(curr) + 1).asType(String)
        return number.substring(0, d - num.length()) + num
    }

    /**
     *
     * @param curr
     * @return
     */
    static String nextGoodsCode(String curr) {
        def number = curr.substring(curr.length() - 4, curr.length())
        def catCode = curr.substring(0, curr.length() - 4)
        return catCode + nextSerialNumber(4, number)
    }
    /**
     *
     * @return
     */
    static String nextMenuCode(String curr) {
        String number
        if (!curr) {
            number = nextSerialNumber(4, null)
        } else {
            number = nextSerialNumber(4,curr.substring(curr.length()-4,curr.length()))
        }
        return 'CP' + DateUtils.getSpaceDate('yyMMdd') + number
    }

    /**
     *
     * @param id
     * @param curr
     * @return
     */
    static String getNextCode(int id, String curr) {
        return nextSerialNumber(id, curr)
    }
    /**
     *
     * @param digit
     */
    private static String number(int digit) {
        StringBuilder sb = new StringBuilder()
        for (i in 0..digit) {
            sb.append('0')
        }
        return sb.toString()
    }
    /**
     *
     * @param catCode
     * @return
     */
    static String getNextCatTwoCode(String catCode){
        if (catCode){
            return catCode.substring(0,2)+nextSerialNumber(2,catCode.substring(2,4))
        }else {
            return null
        }
    }
}
