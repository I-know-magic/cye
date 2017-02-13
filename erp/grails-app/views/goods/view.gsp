<%@ page import="com.smart.common.util.PropertyUtils" %>
<!doctype html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商品管理</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'goods/goods.css', base: '..')}" type="text/css">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'goods/goods.js', base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'goodsSpec/goodsSpec.js', base: '..')}"></script>
    <style type="text/css">
    .addr-details-remark .textbox-invalid {
        width: 600px !important;
        height: 60px !important;
    }

    .addr-details-remark .textbox {
        width: 600px !important;
        height: 60px !important;
    }

    .addr-details-remark .textbox-text {
        width: 600px !important;
        overflow: hidden;
        height: 60px !important;
    }
    .addr-details-price .numberbox-invalid {
        width: 60px !important;
        height: 36px !important;
    }

    .addr-details-price .numberbox {
        width: 60px !important;
        height: 36px !important;
    }

    .addr-details-price .numberbox-text {
        width: 60px !important;
        overflow: hidden;
        height: 36px !important;
    }

    .title {
        width: 80px;
    }

    .search-width {
        width: 220px;
        width: 226px \9;
    }

    .search-txt-width {
        width: 170px;
    }

    .goodsSpec-height .textbox.combo {
        width: 600px !important;
        height: 36px !important;
    }

    .goodsSpec-height .textbox-text {
        width: 600px !important;
        overflow: hidden;
        height: 36px !important;
    }

    .goodsSpec-height .textbox-invalid {
        width: 600px !important;
        height: 36px !important;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        var is = false;
        var mnemonicFlage = -1;
        var uploadUrl = "<g:createLink controller='goods' action='importGoodsByExcel' base=".."/>"
        var url_goods_m = '<g:createLink base=".." controller="goods" action="getMnemonic"/>';
        var url_goods_check = '<g:createLink base=".." controller="goods" action="checkCode"/>';
        %{--var isHeader = ${isHeader};--}%
        var isAdd;
        var $temp;
        var goodsSpecVal = [];
        $(function () {
//            if (!isHeader) {
//                $('.class_branch_op').hide();
//            }
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
            //创建datagrid对象
            orderTable = new EasyUIExt($("#goodsTable"), "");
            orderTable.singleSelect = false;//是否单选
            orderTable.window = $("#goodsInfoWindow");//dialog
            orderTable.form = $("#goodsOrder");//表单
            orderTable.pagination = true;//是否分页
            orderTable.clickRow = function (index, row) {
            };
            orderTable.mainEasyUIJs();
//            init();
            loadZTree('<g:createLink base=".." controller='category' action='loadZTree'/>');
//            getCheckBox();
        });
        //动态生成口味的checkbox
        %{--function getCheckBox(){--}%
            %{--$temp = $("#goosSpec_td");--}%
            %{--$.post("<g:createLink base=".." controller="goodsSpec" action="queryBox"  />",function(data){--}%
                %{--if(data.length > 0){--}%
                    %{--for(var i = 0;i < data.length;i++){--}%
                        %{--$temp.append($("<input type='checkbox'/>").attr("id",data[i].id).attr("name",data[i].property))--}%
                                %{--.append($("<span></span>").text(data[i].property).css({"margin-right":"17px"}));--}%
                        %{--var $goodsSpec_click = function() {--}%
                            %{--if (this.checked) {--}%
                                %{--if($.inArray(this.id, goodsSpecVal) == -1){--}%
                                    %{--goodsSpecVal.push(this.id);--}%
                                    %{--$("#goodsSpec").val(goodsSpecVal)--}%
                                %{--}--}%
                            %{--}--}%
                            %{--else {--}%
                                %{--var del_index = $.inArray(parseInt(this.id), goodsSpecVal);--}%
                                %{--goodsSpecVal.splice(del_index,1);--}%
                                %{--$("#goodsSpec").val(goodsSpecVal)--}%
                            %{--}--}%

                        %{--};--}%
                        %{--$("#"+data[i].id).click($goodsSpec_click);--}%
                    %{--}--}%
                %{--}else{--}%
                    %{--$temp.append("<span>无</span>")--}%
                %{--}--}%


            %{--},'json');--}%
        %{--}--}%
        function doSearch() {
            $('#goodsTable').datagrid('clearSelections');
            $('#goodsTable').datagrid({
                url: '<g:createLink base=".." controller="goods" action="list"/>',
                queryParams: {
                    goodsCodeOrName: $("#queryStr").val(),
                    categoryIds: $("#categoryIds").val()
                }
            });
        }
        function myAdd() {
            isAdd = true;
            orderTable.reset = false;
            mnemonicFlage = 1;
            $("#img").attr("src", "");
            $("#photo").val('');
            $(".c_g_type").removeAttr("disabled");
            loadComboTree('category_id', '<g:createLink base=".." controller='category' action='loadNoRootTreeData'/>', 'barCode', '<g:createLink base=".." controller='goods' action='getNextGoodsCode'/>', true);
            %{--loadBoxData('goodsUnitId', '<g:createLink base=".." controller="goodsUnit" action="queryUnitBox"/>', 'unitName');--}%
            orderTable.formAction = "<g:createLink base=".." controller="goods" action="save"  />";
            $("#goodsInfoWindow").dialog('open').dialog('setTitle', '商品-增加');

        }
        function edit(id) {
            var rows = $("#goodsTable").datagrid("getSelections");
            if (!id && rows.length != 1 ) {
                $.messager.alert('系统提示', '只有一条商品被选中时才能修改！', 'info');
                return
            }
            if (!id && rows.length == 1 && (rows[0].goodsName == '美团外卖' || rows[0].goodsName == '饿了么外卖')) {
                $.messager.alert('系统提示', '【' + rows[0].goodsName + '】特殊商品不能修改！', 'info');
                return
            }
            isAdd = false;
            mnemonicFlage = 0;
            $("#photo").val('');
            $("#img").attr("src", "");
            %{--loadBoxData('goodsUnitId', '<g:createLink base=".." controller="goodsUnit" action="queryUnitBox"/>', 'unitName', true);--}%
            var data = orderTable.mainEditDish("<g:createLink base=".." controller="goods" action="create"  />", "商品-修改", id);
            loadComboTree('category_id', '<g:createLink base=".." controller='category' action='loadNoRootTreeData'/>', 'catName',null,null,data);
            orderTable.formAction = "<g:createLink base=".." controller="goods" action="update"  />";
            var imgSrc = "${com.smart.common.util.PropertyUtils.getDefault("goods_img_url")}"+$("input[name='photo']").val();
            $("#img").attr("src", imgSrc);
            $('#goodsSpec').combobox('setValues',data.tastesIds);
//            goodsSpecVal = [];
//            var tempGoodsSpec = data.tastesIds.split(',');
//            if(tempGoodsSpec.length > 0){
//               for(var i=0;i<tempGoodsSpec.length;i++){
//                   document.getElementById(tempGoodsSpec[i]).checked = true;
//                   goodsSpecVal.push(tempGoodsSpec[i]);
//                   $("#goodsSpec").val(goodsSpecVal);
//               }
//            }


        }
        function del() {
            var rows = $("#goodsTable").datagrid("getSelections");
            var len = rows.length;
            orderTable.mainDel("<g:createLink base=".." controller="goods" action="del"  />");
        }
        function cleardata() {
            formclear("myForm")
        }

        function addList() {
            var rebackUrl = '<g:createLink base=".." controller="goods" action="index"/>';
            var url = '<g:createLink base=".." controller="goods" action="addListIndex"/>' + "?backUrl=" + rebackUrl;
            $.redirect(url, {_position: "批量添加"})
        }

        /**
         * 图片上传
         */
        function ajaxFileUpLoad() {
            $.ajaxFileUpload({
                url: "<g:createLink base=".." controller="goods" action="upLoadFile"/>",
                secureuri: false,
                fileElementId: "fileUpLoad",
                dataType: "JSON",
                success: function (data) {

                    if (data.success == "false") {
                        $.messager.alert("系统提示", "" + data.msg + "", "info");
                        return;
                    }
                    $("#img").attr("src", data.filePath);
                    $("input[name='photo']").val("" + data.dbpath + "");
                }
            })
        }
        function clearSearch() {
            $("#queryStr").val("");
        }

        function integrate(obj, checkId) {
            if (obj.checked) {
                $("#" + checkId + "").numberspinner("enable").numberspinner("enableValidation").numberspinner("setValue", '0');
            }
            else {
                $("#" + checkId + "").numberspinner("disable").numberspinner("disableValidation").numberspinner("setValue", '');
            }
        }
        function closeWindow() {
            $("#goodsInfoWindow").dialog('close')
        }
        function change_mnemonic(newVal, oldVal) {
            if (newVal) {
                var is = /^[a-zA-Z0-9]+$/.test(newVal);
                if (!is) {
                    $("#mnemonic").textbox('setValue', oldVal);
                }
            }
        }
        function checkCode(newV, oldV) {
            var url = url_goods_check + '?barCode=' + newV;
            $.post(encodeURI(url), function (data) {
                debugger
                if (data.isSuccess=="false") {
                    $.messager.alert("系统提示", "" + "商品条码不能重复!" + "", "info");
                }

            });
        }
        function codeT(val, row) {
            if(row.goodsName == "美团外卖" || row.goodsName == "饿了么外卖"){
                return val
            }
            if (row.id != null) {
                return "<a href='javascript:void(0)' class='code_open' onClick=edit('" + row.id + "')>" + val + "</a>";
            }
            return val;
        }

    </script>
</head>

<body>
<input type="hidden" id="hidden_categoryId" value="${categoryId}">

<h3 class="rel ovf js_header">
    <span></span>-<span></span>-<span></span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li  class="icon add class_branch_op" onclick="myAdd()">新 增</li>
        <li  class="icon alt class_branch_op" onclick="edit()">修 改</li>
        <li  class="icon del class_branch_op" onclick="del()">删 除</li>
        %{--<li  class="icon bat class_branch_op" onclick="addList()">批量添加</li>--}%
        <g:if test="${backUrl != '' && categoryId != ''}">
            <li class="icon back" onclick="back('${backUrl}')">返回${backTitle}</li>
        </g:if>
        %{--<li   class="icon daochu "--}%
            %{--onclick="exportExcel(event, '<g:createLink base=".." controller="goods" action="exportExcel"  />')">商品导出</li>--}%
        %{--<li  class="icon daoru  "  onclick="importExcel(event)" class="class_branch_op">商品导入</li>--}%
        %{--<li  class="icon xiazai  class_branch_op"--}%
            %{--onclick="down(event, '<g:createLink base=".." controller="goods" action="getExcelTemplate"  />')">下载模板</li>--}%
    </ul>

    <p  class="search search-width abs">
        <input type="hidden" id="categoryIds">
        <input type="hidden" id="is_cat" value="0">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入编码或名称查询"
               class="search-txt search-txt-width abs js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-l fl" style="background:#dfe3e5;">
        <ul id="goodsTree" class="ztree">
        </ul>
    </div>

    <div class="table-list-r fr" style="background:#b6b6b6;">
        <table id="goodsTable" data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{
	    field:'id',
	    checkbox:true
	}]]">
            <thead>
            %{--<th data-options="field:'barCode',width:100,formatter:codeT">商品条码</th>--}%
            <th data-options="field:'goodsName',width:100">中文名称</th>
            <th data-options="field:'goodsName2',width:100,align:'left'">英文名称</th>
            <th data-options="field:'tastes',width:220,align:'left'">口味</th>
            <th data-options="field:'categoryName',width:100,align:'left'">分类</th>
            <th data-options="field:'goodsStatus',formatter:statusFormatter,width:100">状态</th>
            <th data-options="field:'salePrice',formatter:moneyFormatter,width:100,align:'right'">售价</th>
            %{--<th data-options="field:'vipPrice1',formatter:moneyFormatter,width:100,align:'right'">会员价-1</th>--}%
            %{--<th data-options="field:'vipPrice2',formatter:moneyFormatter,width:100,align:'right'">会员价-2</th>--}%
            %{--<th data-options="field:'isForPoints',formatter:booleanFormatter">可折扣</th>--}%
            %{--<th data-options="field:'isStore',formatter:booleanFormatter">管理库存</th>--}%
            </thead>
        </table>

        <div id="goodsInfoWindow" class="easyui-dialog dialog-pad"
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px',onClose:function(){orderTable.form.form('reset');is=false;$('#category_id').combotree('hidePanel');}"
             buttons="#infoWindow-buttons" style="width: 816px;height:400px; padding: 10px 20px 10px 0px">
            <form id="goodsOrder" method="post">
                <input type="reset" style="display:none;"/>
                <table cellpadding="7" border="0" style="table-layout:fixed;">
                    <input type="hidden" name="id"/>
                    %{--<input type="hidden" name="goodsSpec" id="goodsSpec"/>--}%
                    <input id="photo" type="hidden" name="photo"/>
                    <tr>
                        <td class="title"><div style="width: 130px;">分类:</div></td>
                        <td><input id="category_id" name="categoryId"/></td>
                        <td rowspan="4" colspan="2" style="text-align: left;padding-left: 100px;">
                            <img id="img" src="" style="width:150px;height:150px"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">英文名称:</td>
                        <td colspan="3">
                            <input type="text" id="goodsName2" name="goodsName2" class="easyui-textbox"
                                   data-options="required:true,missingMessage:'英文名称为必填项',validType:['nochina','length[1,20]']"/>
                            %{--,onChange:goodsNameM--}%
                        </td>
                    </tr>
                    <tr>
                        <td class="title">中文名称:</td>
                        <td>
                            <input class="easyui-textbox" type="text" name="goodsName" id="goodsName"
                                   data-options="required:true,missingMessage:'中文名称为必填项',validType:['length[1,20]'],onChange:goodsNameM"/>
                                   %{--data-options="required:true,missingMessage:'商品名称为必填项',validType:['goodsNameValid','length[1,20]'],onChange:goodsNameM"/>--}%
                        </td>
                    </tr>
                    <tr>
                        %{--<td class="title">助记码:</td>--}%
                        %{--<td>--}%
                            %{--<input class="easyui-textbox" type="text" id="mnemonic" name="mnemonic"--}%
                                   %{--data-options="required:true,editable:true,validType:'length[1,20]',--}%
                                   %{--missingMessage:'助记码为必填项',invalidMessage:'长度不超过20个汉字或字符！',onChange:change_mnemonic"/>--}%
                        %{--</td>--}%
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
                    </tr> <tr>
                        %{--<td class="title">助记码:</td>--}%
                        %{--<td>--}%
                            %{--<input class="easyui-textbox" type="text" id="mnemonic" name="mnemonic"--}%
                                   %{--data-options="required:true,editable:true,validType:'length[1,20]',--}%
                                   %{--missingMessage:'助记码为必填项',invalidMessage:'长度不超过20个汉字或字符！',onChange:change_mnemonic"/>--}%
                        %{--</td>--}%
                    <td class="title" >售价:</td>
                    <td>
                        <input class="easyui-numberbox" type="text" name="salePrice"
                               data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'售价为必填项',
                               %{--onChange:setVipPrice--}%"
                               value="0"/>
                    </td>

                        <td colspan="2">
                            <div style="text-align: left;padding-left: 105px;">
                                <a href="javascript:void(0)" class="a-upload class_branch_op">
                                    <input type="file" name="file" id="fileUpLoad"
                                           onchange="ajaxFileUpLoad(this)">点击这里上传图片
                                </a>
                            </div>
                        </td>
                    </tr>
                    %{--<tr>--}%
                        %{--<td class="title">单位:</td>--}%
                        %{--<td><select id="goodsUnitId" name="goodsUnitId"></select></td>--}%

                        %{--<td class="title">售价:</td>--}%
                        %{--<td>--}%
                            %{--<input class="easyui-numberbox" type="text" name="salePrice"--}%
                                   %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'售价为必填项',onChange:setVipPrice"--}%
                                   %{--value="0"/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%

                        %{--<td class="title">会员价-1:</td>--}%
                        %{--<td><input class="easyui-numberbox" type="hidden" name="vipPrice1" id="vipPrice1"--}%
                                   %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'会员价-1为必填项'"--}%
                                   %{--value="0"/>--}%
                        %{--</td>--}%
                        %{--<td class="title">会员价-2:</td>--}%
                        %{--<td>--}%
                            %{--<input class="easyui-numberbox" type="hidden" name="vipPrice2" id="vipPrice2"--}%
                                   %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'会员价-2为必填项'"--}%
                                   %{--value="0"/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">配货价-1:</td>--}%
                        %{--<td><input class="easyui-numberbox" type="text" name="shippingPrice1" id="shippingPrice1"--}%
                                   %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'配货价-1为必填项'"--}%
                                   %{--value="0"/>--}%
                        %{--</td>--}%
                        %{--<td class="title">配货价-2:</td>--}%
                        %{--<td>--}%
                            %{--<input class="easyui-numberbox" type="text" name="shippingPrice2" id="shippingPrice2"--}%
                                   %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'配货价-2为必填项'"--}%
                                   %{--value="0"/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">进价：</td>--}%
                        %{--<td>--}%
                            %{--<input class="easyui-numberbox" type="text" name="purchasingPrice" id="purchasingPrice"--}%
                                   %{--data-options="required:true,min:0,precision:2,max:9999.99,missingMessage:'进价为必填项'"--}%
                                   %{--value="0"/>--}%
                        %{--</td>--}%
                        %{--<td class="title">状态:</td>--}%
                        %{--<td>--}%
                            %{--<select id="stat" class="easyui-combobox" name="goodsStatus" panelHeight="auto"--}%
                                    %{--editable="false">--}%
                                %{--<option value="0">正常</option>--}%
                                %{--<option value="1">停售</option>--}%
                                %{--<option value="2">停够</option>--}%
                                %{--<option value="3">淘汰</option>--}%
                            %{--</select>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">参数:</td>--}%
                        %{--<td colspan="3">--}%
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
                            %{--<input type="checkbox" name="goodsType" value="3" id="goodsType"--}%
                            %{--onclick="goodsTypeClick(this)" class="c_g_type">--}%
                            %{--<span style="height: 100%;;margin-left: 5px" id="goodsType_text">原料</span>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">前台角标:</td>--}%
                        %{--<td colspan="3">--}%
                            %{--<input type="checkbox" name="isRecommended" value="true"><span--}%
                                %{--style="height: 100%;margin-right: 17px;margin-left: 5px">推荐</span>--}%
                            %{--<input type="checkbox" name="isNewgood" value="true">--}%
                            %{--<span style="height: 100%;margin-left: 5px;margin-right: 17px">新品</span>--}%
                            %{--<input type="checkbox" name="isChangeprice" value="true">--}%
                            %{--<span style="height: 100%;margin-left: 5px;margin-right: 17px">时价商品</span>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    <tr>
                        <td class="title">口味:</td>
                        <td colspan="3" class="goodsSpec-height">
                        <input class="easyui-combobox" name="tastesIds" id="goodsSpec"
                        data-options="url:'<g:createLink base=".." controller="goodsSpec" action="queryBox"/>',
                        method:'get',
                        valueField:'id',
                        editable:false,
                        textField:'specName',
                        multiple:true,
                        panelHeight:130">
                        </td>
                        <td colspan="3" id="goosSpec_td">

                        </td>
                    </tr>
                    <tr>
                        <td class="title">描述:</td>
                        <td colspan="3" class="addr-details-remark">
                            <input class="easyui-textbox" type="text" name="memo"
                                   data-options="prompt:'请输入商品描述',multiline:true,validType:'maxLength[50]',invalidMessage:'长度不超过50个汉字或字符！'"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" class="easyui-linkbutton class_branch_op" iconCls="icon-ok"
               onclick="saveGoods()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
        <!-- 导入Dialog -->
        <div id="importExcelDialog"
             style="padding-top:17px;padding-left:20px;width:400px;height:200px;,top:'80px'" class="easyui-dialog"
             data-options="
        title:'导入商品',
        modal: true,
        closed:true,
        resizable : false,
        closable:false,
        striped:false,
        top:'80px',
        buttons:'#excelDialog-buttons'
     ">
            <form id="submitUploadFileForm" method="post" enctype="multipart/form-data" target="hidden_frame">
                <div>&nbsp;&nbsp; 请使用最新模板导入数据
                    <a href='<g:createLink base=".." controller="goods" action="getExcelTemplate"/>'
                       style="text-decoration:none">
                        点击下载最新模板
                    </a>
                </div>
                <table style="padding: 10px;width: 100%;" border="0">
                    <tr>
                        <td colspan="2">
                            <input class="easyui-filebox" id="uploadFile1" name="uploadFile"
                                   data-options="prompt:'请选择excel...',buttonIcon:'icon-search',buttonText:' 选择文件 ',height:28 "
                                   style="width:70%">
                        </td>
                    </tr>
                </table>
            </form>
        </div>

        <div id="excelDialog-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="okUpload()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="cUpload()">取消</a>
        </div>
    </div>
</div>
</body>
</html>











































