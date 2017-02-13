<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>员工功能</title>
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
    .addr-details-remark .textbox-invalid {
        width: 240px !important;
        height: 60px !important;
    }

    .addr-details-remark .textbox {
        width: 240px !important;
        height: 60px !important;
    }

    .addr-details-remark .textbox-text {
        width: 240px !important;
        overflow: hidden;
        height: 60px !important;
    }
    </style>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'ztree-cus.js',base: '..')}"></script>
    <script type="text/javascript">
        var orderTable;
        var url;
        var nodes_delId = [];
        var oneCode;//一级分类编码
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="sysEmp" action="list"  />");
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            orderTable.mainEasyUIJs();
            url='<g:createLink base=".." controller='branch' action='loadZTree'/>';
            init_tree('id','tenantId','name',true);
            loadMyTree(url);
        });

        function myAdd() {
            var selectedNode = tree_Obj.getSelectedNodes()[0];
            if(selectedNode && selectedNode.id ==-1){
                $.messager.alert("系统提示", "所有部门不能添加员工！", "warning");
                return false;
            }
            if(selectedNode){
                orderTable.mainAdd("", "员工-增加");
                $("#deptName").textbox("setValue", selectedNode.name);
                $("#deptId").val(selectedNode.id);
            }else {
                $.messager.alert("系统提示", "请选择部门！", "warning");
            }
            %{--orderTable.mainAdd("<g:createLink controller="sysEmp" action="create"/>","部门-增加");--}%
            %{--orderTable.formAction = "<g:createLink controller="sysEmp" action="save"  />";--}%
        }
        function save() {
            $('#editForm').form('submit', {
                url: "<g:createLink base=".." controller="sysEmp" action="save" />",
                success: function (data) {
                    var result = eval('(' + data + ')')
                    if (result.success == "true") {
                        $('#editWindow').dialog('close');
                        $("#mainGrid").datagrid('load');
                        $.messager.alert("系统提示", result.msg, 'info');
                    } else {
                        $.messager.alert("系统提示", result.msg, 'error');
                    }

                }
            });
        }
        function edit(id) {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return;
            }
            var deptName=rows[0].deptName;
            var data=orderTable.mainEdit2("<g:createLink controller="sysEmp" action="edit"  />", "部门-修改", id);
            if(data){
                $("#deptName").textbox("setValue", deptName);
                orderTable.formAction = "<g:createLink controller="sysEmp" action="update"  />";

            }
        }
        function del() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].id == 1) {
                $.messager.alert('系统提示', '【' + rows[0].name + '】员工不能删除', 'info');
                return
            }
            orderTable.mainDel("<g:createLink controller="sysEmp" action="delete"  />");
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
        function resetPass() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].id == 1) {
                $.messager.alert('系统提示', '【' + rows[0].name + '】员工不能重置密码', 'info');
                return
            }
            var rows = jQuery("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                jQuery.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return;
            }
            var row = jQuery("#mainGrid").datagrid("getSelected");
            var employeeId = row.id
            $.messager.confirm('确认重置', '您确认重置此用户的密码吗？', function (r) {
                if (r) {
                    $.ajax({
                        type: 'GET',
                        async: true,
                        url: '<g:createLink base=".." controller='sysEmp' action='resetpass'/>?employeeId=' + employeeId,
                        dataType: 'json',
                        success: function (data) {
                            if (data.success == "true") {
                                $.messager.alert("系统提示", "密码重置成功，密码重置为888888!", 'info');
                            } else {
                                $.messager.alert('系统提示', data.msg, 'error');
                            }

                        }
                    });
                }
            });
        }
        function openRole() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].loginName == 'admin') {
                $.messager.alert('系统提示', '【' + rows[0].name + '】员工不能设置角色！', 'info');
                return
            }
            var rows = jQuery("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                jQuery.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return;
            }
            //获取用户Id
            var row = jQuery("#mainGrid").datagrid("getSelected");
            var userId = row.id;
            var url = "<g:createLink base=".." controller='sysEmp' action='role'/>?userId=" + userId;
            $("#roleWin").window("open").window("refresh", url);

        }
        function closeRole() {
            $("#roleWin").window("close");
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
        <li  class="icon alt class_branch_op" onclick="resetPass()">密码重置</li>
        <li  class="icon alt class_branch_op" onclick="openRole()">设 置 角 色</li>
        %{--<li  class="icon alt class_branch_op" onclick="del()">启 用/禁 用</li>--}%
    </ul>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入姓名或电话查询" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-l fl" style="background:#dfe3e5;">
        <ul id="kindTree" class="ztree">
        </ul>
    </div>
    <div class="table-list-r fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
                <th data-options="field:'name'">姓名</th>
                <th data-options="field:'loginName'">登录账号</th>
                <th data-options="field:'phone'">电话</th>
                <th data-options="field:'addr'">地址</th>
                <th data-options="field:'deptName'">门店名称</th>
                %{--<th data-options="field:'userId'">登录用户id</th>--}%
                %{--<th data-options="field:'deptId'">部门id</th>--}%


            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input  type="hidden" name="id" id="id"/>
                    <input  type="hidden" name="deptId" id="deptId"/>
                    <input  type="hidden" name="userId" id="userId"/>
                    <tr>
                        <td class="title">门店名称:</td>
                        <td><input class="easyui-textbox" type="text" name="deptName" id="deptName" readonly="readonly" /></td>
                    </tr>
                    <tr>
                        <td class="title">姓名:</td>
                        <td><input class="easyui-textbox" type="text" name="name" data-options="required:true,missingMessage:'姓名为必填项',invalidMessage:'长度不超过20个汉字或字符！',validType:'maxLength[20]'"/></td>
                    </tr>
                    <tr>
                        <td class="title">电话:</td>
                        <td><input class="easyui-textbox" type="text" name="phone" data-options="required:true,missingMessage:'联系电话为必填项',validType:'mobilePhoneAndPhone',prompt:'请输入手机号或者座机'"/></td>
                    </tr>
                    <tr>
                        <td class="title">联系地址:</td>
                        <td class="addr-details-remark"><input class="easyui-textbox" type="text" name="addr" data-options="required:true,missingMessage:'地址为必填项',invalidMessage:'长度不超过50个汉字或字符！',validType:'maxLength[50]'"/></td>
                    </tr>
                    %{--<tr>--}%
                        %{--<td class="title">备注:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="memo" data-options="required:true"/></td>--}%
                    %{--</tr>--}%
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok"
                onclick="save()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
        %{--角色设置--}%
        <div class="easyui-dialog" title="角色设置" buttons="#footer" id="roleWin"
             data-options="modal:true,minimizable:false,maximizable:false,closed:true,closable:true,align:'left'"
             style="width: 450px;height:400px;overflow-y: hidden;overflow-x: hidden">
        </div>

        <div id="footer">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveRoles()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeRole()">取消</a>
        </div>
    </div>
</div>
</body>
</html>

