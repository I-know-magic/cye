/**
 * Created by Administrator on 2015/8/10.
 */
/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */
;String.prototype.replaceAll = function(reallyDo, replaceWith) {
    return this.replace(new RegExp(reallyDo, ("gi")), replaceWith);
};
;(function($) {
    $.extend({
    // $.dateFormat("2015-03-21","yyyy年MM月dd日")
        dateFormat:function(date_in,format){//将给定的时间给话为对应的格式字符串
            //参数:
            //		date_in:要格式化的时间对象
            //		format:格式化字符串 支持的字符M月 d日 y年 h小时 m分钟 s分钟 q时区 S毫秒
            if(!date_in){
                return false;
            }
            var date = null;
            if(typeof date_in == "string"){
                // 转成date对象
                date = new Date(date_in.replaceAll("-","/"))
            }else{
                date = date_in
            }
            if(!date){
                return false;
            }
            var o = {
                "M+" : date.getMonth()+1,
                "d+" : date.getDate(),
                "h+" : date.getHours(),
                "m+" : date.getMinutes(),
                "s+" : date.getSeconds(),
                "q+" : Math.floor((date.getMonth()+3)/3),
                "S" : date.getMilliseconds()
            }
            if(/(y+)/.test(format)) {
                format = format.replace(RegExp.$1, (date.getFullYear()+"").substr(4 - RegExp.$1.length));
            }
            for(var k in o) {
                if(new RegExp("("+ k +")").test(format)) {
                    format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
                }
            }
            return format;
        }
    })
})(jQuery);

