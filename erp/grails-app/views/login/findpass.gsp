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
    <title>惠管家-找回密码</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/lgui.css', base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'login/base.css', base: '..')}" type="text/css">




    <script type="text/javascript" src="${resource(dir: 'js', file: 'portal.js', base: '..')}"></script>
    <meta name="viewport" content="width=device-width" />
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" /> -->
    <!-- 声明以ie浏览器的最高级别显示页面，如果浏览器内含chrome frame，则以chrome内核展示页面 -->
    <meta http-equiv="X-UA-Compatible" content="IE=Edeg,chrome=1" />

</head>
<body>
<!--[if lt IE 8]>
<![endif]-->
<div class=get-password-wrapper>
    <div class="logo clearfix">
        logo
    </div>
    <div class="product-login get-password clearfix">
        <h3>找回密码</h3>
        <form class="si-form" action="<g:createLink base="." controller="login" action="findpass"  />" method="post">
            <table index="0" >
                <tr>
                    <g:if test="${flash.message}">
                        <div class="message" style="text-align: center"><h3 style="color: #ff0000"><g:message code="${flash.message}"/></h3>
                        </div>
                    </g:if>
                </tr>
                <tr>
                    <td>请输入您绑定惠管家账号的手机号码：</td>
                </tr>

                <tr>
                    <td class="input-td"> <div class="field"><label class="required" for="Account"></label>
                        <div class="field-inner">
                            <input class="login-text" data-val="true" data-val-required="请输入账号"  id="Account" name="Account" placeHolder="手机号" type="text" value="" onblur="valphone(this)"/>
                        </div>
                    </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a id="sendValidateCode" class="si-btn next blue">下一步</a>
                    </td>
                </tr>
                <tr>
                    <td style="color: #ff0000" class="messageerror"></td>
                </tr>
            </table>
            <table index="1" style="display:none">
                <tr>
                    <td class="message"></td>
                </tr>
                <tr>
                    <td class="input-td"><div class="field">
                        <label class="required" for="ValidateCode"></label>
                        <div class="field-inner">
                            <input class="login-text validate-text" required="true"  data-val="true" data-val-required="请输入验证码" id="ValidateCode" name="ValidateCode" placeHolder="输入验证码" type="text" value="" />
                        </div></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a id="verifyPassword" class="si-btn next blue">下一步</a>
                    </td>
                </tr>

                <tr>
                    <td style="color: #ff0000" class="messageerror"></td>
                </tr>
                <tr>
                    <td style="display:none" class="tenantId"></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<div id="footer">
    <p>&copy; 版权所有 青岛方象软件科技有限公司 Copyright 2014</p>
    %{--<p><a href="http://smartpos.top" target="_blank">http://smartpos.top</a></p>--}%
</div>
<script type="text/javascript">
    var $form = $('.si-form');
    $form.off('click').on('click', '#sendValidateCode:not(".readonly")', function () {

        if(/^1[0-9]{10}$/.test($('#Account').val())==false){
            $('.si-form').validateErrors([{
                element: $('#Account'),
                msg:"手机号码不正确"
            }])
            return false
        }else{
            $('.si-form').validate({ iconShowable: true  });
        }

        var _this = this;
        $(this).addClass("readonly");
        $.ajax({
            type: 'GET',
            async: true,
            url: '<g:createLink base=".." controller="login" action="validatebind"  />?Account='+$('#Account').val(),
            dataType: 'json',
            success: function (data) {
                if (data.success=='true') {
                        $('table[index="1"] td.message', $form).html(data.msg);
                        $('table[index="1"] td.tenantId', $form).html(data.employee.tenantId);
                        $('table[index="0"]', $form).hide();
                        $('table[index="1"]', $form).show();
                }else {
                    $('table[index="0"] td.messageerror', $form).html(data.msg);
//                    $('.si-form').validateErrors([{
//                        element: $('#Account'),
//                        msg: data.msg
//                    }])
                    $(_this).removeClass("readonly");
                }
            }
        });
    });
    $('#verifyPassword').on('click', function () {
        if (!$('#ValidateCode').validate({ errorShowable: false })) {
            return false;
        }
        if (!$('#ValidateCode').validate({ tipType: 'arrow-down', iconShowable: true })) {
            return false;
        }
        $.ajax({
            type: 'GET',
            async: true,
            url: '<g:createLink base=".." controller="login" action="openresepass"  />?ValidateCode='+$('#ValidateCode').val()+'&Account='+$('#Account').val(),
            dataType: 'json',
            success: function (data) {
                if (data.success=='true') {
                    window.location.assign("<g:createLink base=".." controller="login" action="resetpass"/>?tenantId="+ $('table[index="1"] td.tenantId', $form).html());
                }else {
                    $('.si-form').validate({ iconShowable: true  });
                    $('.si-form').validateErrors([{
                        element: $('#ValidateCode'),
                        msg: data.msg
                    }])
                }
            }
        });
    });
    function valphone(data){
        if(/^1[0-9]{10}$/.test(data.value)==false){
            $('.si-form').validateErrors([{
                element: $('#Account'),
                msg:"手机号码不正确"
            }])
        }else{
            $('.si-form').validate({ iconShowable: true  });
        }
    }
</script>


</body>
</html>