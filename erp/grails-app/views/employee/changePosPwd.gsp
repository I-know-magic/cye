<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/8/19
  Time: 15:55
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>修改POS登录密码</title>
</head>

<body>
<script type="text/javascript">
    function confirmPOSPwd() {
        var $POSOldPass = $("#POSOldPass").val();
        var $POSNewPass = $("#POSNewPass").val();

        $('#POSPwd').form('submit', {
            url: "<g:createLink base=".." controller="employee" action="doChangePOSPwd"  />"
            ,
            onSubmit: function () {
                var isValid = $('#POSPwd').form('validate');
                if (!isValid) {
                    return isValid
                }
                if ($POSOldPass == $POSNewPass) {
                    $.messager.alert("系统提示", "原密码和新密码相同，不允许修改！", "info");
                    return false
                }
            },
            success: function (data) {
                var result = eval('(' + data + ')');
                if (result.success == 'true') {
                    $.messager.alert("系统提示", result.msg, "info", function () {
                        window.parent.closePosDialog();
                        $("#POSPwd").form("clear");
                    });
                } else if (result.success == 'false') {
                    $.messager.alert("系统提示", result.msg, "error");
                }

            }
        });

    }
    $(function(){
        $("#posloginName").val($("#_data_div").data("loginName"))
    })
</script>

<div>
    <form id="POSPwd" method="post">
        <table cellpadding="5" style="table-layout:fixed;">
            <tr>
                <td class="title" style="text-align: right"><div style="width: 124px;">工号：</div></td>
                <td>
                    <input class="easyui-textbox" type="text" name="loginName" id="posloginName" readonly="readonly"/>
                </td>
            </tr>
            <tr>
                <td  class="title" style="text-align: right">原密码：</td>
                <td><input class="easyui-textbox" type="password" name="oldPwd" id="POSOldPass"
                           placeholder="请输入原密码" data-options="required:true" style="width: 250px;height: 25px"/></td>
            </tr>
            <tr>
                <td  class="title" style="text-align: right">新密码：</td>
                <td><input class="easyui-textbox" type="password" name="newPwd" id="POSNewPass"
                           placeholder="请输入新密码" data-options="required:true,validType:'sixNumber'"
                           style="width: 250px;height: 25px"/></td>
            </tr>
            <tr>
                <td  class="title" style="text-align: right">确认新密码：</td>
                <td><input class="easyui-textbox" type="password" name="confirmPwd" id="POSConfirmPwd"
                           placeholder="请再次输入新密码" data-options="required:true" validType="equalTo['#POSNewPass']"
                           style="width: 250px;height: 25px"/></td>
            </tr>
        </table>
    </form>

</div>
</body>
</html>