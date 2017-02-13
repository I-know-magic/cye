<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/6/8
  Time: 9:50
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta name="layout" content="main">
    <meta charset="utf-8">
    <title>惠管家-重置密码</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/lgui.css', base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/base.css', base: '..')}" type="text/css">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'portal.js', base: '..')}"></script>
    <meta name="viewport" content="width=device-width"/>
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" /> -->
    <!-- 声明以ie浏览器的最高级别显示页面，如果浏览器内含chrome frame，则以chrome内核展示页面 -->
    <meta http-equiv="X-UA-Compatible" content="IE=Edeg,chrome=1"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edeg,chrome=1" />
</head>
<body>
<!--[if lt IE 8]>
    <![endif]-->
<div class=reset-password-wrapper>
    <div class="logo clearfix">

    </div>

    <div class="product-login reset-password clearfix">
        <h3>重置密码</h3>

        <form action="<g:createLink base=".." controller="login" action="tenantinfo"  />" class="si-form" method="post">

           <table>
               <tr>
                   %{--<input id="tenantId" name="tenantId" type="text" value="${tenantId}"/>--}%
                   <g:if test="${flash.message}">
                       <div class="message" style="text-align: center"><h3 style="color: #ff0000"><g:message code="${flash.message}"/></h3>
                       </div>
                   </g:if>
               </tr>
            <tr>
                <th><label for="Password">新密码</label></th>
                <td><div class="field"><label class="required" for="Password"></label>
                    %{--^[0-9a-zA-Z]{6,20}--}%
                    <div class="field-inner"><input class="login-text" required="true"  data-val="true"
                                                    data-val-length="字段 密码 必须是6-20的字符串。" data-val-length-max="20"
                                                    data-val-length-min="6"
                                                    data-val-required="请输入密码" id="user_psd" name="Password"
                                                    type="password" value="" onblur="valadatePass(this)"/></div></div></td>
            </tr>
            <tr>
                <th><label  class="required" for="ReTypePassword">重复新密码</label></th>
                <td><div class="field"><label class="required" for="ReTypePassword"></label>

                    <div class="field-inner"><input class="login-text" required="true"  data-val="true" data-val-equalto="新密码两次输入不一致"
                                                    data-val-equalto-other="*.Password"
                                                    data-val-length="字段 密码 必须是6-20的字符串。" data-val-length-max="20"
                                                    data-val-length-min="6"
                                                    data-val-required="请再次输入密码" id="user_psd2" name="ReTypePassword"
                                                    type="password" value=""  /></div></div></td>
            </tr>
            <tr>
                <td></td>
                <td><button type="button" class="login-button" onclick="">确定</button>

                </td>
            </tr>

        </table>
           <input id="TenantId" name="TenantId" type="hidden" value="${tenantId}" />
            <input id="TenantCode" name="TenantCode" type="hidden" value="${tenantCode}" />
        </form>

    </div>

</div>

<div id="footer">
    <p>&copy; 版权所有 青岛方象软件科技有限公司 Copyright 2014</p>
    %{--<p><a href="http://smartpos.top" target="_blank">http://smartpos.top</a></p>--}%
</div>
</body>
</html>
<script>
    function valadatePass(data){
        if(/^[0-9a-zA-Z]{6,20}$/.test(data.value)==false){
            $('.si-form').validateErrors([{
                element: $('#user_psd'),
                msg:"密码为6-20位的数字或字母"
            }])
        }else{
            $('.si-form').validate({ iconShowable: true  });
        }
    }

</script>