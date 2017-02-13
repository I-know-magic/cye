/**
 * Created by LiuJie on 2016/4/15.
 */
;(function($){
    $.extend({
        ftrend:{
            //**********input只填数字组件*****//
            textInput:function(){
                var inputs99 = $("body").find("input[elemType]");
                if(inputs99 && inputs99.length>0){
                    for(var i =0;i<inputs99.length;i++){
                        var _01type = $(inputs99[i]).attr("elemType");
                        if(_01type == "number"){
                            $(inputs99[i]).bind("keydown",function(e){
                                var code = window.event ? e.keyCode : e.which;
                                if(
                                    (code >= 48 && code <= 57) // [0-9]
                                        //|| code == 189  // - 负号
                                        //|| code == 190  // . 小数点
                                    || code == 8 // backspace
                                    || code == 37 // 左箭头
                                    || code == 39 // 右键头
                                    || (code <= 105 && code >= 96)//小键盘
                                //|| code == 110 //小键盘的小数点
                                ){
                                    return true;
                                }else{
                                    return false;
                                }
                            });
                        }
                    }
                }
            }
        }
    })
})(jQuery);


;$(function(){
    $.ftrend.textInput();
});


