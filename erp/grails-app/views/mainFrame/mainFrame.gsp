<%@ page import="com.smart.common.util.PropertyUtils" %>
<!doctype html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>智慧收银平台</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mainFrame/base.css', base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/bootstrap/easyui.css', base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/icon.css', base: '..')}" type="text/css">
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'easyui', file: 'jquery.min.js', base: '..')}"></script>--}%
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.validate.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'jquery.easyui.min.js', base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'easyloader.js', base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'locale/easyui-lang-zh_CN.js', base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.json.js', base: '..')}"></script>
    <script src="${resource(base: "..", dir: "js", file: "common/jquery.cookie.js")}" type="text/javascript"></script>
    <script type="text/javascript">
        var _dic_all_url = "<g:createLink controller="sysDict" action="qryAllDics" base=".." />"
        var _dic_key_url = "<g:createLink controller="sysDict" action="qryDicByKey" base=".."/>";
    </script>
    <script type="text/javascript">
        $(function () {
            %{--var src ="${com.smart.common.util.PropertyUtils.getDefault("home_url")}/home/index" ;--}%
            %{--var src ="${com.smart.common.util.PropertyUtils.getDefault("home_url")}/goods/index" ;--}%
            var userType=${userType};
            %{--if(userType=='1'){--}%
                %{--src="${PropertyUtils.getDefault("home_url")}/tabCustomerOrder/index" ;--}%
            %{--}--}%
            $("#mainFrame").attr("src","");


            $("body").bind("keydown", function(event) {
                if (event.keyCode == 116) {
                    frames["mainFrame"].window.location.reload();
                    return false;
                }
//                if(event.keyCode == 8){
//                   return false;
//                }
            });
            //$(":input").bind("keydown", function(event) {
            //    if(event.keyCode == 8){
            //        return true;
            //    }
            //});
            auto_win();
            $(window).resize(function () {
                auto_win();
            })
            $(".menu1").bind("click", function () {
                if($(".menu1[mid='" + $(this).attr("mid") + "'] i").hasClass("current")){
                    $(".menu1[mid='" + $(this).attr("mid") + "'] i").removeClass("current");
                    $(".menu2[pid='" + $(this).attr("mid") + "']").hide("slow");
                }else{
                    $(".menu1[mid!='" + $(this).attr("mid") + "'] i").removeClass("current");
                    $(this).find("i").addClass("current");
                    $(".menu2[pid!='" + $(this).attr("mid") + "']").hide("slow");
                    $("[pid='" + $(this).attr("mid") + "']").show("slow");
                }

            })
            $(".jsparent").hover(
                    function () {
                        $(this).addClass("current");
                        $("#per_list").stop(true).slideDown("slow");
                    },
                    function () {
                        $(this).removeClass("current");
                        hid_pre();
                    }
            );
            $(".jscurrent").hover(
                    function () {
                        $(this).addClass("current")
                    },
                    function () {
                        $(this).removeClass("current")
                    }
            )
//            refresh();
        })
        function openFrame(url, obj, position) {
            hid_pre();
            $("[menuId='menu3']").removeClass("current");
            $(obj).addClass("current");
            var first_param = false;
            if (url.indexOf("?") == -1) {
                url += "?";
                first_param = true;
            } else {
                if (url.indexOf("?") == url.indexOf("?").length - 1) {
                    first_param = true;
                }
            }
            if (first_param) {
                url += "_position=" + encodeURI(encodeURI(position))
            } else {
                url += "&_position=" + encodeURI(encodeURI(position))
            }
            $("#mainFrame").attr("src", url);
        }
        function logout() {
            location.href = "<g:createLink base=".." controller="login" action="logout"  />";
        }
        function ordernew() {
            var url = "<g:createLink base=".." controller="login" action="ordernew"  />";
            window.open(url)
        }
        function myOrder() {
            var url = "<g:createLink base=".." controller="login" action="myOrder"  />";
            window.open(url)
        }
        function userDoc() {
            var url = "<g:createLink base='..' controller='login' action='userDoc'/>";
            window.open(url)
        }
        function changePwd() {
            hid_pre();
            $("#_data_div").data("loginName",'${loginName}');
            $("#yptPwd_dialog").dialog("open").dialog("setTitle","登录密码修改");
        }
        function closePwdDialog(){
            $("#yptPwd_dialog").dialog("close");
        }
        function changePosPwd(){
            hid_pre();
            $("#_data_div").data("loginName",'${userCode}');
            $("#pos_dialog").dialog("open").dialog("setTitle","POS登录密码");
        }
        function closePosDialog(){
            $("#pos_dialog").dialog("close");
        }
        function refreshTenant(text) {
            $("#tenant_name").text(text)
        }
        function editInfo() {
            hid_pre();
            $("#info_dialog").dialog("open").dialog('setTitle', "商户信息");
        }
        function editPersonInfo() {
            hid_pre();
            $("#personal_dialog").dialog("open").dialog('setTitle', "个人信息");
        }
        function accountBind(){
            hid_pre();
            $("#_data_div").data("loginName", '${loginName}');
            $("#bind_dialog").dialog("open").dialog('setTitle', '帐号绑定');
        }
        function closeEditWin() {
            $("#info_dialog").dialog("close");
        }
        function closePersonalWin() {
            $("#personal_dialog").dialog("close");
        }
        function closeBindWin(){
            $("#bind_dialog").dialog("close");
        }
        function hid_pre() {
            $("#per_list").stop(true).slideUp("slow");
        }
        function auto_win() {
            var height = $(window).height();
            $(".box").css({"height": (height - 70 ) + "px"});
            var width = $(window).width();
            $(".box-table").css({"width": (width - 160) + "px"})
            var height = $(window).height();
            $(".box-table-wrap").css({"height": (height - 40 - 70 - 24-10) + "px"});
        }
        /**
         * 刷新报警信息
         * @param text
         */
        function refresh() {
            var url = '<g:createLink controller="tabWaringInfo" action="refresh"  base=".."  />'
            $.ajax({
                type: "GET",
                url: url,
                cache: false,
                //async: false,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        var carno=data.carno;
                        var waringinfo=data.waringcontent;
                        var id=data.id;
                        var carid=data.carid;
                        if(carno){
                            $("#id").val(id);
                            $("#carid").val(carid);
                            $("#carno").text(carno+",有异常事件，请处理！");
                            $("#but_make").text("确定处理");
                            $("#waring_info").text(waringinfo);
                        }

                    } else {
                        $.messager.alert('系统提示', data.msg, 'error');
                    }
                }
            });

        }
//        setInterval('refresh()',30000);
        function makewarning() {
//        //debugger;
            var id=$("#id").val()
            if(id){
                var url = '<g:createLink controller="tabWaringInfo" action="makewarning"  base=".."  />?id='+id;
                $.ajax({
                    type: "GET",
                    url: url,
                    cache: false,
                    //async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data.success == "true") {
                            $("#id").val("");
                            $("#carid").val("");
                            $("#carno").text("");
                            $("#but_make").text("");

                            $("#waring_info").text("");
                        } else {
                            $.messager.alert('系统提示', data.msg, 'error');
                        }
                    }
                });
            }


        }
    </script>
</head>

<body>
<div class="header">
    <h2 class="logo fl">
        %{--logo图片--}%
        %{--<img--}%
                %{--src="${resource(dir: 'css', file: '/mainFrame/img/logo.png', base: '..')}" alt="">--}%
        %{--mainFrame/img/logo.png--}%
    </h2>

    <div class="user-txt fl">
        <p width="200px">欢迎您，<span id="tenant_userName">${userName}<span style="color: #a47104">【${branchName}】</span></span></p>
        <p><a href="javascript:void(0)" onclick="logout()">[ 退 出 ]</a>
        </p>
    </div>

    <div class="header-nav fr ovf" style="width: 700px">
        <ul>
            <li class="headnav-txt" style="width: 500px">
                <input type="hidden" id="id">
                <input type="hidden" id="carid">
                %{--<p>路灯编码：<span style="margin-right: 37px;margin-left: 10px" id="carno" ></span><span><a href="javascript:void(0)" onclick="makewarning()" id="but_make" style="color: #b52b27"></a></span></p>--}%
                %{--<p>报警信息：<span style="margin-right: 37px;margin-left: 10px" id="waring_info"></span></p>--}%
            </li>
            %{--<li class="headnav-txt" style="width: 500px">--}%
                %{--<p>车牌号：<span style="margin-right: 37px;margin-left: 10px" id="carno"></span><span></span></p>--}%
                %{--<p>报警信息：<span style="margin-right: 37px;margin-left: 10px" id="waring_info"></span></p>--}%
            %{--</li>--}%
            <li class="headnav-user jsparent">
                <a href="#" id="per" class="icon">帐号信息</a>
                <i class="icon"></i>

                <div id="per_list" is_hid="true" class="pull-list abs clearfix" style="display:none;">
                    <g:if test="${userType == '2'} || ${userType == '1'}">
                        <span class="clearfix"><a href="javascript:void(0)" onclick="changePwd()">用户密码</a></span>
                        %{--<span class="clearfix"><a href="javascript:void(0)" onclick="editInfo()">商户信息</a></span>--}%
                    </g:if>
                    %{--<span class="clearfix"><a href="#" onclick="editPersonInfo()">个人信息</a></span>--}%
                    %{--<span class="clearfix"><a href="javascript:void(0)" onclick="changePwd()">车管家密码</a></span>--}%
                    %{--<g:if test="${roleCode == '02'}">--}%
                    <g:if test="${userType == '3'}">
                        <span class="clearfix"><a href="javascript:void(0)" onclick=" changePosPwd()">app密码</a></span>
                    </g:if>
                    %{--</g:if>--}%
                    %{--<span class="clearfix"><a href="javascript:void(0)" onclick="accountBind()">帐号绑定</a>--}%
                    %{--</span>--}%
                </div>
            </li>
            %{--<g:if test="${userType == '1'}">--}%
                %{--<li class="headnav-money jscurrent" onclick="ordernew()">--}%
                    %{--<a href="javascript:void(0)" class="icon">帐号续费</a>--}%
                    %{--<i></i>--}%
                %{--</li>--}%
                %{--<li class="headnav-order jscurrent" onclick="myOrder()">--}%
                    %{--<a href="#" class="icon">我的订单</a>--}%
                    %{--<i></i>--}%
                %{--</li>--}%
            %{--</g:if>--}%
            %{--<li class="headnav-help jscurrent" onclick="userDoc()">--}%
                %{--<a href="#" class="icon">用户手册</a>--}%
                %{--<i></i>--}%
            %{--</li>--}%
        </ul>
    </div>
</div>

<div class="box">
    <div class="box-nav fl ovf" style="overflow-y: auto">
        <ul>
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/home/index')">首页<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/mainFrame/getMap')">地图监控<i class="abs current"></i></h4>--}%
            %{--基础资料--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/sysDept/index')">部门管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/employeeRole/index')">角色管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/sysEmp/index')">员工管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseArea/index')">区域管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseTerminal/index')">集中控制器管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseBoundDevice/index')">终端设备管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseChargingPile/index')">充电桩查询-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseBillBoard/index')">广告牌查询-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseCamera/index')">摄像头查询-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseWifi/index')">wifi查询-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseGroup/index')">分组管理-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseGroupBoundDeviceR/index')">分组-终端设备管理-1<i class="abs current"></i></h4>--}%
            %{--业务--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/baseDeviceSync/index')">档案同步<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busTerminalDateSet/index')">时段任务设置<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busTerminalEnergySet/index')">集中器节能设置<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busTerminalData/index')">集中控制器实时数据信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busTerminalHisData/index')">集中控制器历史数据信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busBoundDeviceData/index')">终端设备实时信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busBoundDeviceHisData/index')">终端设备历史信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busTerminalWarningSet/index')">集中控制器报警设置<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busWarningHisData/index')">报警历史数据<i class="abs current"></i></h4>--}%

            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busChargingPileData/index')">充电桩设备实时信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busChargingPileHisData/index')">充电桩设备历史信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busLog/index')">操作日志<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busBillBoardData/index')">广告牌实时信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busWifiData/index')">wifi实时信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busCameraData/index')">高清摄像实时信息<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/busWifiData/index')">线损统计<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/jobScheduler/index')">定时任务-1<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/chart/index')">图表<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/chart/chartline')">图表-曲线<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/chart/chartcolumn')">图表-柱状<i class="abs current"></i></h4>--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/chart/chartpie')">图表-饼图<i class="abs current"></i></h4>--}%

            %{--<g:if test="${userType == '2'}">--}%
            %{--<h4 class="rel menu1" onclick="openFrame('${PropertyUtils.getDefault("home_url")}/mainFrame/getMap')">地图监控<i class="abs current"></i></h4>--}%
        %{--</g:if>--}%
    <g:each in="${parentMenuList}" var="pm" status="i">
                <li>
                <!-- 当前的li在i标签class上加current-->
                    <g:if test="${i == 0}">
                        <h4 class="rel menu1" mid="${pm.id}">${pm.resName}<i class="icon abs "></i></h4>
                    </g:if>
                    <g:else>
                        <h4 class="rel menu1" mid="${pm.id}">${pm.resName}<i class="icon abs"></i></h4>
                    </g:else>
                    <g:each in="${sysMap}" var="sys">
                        <g:if test="${sys.key?.asType(BigInteger) == pm.id}">
                            <g:if test="${i == 0}">
                                <ul class="box-nav-child menu2" pid="${pm.id}" style="display: none">
                            </g:if>
                            <g:else>
                                <ul class="box-nav-child menu2" pid="${pm.id}" style="display: none">
                            </g:else>
                            <g:each in="${sys.value}" var="sysMenu" status="j">
                                <g:if test="${sysMenu.memo!=null}">
                                    <li class="" menuId="menu3"
                                        onclick="openFrame('<g:createLink base=".." controller="${sysMenu.controllerName}" action="${sysMenu.packageName}" />?${sysMenu.memo}', this,'${pm.resName},${sysMenu.resName}')"
                                        id="showOrders"><i
                                            class="icon icon-${(j + 1) % 8 == 0 ? 1 : (j + 1) % 8}"></i>${sysMenu.resName}
                                    </li>
                                </g:if>
                                <g:else>
                                    <li class="" menuId="menu3"
                                        onclick="openFrame('<g:createLink base=".." controller="${sysMenu.controllerName}" action="index" />', this,'${pm.resName},${sysMenu.resName}')"
                                        id="showOrders"><i
                                            class="icon icon-${(j + 1) % 8 == 0 ? 1 : (j + 1) % 8}"></i>${sysMenu.resName}
                                    </li>
                                </g:else>
                            </g:each>
                            </ul>
                        </g:if>
                    </g:each>
                </li>
            </g:each>
        </ul>
    </div>

    <div class="box-table fr ovf">
        <div class="box-table-wrap ovf">
            <iframe id="mainFrame" name="mainFrame" style="width:100%;height:100%;border: hidden;overflow: hidden">
            </iframe>
        </div>
    </div>
</div>

<div class="footer">
    %{--<p>济南市历城区食药监监制</p>--}%
</div>

<div id="info_dialog" class="easyui-dialog"
     data-options="cache:false,modal:true,closed:true,closable:true,href:'<g:createLink base=".." controller="tenant"
                                                                                         action="index"/>',top:'160px'"
     style="width:650px;height:500px;padding-left: 56px;overflow-x: hidden;overflow-y: hidden" buttons="#footer">
</div>

<div id="footer">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="false" onclick="myAdd()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="false"
       onclick="closeEditWin()">取消</a>
</div>

<div id="personal_dialog" class="easyui-dialog"
     data-options="cache:false,modal:true,closed:true,closable:true,href:'<g:createLink base=".." controller="login"
                                                                                         action="showAccountSetting"/>',top:'160px'"
     style="width:550px;height:280px;padding-left: 86px;overflow-x: hidden;overflow-y: hidden" buttons="#info-button">
</div>

<div id="info-button">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="false" onclick="saveUpdate()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="false"
       onclick="closePersonalWin()">取消</a>
</div>
<div id="bind_dialog" class="easyui-dialog"
     data-options="cache:false,modal:true,closed:true,closable:true,href:'<g:createLink base=".." controller="account"
                                                                                        action="index"/>',top:'160px'"
     style="width:650px;height:300px;padding-left: 86px;overflow-x: hidden;overflow-y: hidden" buttons="#bind-button">
</div>
<div id="bind-button" >
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="false"
       onclick="closeBindWin()">确定</a>
</div>
<div id="yptPwd_dialog" class="easyui-dialog"
     data-options="cache:false,modal:true,closed:true,closable:true,href:'<g:createLink base=".." controller="login"
                                                                                         action="showChangePwd"/>',top:'160px'"
     style="width:550px;height:300px;padding-left: 60px;overflow-x: hidden;overflow-y: hidden" buttons="#yptPwd-button">
</div>
<div id="yptPwd-button">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="false" onclick="confirmEdit()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="false"
       onclick="closePwdDialog()">取消</a>
</div>
<div id="pos_dialog" class="easyui-dialog"
     data-options="cache:false,modal:true,closed:true,closable:true,href:'<g:createLink base=".." controller="login"
                                                                                         action="showChangePosPwd"/>',top:'160px'"
     style="width:550px;height:300px;padding-left: 60px;overflow-x: hidden;overflow-y: hidden" buttons="#pos-button">
</div>
<div id="pos-button">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="false" onclick="confirmPOSPwd()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="false"
       onclick="closePosDialog()">取消</a>
</div>
<div id="_data_div" style="display: none"></div>
</body>
%{--<script type="text/javascript">--}%
    %{--var _op_json = <%=request.getSession().getAttribute("op")%>;--}%
    %{--var _op_object = [];--}%
    %{--if (_op_json) {--}%
        %{--for (var i in _op_json) {--}%
            %{--var _resList = _op_json[i]["resList"];--}%
            %{--for (var j in _resList) {--}%
                %{--var _res_id = _resList[j]["resId"];--}%
                %{--var _opList = _resList[j]["opList"];--}%
                %{--for (var g in _opList) {--}%
                    %{--_op_object.push(_res_id + "_" + _opList[g]["opId"]);--}%
                %{--}--}%
            %{--}--}%
        %{--}--}%
        %{--$.cookie("_op_json", $.toJSON(_op_object), {path: "/"});--}%
    %{--}--}%

%{--</script>--}%
</html>