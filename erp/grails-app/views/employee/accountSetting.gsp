<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/7/1
  Time: 14:30
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>账号设置</title>
</head>

<body class="easyui-layout" style="width: 100%;height: 100%">
<script type="text/javascript">
    $(function () {
        var sexVal = ${employee?.sex}+"";

        if (sexVal == "1") {
            $('input:radio[name="sex"][value="1"]').prop('checked', true);

        }
        if (sexVal == "2") {
            $('input:radio[name="sex"][value="2"]').prop('checked', true);

        }

    });

    function saveUpdate() {
        $('#personalInfo').form('submit', {
            url: "<g:createLink base=".." controller="employee" action="doAccountSetting"  />",
            onSubmit: function () {
                var isValid = $('#personalInfo').form('validate');
                if (!isValid) {
                    return isValid
                }

            },
            success: function (data) {
                var result = eval('(' + data + ')');
                if (result.success == 'true') {
                    window.parent.refresh($("#employeeName").val())
                    $.messager.alert("系统提示", result.msg, 'info', function () {
                        window.parent.closePersonalWin();
                    });
                } else if (result.success == 'false') {
                    $.messager.alert("系统提示", result.msg);
                }

            }
        });

    }


</script>

<div data-options="region:'center',split:true,border:false" style="width: 100%;height: 100%">
        <form id="personalInfo">
            <table cellpadding="5">
                <tr>
                    <td style="text-align: right">工号：</td>
                    <td>
                        <input class="easyui-textbox" type="text" id="employeeCode" style="width: 250px;height: 25px"
                               readonly="readonly" value="${employee?.code}">
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">姓名：</td>
                    <td><input class="easyui-validatebox textbox" type="text" id="employeeName" name="name"
                               style="width: 250px;height: 25px" value="${employee?.name}"
                               data-options="required:true,validType:'length[1,20]',missingMessage:'姓名为必填项',invalidMessage:'长度不超过20个汉字或字符！'"></td>
                </tr>
                <tr>
                    <td style="text-align: right">性别：</td>
                    <td>
                        <input name="sex" type="radio" class="easyui-validatebox" checked="checked" required="true"
                               value="1">男　
                        <input name="sex" type="radio" class="easyui-validatebox" required="true" value="2">女
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">生日：</td>
                    <td>
                        <input class="easyui-datebox" type="text" name="birthday" style="width:250px;height: 25px"
                               editable="false"
                               value="${employee?.birthday}"/>
                    </td>
                </tr>
                %{--<tr>--}%
                %{--<td style="text-align: right">手机：</td>--}%
                %{--<td>--}%
                %{--<input class="easyui-validatebox textbox" type="text" name="phone" id="phone"--}%
                %{--style="height: 25px" value="${employee?.phone}" data-options="validType:'mobilePhone'">--}%
                %{--</td>--}%
                %{--</tr>--}%

            </table>
            <input type="hidden" name="id" id="id" value="${employee?.id}">
        </form>
</div>
</body>
</html>