<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <title>帐号绑定</title>
</head>
<body class="easyui-layout" style="width: 100%;height: 100%">
<script type="text/javascript">
    $(function () {
        var email = $('#email').val();
        var qq = $('#qq').val();
        var phone = $('#phone').val();
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="account" action="validates"/>?phone=" + phone + "&qq=" + qq + "&email=" + email,
            dataType: 'json',
            success: function (data) {
                if (data.success == 'true') {
                    if (data.isBindMobile) {
                        $("#msgphone").css("display", "none")
                        $("#removephone").hide()
                        $("#phone").textbox({})
                        $('#phone').textbox('readonly', false)
                    } else {
                        $("#msgphone").css("display", "block")
                        $("#bindphone").hide()
                        $('#phone').textbox('readonly')
                    }
                    if (data.isBindEmail) {
                        $("#msgemail").css("display", "none")
                        $("#removeemail").hide()
                        $("#email").textbox({})
                        $('#email').textbox('readonly', false)
                    } else {
                        $("#msgemail").css("display", "block")
                        $("#bindemail").hide()
                        $('#email').textbox('readonly')
                    }
                    if (data.isBindQQ) {
                        $("#msgqq").css("display", "none")
                        $("#removeqq").hide()
                        $("#qq").textbox({})
                        $('#qq').textbox('readonly', false)
                    } else {
                        $("#msgqq").css("display", "block")
                        $("#bindqq").hide()
                        $('#qq').textbox('readonly')
                    }

                } else if (data.success == 'false') {
                    $.messager.alert("系统提示", "页面加载错误","error");
                }
            }
        });

    });
    var phone;
    function bind() {
        phone = $("#phone").val();
        $("#showPhone").html();
        $("#checkPhone").val();
        $("#authCode").val();
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="employee" action="smsSendAuthCode"/>?phone=" + phone,
            dataType: 'json',
            success: function (data) {
                eval(data)
                if (data.success == 'true') {
                    $("#bindPhonewin").dialog("open");
                    $("#showPhone").html(phone);
                    $("#checkPhone").val(phone);
                } else if (data.success == 'false') {
                    $.messager.alert("系统提示", data.msg,"info");
                }
            }
        });
    }
    function bindQQ() {
        var qq = $("#qq").val();
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="employee" action="bindqq"/>?qq=" + qq,
            dataType: 'json',
            success: function (data) {
                $.messager.alert("系统提示", data.msg,"info");

            }
        });
    }
    function bindEmail() {
        var email = $("#email").val();
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="employee" action="bindEmail"/>?email=" + email,
            dataType: 'json',
            success: function (data) {
                $.messager.alert("系统提示", data.msg,"info");
            }
        });
    }
    function removebind() {
        phone = $("#phone").val();
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="employee" action="removeMobileBind"/>",
            dataType: 'json',
            success: function (data) {
                eval(data)
                if (data.success == 'true') {
                    $("#msgphone").css("display", "none")
                    $("#removephone").hide()
                    $("#bindphone").show()
                    $("#phone").textbox("clear")
                    $("#phone").textbox({})
                    $('#phone').textbox('readonly', false)
                } else if (data.success == 'false') {
                    $.messager.alert("系统提示", result.msg,"error");
                }
            }
        });
    }
    function removebingEmail() {
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="employee" action="removeEmailBind"/>",
            dataType: 'json',
            success: function (data) {
                eval(data)
                if (data.success == 'true') {
                    $("#msgemail").css("display", "none")
                    $("#removeemail").hide()
                    $("#bindemail").show()
                    $("#email").textbox("clear")
                    $("#email").textbox({})
                    $('#email').textbox('readonly', false)
                } else if (data.success == 'false') {
                    $.messager.alert("系统提示", result.msg,"error");
                }
            }
        });
    }
    function removebingQQ() {
        $.ajax({
            type: 'GET',
            async: true,
            url: "<g:createLink base=".."  controller="employee" action="removeQqBind"/>",
            dataType: 'json',
            success: function (data) {
                eval(data)
                if (data.success == 'true') {
                    $("#msgqq").css("display", "none")
                    $("#removeqq").hide()
                    $("#bindqq").show()
                    $("#qq").textbox("clear")
                    $("#qq").textbox({})
                    $('#qq').textbox('readonly', false)
                } else if (data.success == 'false') {
                    $.messager.alert("系统提示", result.msg,"error");
                }
            }
        });
    }
    function cancelBind() {
        $("#bindPhonewin").dialog("close");
    }
    function confirmBind() {
        $('#checkCodeForm').form('submit', {
            url: "<g:createLink base=".."   controller="employee" action="bindMobile"  />",
            success: function (data) {
                var result = eval('(' + data + ')');
                if (result.success == 'true') {
                    $.messager.alert("系统提示", result.msg,"info");
                    cancelBind();
                    $("#msgphone").css("display", "block")
                    $("#removephone").show()
                    $("#bindphone").hide()
                    $('#phone').textbox('readonly')
                } else if (result.success == 'false') {
                    $.messager.alert("系统提示", result.msg,"error");
                }

            }
        });
    }
    $(function(){
        $("#acloginName").val($("#_data_div").data("loginName"))
    })
</script>

%{--<div data-options="region:'center',split:true" style="width: 100%;height: 100%">--}%
    <form id="ff" method="post">
            <table cellpadding="5" style="table-layout:fixed;">
                <tr>
                    <td class="title"  style="text-align: right">商户号：</td>
                    <td>
                        <input class="easyui-textbox" type="text" name="tenantCode" readonly="readonly" value="${tenantCode}">
                        %{--<input type="text" name="tenantCode" value="${tenantCode}" style="border: hidden" readonly="readonly"/>--}%
                    </td>
                </tr>
                <tr>
                    <td class="title"  style="text-align: right">工号：</td>
                    <td>
                        <input class="easyui-textbox" type="text" name="code" readonly="readonly" value="${code}">
                        %{--<input type="text" name="code" value="${code}" style="border: hidden" readonly="readonly">--}%
                    </td>
                </tr>
                <tr>
                    <td class="title" style="text-align: right"><div style="width: 124px;">登录帐号：</div></td>
                    <td>
                        <input class="easyui-textbox" type="text" name="loginName" id="acloginName" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <td class="title"  style="text-align: right">手机号：</td>
                    <td><input class="easyui-textbox" type="text" id="phone" name="phone"
                               data-options="validType:'mobilePhone'"
                               value="${phone}">

                    </td>
                    <td id="msgphone" style="display: none;line-height: 40px;">已验证</td>
                    <td>
                        <a class="easyui-linkbutton" id="removephone" href="javascript:void(0)"
                           onclick="removebind()">解除绑定</a>
                        <a class="easyui-linkbutton" id="bindphone" href="javascript:void(0)" onclick="bind()">立即绑定</a>
                    </td>
                </tr>
                %{--<tr>--}%
                    %{--<td>邮箱:</td>--}%
                    %{--<td>--}%
                        %{--<input class="easyui-textbox" type="text" id="email" name="email"--}%
                               %{--data-options="validType:'email'" value="${email}">--}%
                    %{--</td>--}%
                    %{--<td id="msgemail" style="display: none">已验证</td>--}%
                    %{--<td>--}%
                        %{--<a class="easyui-linkbutton" id="removeemail" href="javascript:void(0)"--}%
                           %{--onclick="removebingEmail()">解除绑定</a>--}%
                        %{--<a class="easyui-linkbutton" id="bindemail" href="javascript:void(0)"--}%
                           %{--onclick="bindEmail()">立即绑定</a>--}%
                    %{--</td>--}%
                %{--</tr>--}%
                %{--<tr>--}%
                    %{--<td>QQ:</td>--}%
                    %{--<td>--}%
                        %{--<input class="easyui-textbox" type="text" id="qq" name="qq" data-options="validType:'QQ'"--}%
                               %{--value="${qq}"/>--}%
                    %{--</td>--}%
                    %{--<td id="msgqq" style="display: none">已验证</td>--}%
                    %{--<td>--}%
                        %{--<a class="easyui-linkbutton" id="removeqq" href="javascript:void(0)"--}%
                           %{--onclick="removebingQQ()">解除绑定</a>--}%
                        %{--<a class="easyui-linkbutton" id="bindqq" href="javascript:void(0)" onclick="bindQQ()">立即绑定</a>--}%
                    %{--</td--}%
                %{--</tr>--}%
            </table>
        </form>
%{--</div>--}%

<div id="bindPhonewin" class="easyui-dialog" data-options="modal:true,closed:true,iconCls:'icon-save',title:'校验'"
     buttons="#infoWindow-buttons" style="width:400px;height:200px;">
    <form id="checkCodeForm" method="post">
        <div STYLE="text-align: center">
            已给手机号为<span id="showPhone"></span>发送验证码
        </div>
        <table>
            <tr>
                <td>验证码：</td>
                <td><input class="easyui-validatebox textbox" type="text" name="authCode" id="authCode"
                           data-options="required:true"/></td>
            </tr>
        </table>
        <input type="hidden" name="checkPhone" id="checkPhone">
    </form>
</div>

<div id="infoWindow-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="confirmBind()">确定</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="cancelBind()">取消</a>
</div>
<script>
    function submitForm() {
        $('#ff').form('submit');
    }
    function clearForm() {
        $('#ff').form('clear');
    }
</script>
</body>
</html>

