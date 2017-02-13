<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>打印机信息</title>
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink base=".."  controller="printerInfo" action="list"  />");
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
            orderTable.mainAdd("<g:createLink  base=".." controller="printerInfo" action="create"/>","打印机信息-增加");
            orderTable.formAction = "<g:createLink  base=".." controller="printerInfo" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink  base=".." controller="printerInfo" action="edit"  />", "打印机信息-修改", id);
            orderTable.formAction = "<g:createLink  base=".." controller="printerInfo" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink  base=".." controller="printerInfo" action="delete"  />");
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
//        0-账单；1-总单；2-分单
        function printTypeFormatter(val) {
            if (val == 0) {
                return '账单';
            }
            if (val == 1) {
                return '总单';
            }
            if (val == 2) {
                return '分单';
            }
            return val;
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
                <th data-options="field:'printerName'">名称</th>
                <th data-options="field:'ipAddress'">地址</th>
                %{--<th data-options="field:'groupIds'"></th>--}%
                <th data-options="field:'printType',formatter:printTypeFormatter">类型</th>%{--0-账单；1-总单；2-分单--}%
                %{--<th data-options="field:'branchId'"></th>--}%

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
                <td>
                    <input class="easyui-textbox" type="text" name="printerName" data-options="required:true,missingMessage:'名称为必填项',validType:['length[1,20]']"/></td>
                    </tr>
                    <tr>
                        <td class="title">ip地址:</td>
                        <td><input class="easyui-textbox" type="text" name="ipAddress" data-options="required:true,missingMessage:'ip地址为必填项',validType:['ip','length[1,20]']"/></td>
                    </tr>
                    %{--<tr>--}%
                        %{--<td class="title">:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="groupIds" data-options="required:true"/></td>--}%
                    %{--</tr>--}%
                    <tr>
                        <td class="title">类型:</td>
                        <td>
                            <select class="easyui-combobox" name="printType" id="printType" panelHeight="auto">
                                <option value="0">账单</option>
                                <option value="1">总单</option>
                                <option value="2">分单</option>
                            </select>
                            %{--<input class="easyui-textbox" type="text" name="printType" data-options="required:true"/>--}%
                        </td>
                    </tr>
                    %{--<tr>--}%
                        %{--<td class="title">:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/></td>--}%
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

