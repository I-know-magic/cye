<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>销售明细流水</title>
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="saleDetail" action="list"  />");
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
            orderTable.mainAdd("<g:createLink controller="saleDetail" action="create"/>","销售明细流水-增加");
            orderTable.formAction = "<g:createLink controller="saleDetail" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="saleDetail" action="edit"  />", "销售明细流水-修改", id);
            orderTable.formAction = "<g:createLink controller="saleDetail" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink controller="saleDetail" action="delete"  />");
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
                <th data-options="field:'saleCode'">销售账单号</th>
    <th data-options="field:'goodsId'">商品</th>
    <th data-options="field:'promotionId'">促销活动</th>
    <th data-options="field:'quantity'">数量</th>
    <th data-options="field:'salePrice'">售价</th>
    <th data-options="field:'salePriceActual'">实际售价</th>
    <th data-options="field:'totalAmount'">应收合计</th>
    <th data-options="field:'isFreeOfCharge'">是否免单或赠送</th>
    <th data-options="field:'receivedAmount'">实收合计</th>
    <th data-options="field:'isRefund'">是否冲销</th>
    <th data-options="field:'isPrinted'"></th>
    <th data-options="field:'isProduced'"></th>
    <th data-options="field:'isServed'"></th>
    <th data-options="field:'branchId'">所属门店，默认为0，代表总部</th>
    <th data-options="field:'discountAmount'">折扣金额</th>
    <th data-options="field:'discountAmount1'"></th>

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                                <tr>
                <td class="title">销售账单号:</td>
                <td><input class="easyui-textbox" type="text" name="saleCode" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">商品:</td>
                <td><input class="easyui-textbox" type="text" name="goodsId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">促销活动:</td>
                <td><input class="easyui-textbox" type="text" name="promotionId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">数量:</td>
                <td><input class="easyui-textbox" type="text" name="quantity" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">售价:</td>
                <td><input class="easyui-textbox" type="text" name="salePrice" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">实际售价:</td>
                <td><input class="easyui-textbox" type="text" name="salePriceActual" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">应收合计:</td>
                <td><input class="easyui-textbox" type="text" name="totalAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">是否免单或赠送:</td>
                <td><input class="easyui-textbox" type="text" name="isFreeOfCharge" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">实收合计:</td>
                <td><input class="easyui-textbox" type="text" name="receivedAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">是否冲销:</td>
                <td><input class="easyui-textbox" type="text" name="isRefund" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="isPrinted" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="isProduced" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="isServed" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所属门店，默认为0，代表总部:</td>
                <td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">折扣金额:</td>
                <td><input class="easyui-textbox" type="text" name="discountAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="discountAmount1" data-options="required:true"/></td>
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

