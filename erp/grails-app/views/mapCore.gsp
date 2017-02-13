<%--
  Created by IntelliJ IDEA.
  User: zcl
  Date: 16/3/11
  Time: 上午9:55
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>GeoUtils</title>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=1.2"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/library/GeoUtils/1.2/src/GeoUtils_min.js"></script>
    <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
    <style type="text/css">
    table{
        font-size:14px;
    }
    </style>
</head>
<body>
<div style="float:left;width:600px;height:500px;border:1px solid gray" id="container"></div>
<form name="mainform">
<div style="float:left;width:300px;height:500px;border:1px solid gray" id="control">
    <table style="width:100%;" >
        <tr>
            <td colspan="2">点与矩形的关系: </td>
        </tr>
        <tr>
            <td><input type="button" value="点在矩形内" id="initBtn" onclick="init()" /></td>
            <td><input type="button" value="点在矩形外" onclick="ptOutRect()" /></td>
        </tr>
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td colspan="2">点与圆形的关系: </td>
        </tr>
        <tr>
            <td><input type="button" value="点在圆形内" onclick="ptInCircle()" /></td>
            <td><input type="button" value="点在圆形外" onclick="ptOutCircle()" /></td>
        </tr>
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td colspan="2">计算折线长度: </td>
        </tr>
        <tr>
            <td><input type="button" value="参数为折线" onclick="computeLenByPolyine()" /></td>
            <td><input type="button" value="参数为点数组" onclick="computeLenByArray()" /></td>
        </tr>
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td colspan="2">计算多边形面积: </td>
        </tr>
        <tr>
            <td><input type="button" value="参数为多边形" onclick="computeAreaByPolygon()" /></td>
            <td><input type="button" value="参数为点数组" onclick="computeAreaByArray()" /></td>
        </tr>
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td colspan="2">判断点是否在折线上: </td>
        </tr>
        <tr>
            <td><input type="button" value="点在折线上" onclick="ptOnPolyline()" /></td>
            <td><input type="button" value="点在折线外" onclick="ptOutPolyline()" /></td>
        </tr>
        <tr>
            <td><br/></td>
        </tr>
        <tr>
            <td colspan="2">判断点是否在多边形内: </td>
        </tr>
        <tr>
            <td><input type="button" value="点在多边形内" onclick="ptInPolygon()" /></td>
            <td><input type="button" value="点在多边形外" onclick="ptOutPolygon()" /></td>
        </tr>
    </table>
</div>
</form>
</body>
</html>
<script type="text/javascript">

    var map = new BMap.Map("container");
    var pt = new BMap.Point(116.404, 39.915);
    map.centerAndZoom(pt, 16);

    map.enableScrollWheelZoom();//开启滚动缩放
    map.enableContinuousZoom();//开启缩放平滑

//    urlinfo=window.location.href; //获取当前页面的url
//    len=urlinfo.length;//获取url的长度
//    alert(urlinfo);
//    GetArgsFromHref(urlinfo);

    function init(){
        var url = window.document.location.href.toString();
        alert(url);
        GetArgsFromHref(url);
    }

    function GetArgsFromHref(sHref)
    {
        var args    = sHref.split("?");
        var method = "";
        var srcpoint ="";
        var despoints ="";
        var systemno ="";

        if(args[0] == sHref) /*参数为空*/
        {
            return retval; /*无需做任何处理*/
        }
        var str = args[1];
        args = str.split("&");
        for(var i = 0; i < args.length; i ++)
        {
            str = args[i];
            var arg = str.split("=");
            if(arg.length <= 1) continue;

            if(arg[0] == "method"){
                method = arg[1];
            }else if(arg[0] == "srcpoint"){
                srcpoint = arg[1];
            }else if(arg[0] == "despoints"){
                despoints = arg[1];
            }else{
                systemno = arg[1];
            }

        }
        //js 分流
        if(method=="ptInRect"){

            ptInRect(srcpoint,despoints,systemno);

        }else if(method=="ptOutRect"){

            ptOutRect(srcpoint,despoints,systemno);

        } else if(method=="ptInCircle"){

            ptInCircle(srcpoint,despoints,systemno);

        }else if(method=="ptOnPolyline"){

            ptOnPolyline(srcpoint,despoints,systemno);

        }else if(method=="ptInPolygon"){

            ptInPolygon(srcpoint,despoints,systemno);

        }else{
            return "Error";
        }


    }

    //使出
    function ptOutRect(srcPoint,desPoints,systemNo){

        var sPoint =  srcPoint.split(",");

        var sX = parseFloat(sPoint[0]);
        var sY = parseFloat(sPoint[1]);
        var pt = new BMap.Point(sX , sY);//src点

        var dPoint = desPoints.split(";");
        var onePoints = dPoint[0].split(",");
        var twoPoints = dPoint[1].split(",");

        var oneXpoint = parseFloat(onePoints[0]);
        var oneYpoint = parseFloat(onePoints[1]);
        var twoXpoint = parseFloat(twoPoints[0]);
        var twoYpoint = parseFloat(twoPoints[1]);

        var pt1 = new BMap.Point(oneXpoint, oneYpoint);//西南脚点
        var pt2 = new BMap.Point(twoXpoint, twoYpoint);//东北脚点
        var bds = new BMap.Bounds(pt1, pt2); //测试Bounds对象

        var result = BMapLib.GeoUtils.isPointInRect(pt, bds);
        var method = "ptOutRect";
        //ajax 提交后台
        backResult(result,method,systemNo);

//        if(result == true){
//            alert("点在矩形内");
//        } else {
//            alert("点在矩形外")
//        }

    }


    //点在矩形内
    function ptInRect(srcPoint,desPoints,systemNo){

        var sPoint =  srcPoint.split(",");

        var sX = parseFloat(sPoint[0]);
        var sY = parseFloat(sPoint[1]);
        var pt = new BMap.Point(sX , sY);//src点

        var dPoint = desPoints.split(";");
        var onePoints = dPoint[0].split(",");
        var twoPoints = dPoint[1].split(",");

        var oneXpoint = parseFloat(onePoints[0]);
        var oneYpoint = parseFloat(onePoints[1]);
        var twoXpoint = parseFloat(twoPoints[0]);
        var twoYpoint = parseFloat(twoPoints[1]);

        var pt1 = new BMap.Point(oneXpoint, oneYpoint);//西南脚点
        var pt2 = new BMap.Point(twoXpoint, twoYpoint);//东北脚点
        var bds = new BMap.Bounds(pt1, pt2); //测试Bounds对象

        var result = BMapLib.GeoUtils.isPointInRect(pt, bds);
        var method = "ptInRect";
        //ajax 提交后台
        backResult(result,method,systemNo);

//        if(result == true){
//            alert("点在矩形内");
//        } else {
//            alert("点在矩形外")
//        }

    }



    //点在圆内
    function ptInCircle(srcPoint,desPoints,systemNo){

        var sPoint =  srcPoint.split(",");

        var sX = parseFloat(sPoint[0]);
        var sY = parseFloat(sPoint[1]);
        var pt = new BMap.Point(sX , sY);//src点

        var dPoint =  desPoints.split(",");

        var dX = parseFloat(dPoint[0]);
        var dY = parseFloat(dPoint[1]);
        var c = new BMap.Point(dX , dY);//d点
        var circle = new BMap.Circle(c, 500);//测试圆
        var result = BMapLib.GeoUtils.isPointInCircle(pt, circle);
        var method = "ptInCircle";
        //ajax 提交结果
        backResult(result,method,systemNo);

//        if(result == true){
//            alert("点在圆形内");
//        } else {
//            alert("点在圆形外")
//        }

    }






    //点在折线上
    function ptOnPolyline(srcPoint,desPoints,systemNo){

        var sPoint =  srcPoint.split(",");

        var sX = parseFloat(sPoint[0]);
        var sY = parseFloat(sPoint[1]);
        var pt = new BMap.Point(sX , sY);//src点

        var dPoints =  desPoints.split(";");
        var pts = [];

        for(var i = 0; i < dPoints.length; i ++){
            var tmpdPoints = dPoints[i].split(",");
            var tmpxP = tmpdPoints[0];
            var tmpyP = tmpdPoints[1];
            pts.push(new BMap.Point(parseFloat(tmpxP),parseFloat(tmpyP)));

        }
        var ply = new BMap.Polyline(pts);
        var result = BMapLib.GeoUtils.isPointOnPolyline(pt, ply);
        var method="ptOnPolyline";

        //ajax 调用
        backResult(result,method,systemNo);
//        if(result == true){
//            alert("点在折线上");
//        } else {
//            alert("点在折线外")
//        }


    }


    //点在多边形内
    function ptInPolygon(srcPoint,desPoints,systemNo){


        var sPoint =  srcPoint.split(",");

        var sX = parseFloat(sPoint[0]);
        var sY = parseFloat(sPoint[1]);
        var pt = new BMap.Point(sX , sY);//src点

        var dPoints =  desPoints.split(";");
        var pts = [];

        for(var i = 0; i < dPoints.length; i ++){
            var tmpdPoints = dPoints[i].split(",");
            var tmpxP = tmpdPoints[0];
            var tmpyP = tmpdPoints[1];
            pts.push(new BMap.Point(parseFloat(tmpxP),parseFloat(tmpyP)));

        }

        var ply = new BMap.Polygon(pts);

        var result = BMapLib.GeoUtils.isPointInPolygon(pt, ply);

        var method="ptInPolygon";
        //ajax 调用
        backResult(result,method,systemNo);

//        if(result == true){
//            alert("点在多边形内");
//        } else {
//            alert("点在多边形外")
//        }


    }

    function backResult(result,method,systemno){
        var formData = {"result":result,"method":method,"systemno":systemno};
        alert(JSON.stringify(formData));
        $.ajax({
            type: "POST",
            url:'<g:createLink base=".." controller='channelProcess' action='checkWaring'/>',
            dataType: "json",
            data : JSON.stringify(formData),
            success: function (data) {
            }
        });
    }

</script>