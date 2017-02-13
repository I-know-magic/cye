
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="main"/>
    %{--<meta http-equiv="pragma" content="no-cache">--}%
    %{--<meta http-equiv="cache-control" content="no-cache">--}%
    %{--<meta http-equiv="expires" content="0">--}%
    %{--<meta http-equiv="kiben" content="no-cache">--}%
    %{--<%--}%
        %{--response.setHeader("Expires", "0");--}%
        %{--response.setHeader("Cache-Control", "no-store,no-cache,must-revalidate");--}%
        %{--response.addHeader("Cache-Control", "post-check=0, pre-check=0");--}%
        %{--response.setDateHeader("Last-Modified", 0);--}%
    %{--%>--}%
    <title>出入库单据</title>
    <script type="text/javascript" src="${resource(base: '..', dir: 'js', file: 'storeOrder/storeOrder.js')}"></script>
    <style type="text/css">
    .addr-details-remark .textbox-invalid {
        width: 260px !important;
    }

    .addr-details-remark .textbox {
        width: 260px !important;
    }

    .addr-details-remark .textbox-text {
        width: 260px !important;
        overflow: hidden;
    }

    .p_show_status_c {
        font-size: 20px;
        font-weight: 900;
        font-style: oblique;
        color: red;
    }

    .numberbox .textbox-text{
        width: 109px !important;
    }
    .spinner{
        width: 109px !important;
    }
    .spinner .textbox-text{
        width: 83px !important;
    }

    .pro_h {
        height: 70px;
    }

    .p_show_status_c {
        background: #ff6565;
        border-radius: 0 0 5px 5px;
        color: #fff;
        font-size: 16px;
        font-weight: normal;
        height: 70px;
        left: -187px;
        position: absolute;
        text-align: center;
        top: 73px;
        width: 26px;
        font-style: normal;
    }

    .textbox-disabled {
        background-color: #DFE3E5
    }

    .textbox-disabled textarea {
        background-color: #DFE3E5
    }

    .textbox-disabled a {
        background: #DFE3E5 !important;
        color: #fff;
        border-left: 1px solid #D3D3D3 !important;
        cursor: default
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        var backUrl = '<g:createLink controller='storeOrder' action='index' base=".." />?orderType=${orderType}&backParams=${backParams}';
        var isRequiredAdd = 'false';
        var h_branch_url = '<g:createLink base=".." controller="saleReport" action="branchview"/>';
        var audit_ok_url = '<g:createLink controller="storeOrder" action="initForm" base=".." />?' + 'opType=3' +
                '&orderType=${orderType}' + '&orderId=';
        var add_ok_url = '<g:createLink controller="storeOrder" action="initForm" base=".." />?' + 'opType=2' +
                '&orderType=${orderType}' + '&orderId=';
        var order_type_amount = '${orderType == 2 ? '出库金额':'入库金额'}';
        var order_type_quantity = '${orderType == 2 ? '出库数量':'入库数量'}';
        var saBackParams="${saBackParams}";
        var sBackParams="${sBackParams}";
        var audit_url = '<g:createLink controller="storeOrder" action="auditOrder" base=".." />?orderId=';
        var update_p_o;
        var opType = ${opType};
        var d = '<a href="javascript:void(0)" onclick="deleterow(this)"><img src="${resource(dir: 'easyui/themes/icons/', file: 'delete.png',base:'..')}"></a> ';
        var add = '<a href="javascript:void(0)" onclick="appendGoodsRow()"><img src="${resource(dir: 'easyui/themes/icons/', file: 'edit_add.png',base:'..')}"></a> ';
        var queryUrl = "<g:createLink controller='goods' action='queryList' base=".."/>?goodsCodeOrName=";
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
            newDataGrid( '${pro?.status}');
            init_eas();
            initPro('<g:createLink base=".." controller="storeOrder" action="queryOrderDetails"/>?storeOrderId=');
            if(opType == 3){
                update_p_o = false;
            }else{
                update_p_o = true;
            }
            myUpdate();
        });
        function storeOrder_add(url) {
            if($("#h_id").val() == ''||update_p_o == true){
                $.messager.confirm('系统提示', '请先保存数据,确定离开?', function (r) {
                    if (r) {
                        location.replace(url);
                    }
                });
            }else{
                location.replace(url);
            }

        }
        function doSearchGoods() {
            $("#goodsDialog").dialog({
                href: '<g:createLink controller="package" action="addGoodsView" base=".." />?isStore=1'
            }).dialog("open");
        }
        function callBack() {
//            var rows=$('#goodsTable_info').datagrid('getRows')
//            endGridEdit(rows);
//            var changeRows = $('#goodsTable_info').datagrid('getChanges');
//            if($("#goodsTable_info").data("is_update") || changeRows.length>0){
//                beginGridEdit(rows);
//                $.messager.alert('系统提示', '请先保存数据！', 'info');
//                return
//            }else{
//                location.replace(backUrl);
//            }
            if($("#h_id").val() == ''||update_p_o == true){
                $.messager.confirm('系统提示', '请先保存数据,确定返回?', function (r) {
                    if (r) {
                        location.replace(backUrl);
                    }
                });
            }else{
                location.replace(backUrl);
            }
        }
        function del() {
            var url = '<g:createLink controller="storeOrder" action="deleteOrder" base=".." />?orderId=';
            var h_id = $('#h_id').val();
            $.messager.confirm('系统提示', '确定删除?', function (r) {
                if (r) {
                    $.post(url + h_id, function (data) {
                        if (data.success == 'true') {
                            location.replace(backUrl);
                        } else {
                            $.messager.alert('系统提示', data.msg, 'info');
                        }
                    }, 'json');
                }
            });
        }
        function back(url) {
            var backs = saBackParams.split(';');
            var goodsCode=backs[8];
            <g:if test="${orderType == 1}">
            if(${isFromStore}){
                $.redirect(url+"?saBackParams="+saBackParams+"&backUrl=<g:createLink base=".." controller="store" action="index"  />&backTitle=库存查询&goodsCode="+goodsCode+"&sBackParams="+sBackParams, {_remove_position: "入库管理-明细"});
            }else{
                $.redirect(url+"?saBackParams="+saBackParams, {_remove_position: "入库管理-明细"});
            }
            </g:if>
            <g:else>
            if(${isFromStore}){
                $.redirect(url+"?saBackParams="+saBackParams+"&backUrl=<g:createLink base=".." controller="store" action="index"  />&backTitle=库存查询&goodsCode="+goodsCode+"&sBackParams="+sBackParams, {_remove_position: "出库管理-明细"});
            }else{
                $.redirect(url+"?saBackParams="+saBackParams, {_remove_position: "出库管理-明细"});
            }
            </g:else>
        }
        function storeOrder_addGoods(flag,target) {
            $('#goodsTable_info').data("_replace",flag==undefined?true:flag);
            $("#goodsDialog").dialog({
                href: '<g:createLink controller="goods" action="addGoodsView" base=".." />?isHavePackage=false&isHaveMaterial=true&isStore=1&searchTraget='+target+'&flag='+flag
            }).dialog("open");
        }

    </script>
</head>

<body>
<h3 class="rel ovf js_header">
    <span>库存管理</span>
    -
    <span>
        <g:if test="${orderType == 1}">入库管理</g:if>
        <g:else>出库管理</g:else>
    </span>
    -
    <span>明细</span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li class="icon add" id="p_add"
            onclick="storeOrder_add('<g:createLink controller='storeOrder' action='initForm' base=".." />?opType=1&orderType=' + $('#h_order_type').val())">增 加</li>
        <li class="icon bat" id="p_audit"
            onclick="audit_order('<g:createLink controller='storeOrder' action='auditOrder' base=".." />?orderId=')"
            id="p_audit">审 核</li>
        <li class="icon bat" id="p_save"
            onclick="savePro('<g:createLink controller='storeOrder' action='saveOrUpdate' base=".." />')">保 存</li>
        <li class="icon alt" onclick="myUpdate()" id="p_update">修 改</li>
        <li class="icon del" id="p_del" onclick="del()">删 除</li>
        <g:if test="${backUrl != '' && backUrl != null}">
            <li class="icon back" onclick="back('${backUrl}')">返回${backTitle}</li>
        </g:if>
        <g:else>
            <li class="icon back" onclick="callBack()">返回</li>
        </g:else>
    </ul>
</div>

<div class="table-list">
    <div class="ad-search-box pro_h ">
        <input type="hidden" id="h_status" value="${pro.status}">
        <input type="hidden" id="h_op_type" value="${opType}">
        %{--<input type="hidden" class="search" id="h_branchMenu_r" value="${branch.id}">--}%
        %{--<input type="hidden" class="search" id="h_branch_type" value="${branch.branchType}">--}%

        <form id="storeOrderForm" method="post">
            <ul class="js_table_branch clearfix pro_h ">
                <input type="hidden" id="h_id" name="id" value="${pro.id}">
                <input type="hidden" class="search" id="h_detailsStr" name="detailStr">
                %{--<input type="hidden" class="search" id="branchMenu_r" name="branchId" value="${branch.id}">--}%
                <input type="hidden" id="h_order_type" value="${orderType}" name="orderType">
                <li class="rel">
                    <span class="store_branch_span">单据号:</span>
                    <input readonly="readonly" type="text" class="easyui-textbox abs" value="${pro.code}" name="code"
                           id="code">
                    <g:if test="${opType == 3}">
                        <span style="margin-left: 200px;top:-15px;background: #3dac45;" id="p_show_status" class="p_show_status_c" ></span>
                    </g:if>
                    <g:else>
                        <span style="margin-left: 200px;top:-15px;" id="p_show_status" class="p_show_status_c"></span>
                    </g:else>
                </li>
                <li class="rel">
                    <span class="store_branch_span">备注:</span>
                    <span class=" addr-details-remark">
                        <input type="text" id="pro_memo" name="memo" value="${pro.memo}" class="abs">
                    </span>
                </li>
            </ul>
        </form>
    </div>

    <div class="set-meal-box">
        <div class="set-meal-top">
            <p class="fl">商品明细</p>

            %{--<p class="fr">--}%
                %{--<input type="button" id="cp_ok" onclick="addPro()" value="添加明细">--}%
                %{--<input type="button" id="cp_remove" onclick="deleteGoods()" value="删除明细">--}%
            %{--</p>--}%
        </div>

        <div class="store_set-meal-table">
            <table id="goodsTable_info"></table>

            <div id="goodsDialog" title="添加商品" class="easyui-dialog"
                 data-options="closed:true,modal:false,closable:false"
                 buttons="#goodsDialog-button"
                 style="width:600px;height:480px;overflow:hidden;padding: 0px 0px 0px 0px;">
            </div>
        </div>

        <div id="goodsDialog-button">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="storeOrder_add_good();">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="storeOrder_closeGoodsDialog()">取消</a>
        </div>

        <div id="select_dialog" class="easyui-dialog" data-options="modal:true,closed:true,closable:false"
             buttons="#infoWindow-buttons" style="width: 350px;height: 500px;overflow-x: hidden;overflow-y: auto">
        </div>

        <div id="infoWindow-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="report_save()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeReport()">取消</a>
        </div>
    </div>
    <div>
        <form>
            <ul class="js_table_branch_under clearfix pro_h ">
                <li class="rel">
                    <span class="store_branch_span">制单人:</span>
                    <input type="text" name="makeName" readonly="readonly" value="${pro.makeName}" class="abs">
                </li>
                <li class="rel">
                    <span class="store_branch_span">制单时间:</span>
                    <input type="text" name="createAt" readonly="readonly"
                           value="${pro.makeAt == null ? null : com.smart.common.util.DateUtils.formatData('yyyy-MM-dd HH:mm', pro.makeAt)}" class="abs">
                </li>
                <li class="rel">
                    <span class="store_branch_span">审核人:</span>
                    <input type="text" name="auditName" readonly="readonly" value="${pro.auditName}" class="abs">
                </li>
                <li class="rel">
                    <span class="store_branch_span">审核时间:</span>
                    <input type="text" name="auditAt" readonly="readonly"
                           value="${pro.auditAt == null ? null : com.smart.common.util.DateUtils.formatData('yyyy-MM-dd HH:mm', pro.auditAt)}" class="abs">
                </li>
                <li class="store_branch_li p_branch_ rel">
                    <span class="store_branch_span"></span>
                    %{--<input id="branch" name="searchCode" value="${branch.name}" class="abs">--}%
                </li>
            </ul>
        </form>
    </div>
</div>

</body>
</html>
