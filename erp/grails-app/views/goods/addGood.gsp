<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/6/25
  Time: 18:38
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title></title>
</head>

<body>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'goods/goods.css',base: '..' )}" type="text/css">
<script type="text/javascript" src="${resource(dir:'js',file:'goods/goods.js',base: '..')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'goodsSpec/goodsSpec.js',base: '..')}"></script>
<style type="text/css">
.addr-details-remark .textbox-invalid{width: 622px !important;height: 60px !important;}
.addr-details-remark .textbox{width: 622px !important;height: 60px !important;}
.addr-details-remark .textbox-text{width: 622px !important;overflow: hidden;height: 60px !important;}
.title{width:80px;}
.goodsSpec-height .textbox.combo{  width: 622px !important;height: 36px !important;  }
.goodsSpec-height .textbox-text{  width: 622px !important;overflow: hidden;height: 36px !important;  }
.goodsSpec-height .textbox-invalid{  width: 622px !important;height: 36px !important;  }
.title{width:85px;}
</style>
<script type="text/javascript">

    var orderTable;
    var is = false;
    var mnemonicFlage = -1;
    var isAdd = true;
    $(function(){
        loadComboTree('category_id', '<g:createLink base=".." controller='category' action='loadNoRootTreeData'/>', 'goodsCode', '<g:createLink base=".." controller='goods' action='getNextGoodsCode'/>',true);
        loadBoxData('goodsUnitId', '<g:createLink base=".." controller="goodsUnit" action="queryUnitBox"/>', 'unitName');
    })
    /**
     * 图片上传
     */
    function ajaxFileUpLoad(){
        $.ajaxFileUpload({
            url:"<g:createLink base=".." controller="goods" action="upLoadFile"/>",
            async:true,
            secureuri:false,
            fileElementId:"fileUpLoad",
            dataType:"JSON",
            success:function(data){
                if(data.success=="false"){
                    $.messager.alert("系统提示",""+data.msg+"","info");
                    return;
                }
                $("#img").attr("src",data.filePath);
                $("input[name='photo']").val(""+data.dbpath+"");
            }
        })
    }

    function  integrate(obj,checkId){
        if(obj.checked){
            if(checkId=="init"){
                $("#"+checkId+"").numberbox("enable");
            }
            if(checkId=="init2"){
                $("#"+checkId+"").textbox("enable");
            }

        }
        else{
            if(checkId=="init"){
                $("#"+checkId+"").numberbox("disable");
            }
            if(checkId=="init2"){
                $("#"+checkId+"").textbox("disable");
            }
        }
    }

    function saveGood(){
        var val = $('#category_id').combobox('getValue');
        var val1 = $('#goodsUnitId').combobox('getValue');
        if(val == '' || val == null){
            $.messager.alert("系统提示","  请设置分类","info");
            return ;
        }
        if(val1 == '' || val1 == null){
            $.messager.alert("系统提示","请设置单位","info");
            return ;
        }
        goodSave("goodsOrder", "<g:createLink base=".." controller='goods' action='save'  />");

    }
    function goodSave(formId,url){
        $("#"+formId+"").form('submit',{
            url:url,
            onSubmit: function(){
                if($(this).form('validate')){
                    return true;
                }else{
                    return false;
                }
            },
            success: function(result){
                var result = eval('('+result+')');
                if (result.success == "false"){
                    $.messager.alert('系统提示', result.msg, 'error' );
                } else {
                    $.messager.alert('系统提示',"保存成功！", 'info',function(){
                        closeWindow();
                    });
                }
            },
            onLoadError:function(){
                $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error' );
            }
        });
    }
    function change_mnemonic(newVal,oldVal){
        if(newVal){
            var is = /^[a-zA-Z0-9]+$/.test(newVal);
            if(!is){
                $("#mnemonic").textbox('setValue',oldVal);
            }
        }
    }
    function goods_Name(url) {
        var gn = $('#goodsName').textbox('getValue');
        if (gn == '' || gn == null) {
            $('#mnemonic').textbox('setValue', '');
            return;
        }
        url = url + '?goodsCode=' + gn;
        $.post(encodeURI(url), function (data) {
            if (true) {
                mnemonicFlage = 1;
                if (mnemonicFlage > 0) {
                    $('#mnemonic').textbox('setValue', data);
                }
                mnemonicFlage = 2;
            }
            else {
            }
        });
    }
    function setVipPrice2(newVal,oldVal){
//        debugger;
//        alert(newVal);
    //        $('#vipPrice-1').numberbox('setValue',newVal);
    //        $('#vipPrice-2').numberbox('setValue',newVal);
    //        $('#purchasingPrice').numberbox('setValue',newVal);

    }
</script>
<form id="goodsOrder" method="post">
    <input type="reset" style="display:none;"/>
    <table cellpadding="5" border="0" style="table-layout:fixed;">
        <input type="hidden" name="id"/>
        <input id="photo" type="hidden" name="photo"/>
        <tr>
            <td class="title"><div style="width: 130px;">分类:</div></td>
            <td><input class="easyui-textbox" id="category_id" name="categoryId" data-options="required:true,missingMessage:'分类为必填项'"/></td>
            <td class="title">中文名称:</td>
            <td>
                <input class="easyui-textbox" type="text" name="goodsName" id="goodsName"
                       data-options="required:true,missingMessage:'商品名称为必填项',validType:['goodsNameValid','length[1,20]'],
                                   onChange:function(){goods_Name('<g:createLink base=".." controller="goods"
                                                                                 action="getMnemonic"/>')}"/>
            </td>
            <td rowspan="2" style="text-align: right;width: 210px; ">
                <img id="img" src="" style="width:200px;height:100px"/>
            </td>
        </tr>
        <tr>
            <td class="title">英文名称:</td>
            <td>
                <input class="easyui-textbox" type="text" name="goodsName2" id="goodsName2"
                       data-options="required:true,missingMessage:'商品名称为必填项',validType:['goodsNameValid','length[1,20]']
                                   %{--onChange:function(){goods_Name('<g:createLink base=".." controller="goods"
                                                                                action="getMnemonic"/>')}--}%"/>
            </td>
            <td  class="title">售价:</td>
            <td>
                <input class="easyui-numberbox" type="text" name="salePrice"
                       data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'售价为必填项',onChange:setVipPrice2" value="0"/>
            </td>
            %{--<td class="title">助记码:</td>--}%
            %{--<td>--}%
                %{--<input class="easyui-textbox" type="text" id="mnemonic" name="mnemonic"--}%
                       %{--data-options="required:true,editable:true,validType:'length[1,20]',--}%
                                   %{--missingMessage:'助记码为必填项',invalidMessage:'长度不超过20个汉字或字符！',onChange:change_mnemonic"/>--}%
            %{--</td>--}%
        </tr>

        <tr>
            %{--<td class="title">单位:</td>--}%
            %{--<td><select id="goodsUnitId" name="goodsUnitId"></select></td>--}%

            <td class="title">会员价-1:</td>
            <td><input class="easyui-numberbox" type="text" name="vipPrice" id="vipPrice-1"
                       data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'会员价-1为必填项'" value="0"/>
            </td>
            <td>
                <div style="text-align: center">
                    <a href="javascript:void(0)" class="a-upload">
                        <input type="file" name="file" id="fileUpLoad" onchange="ajaxFileUpLoad(this)">点击这里上传图片
                    </a>
                </div>
            </td>
        </tr>
        <tr>
            <td class="title">会员价-2:</td>
            <td>
                <input class="easyui-numberbox" type="text" name="vipPrice2" id="vipPrice-2"
                       data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'会员价-2为必填项'" value="0"/>
            </td>
            %{--<td class="title">会员价-2:</td>--}%
            %{--<td>--}%
                %{--<input class="easyui-numberbox" type="text" name="vipPrice2" id="vipPrice-2"--}%
                       %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'会员价-2为必填项'" value="0"/>--}%
            %{--</td>--}%
        </tr>
        <tr>
            <td class="title">配货价-1:</td>
            <td><input class="easyui-numberbox" type="text" name="shippingPrice1" id="shippingPrice1"
                       data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'配货价-1为必填项'"
                       value="0"/>
            </td>
            <td class="title">配货价-2:</td>
            <td>
                <input class="easyui-numberbox" type="text" name="shippingPrice2" id="shippingPrice2"
                       data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'配货价-2为必填项'"
                       value="0"/>
            </td>
        </tr>
        <tr>
            <td class="title">进价:</td>
            <td>
                <input class="easyui-numberbox" type="text" name="purchasingPrice" id="purchasingPrice"
                       data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'进价为必填项'" value="0"/>
            </td>
            <td class="title">状态:</td>
            <td>
                <select id="stat" class="easyui-combobox" name="goodsStatus" panelHeight="auto"
                        editable="false">
                    <option value="0">正常</option>
                    <option value="1">停售</option>
                    %{--<option value="2">停够</option>--}%
                    %{--<option value="3">淘汰</option>--}%
                </select>
            </td>
        </tr>
        %{--<tr>--}%
            %{--<td class="title">参数:</td>--}%
            %{--<td style="text-align: left" colspan="3">--}%
                %{--<input type="checkbox" name="isForPoints" value="true"><span--}%
                    %{--style="height: 100%;margin-right: 17px;margin-left: 5px">允许折扣</span>--}%
                %{--<input type="checkbox" name="isTakeout"--}%
                       %{--value="true"><span--}%
                    %{--style="height: 100%;margin-right: 17px;margin-left: 5px">允许外卖</span>--}%
                %{--<input type="checkbox" name="isStore" value="true" id="isStore"--}%
                       %{--class="c_g_type" >--}%
                %{--<span style="height: 100%;margin-right: 17px;margin-left: 5px">管理库存</span>--}%
                %{--<input type="checkbox" name="isWeigh" value="true" id="isWeigh" >--}%
                %{--<span style="height: 100%;margin-right: 17px;margin-left: 5px">是否称重</span>--}%
                %{--<input type="checkbox" name="isPricetag" value="true" id="isPricetag">--}%
                %{--<span style="height: 100%;margin-right: 17px;margin-left: 5px">是否打印标价签</span>--}%
                %{--<input type="checkbox" name="goodsType" value="3" id="goodsType" onclick="goodsTypeClick(this)"><span--}%
                    %{--style="height: 100%;;margin-left: 5px">原料</span>--}%
            %{--</td>--}%
        %{--</tr>--}%
        %{--<tr>--}%
            %{--<td class="title">前台角标:</td>--}%
            %{--<td>--}%
                %{--<input type="checkbox" name="isRecommended" value="true"><span--}%
                    %{--style="height: 100%;margin-right: 17px;margin-left: 5px">推荐</span>--}%
                %{--<input type="checkbox" name="isNewgood" value="true">--}%
                %{--<span style="height: 100%;margin-left: 5px;margin-right: 17px">新品</span>--}%
                %{--<input type="checkbox" name="isChangeprice" value="true">--}%
                %{--<span style="height: 100%;margin-left: 5px;margin-right: 17px">时价商品</span>--}%
            %{--</td>--}%
        %{--</tr>--}%
        %{--<tr>--}%

            %{--<td class="title">口味:</td>--}%
            %{--<td colspan="3" class="goodsSpec-height">--}%
                %{--<input class="easyui-combobox" name="goodsSpec" id="goodsSpec"--}%
                       %{--data-options="url:'<g:createLink base=".." controller="goodsSpec" action="queryBox"/>',--}%
                                    %{--method:'get',--}%
                                    %{--valueField:'id',--}%
                                    %{--editable:false,--}%
                                    %{--textField:'property',--}%
                                    %{--multiple:true,--}%
                                    %{--panelHeight:130">--}%
            %{--</td>--}%
            %{--<td></td>--}%
        %{--</tr>--}%
        <tr>
            <td class="title">描述:</td>
            <td colspan="3" class="addr-details-remark">
                <input class="easyui-textbox" type="text" name="goodsDesc"
                       data-options="prompt:'请输入商品描述',multiline:true,validType:'maxLength[50]',invalidMessage:'长度不超过50个汉字或字符！'"/>
            </td>
        </tr>
    </table>
</form>
</body>

</html>