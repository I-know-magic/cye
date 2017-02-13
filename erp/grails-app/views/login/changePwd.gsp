<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/7/1
  Time: 18:11
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>登录密码</title>
    <style type="text/css">

    </style>
</head>

<body>
<script type="text/javascript">
    function confirmEdit() {
        var $oldPwd = $("#oldPass").val();
        var $newPwd = $("#newPass").val();

        $('#yptPwd').form('submit', {
            url: "<g:createLink base=".." controller="login" action="doChangePwd"  />"
            ,
            onSubmit: function () {
                var isValid = $('#yptPwd').form('validate');
                if (!isValid) {
                    return isValid
                }
                if ($oldPwd == $newPwd) {
                    $.messager.alert("系统提示", "原密码和新密码相同，不允许修改！", "info");
                    return false
                }

            },
            success: function (data) {
                var result = eval('(' + data + ')');
                if (result.success == 'true') {
                    $.messager.alert("系统提示", result.msg, "info", function () {
                        window.parent.closePwdDialog();
                        $("#yptPwd").form("clear");
                    });

                } else if (result.success == 'false') {
                    $.messager.alert("系统提示", result.msg, "error");
                }

            }
        });


    }
    $(function(){
        $("#ptloginName").val($("#_data_div").data("loginName"))
    })
</script>

<div>
    <form id="yptPwd" method="post">
        <table cellpadding="5" style="table-layout:fixed;">
            <tr>
                <td class="title" style="text-align: right"><div style="width: 124px;">登录帐号：</div></td>
                <td>
                    <input class="easyui-textbox" type="text" name="loginName" id="ptloginName" readonly="readonly"/>
                </td>
            </tr>
            <tr>
                <td class="title" style="text-align: right">原密码：</td>
                <td><input class="easyui-textbox" type="password" name="oldPwd" id="oldPass"
                           placeholder="请输入原密码" data-options="required:true" style="width: 250px;height: 25px"/></td>
            </tr>
            <tr>
                <td class="title" style="text-align: right">新密码：</td>
                <td><input class="easyui-textbox" type="password" name="newPwd" id="newPass"
                           placeholder="请输入新密码" data-options="required:true,validType:['passVal']"
                           style="width: 250px;height: 25px"/></td>
            </tr>
            <tr>
                <td class="title" style="text-align: right">确认新密码：</td>
                <td><input class="easyui-textbox" type="password" name="confirmPwd" id="confirmPass"
                           placeholder="请再次输入新密码" data-options="required:true" validType="equalTo['#newPass']"
                           style="width: 250px;height: 25px"/></td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>