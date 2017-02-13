<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/7/1
  Time: 11:37
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title></title>

</head>

<body>
<style>
.addGoods_search {
    right: 1px;
}

.addGoods_a {
    margin-top: 5px;
    height: 30px;
    border-radius: 3px;
    cursor: pointer;
    margin-left: 10px;
    background: #0ae;
    color: #fff;
}

</style>

<script type="text/javascript" src="${resource(dir: 'js', file: 'package/loadGoodAndTree.js', base: '..')}"></script>
<script type="text/javascript">
    var good_Array = [];
    var singleSelect = ${singleSelect};
    var isHavePackage = "${isHavePackage}";
    var isHaveMaterial = "${isHaveMaterial}";
    $(function () {
        good_Array = _get_push();
        var initPar = 'isStore=' + $('#isStore').val();
        var flag = '${params.flag}';
        var url ;
        newDataGrid("" , good_Array);
        if (isHavePackage == 'true') {
            url= '<g:createLink controller='goods' action='queryList' base=".."/>';
            if(flag=="true" || flag == 'undefined'){
                doSearch(url);
            }

        } else {
            if($('#isStore').val()!=''){
                url= '<g:createLink controller='goods' action='list' base=".."/>?'+ initPar;
                if(flag=="true" || flag == 'undefined'){
                    doSearch(url);
                }

            }else{
                url= '<g:createLink controller='goods' action='list' base=".."/>?notMaterial='+true;
                if(flag=="true" || flag == 'undefined'){
                    doSearch(url);
                }
            }
        }
        if(isHaveMaterial == 'true'){
            loadTree("<g:createLink controller='category' action='loadZTree' base=".."/>?isHavePackage=" + isHavePackage, $("#cateTree"), setting);
        }else{
            loadTree("<g:createLink controller='category' action='loadZTree' base=".."/>?isHavePackage=" + isHavePackage+"&isHaveMaterial="+isHaveMaterial, $("#cateTree"), setting);
        }
        var searchTraget = '${params.searchTraget}';
        if(searchTraget!="undefined"){
            $("#categoryIds").val("");
            $("#queryStr").val(searchTraget);
            doSearch(url);
        }
    });

    function add_good() {
        var rows = $("#goodsTable").datagrid("getChecked");
        if (rows.length == 0) {
            $.messager.alert("系统提示", "你还没有选择任何菜品!", "info");
            return;
        }
        for (var i = 0; i < rows.length; i++) {
            if (isRequiredAdd == "true") {
                rows[i].quantity = 1;
            } else {
                rows[i].addPrice = 0;
            }
        }
        pushRowsArray(rows);
    }
    function clearSearch() {
        $('#queryStr').val('');
    }
</script>

<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north'" style="width: 100%;height:10%;text-align: right;padding-top:5px ">
        <input type="hidden" id="categoryIds">
        <input type="hidden" id="isStore" value="${isStore}">

        <p class="search abs search-pos-table addGoods_search">
            <input type="text" id="queryStr" name="queryStr" value="" placeholder="请输入编号或名称" class="search-txt abs js_p  js_isFocus">
            <input type="button" class="search-btn icon abs js_button  js_enterSearch" onclick="doSearch()">
            <i class="srh-close icon abs js_i" onclick="clearSearch()"></i>
        </p>
    </div>

    <div data-options="region:'west',split:true" style="width:30%;height:auto">
        <div>
            <ul id="cateTree" class="ztree"></ul>
        </div>
    </div>

    <div data-options="region:'center'" style="width:70%;height:auto">
        <table id="goodsTable">
        </table>
    </div>
</div>
</body>
</html>