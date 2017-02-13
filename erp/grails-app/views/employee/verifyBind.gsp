<!doctype html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" charset="utf-8">
    <title>绑定邮箱</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/lgui.css',base: '..')}">
    <script type="text/javascript" src="${resource(dir:'easyui',file:'jquery.min.js',base: '..')}"></script>
    <script language="javascript">
        var flag=${flag}
        $(function(){
            if(flag==true){
                $(".js_success").show();
            }else{
                $(".js_fail").show();
            }
        })
        // 这个脚本是 ie6和ie7 通用的脚本
        //FF中需要修改配置window.close方法才能有作用，为了不需要用户去手动修改，所以用一个空白页面显示并且让后退按钮失效
        //Opera浏览器旧版本(小于等于12.16版本)内核是Presto，window.close方法有作用，但页面不是关闭只是跳转到空白页面，后退按钮有效，也需要特殊处理
        function custom_close(){
            if
            (confirm("您确定要关闭本页吗？")){
                var browserName=navigator.appName;
                if (browserName=='Netscape') {
                    window.open('','_self','');
                    window.close();
                } else {
                    window.opener=null;
                    window.open('','_self');
                    window.close();
                }

            }
            else{}
        }
        function openLogin(){
            window.location.href="<g:createLink base=".." controller="login" action="login"/>"
        }
    </script>
</head>
<body style="background: #fdfefe">
<header class="header">
    <div class="header-wrap rel clearfix">
        <div class="logo fl">

        </div>
        <div class="nav fr">
            <ul class="nav-main clearfix abs">
                <li></li>
                <li></li>
                <li></li>
                <li></li>
            </ul>
            <ul class="nav-ass clearfix abs">
                <li></li>
                <li></li>
                <li></li>
                <li class="nav-tel"><i class=""></i></li>
            </ul>
        </div>
    </div>
</header>
<!-- 内容开始 -->
<section >
    <input type="hidden" value="${flag}">
    <div class="way">
    </div>
    <div class="bind-e-warp clearfix">
        <div class="bind-e-box rel js_fail" style="display:none;">
            <span class="icon fail abs"></span>
            <p class="bind-e-txt">很遗憾，您的邮箱绑定失败。</p>
            <p>点击<span><a href="javascript:void(0)" onClick="custom_close()">关闭本页</a></span></p>
        </div>
        <div class="bind-e-box rel js_success" style="display:none;">
            <span class="icon suc abs"></span>
            <p class="bind-e-txt">恭喜您，您的邮箱绑定成功。</p>
            <p>点击<span><a href="javascript:void(0)" onclick="openLogin()">立即跳转</a></span></p>
        </div>
        <div class="bind-reason">
            <p class="title">可能由于以下原因：</p>
            <p><i></i>绑定申请提交后的2小时内未确认，链接已过期，如果是这种情况的话，请重新绑定。</p>
            <p><i></i>邮箱已经绑定成功，绑定链接已生效。</p>
            <p><i></i>激活链接有误，请确认是否是从绑定邮件中点击的链接。</p>
        </div>
    </div>
</section>
<!-- 内容结束 -->
</body>
<script>
    function submitForm() {
        $('#ff').form('submit');
    }
    function clearForm() {
        $('#ff').form('clear');
    }
</script>
</html>

