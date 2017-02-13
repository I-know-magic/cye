<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/10/24
  Time: 17:28
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.validate.js',base: '..')}"></script>
    <title>收款账号设置</title>
    <script type="text/javascript">
        $(function () {
            var height = $(window).height();
            $(".member-box").css({"height": (height - 70 - 24-70-20) + "px"});
            $.post("<g:createLink base=".." controller="accountSet" action="getPayAccount"/>",function(data){
                var result = eval('(' + data + ')');
                $("#ZFBPID").textbox('setValue',result.alipayPartner);
                $("#ZFBKey").textbox('setValue',result.alipayKey);
//                $("#WXAPPID").textbox('setValue',result.wechatPayAppid);
                $("#WXMacId").textbox('setValue',result.wechatPaySubMchid);
//                $("#WXKey").textbox('setValue',result.wechatPayKey);
                if($("#ZFBPID").textbox('getValue')!=""&&$("#ZFBKey").textbox('getValue')!=""){
                    document.getElementById("zTest").disabled=false;
                    $("#zTest").css("backgroundColor","#0ae");
                }
                if($("#WXMacId").textbox('getValue') ){
                    document.getElementById("wTest").disabled=false;
                    $("#wTest").css("backgroundColor","#0ae");
                }
            });
        });
        function apply(){
            $("#apply").show()
        }
        function closeApply(){
            $("#apply").hide()
        }
        function saveInfo(){
            var ZFBPID = $("#ZFBPID").textbox('getValue');
            var ZFBKey = $("#ZFBKey").textbox('getValue');
//            var WXAPPID = $("#WXAPPID").textbox('getValue');
            var WXAPPID = '';
            var WXMacId = $("#WXMacId").textbox('getValue');
//            var WXKey = $("#WXKey").textbox('getValue');
            var WXKey = '';
            if(ZFBPID!=''||ZFBKey!=''){
                if(ZFBPID==""){
                    $.messager.alert("系统提示", "请填写合作者身份(PID)", 'info');
                    return
                }
                if(ZFBKey==""){
                    $.messager.alert("系统提示", "请填写安全校验码(Key)", 'info');
                    return
                }
               if(!$("#ZFB").form('validate')) {
                   return
               }

            }
//            if(WXAPPID!=""||WXMacId!=""||WXKey!=""){
            if(WXMacId!=""){
//                if(WXAPPID==""){
//                    $.messager.alert("系统提示", "请填写APPID", 'info');
//                    return
//                }
                if(WXMacId==""){
                    $.messager.alert("系统提示", "请填写微信支付商户号(mch_id)", 'info');
                    return
                }
//                if(WXKey==""){
//                    $.messager.alert("系统提示", "请填写API密钥(Key)", 'info');
//                    return
//                }
                if(!$("#WX").form('validate')){
                    return
                }
            }

            $.post("<g:createLink base=".." controller="accountSet" action="saveInfo"/>?ZFBPID="+ZFBPID+"&ZFBKey="+ZFBKey+"&WXAPPID="+WXAPPID+"&WXMacId="
                    +WXMacId+"&WXKey="+WXKey,function(data){
                var result = eval('(' + data + ')');
                if(result.success == "true"){
                    $.messager.alert("系统提示", result.msg, 'info',function(){
                        location.replace("<g:createLink base=".." controller="accountSet" action="index"/>")
                    });
                }else{
                    $.messager.alert("系统提示", result.msg, 'error');
                }

            })

        }
        var isZFB = false;
        var isWX = false;
        function testPay(flag){
            $("#test").form('clear');
            if(flag == "ZFB"){
                isZFB = true;
                isWX = false;
            }else if(flag == "WX"){
                isZFB = false;
                isWX = true;
            }
            $("#testPay").dialog('open').dialog("setTitle","测试支付");
        }
        function cancelTest(){
            $("#testPay").dialog('close');
        }
        function confirTest(){
            var payCode = $("#payCode").numberbox('getValue');
            if(payCode == ""){
                $.messager.alert("系统提示", '请输入或扫描支付条码', 'info');
                return
            }
            if(!$("#test").form('validate')){
                return
            }
            var url;
            if(isZFB){
                url = "<g:createLink base=".." controller="accountSet" action="testPay"/>?flag=zfb&payCode="+payCode
            }else if(isWX){
                url = "<g:createLink base=".." controller="accountSet" action="testPay"/>?flag=wx&payCode="+payCode
            }
            $.post(url,function(data){
                var result = eval('(' + data + ')');
                if(result.success == "true"){
                    $.messager.alert("系统提示", result.msg, 'info',function(){
                        cancelTest();
                    });
                }else{
                    $.messager.alert("系统提示", result.msg, 'error');
                }
            });

        }
    </script>
    <style type="text/css">
        .pop-up-box{
            left:40%
        }
        .title {
            width: 120px;
        }
        .pay_p .textbox{width:240px!important;padding:0 0px;margin-left:20px}
        .pay_p .textbox input{width:240px!important;padding:0 0px;height: 36px!important;}
    </style>
</head>

<body>
<h3 class="rel ovf">
    <span>收款账号设置</span>
</h3>

<div class="rel clearfix function-btn" style="">
    <ul class="boxtab-btn abs">
        <li class="icon save" onclick="saveInfo()">保存</li>
    </ul>
</div>

<div class="member-box clearfix receipt-wrap">
    <div class="weixin-box clearfix">
        <div class="weixin-box-r fl">
            <h4 class="weixin-top rel"><span class="abs">支付宝支付设置</span></h4>
            <form id="ZFB" >
                <div class="weixin-box-input clearfix">
                    <p class="btn-txt">
                        <input class="btn" type="button" value="申请开通" onclick="apply()">
                        <input class="btn" type="button" value="测试支付" onclick="testPay('ZFB')" disabled="disabled" style="background-color: #c5c9cb" id="zTest">
                    </p>

                    <p class="pay_p">
                        <span>合作者身份(PID):</span>
                        <input class="easyui-textbox" type="text" id="ZFBPID" name="ZFBPID"  data-options="validType:'length[0,50]'">
                    </p>

                    <p class="pay_p">
                        <span>安全校验码(Key):</span>
                        <input class="easyui-textbox"  type="text" id="ZFBKey" name="ZFBKey" data-options="validType:'length[0,50]'">
                    </p>
                </div>
            </form>

        </div>

        <div class="weixin-box-r fr" style="border:none;">
            <h4 class="weixin-top rel"><span class="abs">微信支付设置</span></h4>
            <form id="WX">
                <div class="weixin-box-input clearfix">
                    <p class="btn-txt">
                        <input class="btn" type="button" value="申请开通" onclick="apply()">
                        <input class="btn" type="button" value="测试支付" onclick="testPay('WX')" disabled="disabled" style="background-color: #c5c9cb" id="wTest">
                    </p>

                    %{--<p class="pay_p">--}%
                        %{--<span>APPID:</span>--}%
                        %{--<input class="easyui-textbox" type="text" id="WXAPPID" name="WXAPPID" data-options="validType:'length[0,50]'">--}%
                    %{--</p>--}%

                    <p class="pay_p">
                        <span>微信支付商户号(mch_id):</span>
                        <input class="easyui-textbox" type="text" id="WXMacId" name="WXMacId" data-options="validType:'length[0,50]'">
                    </p>

                    %{--<p class="pay_p">--}%
                        %{--<span>API密钥(Key):</span>--}%
                        %{--<input class="easyui-textbox" type="text" id="WXKey" name="WXKey" data-options="validType:'length[0,50]'">--}%
                    %{--</p>--}%
                </div>
            </form>

        </div>
    </div>

    <div class="pop-up-box" style="display:none;" id="apply">
        <h4 class="rel">联系方式<a href="" class="icon abs"></a></h4>

        <p>申请开通请联系我们 : 400-033-9199</p>

        <p class="btn-box"><input type="button" value="确定" onclick="closeApply()"></p>
    </div>
    <div id="testPay" class="easyui-dialog "data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
         buttons="#infoWindow-buttons" style="width:500px;height:200px;">
        <form id="test">
            <table cellpadding="5" style="table-layout:fixed;margin-top: 30px;margin-left: 30px">
                <tr>
                    <td >请输入或扫描支付条码:</td>
                    <td>
                        <input class="easyui-textbox" type="text" name="payCode" id="payCode" data-options="validType:'eighteenNumber'" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div id="infoWindow-buttons">
        <a  href="javascript:void(0)" class="easyui-linkbutton  class_branch_op" iconCls="icon-ok"
           onclick="confirTest()">确定</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
           onclick="cancelTest()">取消</a>
    </div>
</div>
</body>
</html>