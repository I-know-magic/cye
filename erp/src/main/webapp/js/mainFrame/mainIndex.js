/**
 * Created by LiuJie on 2015/6/9.
 */
function downMenu(){
    $(".dropdown").each(function(i,e){
        $(e).find("a:first").mouseover(function(){
            $(".dropdown").find("ul").hide();
            $(this).parent().find("ul").show();
        });
        $(".wrapper").mouseleave(function(){
            $(".dropdown").find("ul").hide();
        })
    });
}