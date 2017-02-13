<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>销售账单流水</title>
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="sale" action="list"  />");
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
        %{--<li  class="icon add class_branch_op" onclick="myAdd()">增 加</li>--}%
        %{--<li  class="icon alt class_branch_op" onclick="edit()">修 改</li>--}%
        %{--<li  class="icon del class_branch_op" onclick="del()">删 除</li>--}%
    </ul>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入单号" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
                %{--<th data-options="field:'saleOrderCode'">订单号</th>--}%

                %{--<th data-options="field:'clientId'">POS数据主键ID</th>--}%
                %{--<th data-options="field:'branchId'">所属门店</th>--}%
            %{--，默认为0，代表总部--}%
                <th data-options="field:'saleCode'">销售账单号</th>
                %{--<th data-options="field:'posId'"></th>--}%
                <th data-options="field:'posCode'">POS号</th>
                <th data-options="field:'totalAmount'">销售合计</th>
            %{--（所有单品计价的合计 商品原价*数量）--}%
                <th data-options="field:'discountAmount'">折扣额</th>
                <th data-options="field:'giveAmount'">赠送额</th>
                <th data-options="field:'longAmount'">长款金额</th>
                <th data-options="field:'truncAmount'">抹零额</th>
                %{--<th data-options="field:'isFreeOfCharge'">是否免单</th>--}%
                %{--<th data-options="field:'serviceFee'">所有服务费的合计，属于加收项目--}%
            %{--包括座位费、加工费等--}%
            %{--单项加工费另表保存</th>--}%
                <th data-options="field:'receivedAmount'">实收金额
            %{--=total_amount-discount_amount-give_amount-trunc_amount=sum(sale_payment.pay_total)-long_amount--}%
            </th>
                <th data-options="field:'cashier'">收银员</th>
                <th data-options="field:'checkoutAt'">结账时间</th>
                <th data-options="field:'promotionId'">促销活动</th>
                <th data-options="field:'isRefund'">是否退货 </th>
            %{--0：销售 1 ：退货--}%
                %{--<th data-options="field:'orderStatus',formatter:orderStatus">订单状态--}%
                %{--0-录入--}%
                %{--1-已提交--}%
                %{--2-（卖方）已确认--}%
                %{--3-（卖方）已拒绝--}%
                %{--4-已支付--}%
                %{--5-已取消--}%
                </th>
                    %{--<th data-options="field:'deliveryStatus'">0-未发货--}%
                %{--1-已发货--}%
                %{--2-已收货--}%
                    %{--</th>--}%
                    %{--<th data-options="field:'saleType'">订单类型：0-pos订单</th>--}%

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                                <tr>
                <td class="title">POS数据主键ID:</td>
                <td><input class="easyui-textbox" type="text" name="clientId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所属门店，默认为0，代表总部:</td>
                <td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售账单号:</td>
                <td><input class="easyui-textbox" type="text" name="saleCode" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="posId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">POS号(冗余字段):</td>
                <td><input class="easyui-textbox" type="text" name="posCode" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">销售合计
（所有单品计价的合计 商品原价*数量）:</td>
                <td><input class="easyui-textbox" type="text" name="totalAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">折扣额:</td>
                <td><input class="easyui-textbox" type="text" name="discountAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">赠送额:</td>
                <td><input class="easyui-textbox" type="text" name="giveAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">长款金额:</td>
                <td><input class="easyui-textbox" type="text" name="longAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">抹零额:</td>
                <td><input class="easyui-textbox" type="text" name="truncAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">是否免单:</td>
                <td><input class="easyui-textbox" type="text" name="isFreeOfCharge" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所有服务费的合计，属于加收项目
包括座位费、加工费等
单项加工费另表保存:</td>
                <td><input class="easyui-textbox" type="text" name="serviceFee" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">实收金额=total_amount-discount_amount-give_amount-trunc_amount=sum(sale_payment.pay_total)-long_amount:</td>
                <td><input class="easyui-textbox" type="text" name="receivedAmount" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">收银员:</td>
                <td><input class="easyui-textbox" type="text" name="cashier" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">结账时间:</td>
                <td><input class="easyui-textbox" type="text" name="checkoutAt" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">促销活动:</td>
                <td><input class="easyui-textbox" type="text" name="promotionId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">是否退货 0：销售 1 ：退货:</td>
                <td><input class="easyui-textbox" type="text" name="isRefund" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">订单状态
0-录入
1-已提交
2-（卖方）已确认
3-（卖方）已拒绝
4-已支付
5-已取消:</td>
                <td><input class="easyui-textbox" type="text" name="orderStatus" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">0-未发货
1-已发货
2-已收货:</td>
                <td><input class="easyui-textbox" type="text" name="deliveryStatus" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="saleOrderCode" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">订单类型：0-pos订单:</td>
                <td><input class="easyui-textbox" type="text" name="saleType" data-options="required:true"/></td>
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

