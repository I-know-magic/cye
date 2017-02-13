<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>员工信息</title>
    <style type="text/css">
    .title {
        width: 120px;
    }

    .search-txt-width {
        width: 170px;
    }
    .search-width{
        width: 220px;width: 226px \9;
    }
    </style>
    <script type="text/javascript">
        var dgMain;
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            dgMain = new EasyUIExt($("#mainGrid"), "<g:createLink base=".." controller="employee" action="list"  />");
            dgMain.singleSelect = true;
            dgMain.window = $("#editWindow");
            dgMain.form = $("#editForm");
            dgMain.pagination = true;
            dgMain.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            dgMain.mainEasyUIJs();
            $(".js_show").bind("click", function () {
                $(this).parent().hide(300);
                $(".js_hide").parent().show(300);
                $(".js_box").slideDown("slow");
            })
            $(".js_hide").bind("click", function () {
                $(this).parent().hide(300);
                $(".js_show").parent().show(300);
                $(".js_box").slideUp("slow");
            })
            $(".js_bottom").bind("click", function () {
                $(".js_hide").parent().hide(300);
                $(".js_show").parent().show(300);
                $(".js_box").slideUp("slow");
            })
            $(".js_i").bind("click", function () {
                $("#queryStr").val("");
            });
        });


        function myAdd() {
            dgMain.mainAdd("<g:createLink base=".." controller="employee" action="getCodeAuto"/>", "员工档案-增加",false,function (){
//                $("#discountAmount").numberspinner('setValue', 0);
//                $("#discountRate").numberspinner('setValue', 100);
            });
            dgMain.formAction = "<g:createLink base=".." controller="employee" action="save"  />";
            $('#sub').show();
        }
        function edit(id, code, name) {
            $('#sub').show();
            var rows = $("#mainGrid").datagrid("getSelections");
            if (!id) {
                if (rows.length == 1 && rows[0].code == '0000') {
                    $.messager.alert('系统提示', '【' + rows[0].name + '】员工不能修改', 'info');
                    return
                }
            }

            if (id && code == '0000') {
                $.messager.alert('系统提示', '【' + name + '】员工不能修改', 'info');
                return
            }
            var data = dgMain.mainEdit2("<g:createLink base=".." controller="employee" action="edit"  />", "员工档案-修改", id,
                    function backEdit(data){
                        if(data.branchId != $('#h_branchMenu_r').val()){
                            $('#sub').hide();
                        }
                    });
//            $("#discountAmount").numberspinner('setValue', data.discountAmount);
//            $("#discountRate").numberspinner('setValue', data.discountRate);
//            treeOnCheck();
            dgMain.formAction = "<g:createLink base=".." controller="employee" action="update"  />";
        }
        function del() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].code == '0000') {
                $.messager.alert('系统提示', '【' + rows[0].name + '】员工不能删除', 'info');
                return
            }
            dgMain.mainDel("<g:createLink base=".." controller="employee" action="delete"  />");
        }
        function doSearch() {
            $("#mainGrid").datagrid({
                queryParams: {
                    employeeInfo: $("#queryStr").val(),
                    branchId: $("#branchIdSearch").val()
                }
            });
        }
        function clearSearch() {
            $("#queryStr").val("");
        }
        function resetForm() {
            $("#queryStr").val("");
            $("#branchIdSearch").val($('#h_branchMenu_r').val());
            $("#branchCodeSearch").textbox('setValue',$('#h_branchMenu_name').val());
        }

        function openRole() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].code == '0000') {
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
            var url = "<g:createLink base=".." controller='employee' action='role'/>?userId=" + userId;
            $("#roleWin").window("open").window("refresh", url);

        }
        function closeRole() {
            $("#roleWin").window("close");
        }
        function alertMsg() {
            $.messager.alert("系统提示", "角色重置成功！", 'info');
        }

        function stated(value) {
            if (value == 0) {
                return "未激活";
            }
            if (value == 1) {
                return "启用";
            }
            if (value == 2) {
                return "停用";
            }

        }
        function resetPass() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].code == '0000') {
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
                        url: '<g:createLink base=".." controller='employee' action='resetpass'/>?employeeId=' + employeeId,
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

        function disabledUser() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length == 1 && rows[0].code == '0000') {
                $.messager.alert('系统提示', '【' + rows[0].name + '】员工不能禁用', 'info');
                return
            }
            var rows = jQuery("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                jQuery.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return;
            }
            var row = jQuery("#mainGrid").datagrid("getSelected");
            var employeeId = row.id;
            var state = row.state;
            var msg = '确定要启用账户?';
            if (state == '1') {
                msg = '确定要停用账户?'
            }
            $.messager.confirm('系统提示', msg, function (r) {
                if (r) {
                    $.ajax({
                        type: 'GET',
                        async: true,
                        url: '<g:createLink base=".." controller='employee' action='enableEmployee'/>?employeeId=' + employeeId + '&state=' + state,
                        dataType: 'json',
                        success: function (data) {
                            if (data.success == "true") {
                                $("#mainGrid").datagrid('reload').datagrid('unselectAll');
                                $.messager.alert("系统提示", data.msg, 'info');
                            } else {
                                $.messager.alert('系统提示', data.msg, 'error');
                            }

                        }
                    });
                }
            });
        }
        function codeW(val, row) {
            if (row != null) {
                return "<a href='javascript:void(0)' class='code_open' onClick=edit(" + row.id + "," + row.code + ",'" + row.name + "')>" + val + "</a>";
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
        <li  class="icon alt class_branch_op" onclick="resetPass()">密码重置</li>
        %{--<li  class="icon alt class_branch_op" onclick="disabledUser()">启用/禁用</li>--}%
    </ul>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入姓名查询" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>
%{--<div class="rel clearfix function-btn">--}%
    %{--<ul class="boxtab-btn abs">--}%
        %{--<li  class="icon add" onclick="myAdd()">增 加</li>--}%
        %{--<li  class="icon alt" onclick="edit()">修 改</li>--}%
        %{--<li  class="icon del" onclick="del()">删 除</li>--}%
        %{--<li  class="icon alt" onclick="openRole()">设置角色</li>--}%
        %{--<li class="icon other rel js_other_op">--}%
            %{--其他操作--}%
            %{--<div class="abs boxtab-btn-list js_op_div" style="display: none" jshidden="true">--}%
                %{--<span  onclick="resetPass()">密码重置</span>--}%
                %{--<span  onclick="disabledUser()">启用/禁用</span>--}%
            %{--</div>--}%
        %{--</li>--}%
    %{--</ul>--}%

    %{--<!-- 高级搜索开始 -->--}%
    %{--<!-- 显示全部 -->--}%
    %{--<p class="abs search-more " style="display:block;"><a href="#" class="icon js_show">高级查询</a></p>--}%
    %{--<!-- 收起全部 -->--}%
    %{--<p class="abs search-more " style="display:none;"><a href="#" class="pack-up icon js_hide">收起查询</a></p>--}%

    %{--<div class="abs search-box js_box" style="display:none;">--}%

        %{--<p style="margin-bottom: 15px"></p>--}%

        %{--<p class="search-box-btn">--}%
            %{--<input type="button" onclick="doSearch()" value="搜索">--}%
        %{--</p>--}%

        %{--<p class="search-box-btn gray">--}%
            %{--<input type="button" onclick="resetForm()" value="重置">--}%
        %{--</p>--}%

        %{--<p class="pack-up-bottom icon js_bottom"></p>--}%
    %{--</div>--}%
    %{--<p class="search search-pos-table search-width abs js_p">--}%
        %{--<input type="text" id="queryStr" name="queryStr" placeholder="输入工号或姓名查询"--}%
               %{--class="search-txt search-txt-width abs js_isFocus">--}%
        %{--<input type="button" onclick="doSearch()" class="search-btn icon abs  js_enterSearch">--}%
        %{--<i class="srh-close icon abs" onclick="clearSearch()"></i>--}%
    %{--</p>--}%
%{--</div>--}%


<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
            <th data-options="field:'code',width:100,formatter:codeW">工号</th>
            <th data-options="field:'loginName',width:120,align:'left'">帐号</th>
            %{--<th data-options="field:'branchName',width:240,align:'left'">门店</th>--}%
            <th data-options="field:'name',width:120,align:'left'">姓名</th>
            <th data-options="field:'phone',width:120,align:'left'">电话</th>
            %{--<th data-options="field:'state',formatter:stated,width:80">状态</th>--}%
            %{--<th data-options="field:'loginCount',width:100,align:'right'">登录次数</th>--}%
            %{--<th data-options="field:'lastLoginTime',width:150">最后登录时间</th>--}%
            %{--<th data-options="field:'lastLoginIp',width:150,align:'left'">最后登录IP</th>--}%
            %{--<th data-options="field:'createTime',width:150">创建时间</th>--}%
            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:550px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input type="hidden" name="id" id="id"/>
                    <input type="hidden" name="branchId" id="branchId">
                    <tr>
                        <td class="title"><div style="width: 124px;">工号:</div></td>
                        <td>
                            <input class="easyui-textbox" type="text" name="code" id="code" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title"><div style="width: 124px;">帐号:</div></td>
                        <td>
                            <input class="easyui-textbox" type="text" name="loginName" id="loginName"
                                   readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <th></th>
                        <td><span style="font-size: 12px">默认密码为888888</span></td>
                    </tr>
                    <tr>
                        <td class="title">姓名：</td>
                        <td><input class="easyui-textbox" type="text" name="name"
                                   data-options="required:true,validType:'length[1,20]',
                                   missingMessage:'姓名为必填项',invalidMessage:'长度不超过20个汉字或字符！'"/></td>
                    </tr>
                    <tr>
                        <td class="title">联系电话:</td>
                        <td>
                            <input class="easyui-textbox" type="text" name="phone"
                                   data-options="required:true,missingMessage:'联系电话为必填项',validType:'mobilePhoneAndPhone',prompt:'请输入手机号或者座机'"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>


        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" id="sub"  class="easyui-linkbutton" iconCls="icon-ok"
                onclick="dgMain.mainSave()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="dgMain.mainClose()">取消</a>
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

