<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>销售日结转</title>
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="jzSaleDay" action="list"  />");
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
            orderTable.mainAdd("<g:createLink controller="jzSaleDay" action="create"/>","销售日结转-增加");
            orderTable.formAction = "<g:createLink controller="jzSaleDay" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="jzSaleDay" action="edit"  />", "销售日结转-修改", id);
            orderTable.formAction = "<g:createLink controller="jzSaleDay" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink controller="jzSaleDay" action="delete"  />");
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
                <th data-options="field:'carDate'">结转日期（YYYY-mm-dd）</th>
    <th data-options="field:'branchId'"></th>
    <th data-options="field:'saleNum'">销售单数（销售数量）</th>
    <th data-options="field:'saleDiscountNum'">销售优惠单数</th>
    <th data-options="field:'saleTruncNum'">销售抹零单数</th>
    <th data-options="field:'saleGiveNum'">销售赠送金额</th>
    <th data-options="field:'returnNum'">退货单数（退货数量）</th>
    <th data-options="field:'returnDiscountNum'">退货优惠单数</th>
    <th data-options="field:'returnTruncNum'">退货抹零单数</th>
    <th data-options="field:'returnGiveNum'">退货赠送金额</th>
    <th data-options="field:'saleAmount'">销售金额</th>
    <th data-options="field:'saleDiscountAmount'">销售优惠金额</th>
    <th data-options="field:'saleTruncAmount'">销售抹零金额</th>
    <th data-options="field:'saleGiveAmount'">销售赠送金额</th>
    <th data-options="field:'returnAmount'">退货金额</th>
    <th data-options="field:'returnDiscountAmount'">退货优惠金额</th>
    <th data-options="field:'returnTruncAmount'">退货抹零金额</th>
    <th data-options="field:'returnGiveAmount'">退货赠送金额</th>
    <th data-options="field:'saleGoodsCost'">销售成本</th>
    <th data-options="field:'amount'">总额</th>
    <th data-options="field:'returnGoodsCost'">退货成本</th>

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                                <tr>
                <td class="title">结转日期（YYYY-mm-dd）:</td>
                <td><input class="easyui-textbox" type="text" name="carDate" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售单数（销售数量）:</td>
                <td><input class="easyui-textbox" type="text" name="saleNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售优惠单数:</td>
                <td><input class="easyui-textbox" type="text" name="saleDiscountNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售抹零单数:</td>
                <td><input class="easyui-textbox" type="text" name="saleTruncNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售赠送金额:</td>
                <td><input class="easyui-textbox" type="text" name="saleGiveNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货单数（退货数量）:</td>
                <td><input class="easyui-textbox" type="text" name="returnNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货优惠单数:</td>
                <td><input class="easyui-textbox" type="text" name="returnDiscountNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货抹零单数:</td>
                <td><input class="easyui-textbox" type="text" name="returnTruncNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货赠送金额:</td>
                <td><input class="easyui-textbox" type="text" name="returnGiveNum" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售金额:</td>
                <td><input class="easyui-textbox" type="text" name="saleAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售优惠金额:</td>
                <td><input class="easyui-textbox" type="text" name="saleDiscountAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售抹零金额:</td>
                <td><input class="easyui-textbox" type="text" name="saleTruncAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售赠送金额:</td>
                <td><input class="easyui-textbox" type="text" name="saleGiveAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货金额:</td>
                <td><input class="easyui-textbox" type="text" name="returnAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货优惠金额:</td>
                <td><input class="easyui-textbox" type="text" name="returnDiscountAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货抹零金额:</td>
                <td><input class="easyui-textbox" type="text" name="returnTruncAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货赠送金额:</td>
                <td><input class="easyui-textbox" type="text" name="returnGiveAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售成本:</td>
                <td><input class="easyui-textbox" type="text" name="saleGoodsCost" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">总额:</td>
                <td><input class="easyui-textbox" type="text" name="amount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">退货成本:</td>
                <td><input class="easyui-textbox" type="text" name="returnGoodsCost" data-options="required:true"/></td>
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

