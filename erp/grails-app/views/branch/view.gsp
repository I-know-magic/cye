<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>门店信息（组织结构表，含总部、配送中心、分店）</title>
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="branch" action="list"  />");
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
            orderTable.mainAdd("<g:createLink controller="branch" action="create"/>","门店信息（组织结构表，含总部、配送中心、分店）-增加");
            orderTable.formAction = "<g:createLink controller="branch" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="branch" action="edit"  />", "门店信息（组织结构表，含总部、配送中心、分店）-修改", id);
            orderTable.formAction = "<g:createLink controller="branch" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink controller="branch" action="delete"  />");
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
                <th data-options="field:'branchType'">0总部1配送中心2分店</th>
    <th data-options="field:'code'">代码</th>
    <th data-options="field:'name'">名称</th>
    <th data-options="field:'phone'">联系电话</th>
    <th data-options="field:'contacts'">联系人</th>
    <th data-options="field:'address'">地址</th>
    <th data-options="field:'status'">状态0 停用1启用</th>
    <th data-options="field:'memo'">备注</th>

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                                <tr>
                <td class="title">0总部1配送中心2分店:</td>
                <td><input class="easyui-textbox" type="text" name="branchType" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">代码:</td>
                <td><input class="easyui-textbox" type="text" name="code" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">名称:</td>
                <td><input class="easyui-textbox" type="text" name="name" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">联系电话:</td>
                <td><input class="easyui-textbox" type="text" name="phone" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">联系人:</td>
                <td><input class="easyui-textbox" type="text" name="contacts" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">地址:</td>
                <td><input class="easyui-textbox" type="text" name="address" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">状态0 停用1启用:</td>
                <td><input class="easyui-textbox" type="text" name="status" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">备注:</td>
                <td><input class="easyui-textbox" type="text" name="memo" data-options="required:true"/></td>
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

