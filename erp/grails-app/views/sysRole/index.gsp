<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>角色权限管理</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'employee/employee.js', base: '..')}"></script>
    <style type="text/css">
    .title {
        width: 120px;
    }

    .search-width {
        width: 220px;
    }

    .branch-right {
        right: 320px;
    }
    </style>
    <script type="text/javascript">
        var _orderTable;//记录easyui对象
        %{--var isHeader = ${isHeader};--}%
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
            _orderTable = new EasyUIExt($("#orderTable"), "<g:createLink base=".." controller="employeeRole" action="query" />");
            _orderTable.singleSelect = true;//是否单选
            _orderTable.window = $("#domainWindow");//dialog
            _orderTable.form = $("#domainForm");//表单
            _orderTable.pagination = true;//是否分页
            _orderTable.mainEasyUIJs();
//            initData();
            %{--loadTree2("<g:createLink base=".." controller='branch' action='getBranchArea'/>", $("#branchTree"), branchSetting);--}%
            %{--loadTree2("<g:createLink base=".." controller='branch' action='getBranchArea'/>", $("#branchTreeSearch"), branchSetting);--}%
            loadTree1("<g:createLink base=".." controller='employeeRole' action='querySysPrivilegeAsZTree'/>", $("#cateTree"), setting2);
        });
//        /**
//         * 初始化数据
//         */
//        function initData() {
//            if(!isHeader){
//                $('.class_branch_op').hide();
//            }
//        }
        function getBranchSearch() {
            $("#branchDialogSearch").dialog("open");
        }
        function closeDialog() {
            $("#branchDialog").dialog("close");
        }
        function closeDialogSearch() {
            $("#branchDialogSearch").dialog("close");
        }
        function query() {
            $('#orderTable').datagrid({
                queryParams: {
                    queryStr: $("#queryStr").val(),
                    branchId: $("#branchIdSearch").val()
                }
            });
        }
        function add() {
            _orderTable.mainAdd("<g:createLink base=".." controller="employeeRole" action="getRoleCodeAuto"/>", '角色-增加');
            _orderTable.formAction = "<g:createLink base=".." controller="employeeRole" action="save"  />";
        }
        function saveAndAdd() {
            _orderTable.mainSaveAndAdd();
            $("#domainForm").form('load', "<g:createLink base=".." controller="employeeRole" action="getRoleCodeAuto"/>");
        }
        function edit(id, roleCode, roleName) {
            var rows = $("#orderTable").datagrid("getSelections");
            if (id && roleCode <= '2') {
                $.messager.alert('系统提示', '【' + roleName + '】角色不能修改！', 'info');
                return
            }
            if (!id && rows.length == 1 && rows[0].roleCode <= '02') {
                $.messager.alert('系统提示', '【' + rows[0].roleName + '】角色不能修改！', 'info');
                return
            }

            _orderTable.mainEditRole("<g:createLink base=".." controller="employeeRole" action="edit"  />", '角色-修改', id);
            _orderTable.formAction = "<g:createLink base=".." controller="employeeRole" action="update"  />";
        }
        function dele() {
            var rows = $("#orderTable").datagrid("getSelections");
            if (rows.length == 1 && rows[0].roleCode <= '02') {
                $.messager.alert('系统提示', '【' + rows[0].roleName + '】角色不能删除！', 'info');
                return
            }
            _orderTable.mainDel("<g:createLink base=".." controller="employeeRole" action="delete"  />");
        }

        function closeWindow(windowId) {
            $(windowId).window("close");
        }

        function clearSearch() {
            $("#queryStr").val("");
        }
        function closed_role() {
            $('#rolePowerDialog').dialog('close');
        }
        function roleT(val, row) {
            if (row != null) {
                return "<a href='javascript:void(0)' class='code_open' onClick=edit(" + row.id + "," + row.roleCode + ",'" + row.roleName + "')>" + val + "</a>";
            }
            return val;
        }
    </script>
</head>

<body>

<h3 class="rel ovf js_header">
    <span></span>
    -
    <span></span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li  class="icon add class_branch_op" onclick="add()">增 加</li>
        <li  class="icon alt class_branch_op" onclick="edit()">修 改</li>
        <li  class="icon del class_branch_op" onclick="dele()">删 除</li>
        <li class="icon alt class_branch_op"
            onclick="setRole('<g:createLink base=".." controller="employeeRole" action="queryRolePrivilege"  />')">设置权限</li>
    </ul>
    <p class="search abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入编号或名称" class="search-txt abs js_isFocus">
        <input type="button" onclick="query()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="orderTable"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id', checkbox:true}]]">
            <thead>
            <th data-options="field:'roleCode',width:80">角色编号</th>
            %{--,formatter:roleT--}%
            <th data-options="field:'roleName',width:120,align:'left'">角色名称</th>
            </thead>
        </table>
    </div>

    <div id="domainWindow" class="easyui-dialog"
         data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
         buttons="#window-buttons" style="width:auto;height:auto;padding: 0px 110px 20px 0px">
        <form id="domainForm" method="post">
            <table cellpadding="5" style="table-layout:fixed;">
                <input type="hidden" name="id" id="id"/>
                <input type="hidden" name="branchId" id="branchId">
                <tr>
                    <td class="title">角色编码:</td>
                    <td><input type="text" name="roleCode" id="roleCode" class="easyui-textbox" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <td class="title">角色名称:</td>
                    <td><input class="easyui-textbox" type="text" name="roleName"
                               data-options="required:true,validType:'length[1,20]',
                                   missingMessage:'角色名称为必填项',invalidMessage:'长度不超过20个汉字或字符！'"/></td>
                </tr>
            </table>
        </form>
    </div>

    <div id="window-buttons">
        <a  href="javascript:void(0)" class="easyui-linkbutton class_branch_op" iconCls="icon-ok"
           onclick="_orderTable.mainSave()">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
           onclick="_orderTable.mainClose()">取消</a>
    </div>

    %{--<div id="branchDialogSearch" title="选择门店" buttons="#footerSearch" class="easyui-dialog" data-options="modal:true,closed:true,closable:false,--}%
    %{--onClose:function(){$.fn.zTree.getZTreeObj('branchTreeSearch').checkAllNodes(false);}"--}%
         %{--style="width: 350px;height: 500px;;padding-left: 46px;padding-top: 20px">--}%
        %{--<ul id="branchTreeSearch" class="ztree"></ul>--}%
    %{--</div>--}%

    %{--<div id="footerSearch">--}%
        %{--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true"--}%
           %{--onclick="okCheckSave()">确定</a>--}%
        %{--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="true"--}%
           %{--onclick="closeDialogSearch()">关闭窗口</a>--}%
    %{--</div>--}%

    <div id="rolePowerDialog" class="easyui-dialog" buttons='#excelDialog-buttons' data-options=" modal: true,
                title: '角色-设置权限',
                closed: true,
                closable:true,
                width: 400,
                minimizable:false,
                maximizable:false,
                onClose:function(){
                var bTreeObj=$.fn.zTree.getZTreeObj('cateTree');
                bTreeObj.checkAllNodes(false);
                bTreeObj.expandAll(false);
                },
                height: 450">
        <div style="margin-left: 5%;padding-top: 0px;">
            <ul id="cateTree" class="ztree"></ul>
        </div>
    </div>

    <div id="excelDialog-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
           onclick="saveRolePrivilege('<g:createLink base=".." controller="employeeRole"
                                                                            action="saveRolePrivilege"/>')">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
           onclick="closed_role()">取消</a>
    </div>

</div>

</body>
</html>