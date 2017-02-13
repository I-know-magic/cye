/**
 *  页面加载等待页面
 *
 * @author gxjiang
 * @date 2010/7/24
 *
 */
 var height = window.screen.height;
 var width = window.screen.width;
 var leftW = 300;
 if(width>1200){
 	leftW = 600;
 }else if(width>1000){
 	leftW = 450;
 }else {
 	leftW = 200;
 }
 
 var _html = "<div id='loading' style='position:absolute;left:0;width:100%;height:"+height+"px;top:0;background:#E0ECFF;opacity:1;filter:alpha(opacity=100);'>\
 <div style='position:absolute;	cursor1:wait;left:"+leftW+"px;top:200px;width:auto;height:16px;padding:12px 5px 10px 30px;\
 background:#fff url(skins/default/images/pagination_loading.gif) no-repeat scroll 5px 10px;border:2px solid #ccc;color:#000;'>\
 <span style='font-size:12px'>正在加载，请等待...</span>\
 </div></div>";
 
 window.onload = function(){
 	var _mask = document.getElementById('loading');
 	_mask.parentNode.removeChild(_mask);
 }

	 
 document.write(_html);
 