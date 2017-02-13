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
    <meta charset="utf-8" >
    <title>惠管家-商户信息</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/lgui.css', base: '.')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/base.css', base: '.')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/bootstrap/easyui.css',base: '.')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/icon.css',base: '.')}" type="text/css">
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>
    %{--<script type="text/javascript" src="${resource(dir:'easyui',file:'jquery.min.js',base: '.')}"></script>--}%
    <script type="text/javascript" src="${resource(dir:'easyui',file:'jquery.easyui.min.js',base: '.')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.validate.js',base: '.')}"></script>
    <script type="text/javascript" src="${resource(dir:'easyui',file:'easyloader.js',base: '.')}"></script>
    <script type="text/javascript" src="${resource(dir:'easyui',file:'locale/easyui-lang-zh_CN.js',base: '.')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.form.js',base: '.')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'easyui-ext.js',base: '.')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'portal.js', base: '.')}"></script>
    <meta name="viewport" content="width=device-width" />
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" /> -->
    <!-- 声明以ie浏览器的最高级别显示页面，如果浏览器内含chrome frame，则以chrome内核展示页面 -->
    <meta http-equiv="X-UA-Compatible" content="IE=Edeg,chrome=1" />

</head>
<body>
<!--[if lt IE 8]><![endif]-->
<div class=reset-password-wrapper>
    <div class="logo clearfix">

    </div>
    ﻿<style  type="text/css">
.reg-result p.download {
    margin: 0;
    width: 82%;
}
.reg-result p.download a{
    font-weight:normal;
    height: 30px;
    line-height: 30px;
    margin-right: 8px;
}
</style>
    <div class="product-login reg-result clearfix">
        <g:if test="${flash.message}">
            <p class="message" style="text-align: center"><h3 style="color: #ff0000"><g:message code="${flash.message}"/></h3>
            </p>
        </g:if>
        <h3 class="title"><b class="success "></b>密码已重置成功</h3>
        <p class="message" style="">请注意留存如下账号信息</p>
        %{--，我们同时为您发送了手机短信--}%
        <p class="message box">&nbsp;&nbsp;&nbsp;商户号:&nbsp;&nbsp;&nbsp;${tenantCode}<br>用户账号:&nbsp;&nbsp;&nbsp;${loginName}<br>登录密码:&nbsp;&nbsp;&nbsp;${pass}</p>
        <p class="message download">
            <a  class="si-btn green" href="" alt="收银客户端" >PC客户端</a>
            <a  class="si-btn green"  href="" alt="收银客户端">Android客户端</a>
        </p>
        <a href="<g:createLink base=".." controller="login" action="login"  />" class="return-login si-btn blue" style="">返回登录</a>

    </div>

</div>
<div id="footer">
    <p>&copy; 版权所有 青岛方象软件科技有限公司 Copyright 2014</p>
    %{--<p><a href="http://smartpos.top" target="_blank">http://smartpos.top</a></p>--}%
</div>
</body>
</html>