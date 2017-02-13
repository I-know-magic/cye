<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/10/26
  Time: 18:46
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>完善商户信息</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'init/init.css', base: '..')}" type="text/css">
    <script type="text/javascript">
        var businessId = "${businessId}";
        var provinceId = "${provinceId}";
        var cityId = "${cityId}";
        var countryId = "${countryId}";
        var addressDetail = "${addressDetail}";
        var type = "${type}";
        var sessionId = "${sessionId}";
        $(function () {
            $.post('<g:createLink base=".." controller='mainFrame' action='getInitInfo'/>?businessId='+businessId+"&type=2",function(data){
                $.each(data,function(index,value){
                    $("#contant").append("<p>"+value.name+"</p>")
                });
            });
        });
        function back(){
            location.replace("<g:createLink base=".." controller='mainFrame' action='initCategory'/>?businessId="+businessId+"&provinceId="+provinceId+"&countryId="
            +countryId+"&cityId="+cityId+"&addressDetail="+addressDetail+"&type="+type+"&sessionId="+sessionId)
        }
        function next(){
            location.replace("<g:createLink base=".." controller='mainFrame' action='initGoodsSpec'/>?businessId="+businessId+"&provinceId="+provinceId+"&countryId="
            +countryId+"&cityId="+cityId+"&addressDetail="+addressDetail+"&type="+type+"&sessionId="+sessionId)
        }
    </script>
</head>

<body>
<div class="wrap">
    <h2 class="logo rel clearfix">
        <img class="fl" src="${resource(dir: 'css', file: 'mainFrame/img/logo.png', base: '..')}">
        <span class="abs">初始化设置</span>
    </h2>

    <div class="step">
        <ul class="clearfix">
            <li class="current">
                <p class="rel line line-l">
                    <span class="abs">1</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">完善商户信息</p>
            </li>
            <li class="current">
                <!-- 当前状态li跟已完成状态的li的class上都加上current -->
                <p class="rel line">
                    <span class="abs">2</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">菜品分类</p>
            </li>
            <li class="current">
                <p class="rel line">
                    <span class="abs">3</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">菜品单位</p>
            </li>
            <li class="">
                <p class="rel line line-r">
                    <span class="abs">4</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">菜品口味</p>
            </li>
        </ul>
    </div>

    <div class="monitor">
        <div class="monitor-box-txt" style="border:1px solid #999;" id="contant">
        </div>

        <div class="monitor-box-txt"><p class="beizhu">系统将为您初始化单位数据，您可以在初始化完成后进行修改。</p></div>

        <p class="button">
            <input type="button" class="btn btn-back" value="上一步" onclick="back()">
            <input type="button" class="btn" value="下一步" onclick="next()">
        </p>
    </div>

    <div class="copy-bottom">
        <p>Copyright © 2015 智汇方象（青岛）软件有限公司 鲁ICP备15025493号</p>
    </div>
</div>
</body>
</html>