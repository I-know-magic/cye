<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/5/27
  Time: 11:34
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/lgui.css', base: '..')}" type="text/css">
    <script type="text/javascript">
    $(function(){
        $("#confirmPwd").blur(function(){
            if($(this).val()!=""&&$(this).val()==$("#newPwd").val()){
                $("#tpassw").html("密码输入正确");
            }
            else if($(this).val()!=""){
                $("#tpassw").html("密码确认不正确")
            }
        });
        $("#newPwd").blur(function () {
            if ($(this).val() != "" && !$(this).val().match(/^[\w.]{6,20}$/)) {
                $("#passw").html("请输入正确的密码格式");
                numError++;
            } else if ($(this).val() != "") {
                $("#passw").html("输入正确");
                numError = 0
            }
        });
    });
    </script>
    <title>代理商重置密码</title>
</head>

<body>
<div id="win" class="easyui-window" data-options="closed:false" style="width: 450px;height:200px;padding: -8px" title="代理商修改初始密码">
    <form action="<g:createLink base=".." controller="sysUser" action="resetPassWord"  />" method="get">
    <table>
        <tr>
            <td>初始密码：</td>
            <td><g:textField name="pwd" id="pwd"></g:textField></td>
        </tr>

        <tr>
            <td>新密码：</td>
            <td><g:textField name="newPwd" id="newPwd"></g:textField></td>
            <td><span class="red" id="passw"></span></td>
        </tr>
        <tr>
            <td>确认新密码：</td>
            <td><g:textField id="confirmPwd" name="confirmPwd" ></g:textField></td>
            <td><span class="red" id="tpassw"></span></td>
        </tr>
        <tr style="height: 40px"></tr>
        <tr>
            <td colspan="2" style="text-align: center"><input type="submit" value="确定"></td>
        </tr>
    </table>
    </form>
</div>
</body>
</html>