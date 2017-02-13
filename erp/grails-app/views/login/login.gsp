<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/6/8
  Time: 9:50
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title></title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/lgui.css', base: '.')}" type="text/css">
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '.')}"></script>
    %{--<script type="text/javascript" src="${resource(dir:'easyui',file:'jquery.min.js',base: '.')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'portal.js', base: '.')}"></script>
    <script type="text/javascript">
//        $(function () {
//            $('#checkCodeImg').click(function () {
//                var timenow = new Date().getTime();
//                this.src = this.src + "?d=" + timenow
//            });
//        });
        //当用户输入第四个字符的时候校验验证码的正确性
        %{--function checkCodeFirst() {--}%
            %{--var parm = $('#checkCode').val();--}%
            %{--if (parm.length == 4) {--}%
                %{--$.ajax({--}%
                    %{--type: 'GET',--}%
                    %{--async: true,--}%
                    %{--url: '<g:createLink   base="." controller='login' action='asyValidateCode'/>?yzCode=' + parm,--}%
                    %{--dataType: 'json',--}%
                    %{--success: function (data) {--}%
                        %{--if (data.validate) {--}%
                            %{--$('#yzmessage').html('<img  src="${resource( base:'.' ,dir: 'easyui', file: 'themes/icons/ok.png')}">');--}%
                            %{--return--}%
                        %{--}--}%
                        %{--$('#yzmessage').html('<img  src="${resource( base:'.' ,dir: 'easyui', file: 'themes/icons/cancel.png')}">');--}%
                        %{--return--}%
                    %{--},--}%
                    %{--error: function () {--}%
                        %{--alert("无法获取验证码信息信息.");--}%
                    %{--}--}%
                %{--});--}%
            %{--} else {--}%
                %{--$('#yzmessage').html('<img  src="${resource( base:'.' ,dir: 'easyui', file: 'themes/icons/cancel.png')}">');--}%
                %{--return--}%
            %{--}--}%
        %{--}--}%
    </script>
</head>

<body>
<section class="login">
    <div class="login-wrap">
        <div class="login-w-logo1">
            %{--<a href="<g:createLink base='..' controller='login' action='saasHome'/>">--}%


            %{--<img src="${resource(dir:'css', file:'login/image/login-logo1.png',base:'.')}" alt="">--}%

            %{--</a>--}%
        </div>
        <div class="login-title-txt rel"><span class="abs">用户登录</span></div>
        <div class="login-btn">
            <div class="tc login-l">
                <form action="<g:createLink base="." controller="login" action="employeeLogin"/>" method="post">
                    <p class="rel">
                        <span style="display:inline-block;">账 号：</span>
                        <input type="text" name="staffName" placeholder="用户名" required="required" value="${staffName}">
                    </p>
                    <p class="rel">
                        <span style="display:inline-block;">密 码：</span>
                        <input type="password" id="staffPwd" name="staffPwd" name="tenantPwd" placeholder="请输入用户密码" required="required">
                    </p>
                    <p class="login-button-l">
                        <span style="display:inline-block;"></span>
                        <input type="submit"  value="登 录">
                    </p>
                    %{--<p><span class="fl"><a href="<g:createLink base="." controller="login" action="findpass"/>" style="margin-right: 70px">忘记密码？</a></span><span class="fr">没有账号，<a href="<g:createLink base="." controller="login" action="register"/>">直接注册</a></span></p>--}%
                </form>
                <g:if test="${flash.message}">
                    <div class="message" style="text-align: center"><h3 style="color: #ff0000"><g:message code="${flash.message}"/></h3>
                    </div>
                </g:if>
            </div>
            %{--<div class="fr login-r">--}%
                %{--公众号二维码--}%
                %{--<img src="${resource(dir:'css', file:'login/image/code2.png' ,base:'.')}" alt="">--}%
                %{--<p class="login-code-txt">请使用微信扫描二维码注册</p>--}%
            %{--</div>--}%
        </div>
    </div>
    <div class="copyright-txt abs">
        %{--<p>济南市历城区食药监监制</p>--}%
    </div>
</section>
</body>
</html>