<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/6/25
  Time: 18:13
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>角色设置</title>
</head>

<body style="margin:0; width: 100%;height:100%">

<script type="text/javascript">
    var userId =${userId}
    var _userIds;
    var _roles;
    var orderTable;
    $(function () {
        orderTable = new EasyUIExt($("#roleTable"), "<g:createLink base=".." controller="employeeRole" action="query"  />?");
        orderTable.singleSelect = false;
        orderTable.pagination = true;
        orderTable.page_size = 10;
        orderTable.loadSuccess = function (data) {
            $.ajax({
                type: 'GET',
                async: true,
                url: '<g:createLink base=".." controller='employee' action='selectedRole'/>?userId=' + userId,
                dataType: 'json',
                success: function (result) {
                    if (result.success == "true") {
                        var rowIndex;
                        for (var i = 0; i < result.rows.length; i++) {
                            rowIndex = $("#roleTable").datagrid('getRowIndex', result.rows[i]);
                            // $("#roleTable").datagrid('selectRow', result.rows[i]);
                            $("#roleTable").datagrid('selectRow', rowIndex);
                        }
                    } else {
                        $.messager.alert("系统提示", "角色勾选失败！", 'error');
                    }
                }
            });
        };
        orderTable.mainEasyUIJs();
    });
    function closeWindow() {
        window.parent.closeRole();
    }
    var roleIds = new Array();
    function saveRoles() {
        $.messager.confirm('系统提示', '您确认给此用户设置所选的这些角色吗？', function (r) {

            if (r) {
                $("#roleWin").dialog('close');
                $.messager.alert("系统提示", "角色添加成功", 'info');
                var rows = $("#roleTable").datagrid("getSelections");
                for (var i = 0; i < rows.length; i++) {
                    roleIds.push(rows[i].id);
                }
                $.ajax({
                    type: 'GET',
                    async: true,
                    url: '<g:createLink base=".." controller='employee' action='employeeRoles'/>?roleIds=' + roleIds + '&userId=' + userId,
                    dataType: 'json',
                    success: function (data) {
                        if (data.success == "true") {
                            window.parent.closeRole();
                            window.parent.alertMsg();
                        } else {
                            $.messager.alert("系统提示", "角色重置失败！", 'info');
                        }

                    }
                });
            }
        });

    }
</script>

<div class="easyui-panel" style="width: 100%;height:100%;overflow: hidden">

    <table id="roleTable"
           data-options="fit:true, fitColumns:true, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
        <thead>
        <th data-options="field:'roleCode',width:12">角色编号</th>
        <th data-options="field:'roleName',width:12,align:'left'">角色名称</th>
        %{--<th data-options="field:'branchName',width:25,align:'left'">门店</th>--}%
        </thead>
    </table>
</div>

%{--<div id="footer" style="text-align: right">--}%
%{--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveRoles()">保存</a>--}%
%{--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeWindow()">取消</a>--}%
%{--</div>--}%

</body>
</html>