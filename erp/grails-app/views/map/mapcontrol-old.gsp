<%@ page import="com.smart.common.util.PropertyUtils" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
    body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
    #allmap {width: 100%; height:500px; overflow: hidden;}
    #result {width:100%;font-size:12px;}
    dl,dt,dd,ul,li{
        margin:0;
        padding:0;
        list-style:none;
    }
    p{font-size:12px;}
    dt{
        font-size:14px;
        font-family:"微软雅黑";
        font-weight:bold;
        border-bottom:1px dotted #000;
        padding:5px 0 5px 5px;
        margin:5px 0;
    }
    dd{
        padding:5px 0 0 5px;
    }
    li{
        line-height:28px;
    }
    </style>
    %{--<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=E4805d16520de693a3fe707cdc962045"></script>--}%
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5pOe9cqol0NaNdEbtvTXMC9h"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mainFrame/DrawingManager_min.css', base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mainFrame/SearchInfoWindow_min.css', base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mainFrame/base.css', base: '..')}" type="text/css">
    %{--<script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>--}%
    <script type="text/javascript" src="${resource(dir:'js',file:'DrawingManager.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'SearchInfoWindow_min.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'mapAngle/angle.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'ztree-cus.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'socket.io/socket.io.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'socket.io/moment.min.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'socket-util-cus.js',base: '..')}"></script>

    <title>地图监控</title>
    <div id="plan_dialog" class="easyui-dialog"
         data-options="cache:false,modal:true,closed:true,closable:false,href:'<g:createLink base=".." controller="login" action="showplan"/>',top:'160px'"
         style="width:550px;height:300px;padding-left: 60px;overflow-x: hidden;overflow-y: hidden" buttons="#planbutton">
    </div>
    <div id="planbutton">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeself()">关闭</a>
    </div>
    <script type="text/javascript">
        var afn = "16";
        var fn = "001";

        var data="";
        var data_645="";
        //645中的读写标示
        var query_645="11";
        var add_645="14";
        //645中的读写数据长度
        var data_querylen_645="04";
        var data_addlen_645="0E";

        //控制字
        var data_query_flag="323333B4";
        //主灯
        var data_zd_flag="333433B5";
        //辅灯
        var data_fd_flag="343433B5";
        //全部
        var data_all_flag="353433B5";
        //开关的值
        var data_open_value="0100";
        var data_close_value="0000";
        //调光 +33 倒序
        var data_tg_value="00";
        //密码
        var data_pass="3544444487867478";
        //查询长度=16，其他26
        var len_query_645="16";
        var len_645="26";

        var socket;
        var page=1;
        var terminal="";
        var meteraddr="";
        var terpass="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_PASS)}";
        var mas="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_MSA)}";
        var msgtype="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_MSG_TYPE)}";
        var vn="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_MSG_TYPE)}";
        var socket_class="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_SOCKET_CLASS)}";
        var flag_test="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_FLAG_TEST)}";
        var socket_url="${com.smart.common.util.PropertyUtils.getDefault(com.smart.common.util.LightConstants.KEY_SMART_LIGHT_SOCKET_URL)}";
        var pn = "0";

//        setInterval('refreshAllGPS()',80000);
        %{--function refreshAllGPS(){--}%
            %{--var url = '<g:createLink controller="tabCarInfo" action="queryAllGps"  base=".."  />'--}%
            %{--$.ajax({--}%
                %{--type: "GET",--}%
                %{--url: url,--}%
                %{--cache: false,--}%
                %{--//async: false,--}%
                %{--dataType: "json",--}%
                %{--success: function (data) {--}%
                    %{--if (data.isSuccess==true) {--}%
                        %{--var obj = data.jsonMap.allGPS--}%
                        %{--deleteAllPoint();--}%
                        %{--for(var i=0;i<obj.length;i++){--}%
                            %{--var fx =queryAngle(obj[i].angle);--}%
                            %{--var pt = new BMap.Point(obj[i].longitude,obj[i].latitude);--}%
                            %{--carid = obj[i].id;--}%

                            %{--var content = '<div style="margin:0;line-height:20px;padding:2px;">' +--}%
                                    %{--'车牌号：' + obj[i].carno + '<br/>' +--}%
                                    %{--'姓名：' + obj[i].driverName + '<br/>' +--}%
                                    %{--'联系电话：' + obj[i].driverPhone + '<br/>' +--}%
                                    %{--'方向：' + fx + '<br/>' +--}%
                                    %{--'速度：' + obj[i].velocity +'/s' + '<br/>' +--}%
                                    %{--'里程：' + obj[i].miles + 'KM' + '<br/>' +--}%
                                    %{--'油量：' + obj[i].oil + '<br/>' +--}%
                                    %{--'电压：' + obj[i].levelNum + '<br/>' +--}%
                                    %{--'时间：' + obj[i].time + '<br/>' +--}%
                                    %{--'<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="queryplan()">'+'派送详情'+'</a>'+'<br/>' +--}%
                                    %{--'</div>';--}%
                            %{--addCarMarker(pt,content,obj[i].carno,obj[i].angle);--}%

                        %{--}--}%
                    %{--} else {--}%
                        %{--$.messager.alert('系统提示', data.msg, 'error');--}%
                    %{--}--}%
                %{--}--}%
            %{--});--}%

        %{--}--}%


        $(function () {
            var height = $(window).height();
            var width = $(window).width();
            $("#infoWindow").css({"left":(width-520)+"px"})
            url='<g:createLink base=".." controller='baseArea' action='loadZTreeTerminal'/>';
            init_tree('id','baseAreaPid','baseAreaName',false,'',fn);
            loadMyTree(url);
            socket=connect_socket(socket_url,socket_class);
            check_socket(socket);
        });
        function check_socket(socket){
            if(socket==null){
                output_state("连接错误!");
            }else if(socket.connected){
                output_state("与服务器连接断开!");
            }else{
                socket_retransData("retransData");

            }
        }
        var fn=function clickTree(event, treeId, treeNode) {
            //debugger;
            if(treeNode.isArea==1){
                var baseAreaName=treeNode.baseAreaName;
                var baseAreaId=treeNode.tid;
                var lng=treeNode.lng;//经度
                var lat=treeNode.lat;//纬度
                var point= new BMap.Point(lng,lat);
                addComMarker(point);
//                querydevice(lng,lat);
            }else {
                $.messager.alert("系统提示", "请选择集中控制器下发档案！", "warning");
            }

        }
        /**
        *查询状态
         */
        function queryLight(terminal,meteraddr) {
            openwidow();
//            terminal=$("#h_terminal").val();
//            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_query_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(10,meteraddr,query_645,data_querylen_645,data_query_flag);
            var lst=pack();
            if(flag_test=="0"){
                output_ptl(lst);
            }
            $.messager.alert("系统提示",msg , "warning");
        }
        /**
         *主灯开关 flag=true 开，false 关
         */
        function openMaxLight(terminal,meteraddr,value,light_value,callbackType) {
            openwidow();
            terminal=$("#h_terminal").val();
            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,data_zd_flag,data_pass,value,light_value);

            var lst=pack();
            if(flag_test=="0"){
                output_ptl(lst);
            }
            $.messager.alert("系统提示",msg , "warning");
        }
        /**
         *辅灯开关 flag=true 开，false 关
         */
        function openMinLight(terminal,meteraddr,value,light_value,callbackType) {
            openwidow();
            terminal=$("#h_terminal").val();
            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,data_fd_flag,data_pass,value,light_value);

            var lst=pack();
            if(flag_test=="0"){
                output_ptl(lst);
            }
            $.messager.alert("系统提示",msg , "warning");
        }
        /**
         *全部开关
         */
        function openAllLight(terminal,meteraddr,value,light_value,callbackType) {
            openwidow();
            terminal=$("#h_terminal").val();
            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,data_all_flag,data_pass,value,light_value);
            var lst=pack();
            if(flag_test=="0"){
                output_ptl(lst);
            }
            $.messager.alert("系统提示",msg , "warning");
        }
        function output_state(msg){
            output(msg);

        }
        function socket_retransData(fname){
            output_state('<span class="username-msg">已注册返回服务<span class="disconnect-msg"></span> ');
            socket.on(fname, function(data_res) {
                var sscMessage=data_res.sscMessage;
                var msgType=sscMessage.msgType;
                var message=check_msg_type(msgType);
                if(message=="0"){
                    message=data_res.message;
                    output_state('<span class="username-msg">回复数据类型-' + msgType + ':</span> ' + '<span class="disconnect-msg">' +  message + ':</span> ');
                }else{
                    output_state('<span class="username-msg">回复数据类型-' + msgType + ':</span> ' + '<span class="disconnect-msg">' +  message + '</span> ');
                }

            });

        }
        function clean_output(){
            $('#w_msg').empty();
        }

        function closewidow(){
            $("#infoWindow").dialog("close");
        }
        function openwidow(){
            $("#infoWindow").dialog("open");
        }

    </script>
</head>
<body>
<div class="table-list">
    <input  type="hidden"  id="h_terminal" value="37020001"/>
    <input  type="hidden"  id="h_meteraddr" value="201511220284"/>

    <div class="table-list-lm fl" style="background:#c3dde5;">
        <ul id="kindTree" class="ztree">
        </ul>
    </div>
    <div class="table-list-rm fr" style="background:#a7b4b6;">
        <div id="allmap" style="height:100%;overflow:hidden;zoom:1;position:relative;">
            <div id="map" style="height:100%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;"></div>
        </div>
    </div>
    %{--<div class="store_set-meal-table-r" style="background:#fff;overflow: auto">--}%
        %{--<div><span style="color: #00aaee;font-size: medium">  集中控制器回复信息:</span></div>--}%
            %{--<div>--}%
                %{--<ul class="">--}%
                    %{--<li  class="" onclick="openwidow()">打开窗口</li>--}%
                    %{--<li  class="" onclick="queryLight()">查询灯状态</li>--}%
                    %{--<li  class="" onclick="openMaxLight(data_open_value,100,1)">主灯开</li>--}%
                    %{--<li  class="" onclick="openMaxLight(data_close_value,0,2)">主灯关</li>--}%
                    %{--<li  class="" onclick="openMaxLight(data_tg_value+'50',50,7)">主灯调光</li>--}%
                    %{--<li  class="" onclick="openMinLight(data_open_value,100,3)">辅灯开</li>--}%
                    %{--<li  class="" onclick="openMinLight(data_close_value,0,4)">辅灯关</li>--}%
                    %{--<li  class="" onclick="openMinLight(data_tg_value+'50',50,8)">辅灯调光</li>--}%
                    %{--<li  class="" onclick="openAllLight(data_open_value,100,5)">全部开</li>--}%
                    %{--<li  class="" onclick="openAllLight(data_close_value,0,6)">全部关</li>--}%
                    %{--<li  class="" onclick="openAllLight(data_tg_value+'50',50,9)">全部调光</li>--}%
                %{--</ul>--}%
            %{--</div>--}%
    %{--</div>--}%
</div>
%{--modal:true,--}%
<div id="infoWindow" class="easyui-dialog "
     data-options="closed:true,closable:true,iconCls:'icon-save',top:'150px',title:'集中控制器回复信息'"
     buttons="#infoWindow-buttons" style="width:500px;height:auto;">
    <div id="w_msg" style="padding: 5px;height:400px" >

    </div>
</div>

<div id="infoWindow-buttons">
    <a  href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok"
        onclick="clean_output()">清除打印信息</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
       onclick="closewidow()">关闭</a>
</div>

<script type="text/javascript">
    // 百度地图API功能
    var map = new BMap.Map('map');
    //    var poi =initPoint() //new BMap.Point(116.307852,40.057031);

    var overlays = [];
    var overlaycomplete = function(e){
        overlays.push(e.overlay);
    };
    map.addControl(new BMap.NavigationControl());
    map.addControl(new BMap.ScaleControl());
    map.addControl(new BMap.OverviewMapControl());
    map.enableScrollWheelZoom();
    map.addControl(new BMap.MapTypeControl());
    //        map.setCurrentCity("青岛市");
    var plng;
    var plat;
    var lastMark=[];
    var lastCarNo=[];
    var opts = {
        width : 250,     // 信息窗口宽度
        height: 280,     // 信息窗口高度
        title : "详细信息" , // 信息窗口标题
        enableMessage:true//设置允许信息窗发送短息
    };
    function findCarNo(carNo){
        var index=-1;
        if(lastCarNo!=null && lastCarNo.length>0){
            for(var i=0;i<lastCarNo.length;i++){
                if(lastCarNo[i]==carNo){
                    index = i;
                    break;
                }
            }
        }
        if(index!=-1){
            map.panTo(lastMark[index].getPosition());
        }



    }


    function queryWaring(){

    }

    function queryplan(){
        var url = '<g:createLink base=".." controller="login" action="showplan"/>';
        $("#plan_dialog").dialog('options').href=url;
        $("#plan_dialog").dialog("open").dialog("setTitle","当前派送详情");
//        $("#plan_dialog").dialog('open').dialog('refresh', url);

    }

    function closeself(){
        $("#plan_dialog").dialog("close");
    }

    //添加右键菜单

    initPoint();
    /*
    * 初始化地图
     */
    function initPoint(){
        var array=[];
        var point=null;
        var pointjw ="${com.smart.common.util.PropertyUtils.getDefault("origin")}" ;
        if(pointjw!=null&&pointjw!=""){
            array=pointjw.split(",");
            point = new BMap.Point(array[1], array[0]);
        }
//        addMarker1(point,1)
//        addComMarker(point);
//        querydevice();
//        refreshAllGPS();
    }
    function addComMarker(point) {
//        clean();
        map.centerAndZoom(point,10);
        var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/company.png", new BMap.Size(20,20));
        var marker = new BMap.Marker(point,{icon:myIcon});
//        var marker = new BMap.Marker(point);
        map.addOverlay(marker);
//        map.panTo(point);

//        openInfo();
//                addClickHandler(marker);
    }
    function addTerMarker(point,content) {
//        clean();
        map.centerAndZoom(point,10);
        var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/company.png", new BMap.Size(20,20));
        var marker = new BMap.Marker(point,{icon:myIcon});
//        var marker = new BMap.Marker(point);
        map.addOverlay(marker);
//        map.panTo(point);

//        openInfo();
        addClickHandler(content,marker);
    }
    /**
     * 添加标注--修改时使用
     * @param point
     */
    function addMarker(point) {
//        clean();
        var marker = new BMap.Marker(point);
        map.addOverlay(marker);
        map.panTo(point);
    }
    function addCusMarker(point,content,cuscompany) {
//        var marker = new BMap.Marker(point);
        var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/customer.png", new BMap.Size(20,20));
        var marker = new BMap.Marker(point,{icon:myIcon});
        var label = new BMap.Label( cuscompany,{offset:new BMap.Size(20,-10)});
        marker.setLabel(label);
        map.addOverlay(marker);
        addClickHandler(content,marker);
    }
    function addCarMarker(point,content,carNo,angle) {
//        var marker = new BMap.Marker(point);
//        if(lastMark!=null){
//            deletePoint(carNo);
//        }

//        //debugger;
        var carIcon = queryCarIcon(angle);
        var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/"+carIcon, new BMap.Size(44,44));
        var marker = new BMap.Marker(point,{icon:myIcon});
        var label = new BMap.Label(carNo,{offset:new BMap.Size(20,-10)});
        marker.setLabel(label);
        //lastMark = marker;
        map.addOverlay(marker);
        map.setZoom(13);
        map.panTo(point);
        lastMark.push(marker);
        lastCarNo.push(carNo);
        addClickHandler(content,marker);
    }
    function addMarkerAndClean(point) {
        clean();
        var marker = new BMap.Marker(point);
        map.addOverlay(marker);
        map.panTo(marker);
        map.centerAndZoom(point,10);
    }

    //删除全部marker
    function deleteAllPoint(){

        if(lastMark!=null && lastMark.length>0){
            for(var i=0;i<lastMark.length ; i++){
                map.removeOverlay(lastMark[i]);
            }
        }
        lastMark=[];
        lastCarNo=[];
    }


    //删除指定marker
    function deletePoint(carNo){

        map.removeOverlay(lastMark);
//        var allOverlay = map.getOverlays();
//
//        for (var i = 0; i < allOverlay.length -1; i++){
//            if(allOverlay[i].getLabel().content == carNo){
//
//                map.removeOverlay(allOverlay[i]);
//                return false;
//
//            }
//
//        }
    }


    /**
     * 查询显示点信息
     */
    function queryMark() {
        map.clearOverlays();
        //        var infoWindow = new BMap.InfoWindow(content, opts);  // 创建信息窗口对象
        //        var marker = new BMap.Marker(poi3);
        //        marker.enableDragging(); //marker可拖拽
        addMarker(point);

//        searchInfoWindow.open(marker); //在marker上打开检索信息串口
    }
    /**
     * 添加标注的监听事件
     */
    function addClickHandler(content,marker){
        marker.addEventListener("click",function(e){
            openInfo(content,e)}
        );
    }
    /**
     * 显示提示信息
     */
    function openInfo(content,e){

        var p = e.target;
        var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
        var infoWindow = new BMap.InfoWindow(content,opts);  // 创建信息窗口对象
        map.openInfoWindow(infoWindow,point); //开启信息窗口
    }
    /**
     * 清除标注
     */
    function clean() {
        map.clearOverlays();
    }
    /**
     * 检索
     *
     */

    function serch(queryStr){
        var local = new BMap.LocalSearch(map, {
            renderOptions:{map: map}
        });
        local.search(queryStr);
    }
    var styleOptions = {
        strokeColor:"red",    //边线颜色。
        fillColor:"red",      //填充颜色。当参数为空时，圆形将没有填充效果。
        strokeWeight: 3,       //边线的宽度，以像素为单位。
        strokeOpacity: 0.8,	   //边线透明度，取值范围0 - 1。
        fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
        strokeStyle: 'solid' //边线的样式，solid或dashed。
    }
    //实例化鼠标绘制工具
    var drawingManager = new BMapLib.DrawingManager(map, {
        isOpen: false, //是否开启绘制模式
        enableDrawingTool: true, //是否显示工具栏
        drawingToolOptions: {
            anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
            offset: new BMap.Size(5, 5), //偏离值
        },
        circleOptions: styleOptions, //圆的样式
        polylineOptions: styleOptions, //线的样式
        polygonOptions: styleOptions, //多边形的样式
        rectangleOptions: styleOptions //矩形的样式
    });
    //添加鼠标绘制工具监听事件，用于获取绘制结果
    drawingManager.addEventListener('overlaycomplete', overlaycomplete);
    function clearAll() {
        for(var i = 0; i < overlays.length; i++){
            map.removeOverlay(overlays[i]);
        }
        overlays.length = 0
    }

    /**
    *查询路灯
     */
    function querydevice(lng,lat){
        $.ajax({
            async:false,
            url:'<g:createLink controller='tabCustomerInfo' action='querycus'  base=".." />',
            type:"post",
            dataType:'json',
            success:function(data){
//                //debugger
                for(var i =0;i<data.length;i++){
                    var obj=data[i];
                    if(obj.customerjd && obj.customerjd!=null){
                        var pt = new BMap.Point(obj.customerjd,obj.customerwd);
                        var taddr=obj.taddr;
                        var maddr=obj.maddr;
                        var content = '<div style="margin:0;line-height:20px;padding:2px;">' +
                                '编号：' + obj.mcode + '<br/>' +
                                '地址：' + obj.maddr + '<br/>' +
                                '状态：' + obj.swich + '<br/>' +
                                '亮度：' + obj.level + '<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="queryLight('+taddr+','+maddr+')">'+'查询状态'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMaxLight('+taddr+','+maddr+','+data_open_value+','+100+','+1+')">'+'主灯开'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMaxLight('+taddr+','+maddr+','+data_close_value+','+0+','+2+')">'+'主灯关'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMaxLight('+taddr+','+maddr+','+data_tg_value+'50'+','+50+','+7+')">'+'主灯调光'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMinLight('+taddr+','+maddr+','+data_open_value+','+100+','+3+')">'+'辅灯开'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMinLight('+taddr+','+maddr+','+data_close_value+','+0+','+4+')">'+'辅灯关'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMinLight('+taddr+','+maddr+','+data_tg_value+'50'+','+50+','+8+')">'+'辅灯调光'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openAllLight('+taddr+','+maddr+','+data_open_value+','+100+','+5+')">'+'全部开'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openAllLight('+taddr+','+maddr+','+data_close_value+','+0+','+6+')">'+'全部关'+'</a>'+'<br/>' +
                                '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openAllLight('+taddr+','+maddr+','+data_tg_value+'50'+','+50+','+9+')">'+'全部调光'+'</a>'+'<br/>' +
                                '</div>';
                        addCusMarker(pt,content,obj.customercompany);
                    }

                }


            }
        })
    }

    var contextMenu = new BMap.ContextMenu();
    var txtMenuItem = [
        {
            text: '放大',
            callback: function () {
                map.zoomIn()
            }
        },
        {
            text: '缩小',
            callback: function () {
                map.zoomOut()
            }
        },
        {
            text: '放置到最大级',
            callback: function () {
                map.setZoom(18)
            }
        },
        {
            text: '查看全国',
            callback: function () {
                map.setZoom(4)
            }
        },
        {
            text: '在此添加标注',
            callback: function (p) {
                var marker = new BMap.Marker(p), px = map.pointToPixel(p);
                map.addOverlay(marker);
            }
        }
    ];
    for (var i = 0; i < txtMenuItem.length; i++) {
        contextMenu.addItem(new BMap.MenuItem(txtMenuItem[i].text, txtMenuItem[i].callback, 100));
        if (i == 1 || i == 3) {
            contextMenu.addSeparator();
        }
    }
    map.addContextMenu(contextMenu);
</script>
</body>
</html>
