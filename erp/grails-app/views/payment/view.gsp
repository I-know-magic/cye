<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>支付方式</title>
    <style type="text/css">
    .title {
        width: 120px;
    }
    .search-width{
        width: 220px;width: 226px \9;
    }
    .search-txt-width{
        width: 170px;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="payment" action="list"  />");
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            orderTable.mainEasyUIJs();
        });

        function myAdd() {
            orderTable.mainAdd("<g:createLink controller="payment" action="create"/>","支付方式-增加");
            orderTable.formAction = "<g:createLink controller="payment" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="payment" action="edit"  />", "支付方式-修改", id);
            orderTable.formAction = "<g:createLink controller="payment" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink controller="payment" action="delete"  />");
        }
        function doSearch() {
        $("#mainGrid").datagrid({
                queryParams: {
                    codeName: $("#queryStr").val()
                }
            });
        }
        function clearSearch(){
            $("#queryStr").val("");
        }
        function cleardata() {
            formclear("myForm")
        }
    </script>
</head>

<body>
<h3 class="rel ovf  js_header">
    <span></span>
    -
    <span></span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li  class="icon add class_branch_op" onclick="myAdd()">增 加</li>
        <li  class="icon alt class_branch_op" onclick="edit()">修 改</li>
        <li  class="icon del class_branch_op" onclick="del()">删 除</li>
    </ul>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入编码或名称查询" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
                <th data-options="field:'paymentCode'">'支付代码'
CSH 现金
CRD 银行卡
ZFB 支付宝
WZF 微信支付
JFD 积分抵现
CZF 储值支付</th>
    <th data-options="field:'paymentName'">'支付名称'</th>
    <th data-options="field:'paymentStatus'">0-正常
1-停用</th>
    <th data-options="field:'currencyId'">货币ID

0-默认货币,人民币</th>
    <th data-options="field:'branchId'">所属门店，默认为0，代表总部</th>
    <th data-options="field:'isScore'">0否1是</th>
    <th data-options="field:'isChange'">0否1是</th>
    <th data-options="field:'isMemo'">0否1是</th>
    <th data-options="field:'isSale'">0否1是</th>
    <th data-options="field:'fixValue'">固定面值</th>
    <th data-options="field:'fixNum'">单笔限次</th>
    <th data-options="field:'paymentType'">支付类型</th>
    <th data-options="field:'isVoucher'">是否代金券：0否1是</th>

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                                <tr>
                <td class="title">'支付代码'
CSH 现金
CRD 银行卡
ZFB 支付宝
WZF 微信支付
JFD 积分抵现
CZF 储值支付:</td>
                <td><input class="easyui-textbox" type="text" name="paymentCode" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">'支付名称':</td>
                <td><input class="easyui-textbox" type="text" name="paymentName" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">0-正常
1-停用:</td>
                <td><input class="easyui-textbox" type="text" name="paymentStatus" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">货币ID

0-默认货币,人民币:</td>
                <td><input class="easyui-textbox" type="text" name="currencyId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所属门店，默认为0，代表总部:</td>
                <td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">0否1是:</td>
                <td><input class="easyui-textbox" type="text" name="isScore" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">0否1是:</td>
                <td><input class="easyui-textbox" type="text" name="isChange" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">0否1是:</td>
                <td><input class="easyui-textbox" type="text" name="isMemo" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">0否1是:</td>
                <td><input class="easyui-textbox" type="text" name="isSale" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">固定面值:</td>
                <td><input class="easyui-textbox" type="text" name="fixValue" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">单笔限次:</td>
                <td><input class="easyui-textbox" type="text" name="fixNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">支付类型:</td>
                <td><input class="easyui-textbox" type="text" name="paymentType" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">是否代金券：0否1是:</td>
                <td><input class="easyui-textbox" type="text" name="isVoucher" data-options="required:true"/></td>
            </tr>


                    %{-- 实例
                    <td class="title"><div style="width: 124px;">单位编码:</div></td>--}%
                    %{--<td>--}%
                    %{--<input class="easyui-textbox" type="text" name="unitCode" readonly="readonly"/>--}%
                    %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                    %{--<td class="title">单位名称:</td>--}%
                    %{--<td><input class="easyui-textbox" type="text" name="unitName"--}%
                    %{--data-options="required:true,validType:'length[1,10]',missingMessage:'单位名称为必填项',invalidMessage:'长度不超过10个汉字或字符！'"/></td>--}%
                    %{--</tr>--}%
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok"
                onclick="orderTable.mainSave()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
    </div>
</div>
</body>
</html>

