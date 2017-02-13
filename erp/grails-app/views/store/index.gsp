<%--
  Created by zhangfei.
  User: Administrator
  Date: 2015/9/1
  Time: 19:10
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>库存查询</title>
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
    <script type="text/javascript" src="${resource(dir: 'js', file: 'store/storeQuery.js', base: '..')}"></script>
    <style type="text/css">
    .search-width {
        width: 240px;
    }

    .input-width {
        width: 190px;
    }
    </style>
    <script type="text/javascript">
        var storeGrid;
        var branchTypeParams;
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            storeGrid = new EasyUIExt($("#storeTable"), "<g:createLink base=".." controller="store" action="list"  />");
            storeGrid.singleSelect = true;
            storeGrid.pagination = true;
            storeGrid.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            storeGrid.mainEasyUIJs();
            init_searchStore();
            branchTypeParams = ${branch.branchType};
            if (branchTypeParams == '0') {
                $("#queryStoreBranch").show();
            } else {
                $("#queryStoreBranch").hide();
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
                    $("#category").textbox("readonly", true);
                }
                if ($("#queryStr").val() == "") {
                    $("#category").textbox("readonly", false);
                }
            });
            setBackInitParams();
            doHighSearch();
        });
        function clearInput() {
            $("#queryStr").val("");
            $("#category").textbox("readonly", false);
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
        function doHighSearch() {

            $('#storeTable').datagrid({
                queryParams: {
                    goodsInfo: $("#queryStr").val(),
                    branchInfo: $("#branchMenu_r").val(),
                    categoryInfo: $("#select_cateId").val(),
                    goodsId: $("#select_goods").val()
                }
            });
        }
        function setSelectObj(rowId, rowName, isObj) {
            if (isObj === "3") {
                $("#select_cateId").val(rowId);
                $("#category").textbox("setValue", rowName);
            }
            if (isObj === "2") {
                $("#branchMenu_r").val(rowId);
                $("#branch").textbox("setText", rowName);
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
            $("#queryStr").val("");
            $("#queryStr").attr("disabled", false);
            $("#queryStr").css({"background-color": ""});
            $("#category").textbox("readonly", false);
        }
        function queryStoreAccount(value, row, index) {
            return "<a href='javascript:void(0)' onclick=viewStoreAccount('" + row.barCode + "') style='color: #ffa200' >库存流水查询</a>"
        }
        function viewStoreAccount(barCode) {
            var backTitle = "库存查询";
            var rebackUrl = "<g:createLink base=".." controller="store" action="index"  />";
            var url = "<g:createLink base=".." controller='storeAccount' action='index'  />?barCode=" + barCode + "&backUrl=" + rebackUrl + "&backTitle=" + backTitle + "&backParams=" + getBackInitParams();
            $.redirect(url, {_position: "库存流水查询"})
        }
        <%--
           添加返回参数
       --%>
        function getBackInitParams() {
            var backStr = '';
            backStr += $('#queryStr').val() + ';';
            backStr += $('#branchMenu_r').val() + ';';
            backStr += $('#branch').textbox('getText') + ';';
            backStr += $('#select_cateId').val() + ';';
            backStr += $('#category').textbox('getText');
            return backStr;
        }
        <%--
           设置返回参数
       --%>
        function setBackInitParams() {
            var backStr = '${backParams}';
            if (backStr != '') {
                var backs = backStr.split(';');
                $('#queryStr').val(backs[0]);
                $('#branchMenu_r').val(backs[1]);
                $('#branch').textbox('setText', backs[2]);
                $('#select_cateId').val(backs[3]);
                $('#category').textbox('setText', backs[4]);
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
            <input type="hidden" class="clear_search" id="select_store">
            <input type="hidden" id="select_goods">

            <p id="queryStoreBranch" >
                <span>门店：</span>
                <input id="branch" name="searchCode" value="${branch.name}">
            </p>

            <p>
                <span>商品分类：</span>
                <input id="category" name="searchCode">
            </p>
            %{--<p>--}%
            %{--<span>商品：</span>--}%
            %{--<input id="goods" name="searchCode">--}%
            %{--</p>--}%
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
    <p class="search search-width abs search-pos-table ">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入商品编码或名称查询"
               class="search-txt input-width abs js_p  js_isFocus">
        <input type="button" class="search-btn icon abs js_button  js_enterSearch" onclick="doHighSearch()">
        <i class="srh-close icon abs " onclick="clearInput()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="storeTable"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
            <th data-options="field:'barCode',width:100">商品编码</th>
            <th data-options="field:'goodsName',width:220,align:'left'">商品名称</th>
            <th data-options="field:'categoryName',width:100">小类</th>
            <th data-options="field:'goodsUnitName',width:80">单位</th>
            %{--<th data-options="field:'avgAmount',formatter:moneyFormatter,width:100,align:'right'">成本</th>--}%
            <th data-options="field:'salePrice',formatter:moneyFormatter,width:100,align:'right'">售价</th>
            <th data-options="field:'quantity',formatter:numberF,width:100,align:'right'">库存数量</th>
            %{--<th data-options="field:'storeAmount',formatter:moneyFormatter,width:100,align:'right'">库存金额</th>--}%
            <th data-options="field:'operation',formatter:queryStoreAccount,width:180">操作</th>
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