<%--
  Created by IntelliJ IDEA.
  User: lvpeng
  Date: 2015/5/6
  Time: 09:06
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title></title>
    <script type="text/javascript">
        var orderTable;
        $(function(){
            //创建datagrid对象
            orderTable=new EasyUIExt($("#adminUserTable"),"<g:createLink base=".." controller="adminUser" action="index"  />");
            orderTable.title="";
            orderTable.singleSelect=false;//是否单选
            orderTable.window=$("#adminUserinfoWindow");//dialog
            orderTable.form=$("#adminUserorder");//表单
            orderTable.pagination=true;//是否分页
            orderTable.clickRow=function(index,row){
            };
            orderTable.mainEasyUIJs();
        });

        function myAdd(){
            orderTable.mainAdd();
            orderTable.formAction="<g:createLink base=".." controller="adminUser" action="save"  />";
        }
        function edit(){
            orderTable.mainEdit("<g:createLink base=".." controller="adminUser" action="edit"  />");
            orderTable.formAction="<g:createLink base=".." controller="adminUser" action="save"  />";
        }

        function repassword(){
            var url = "<g:createLink base=".." controller="adminUser" action="repassword"  />"
            var rows = $("#adminUserTable").datagrid("getSelections");
            if (rows.length != 1) {
                $.messager.alert('系统提示', '操作失败，请选择一条数据记录！', 'info' );
                return;
            }

            var ids = rows[0].id

            tempDataGrid = $("#adminUserTable");
            var msg='确定重置密码?'
            $.messager.confirm('系统提示',msg,function(r){
                if (r){
                    $.post(url+'?ids='+ids,function(result){
                        if (result.success=="true"){
                            tempDataGrid.datagrid('reload').datagrid('unselectAll');
                            $.messager.alert('系统提示', result.msg, 'success');
                        } else {
                            $.messager.alert('系统提示', result.msg, 'error');
                        }
                    },'json');
                }
            });
        }
        function disabledUser(){
            var url = "<g:createLink base=".." controller="adminUser" action="disabled"  />"
            var rows = $("#adminUserTable").datagrid("getSelections");
            if (rows.length != 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
                return;
            }
            var ids = rows[0].id
            var state= rows[0].state
            var msg='确定要启用账户?'
            tempDataGrid = $("#adminUserTable");
            if(state=='1'){
                msg='确定要停用账户?'
            }
            $.messager.confirm('系统提示',msg,function(r){
                if (r){
                    $.post(url+'?ids='+ids+'&state='+state,function(result){
                        if (result.success=="true"){
                            tempDataGrid.datagrid('reload').datagrid('unselectAll');
                            $.messager.alert('系统提示', result.msg, 'success');
                        } else {
                            $.messager.alert('系统提示', result.msg, 'error');
                        }
                    },'json');
                }
            });
        }
        function del(){
            orderTable.mainDel("<g:createLink base=".." controller="adminUser" action="deleteSysUser"  />");
        }
        function doSearch(){
            $('#adminUserTable').datagrid({
                queryParams: {
                    userName: $("#userName").val()
                }
            });

        }
        /**
        *启用状态
         *
        * @param value0-未激活；1-启用；2-停用
        * @param row
        * @param index
        * @returns {string}
         */
        function stated(value){
            if(value==0){
                return "未激活";
            }
            if(value==1){
                return "启用";
            }
            if(value==2){
                return "停用";
            }

        }
        function cleardata(){
            formclear("myForm")
        }
        var _userIds;
        var _roles;
        //用户组设置
        function role() {
            _roles = new Object();
            var rows = jQuery("#adminUserTable").datagrid("getSelections");
            if (rows.length < 1) {
                jQuery.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
                return;
            }
            jQuery("#roleList").datalist("loadData", new Array());
            _userIds = new Array();
            for (var i = 0; i < rows.length; i++) {
                _userIds.push(rows[i]["id"])
            }
            jQuery.post("<g:createLink base=".." controller="sysRole" action="roleList" />?userIds="+_userIds, function(data) {
                if (data && data != "") {
                    jQuery("#roleList").datalist("loadData", data);
                    jQuery("#roleWindow").window("open");
                }
            });
        }
        function roleCheck(rowIndex, rowData) {
            rowData.checked = true;
            roleChange(rowData);
        }
        function roleUncheck(rowIndex, rowData) {
            rowData.checked = false;
            roleChange(rowData);
        }
        function roleChange(rowData) {
            var r = _roles[rowData.id];
            if (r == null || r == undefined) {
                _roles[rowData.id] = rowData.checked;
                return;
            }
            if (r != rowData.checked) {
                _roles[rowData.id] = null;
            }
        }
        function closeWindow(windowId) {
            jQuery(windowId).window("close");
        }
        function saveRoles() {
            var addRoles = new Array();
            var rmRoles = new Array();
            for (var i in _roles) {
                if (_roles[i] == true) {
                    addRoles.push(i);
                } else if (_roles[i] == false) {
                    rmRoles.push(i);
                }
            }
            jQuery.post("<g:createLink base=".." controller="sysRole" action="saveUserRole" />?userIds="+_userIds+"&addRoles="+addRoles+"&rmRoles="+rmRoles,function(data) {
                if (data && data != "") {
                    jQuery.messager.alert('系统提示', data.msg, 'info' );
                    closeWindow("#roleWindow");
                }
            });
        }
        var _areas;
        function area() {
            _areas = new Object();
            var rows = jQuery("#adminUserTable").datagrid("getSelections");
            if (rows.length < 1) {
                jQuery.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
                return;
            }
            jQuery("#areaTree").tree("loadData", new Array());
            _userIds = new Array();
            for (var i = 0; i < rows.length; i++) {
                _userIds.push(rows[i]["id"])
            }
            jQuery.post("<g:createLink base=".." controller="sysRole" action="areaList" />?userIds="+_userIds, function (data) {
                if (data && data != "") {
                    jQuery("#areaTree").tree("loadData", data);
                    jQuery("#areaWindow").window("open");
                }
            });
        }

        function saveAreas() {
            var areaIds = new Array();
            var rows = jQuery("#areaTree").tree("getChecked");
            for (var i in rows) {
                var row = rows[i];
                if (row.id != 0) {
                    areaIds.push(row.id);
                }
            }
            jQuery.post("<g:createLink base=".." controller="sysRole" action="saveUserArea" />?userIds="+_userIds+"&areaIds="+areaIds,function(data) {
                if (data && data != "") {
                    jQuery.messager.alert('系统提示', data.msg, 'info' );
                    closeWindow("#areaWindow");
                }
            });
        }
    </script>
</head>

<body>
<table  class="easyui-datagrid" id="adminUserTable" toolbar="#tb" data-options="fit:true, fitColumns:true, idField : 'id',frozenColumns:[[{
	    field:'id',
	    checkbox:true
	}]]">
   <thead>
       <th data-options="field:'loginName'">用户账号</th>
       <th data-options="field:'name'">姓名</th>
       <th data-options="field:'state' ,formatter:stated">状态</th>
       <th data-options="field:'loginCount'">登录次数</th>
       <th data-options="field:'dateCreated'">创建时间</th>
       <th data-options="field:'lastLoginTime'">最后登录时间</th>
       <th data-options="field:'lastLoginIp'">最后登录IP</th>

   </thead>
</table>
<div id="tb" style="padding:5px;height:auto">
    <div style="margin-bottom:5px;">
        <div>
            <form id="myForm">
            <table>
                <tr>
                    <td>用户帐号/名称:<input class="easyui-textbox" data-options="prompt:'请输入用户名或帐号'" id="userName" name="userName"></td>
                    <td><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doSearch()">查询</a></td>
                    <td><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" onclick="cleardata()">清空</a></td>
                </tr>
           </table>
           </form>
        </div>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="myAdd()">增加</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="disabledUser()">启用/禁用</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="repassword()">密码重置</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-anquan" plain="true" onclick="role()">用户组设置</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-dingwei" plain="true" onclick="area()">区域权限设置</a>
    </div>
    </div>
<div id="adminUserinfoWindow" class="easyui-dialog" data-options="modal:true,closed:true,iconCls:'icon-save'" buttons="#infoWindow-buttons" style="width:400px;height:400px;">
    <form id="adminUserorder" method="post">
        <table cellpadding="5">

            <input class="easyui-validatebox" type="hidden" name="sysUser.id"/>
            <input class="easyui-validatebox" type="hidden" name="sysUser.userType" value="4"/>
            <tr>
                <td>用户账号:</td>
                <td><input class="easyui-validatebox textbox" type="text" name="sysUser.loginName" data-options="required:true,validType:'loginName'"/></td>
            </tr>
            <tr>
                <td>姓名:</td>
                <td><input class="easyui-validatebox textbox" type="text" name="sysUser.name" data-options="required:true"/></td>
            </tr>
        </table>
    </form>
</div>
<div id="infoWindow-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="orderTable.mainSave()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="orderTable.mainClose()">取消</a>
</div>
<div id="roleWindow" class="easyui-window" title="用户组设置" data-options="modal:true,closed:true,iconCls:'icon-anquan'" style="width:300px;height:460px;padding:10px;">
    <div class="easyui-layout" style="width:250px;height:370px;">
        <div class="easyui-datalist" id="roleList" data-options="checkbox:true, selectOnCheck: false, fit:true, border:false, onBeforeSelect:function(){return false;}, onCheck:roleCheck, onUncheck:roleUncheck"></div>
    </div>
    <div style="text-align:right;padding:0">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveRoles()">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeWindow('#roleWindow')">取消</a>
    </div>
</div>
<div id="areaWindow" class="easyui-window" title="区域权限设置" data-options="modal:true,closed:true,iconCls:'icon-dingwei'" style="width:400px;height:460px;padding:10px;">
    <div class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',fit:true,border:false" >
            <ul id="areaTree" class="easyui-tree" data-options="checkbox:true"></ul>
        </div>
        <div style="text-align:right;padding:0;height: 30px;" data-options="region:'south',border:false">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAreas()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeWindow('#areaWindow')">取消</a>
        </div>
    </div>
</div>
</body>
</html>
