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
        var data_open_v="100";
        var data_close_value="0000";
        var data_close_v="00";
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
            init_tree('id','baseAreaPid','baseAreaName',false,'',fn_clickTree);
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
                socket_warning("waring");

            }
        }
        var fn_clickTree=function clickTree(event, treeId, treeNode) {
            //debugger;
            if(treeNode.isArea==1){
                var baseAreaName=treeNode.baseAreaName;
                var baseAreaId=treeNode.tid;
                var lng=treeNode.lng;//经度
                var lat=treeNode.lat;//纬度
                $("#h_terminal_id").val(baseAreaId);
                var point= new BMap.Point(lng,lat);
                var content = '<div style="margin:0;line-height:20px;padding:2px;">' +
//                        '    <input  type="hidden"  id="h_terminal_'+baseAreaName+'" value="'+baseAreaId+'"/>' +
                        '编号：' + baseAreaId + '<br/>' +
                        '地址：' + baseAreaName + '<br/>' +
                        '<br/>' +
                        '设备操作<br/>' +
                        '<div class="rel">' +
                        ' <ul class="boxtab-btn-ter abs" title="操作">' +
                        ' <li class="" onclick="openGroup('+baseAreaId+')">分组</li>' +
                        ' <li class="" onclick="openTer('+baseAreaId+','+baseAreaName+')">拉闸</li>' +
                        ' <li class="" onclick="closeTer('+baseAreaId+','+baseAreaName+')">合闸</li>' +
                        '</ul>' +
                        '</div>' +
//                        '<ul>' +
//                        '<li><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openGroup('+baseAreaId+')">'+'分组'+'</a></li>' +
//                        '<li><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openTer('+baseAreaId+','+baseAreaName+')">'+'拉闸'+'</a></li>' +
//                        '<li><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="closeTer('+baseAreaId+','+baseAreaName+')">'+'合闸'+'</a></li>' +
//                        '</ul>' +
                        '</div>';
                addTerMarker(point,content);
                querydevice(baseAreaId);
            }else {
                $.messager.alert("系统提示", "请选择集中控制器下发档案！", "warning");
            }

        }
        /**
        *查询状态
         */
        function queryLight(terminal,meteraddr) {
            //debugger;
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
         *开关调光根据 callbackType不同
         */
        function openLight(terminal,meteraddr,value,light_value,callbackType) {
            //debugger;
            openwidow();
//            terminal=$("#h_terminal").val();
//            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            var _data_flag=data_zd_flag;
            if(value==data_tg_value){
                value=value+light_value;
            }
            if(callbackType==1 || callbackType==2|| callbackType==7){
                _data_flag= data_zd_flag;
            }else if(callbackType==3 ||callbackType==4|| callbackType==8){
                _data_flag= data_fd_flag;

            }else if(callbackType==5 ||callbackType==6|| callbackType==9){
                _data_flag= data_all_flag;

            }
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,_data_flag,data_pass,value,callbackType);

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
            //debugger;
            openwidow();
//            terminal=$("#h_terminal").val();
//            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            if(value==data_tg_value){
                value=value+light_value;
            }
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,data_zd_flag,data_pass,value,callbackType);

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
//            terminal=$("#h_terminal").val();
//            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            if(value==data_tg_value){
                value=value+light_value;
            }
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,data_fd_flag,data_pass,value,callbackType);

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
//            terminal=$("#h_terminal").val();
//            meteraddr=$('#h_meteraddr').val();
            var msg= "集中控制器:"+terminal+"开始查询终端设备地址="+meteraddr+"的状态！";
            output_state(msg);
//            0=31,1=3,2=0,3=1,4=0,5=3,6=0,7=0,8=0,9=0,
            if(value==data_tg_value){
                value=value+light_value;
            }
            data=new Array("31","3","0","1","0","3","0","0","0","0",len_645);
            init(afn,fn,pn,terminal,mas,msgtype);
            setData(data,0,0);
            setData_645(callbackType,meteraddr,add_645,data_addlen_645,data_all_flag,data_pass,value,callbackType);
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
        function socket_warning(fname){
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
        /**
         *打开分组
         */
        function openGroup(tid){
            //debugger;
            var url = '<g:createLink base=".." controller="baseGroup" action="showGroup"/>?baseTerminalId='+tid;
            $("#group_dialog").dialog('options').href=url;
            $("#group_dialog").dialog("open").dialog("setTitle","分组操作");
        }
        function closeGroup(){
            $("#group_dialog").dialog("close");
        }
        /**
         *打开分组
         */
        function openDeviceControl(taddr,maddr){
            //debugger;
            $("#editForm").form('clear');
            $("#h_meteraddr_d").val(maddr);
            $("#h_terminal_d").val(taddr);
            $("#level-d").numberspinner('setValue', 50);
//            $('#ss').numberspinner('setValue', 8234725);
            $("#device_dialog").dialog("open").dialog("setTitle","设备操作");
        }
        function closeDeviceControl(){
            $("#device_dialog").dialog("close");
        }
        /**
         *拉闸
         */
        function openTer(tid,taddr){
            $("#group_dialog").dialog("close");
        }
        /**
        *合闸
         */
        function closeTer(tid,taddr){

        }
        var zd_num=1;
        var fd_num=1;
        var all_num=1;
        function openorclose_zd(){
            var maddr=$("#h_meteraddr_d").val();
            var taddr=$("#h_terminal_d").val();
            if (zd_num == 0) {
                document.getElementById("zdTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/off.png', base:'..')}";
//                openMaxLight(taddr,maddr,data_close_value,data_close_v,2);
                openLight(taddr,maddr,data_close_value,data_close_v,2);
                zd_num = 1;
            } else {
                document.getElementById("zdTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/on.png', base:'..')}";
//                openMaxLight(taddr,maddr,data_open_value,data_open_v,1);
                openLight(taddr,maddr,data_close_value,data_close_v,1);
                zd_num = 0;
            }

        }
        function openorclose_fd(){
            var maddr=$("#h_meteraddr_d").val();
            var taddr=$("#h_terminal_d").val();
            if (fd_num == 0) {
                document.getElementById("fdTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/off.png', base:'..')}";
//                openMinLight(taddr,maddr,data_close_value,data_close_v,4)
                openLight(taddr,maddr,data_close_value,data_close_v,4);

                fd_num = 1;
            } else {
                document.getElementById("fdTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/on.png', base:'..')}";
//                openMinLight(taddr,maddr,data_open_value,data_open_v,3)
                openLight(taddr,maddr,data_close_value,data_close_v,3);

                fd_num = 0;

            }


        }
        function openorclose_all(){
            var maddr=$("#h_meteraddr_d").val();
            var taddr=$("#h_terminal_d").val();
            if (all_num == 0) {
                document.getElementById("allTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/off.png', base:'..')}";
//                openAllLight(taddr,maddr,data_close_value,data_close_v,6);
                openLight(taddr,maddr,data_close_value,data_close_v,6);

                all_num = 1;
            } else {
                document.getElementById("allTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/on.png', base:'..')}";
//                openAllLight(taddr,maddr,data_open_value,data_open_v,5);
                openLight(taddr,maddr,data_close_value,data_close_v,5);

                all_num = 0;
            }


        }
        function lightControl(callbackType){
            var maddr=$("#h_meteraddr_d").val();
            var taddr=$("#h_terminal_d").val();
            var light_value=$('#level-d').numberspinner('getValue');
            if(!light_value){
                $.messager.alert("系统提示","请设置亮度值!" , "warning");
                return false;
            }
            openLight(taddr,maddr,data_tg_value,light_value,callbackType);

        }
    </script>
</head>
<body>
<div class="table-list">
    <input  type="hidden"  id="h_terminal_id" value="37020001"/>
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
     data-options="closed:true,closable:true,iconCls:'icon-save',top:'80px',title:'集中控制器回复信息'"
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
<div id="group_dialog" class="easyui-dialog"
     data-options="cache:false,modal:true,closed:true,closable:false,href:'<g:createLink base=".." controller="baseGroup" action="showGroup"/>',top:'60px'"
     style="width:500px;height:400px;overflow:hidden;padding: 0px 0px 0px 0px;" buttons="#groupbutton">
</div>
<div id="groupbutton">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeGroup()">关闭</a>
</div>


<div id="device_dialog" class="easyui-dialog "
     data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
     buttons="#devicebutton" style="width:500px;height:auto;">
    <form id="editForm" method="post">
        <table cellpadding="6" style="table-layout:fixed;">
            <input  type="hidden"  id="h_terminal_d" value=""/>
            <input  type="hidden"  id="h_meteraddr_d" value=""/>
            <tr>
                %{--<td class="title">开关:</td>--}%
                <td class="title">主灯开关</td>
                <td>
                <img src="${resource(dir: 'css', file: 'mainFrame/img/off.png', base: '..')}"
                onclick="openorclose_zd()"
                id="zdTypeImg">
                </td>
                <td class="title">辅灯开关</td>
                <td>
                    <img src="${resource(dir: 'css', file: 'mainFrame/img/off.png', base: '..')}"
                         onclick="openorclose_fd()"
                         id="fdTypeImg">
                </td>
                <td class="title">全部开关</td>
                <td>
                    <img src="${resource(dir: 'css', file: 'mainFrame/img/off.png', base: '..')}"
                         onclick="openorclose_all()"
                         id="allTypeImg">
                </td>
            </tr>
            %{--<tr>--}%
                %{--<td class="title">辅灯开关:</td>--}%
                %{--<td>--}%
                    %{--<img src="${resource(dir: 'css', file: 'mainFrame/img/off.png', base: '..')}"--}%
                         %{--onclick="openorclose_fd()"--}%
                         %{--id="fdTypeImg">--}%
                %{--</td>--}%
            %{--</tr>--}%
            %{--<tr>--}%
                %{--<td class="title">全部开关:</td>--}%
                %{--<td>--}%
                    %{--<img src="${resource(dir: 'css', file: 'mainFrame/img/off.png', base: '..')}"--}%
                         %{--onclick="openorclose_all()"--}%
                         %{--id="allTypeImg">--}%
                %{--</td>--}%
            %{--</tr>--}%
            <tr>
                <td class="title">亮度:</td>
                <td colspan="5">
                    <input class="easyui-numberspinner" type="text" id="level-d" data-options="required:true" value="50"/>
                </td>
            %{--<td>--}%
                %{--<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="closeDeviceControl()">主灯调光</a>--}%
            %{--</td>--}%
            %{--<td class="title">主灯调光:</td>--}%
            %{--<td>--}%
                %{--<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="closeDeviceControl()">主灯调光</a>--}%
            %{--</td>--}%
            %{--<td class="title">主灯调光:</td>--}%
            %{--<td>--}%
                %{--<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="closeDeviceControl()">主灯调光</a>--}%
            %{--</td>--}%

            </tr>
            <tr>
                <td class="title">主灯调光:</td>
                <td >
                    <a href="javascript:void(0)" class="easyui-linkbutton"  onclick="lightControl(7)">主灯调光</a>
                </td>
                <td class="title">辅灯调光:</td>
                <td >
                    <a href="javascript:void(0)" class="easyui-linkbutton"  onclick="lightControl(8)">辅灯调光</a>
                </td>
                <td class="title">全部调光:</td>
                <td>
                    <a href="javascript:void(0)" class="easyui-linkbutton"  onclick="lightControl(9)">全部调光</a>
                </td>
            </tr>
        </table>
    </form>
</div>


%{--<div id="device_dialog" class="easyui-dialog"--}%
     %{--data-options="cache:false,modal:true,closed:true,closable:false,href:'<g:createLink base=".." controller="baseGroup" action="showGroup"/>',top:'60px'"--}%
     %{--style="width:500px;height:400px;overflow:hidden;padding: 0px 0px 0px 0px;" buttons="#devicebutton">--}%
%{--</div>--}%
<div id="devicebutton">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeDeviceControl()">关闭</a>
</div>
<script type="text/javascript">
    // 百度地图API功能
    var map = new BMap.Map('map');
    map.addControl(new BMap.NavigationControl());
    map.addControl(new BMap.ScaleControl());
    map.addControl(new BMap.OverviewMapControl());
    map.enableScrollWheelZoom();
    map.addControl(new BMap.MapTypeControl());
    var lastMark=[];
    var lastCarNo=[];
    var opts = {
        width : 300,     // 信息窗口宽度
        height: 280,     // 信息窗口高度
        title : "详细信息" , // 信息窗口标题
        enableMessage:true//设置允许信息窗发送短息
    };
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
        map.centerAndZoom(point,10);
//        addMarker1(point,1)
//        addComMarker(point);
//        querydevice();
//        refreshAllGPS();
    }
    %{--function addComMarker(point) {--}%
        %{--map.centerAndZoom(point,10);--}%
        %{--var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/company.png", new BMap.Size(20,20));--}%
        %{--var marker = new BMap.Marker(point,{icon:myIcon});--}%
        %{--map.addOverlay(marker);--}%

    %{--}--}%
    //集中器信息框：分组操作，拉合闸
    function addTerMarker(point,content) {
        clean();
        //debugger;
        map.centerAndZoom(point,10);
        var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/company.png", new BMap.Size(20,20));
        var marker = new BMap.Marker(point,{icon:myIcon});
//        var marker = new BMap.Marker(point);
        map.addOverlay(marker);
        map.panTo(point);

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
    /*
    *添加自定义标注，带图标
     */
    function addDeviceMarker(point,content,lighttype,lable) {
//        var marker = new BMap.Marker(point);
        var myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/customer.png", new BMap.Size(20,20));
        if(lighttype=="1"){
            myIcon = new BMap.Icon("${com.smart.common.util.PropertyUtils.getDefault("home_url")}/css/mainFrame/img/vehicle0.png", new BMap.Size(44,44));
        }

        var marker = new BMap.Marker(point,{icon:myIcon});
        var label = new BMap.Label(lable,{offset:new BMap.Size(10,-10)});

        marker.setLabel(label);
        map.addOverlay(marker);
        addClickHandler(content,marker);
    }
    /*
     *添加自定义标注，带图标 -02
     */
    function addCarMarker(point,content,carNo,angle) {
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
    //清除标注，添加新标注
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
        //debugger;
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

    /**
    *查询路灯
     */
    function querydevice(baseAreaId){
        //debugger;
        $.ajax({
            async:false,
            url:'<g:createLink controller='baseBoundDevice' action='queryDevice'  base=".." />?kindId='+baseAreaId,
            type:"post",
            dataType:'json',
            success:function(data){
                //debugger
                if(data.success=="true"){
                    for(var i =0;i<data.rows.length;i++){
                        var obj=data.rows[i];
                        var tid=obj[0];
                        var mid=obj[1];
                        var taddr=obj[2];
                        var tlng=obj[3];
                        var tlat=obj[4];
                        var mno=obj[5];
                        var maddr=obj[6];
                        var mlng=obj[7];
                        var mlat=obj[8];
                        var mcode=obj[9];
                        //实时状态
                        //主灯开关状态
                        var zswich=obj[10]==null?0:obj[10];
                        //主灯亮度
                        var zlevel=obj[11]==null?0:obj[11];
                        var fswich=obj[12]==null?0:obj[12];
                        var flevel=obj[13]==null?0:obj[13];
                        //电流
                        var zelectric=obj[14]==null?0:obj[14];
                        //电量
                        var zelectricity=obj[15]==null?0:obj[15];
                        var felectric=obj[16]==null?0:obj[16];
                        var felectricity=obj[17]==null?0:obj[17];
                        //功率、电压
                        var zpower=obj[18]==null?0:obj[18];
                        var zvoltage=obj[19]==null?0:obj[19];
                        var fpower=obj[20]==null?0:obj[20];
                        var fvoltage=obj[21]==null?0:obj[21];
                        //报警状态：默认0正常，1损坏
                        var zstate=obj[22];
                        var fstate=obj[23];

                        //其他设备
                        var cameranum=obj[24];
                        var boardnum=obj[25];
                        var pilenum=obj[26];
                        var wifinum=obj[27];
                        var zkg="开";
                        var fkg="开";
                        if(zswich!="128"){
                            zkg="关";
                        }
                        if(fswich!="128"){
                            fkg="关";
                        }

                        //测试
//                        maddr="201511220284";
                        if(mlng && mlng!=null){
                            //debugger;
                            var pt = new BMap.Point(mlng,mlat);
                            var lighttype ="0";
                            if(cameranum>0 ||boardnum>0||pilenum>0||wifinum>0){
                                lighttype="1"
                            }

                            var content = '<div style="margin:0;line-height:20px;padding:2px;">' +
                                    '编号：' + mcode + '<br/>' +
                                    '地址：' + maddr + '<br/>' +
                                    '状态：主灯-' + zkg + ',  ' +
                                    '辅灯-' + fkg + '<br/>' +
                                    '电流：  主灯---' + zelectric + 'A,  ' +
                                    '辅灯---' + felectric + 'A<br/>' +
                                    '电压：  主灯---' + zvoltage + 'V,  ' +
                                    '辅灯---' + fvoltage + 'V<br/>' +
                                    '电量：  主灯---' + zelectricity + 'KW,  ' +
                                    '辅灯---' + felectricity + 'KW<br/>' +
                                    '功率：  主灯---' + zpower + 'KWH,' +
                                    '辅灯---' + fpower + 'KWH<br/>' +
                                    '<div style="margin:0;line-height:20px;padding:2px;"><span>设备操作：' + '</span>' +
                                    '<div class="rel">' +
//                                    '<span>查询：' + '</span>' +
                                    ' <ul class="boxtab-btn-map-query abs">' +
                                    ' <li class="" onclick="queryLight(\''+taddr+'\',\''+maddr+'\')">状态查询</li>' +
                                    ' <li class="" onclick="openDeviceControl(\''+taddr+'\',\''+maddr+'\')">其他操作</li>' +
                                    '</ul>' +
                                    '</div>' +
                                    '<div class="rel" title="图标">' +
//                                    '<span>开关灯：' + '</span>' +
                                    ' <ul class="boxtab-btn-map-open abs">' +
                                    ' <li class="" onclick="openMaxLight(\''+taddr+'\',\''+maddr+'\',\''+data_open_value+'\','+data_open_v+','+1+')">摄像头</li>' +
                                    ' <li class="" onclick="openMaxLight(\''+taddr+'\',\''+maddr+'\',\''+data_close_value+'\','+data_close_v+','+2+')">广告牌</li>' +
                                    ' <li class="" onclick="openMinLight(\''+taddr+'\',\''+maddr+'\',\''+data_open_value+'\','+data_open_v+','+3+')">充电桩</li>' +
                                    ' <li class="" onclick="openMinLight(\''+taddr+'\',\''+maddr+'\',\''+data_close_value+'\','+data_close_v+','+4+')">wifi</li>' +
                                    '</ul>' +
//                                    ' <ul class="boxtab-btn-map-open-1 abs">' +
//                                    ' <li class="" onclick="openAllLight(\''+taddr+'\',\''+maddr+'\',\''+data_open_value+'\','+data_open_v+','+5+')">全部开</li>' +
//                                    ' <li class="" onclick="openAllLight(\''+taddr+'\',\''+maddr+'\',\''+data_close_value+'\','+data_close_v+','+6+')">全部关</li>' +
//                                    '</ul>' +
                                    '</div>' +
//                                    '<div class="rel">' +
////                                    '<span>调光：' + '</span>' +
//                                    ' <ul class="boxtab-btn-map-tg abs">' +
////                                    ' <li class=""><input type="text"min="0" max="10" step="1" value="50"></li>' +
//                                    ' <li class="" onclick="openMaxLight(\''+taddr+'\',\''+maddr+'\',\''+data_tg_value+'\','+50+','+7+')">主灯调光</li>' +
//                                    ' <li class="" onclick="openMinLight(\''+taddr+'\',\''+maddr+'\',\''+data_tg_value+'\','+50+','+8+')">辅灯调光</li>' +
//                                    ' <li class="" onclick="openAllLight(\''+taddr+'\',\''+maddr+'\',\''+data_tg_value+'\','+50+','+9+')">全部调光</li>' +
//                                    '</ul>' +
//                                    '</div>' +
                                    '</div> ' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="queryLight(\''+taddr+'\',\''+maddr+'\')">'+'查询状态'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMaxLight(\''+taddr+'\',\''+maddr+'\',\''+data_open_value+'\','+data_open_v+','+1+')">'+'主灯开'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMaxLight(\''+taddr+'\',\''+maddr+'\',\''+data_close_value+'\','+data_close_v+','+2+')">'+'主灯关'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMaxLight(\''+taddr+'\',\''+maddr+'\',\''+data_tg_value+'\','+50+','+7+')">'+'主灯调光'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMinLight(\''+taddr+'\',\''+maddr+'\',\''+data_open_value+'\','+data_open_v+','+3+')">'+'辅灯开'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMinLight(\''+taddr+'\',\''+maddr+'\',\''+data_close_value+'\','+data_close_v+','+4+')">'+'辅灯关'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openMinLight(\''+taddr+'\',\''+maddr+'\',\''+data_tg_value+'\','+50+','+8+')">'+'辅灯调光'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openAllLight(\''+taddr+'\',\''+maddr+'\',\''+data_open_value+'\','+data_open_v+','+5+')">'+'全部开'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openAllLight(\''+taddr+'\',\''+maddr+'\',\''+data_close_value+'\','+data_close_v+','+6+')">'+'全部关'+'</a>'+'<br/>' +
//                                    '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="openAllLight(\''+taddr+'\',\''+maddr+'\',\''+data_tg_value+'\','+50+','+9+')">'+'全部调光'+'</a>'+'<br/>' +
                                    '</div>';
                            addDeviceMarker(pt,content,lighttype,"编号:"+mcode);
                        }



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
