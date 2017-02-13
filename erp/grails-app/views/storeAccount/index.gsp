<%--
  Created by zhangfei.
  User: Administrator
  Date: 2015/9/2
  Time: 16:40
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>台帐查询</title>
    <meta name="layout" content="main">
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
    <link rel="stylesheet" href="${resource(dir: 'js', file: 'datePicker/jquery-ui-timepicker.css', base: '..')}"
          type="text/css">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'datePicker/jquery-ui.js', base: '..')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'datePicker/jquery-ui-timepicker-addon.js', base: '..')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'datePicker/ftrend.datepicker.js', base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'store/storeQuery.js', base: '..')}"></script>
    <style type="text/css">
    .search-width {
        width: 240px;
    }

    .input-width {
        width: 190px;
    }

    .search-date-position {
        right: 330px;
    }
    </style>
    <script type="text/javascript">
        var storeAccounGrid;
        var branchTypeParams;
        var dateTimePicker;
        var barCode = "${barCode}";
        var backParams = "${backParams}";
        var sBackParams = "${sBackParams}";
        var rbackUrl = "${backUrl}";
        var rbackTitle = "${backTitle}";
        var num = 0;
        var url_storeAccount="<g:createLink base=".." controller="storeAccount" action="list" />";
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            dateTimePicker = new dateTimePicker({
                container: $('#dateTimeRangeBox'),
                defaultDateTime: [$.dateFormat(new Date, "yyyy-MM-dd") + ' 00:00', $.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59']
            });
            storeAccounGrid = new EasyUIExt($("#storeAccountTable"), "");
            storeAccounGrid.singleSelect = true;
            storeAccounGrid.pagination = true;
            storeAccounGrid.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            storeAccounGrid.mainEasyUIJs();
            if ("${barCode}" != "") {
                $('#h_barCode').val("${barCode}");
            } else {
            }
            init_searchStore();
            branchTypeParams = ${branch.branchType};
            if (branchTypeParams == '0') {
                $("#queryStoreAccountBranch").show();
            }
            $(".js_show").bind("click", function () {
                $(this).parent().hide(300);
                $(".js_hide").parent().show(300);
                $(".js_box").slideDown("slow");
                $(".js_button").attr("disabled", true);
            });
            $(".js_hide").bind("click", function () {
                $(this).parent().hide(300);
                $(".js_show").parent().show(300);
                $(".js_box").slideUp("slow");
                $(".js_button").attr("disabled", false);
            });
            $(".js_bottom").bind("click", function () {
                $(".js_hide").parent().hide(300);
                $(".js_show").parent().show(300);
                $(".js_box").slideUp("slow");
                $(".js_button").attr("disabled", false);
            });
            $(".js_i").bind("click", function () {
                $("#queryStr").val("");
            });
            $("#queryStr").blur(function () {
                if ($("#queryStr").val() !== "") {
//                    $("#category").textbox("readonly", true);
                }
                if ($("#queryStr").val() == "") {
//                    $("#category").textbox("readonly", false);
                }
            });
            $("#occurType").combobox({
                editable: false,
                panelHeight: 'auto'
            });
            setBackInitParams();
            doHighSearch();

        });
        function clearInput() {
            $("#queryStr").val("");
//            $("#category").textbox("readonly", false);
        }
        function addCateGory() {
            return '<g:createLink base=".." controller="saleReport" action="categoryGoods"/>';
        }
        function getBranchView() {
            return '<g:createLink base=".." controller="saleReport" action="branchview"/>'
        }
        function getGoodCateView() {
            return '<g:createLink base=".." controller="storeAccount" action="showGoodCate"/>'
        }
        function setSelectObj(rowId, rowName, isObj) {
            if (isObj === "3") {
                $("#select_cateId").val(rowId);
//                $("#category").textbox("setValue", rowName);
            }
            if (isObj === "2") {
                $("#branchMenu_r").val(rowId);
//                $("#branch").textbox("setText", rowName);
            }
            if (isObj === "1") {
                $("#select_goods").val(rowId);
                $("#goods").textbox("setValue", rowName);
            }
            closeParams();
        }
        function closeParams() {
            $("#select_dialog").dialog("close");
        }
        function clearSearch() {
            $("#searchForm").form("reset");
            $(".clear_search").each(function (i, e) {
                $(e).val("");
            });
            $("input[id*='begin']").val(new Date().format("yyyy-MM-dd 00:00"));
            $("input[id*='end']").val($.dateFormat(new Date, "yyyy-MM-dd hh:mm"));
            $("#queryStr").val("");
            $("#queryStr").attr("disabled", false);
            $("#queryStr").css({"background-color": ""});
//            $("#category").textbox("readonly", false);
        }
        function back(url) {
            if (sBackParams != "") {
                $.redirect(url + "?backParams=" + sBackParams, {_remove_position: "台帐查询"});
            } else if (backParams != "") {
                $.redirect(url + "?backParams=" + backParams, {_remove_position: "台帐查询"});
            }

        }
        function doHighSearch() {
            num++;//num=1的时候后台不会拼接时间查询条件
            var startTime = $("input[id*='begin']").val();
            var endTime = $("input[id*='end']").val();
            $('#storeAccountTable').datagrid({
                url:url_storeAccount,
                queryParams: {
                    goodsInfo: $("#queryStr").val(),
                    branchInfo: $("#branchMenu_r").val(),
                    categoryInfo: $("#select_cateId").val(),
                    occurType: $("#occurType").combobox('getValue'),
                    startDate: startTime,
                    endDate: endTime,
                    barCode: $('#h_barCode').val(),
                    number: num
                }
            });
        }
        function occurQuantity(value, row, index) {
            if (value) {
                if (row.occurType == 4) {
                    return "-" + parseFloat(value).toFixed(2);
                } else {
                    return parseFloat(value).toFixed(2);
                }

            } else if (value === 0) {
                return parseFloat(0).toFixed(2);
            }
        }
        function occurAmount(value, row, index) {
            if (value) {
                if (row.occurType == 4) {
                    return "￥" + "-" + parseFloat(value).toFixed(2);
                } else {
                    return "￥" + parseFloat(value).toFixed(2);
                }
            } else if (value === 0) {
                return "￥" + parseFloat(value).toFixed(2);
            } else if (value === undefined || value === "" || val == null) {
                return "￥" + parseFloat(0).toFixed(2);
            } else {
                return "￥" + parseFloat(0).toFixed(2);
            }
        }
        function occurType(value, row, index) {
            if (value == 1) {
                return "POS销售"
            } else if (value == 5) {
                return "盘点"
            } else if (value == 3) {
                return "入库"
            } else if (value == 4) {
                return "出库"
            } else if (value == 2) {
                return "POS退货"
            }
//            if(value == 6){
//                return "线上销售";
//            }
//            if(value == 7){
//                return "线上退货";
//            }
            return value;

        }
        function operation(value, row, index) {
            if (row.occurType == 1) {
                return value
            }
            if (row.occurType == 2) {
                return "<a href='javascript:void(0)' onclick=viewOrder('" + row.orderCode + "','" + row.occurType + "')  style='color: #ffa200' >" + value + "</a>"
            }
            if (row.occurType == 3) {
                return "<a href='javascript:void(0)' onclick=viewOrder('" + row.orderCode + "','" + row.occurType + "')  style='color: #ffa200' >" + value + "</a>"
            }
            if (row.occurType == 4) {
                return "<a href='javascript:void(0)' onclick=viewOrder('" + row.orderCode + "','" + row.occurType + "')  style='color: #ffa200' >" + value + "</a>"
            }
            if (row.occurType == 5) {
                return value
            }
        }
        function queryByOrderCode(value, row, index) {
            return "<a href='javascript:void(0)' onclick=viewOrder('" + row.orderCode + "') style='color: #ffa200' >" + value + "</a>"
        }
        function viewOrder(orderCode, occurType) {
            var isFromStore = false;
            <g:if test="${backUrl != '' && barCode != ''}">
            isFromStore = true;
            </g:if>
            var backTitle = "台帐查询";
            var rebackUrl = "<g:createLink base=".." controller="storeAccount" action="index"  />";
            if (occurType == "2") {
                var url = "<g:createLink base=".." controller='checkOrder' action='initForm'  />?orderCode=" + orderCode + "&backUrl=" + rebackUrl + "&backTitle=" + backTitle + "&saBackParams=" + getBackInitParams() + "&isFromStore=" + isFromStore + "&sBackParams=" + backParams + "&opType=3";
                $.redirect(url, {_position: "库存盘点-明细"});
            }
            if (occurType == "3") {
                var url = "<g:createLink base=".." controller='storeOrder' action='initForm'  />?orderCode=" + orderCode + "&backUrl=" + rebackUrl + "&backTitle=" + backTitle + "&saBackParams=" + getBackInitParams() + "&orderType=1" + "&isFromStore=" + isFromStore + "&sBackParams=" + backParams + "&opType=3";
                $.redirect(url, {_position: "入库管理-明细"});
            }
            if (occurType == "4") {
                var url = "<g:createLink base=".." controller='storeOrder' action='initForm'  />?orderCode=" + orderCode + "&backUrl=" + rebackUrl + "&backTitle=" + backTitle + "&saBackParams=" + getBackInitParams() + "&orderType=2" + "&isFromStore=" + isFromStore + "&sBackParams=" + backParams + "&opType=3";
                $.redirect(url, {_position: "出库管理-明细"});
            }
            if (occurType == "5") {

            }
        }
        <%--
         添加返回参数
     --%>
        function getBackInitParams() {
            var backStr = '';
            backStr += $('#queryStr').val() + ';';
            backStr += $('#branchMenu_r').val() + ';';
//            backStr += $('#branch').textbox('getText') + ';';
            backStr += $('#select_cateId').val() + ';';
//            backStr += $('#category').textbox('getText') + ';';
            backStr += $('#occurType').combobox('getValue') + ';';
            backStr += $("input[id*='begin']").val() + ';';
            backStr += $("input[id*='end']").val() + ';';
            backStr += $("#h_barCode").val();
            return backStr;
        }
        <%--
           设置返回参数
       --%>
        function setBackInitParams() {
            var backStr = '${saBackParams}';
            if (backStr != '') {
                var backs = backStr.split(';');
                var x = 0;
                $('#queryStr').val(backs[x++]);
                $('#branchMenu_r').val(backs[x++]);
//                $('#branch').textbox('setText', backs[x++]);
                $('#select_cateId').val(backs[x++]);
//                $('#category').textbox('setText', backs[x++]);
                $('#occurType').combobox('setValue', backs[x++]);
                $("input[id*='begin']").val(backs[x++]);
                $("input[id*='end']").val(backs[x++]);
                $('#h_barCode').val(backs[x]);
            }

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
        <g:if test="${backUrl != '' && barCode != ''}">
            <li class="icon back" onclick="back('${backUrl}')">返回${backTitle}</li>
        </g:if>
    </ul>
    <!-- 高级搜索开始 -->
    <!-- 显示全部 -->
    <p class="abs search-more " style="display:block;"><a href="#" class="icon js_show">高级查询</a></p>
    <!-- 收起全部 -->
    <p class="abs search-more " style="display:none;"><a href="#" class="pack-up icon js_hide">收起查询</a></p>

    <div class="abs search-box js_box" style="display:none;">
        <form id="searchForm">
            <input type="hidden" class="clear_search" id="select_cateId">
            <input type="hidden" id="branchMenu_r" value="${branch.id}">
            <input type="hidden" id="select_goods">
            <input type="hidden" id="h_barCode">

            %{--<p id="queryStoreAccountBranch" style="display: none">--}%
                %{--<span>门店：</span>--}%
                %{--<input id="branch" name="searchCode" value="${branch.name}">--}%
            %{--</p>--}%

            %{--<p>--}%
                %{--<span>商品分类：</span>--}%
                %{--<input id="category" name="searchCode">--}%
            %{--</p>--}%
            %{--<p>--}%
            %{--<span>商品：</span>--}%
            %{--<input id="goods" name="searchCode">--}%
            %{--</p>--}%
            <p>
                <span>发生类型：</span>
                <select id="occurType" name="occurType">
                    <option value="0">全部</option>
                    <option value="1">POS销售</option>
                    <option value="2">POS退货</option>
                    <option value="3">入库</option>
                    <option value="4">出库</option>
                    <option value="5">盘点</option>
                    %{--<option value="6">线上销售</option>--}%
                    %{--<option value="7">线上退货</option>--}%
                </select>
            </p>
        </form>

        <p class="search-box-btn">
            <input type="button" onclick="doHighSearch()" value="搜索">
        </p>

        <p class="search-box-btn gray">
            <input type="button" onclick="clearSearch()" value="重置">
        </p>

        <p class="pack-up-bottom icon js_bottom"></p>
    </div>
    <!-- 高级搜索结束 -->
    <!-- 日期选择开始 -->
    <p class="search-date search-date-position abs"><a id="dateTimeRangeBox"></a></p>
    <!-- 日期选择结束 -->
    <p class="search search-width abs search-pos-table ">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入商品编码或名称查询"
               class="search-txt input-width abs js_p js_isFocus">
        <input type="button" class="search-btn icon abs js_button js_enterSearch" onclick="doHighSearch()">
        <i class="srh-close icon abs " onclick="clearInput()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="storeAccountTable"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
            %{--<tr>--}%
                %{--<th colspan="4"></th>--}%
                %{--<th colspan="2">进价</th>--}%
                %{--<th colspan="2">数量</th>--}%
                %{--<th colspan="2">成本</th>--}%
                %{--<th colspan="1"></th>--}%

            %{--</tr>--}%
            <th data-options="field:'barCode',width:100">商品条码</th>
            <th data-options="field:'goodsName',width:220,align:'left'">商品名称</th>
            <th data-options="field:'occurType',formatter:occurType,width:80">业务类型</th>
            <th data-options="field:'occurAt',formatter:dateFormatterToHM,width:150">发生时间</th>
            %{--进价--}%
            %{--<th data-options="field:'occurIncurred',formatter:moneyFormatter,width:100,align:'right'">实际发生</th>--}%
            %{--<th data-options="field:'storeIncurred',formatter:moneyFormatter,width:100,align:'right'">平均进价</th>--}%

            <th data-options="field:'occurQuantity',formatter:occurQuantity,width:80,align:'right'">实际发生</th>
            <th data-options="field:'storeQuantity',formatter:numberF,width:100,align:'right'">库存数量</th>
            %{--成本--}%
            %{--<th data-options="field:'occurAmount',formatter:occurAmount,width:100,align:'right'">实际发生</th>--}%
            %{--<th data-options="field:'storeAmount',formatter:moneyFormatter,width:100,align:'right'">库存成本</th>--}%
            <th data-options="field:'orderCode',formatter:operation,width:160,align:'left'">单据号</th>
            </thead>
        </table>

        <div id="select_dialog" class="easyui-dialog" data-options="modal:true,closed:true,closable:true"
             buttons="#infoWindow-buttons" style="width: 350px;height: 500px;overflow-x: hidden;overflow-y: hidden">

        </div>

        <div id="infoWindow-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="report_save()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeParams()">取消</a>
        </div>
    </div>
</div>
</body>
</html>