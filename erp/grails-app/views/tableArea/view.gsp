<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title></title>
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
        var area_id = "";
        var area_name = "";
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="tableArea" action="list" base=".." />");
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
            orderTable.mainAdd("<g:createLink controller="tableArea" action="create"  base=".."/>","-增加");
            orderTable.formAction = "<g:createLink controller="tableArea" action="save"  base=".." />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="tableArea" action="edit"  base=".." />", "-修改", id);
            orderTable.formAction = "<g:createLink controller="tableArea" action="update"  base=".." />";
        }
        function del() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return false;
            }
            var row = $("#mainGrid").datagrid("getSelected");
            if(row.tablenum && row.tablenum>0){
                $.messager.alert('系统提示', '此区域下有桌台不能删除！', 'info');
            }else {
                orderTable.mainDel("<g:createLink controller="tableArea" action="delete"  base=".." />");
            }
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
        function addtables() {
            if (checkdata()) {
                var rebackUrl = "<g:createLink base=".." controller="tableArea" action="index"  />";
                var url = "<g:createLink base=".." controller='tableInfo' action='index'  />?areaId=" + _get_area_id() + "&areaName=" + _get_area_code() + "&backUrl=" + rebackUrl;
                $.redirect(url, {_position: "维护(区域:" + _get_area_code() + ")桌台"});
            }

        }
        function checkdata() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return false;
            }
            var row = $("#mainGrid").datagrid("getSelected");
            _set_area_id(row);
            _set_area_code(row);
            return true;
        }
        function _set_area_id(row) {
            area_id = row.id;
            return area_id;
        }
        function _get_area_id() {
            return area_id;
        }
        function _set_area_code(row) {
            area_name = row.name;
            return area_name;
        }
        function _get_area_code() {
            return area_name;
        }
    </script>
</head>

<body>
<h3 class="rel ovf  js_header">
    <span>基础资料</span>
    -
    <span>区域管理</span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li  class="icon add class_branch_op" onclick="myAdd()">增加区域</li>
        <li  class="icon alt class_branch_op" onclick="edit()">修改区域</li>
        <li  class="icon del class_branch_op" onclick="del()">删除区域</li>
        <li class="icon alt class_branch_op" onclick="addtables()">维护桌台信息</li>

    </ul>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入名称查询" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
                <th data-options="field:'name'">名称</th>
                <th data-options="field:'tablenum'">桌台数量</th>
            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
                <form id="editForm" method="post">
                    <table cellpadding="5" style="table-layout:fixed;">
                        <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                    <tr>
                    <td class="title">名称:</td>
                    <td><input class="easyui-textbox" type="text" name="name" data-options="required:true"/></td>
                    </tr>
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

