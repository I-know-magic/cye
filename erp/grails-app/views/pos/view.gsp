<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>pos管理</title>
    <!-- pos管理-->
    <script type="text/javascript" src="${resource(dir: 'js', file: 'pos/pos.js', base: '..')}"></script>
    <style type="text/css">
    .title {
        width: 120px;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        var _user_branchId;
        var h_branch_url = '<g:createLink base=".." controller="saleReport" action="branchview"/>';
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
            orderTable = new EasyUIExt($("#posTable"), "");
            orderTable.singleSelect = false;
            orderTable.window = $("#posInfoWindow");
            orderTable.form = $("#posOrder");
            orderTable.pagination = true;
            orderTable.clickRow = function (index, row) {
            };
            orderTable.mainEasyUIJs();
            _user_branchId = ${branch.id};
            initBranch();

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
            doSearch();
        });

        function myAdd() {
            orderTable.mainAdd('<g:createLink base=".." controller="pos" action="getNextPosCode" />');
            orderTable.formAction = "<g:createLink base=".." controller="pos" action="save"  />";
            $('#posInfoWindow').dialog('open').dialog('setTitle', "pos管理-增加");
            $('#pos_add_branch').combobox("select", '000');
        }
        function edit() {
//            $('.hide_1').hide();
            orderTable.mainEdit("<g:createLink base=".." controller="pos" action="edit"  />");
            orderTable.formAction = "<g:createLink base=".." controller="pos" action="update"  />";
        }
        function del() {
            var rows = $('#posTable').datagrid("getSelections");
            var is = true;
            $.each(rows, function (index, item) {
                if (item.branchId != _user_branchId) {
                    $.messager.alert('系统提示', '不能删除分店pos机【' + item.posCode + ':' + item.branchName + '】', 'warning');
                    is = false;
                    return false
                }
            });
            if (is) {
                orderTable.mainDel("<g:createLink base=".." controller="pos" action="delete"  />");
            }
        }
        function doSearch() {
            $('#posTable').datagrid({
                url : '<g:createLink base=".." controller="pos" action="list"  />',
                queryParams: {
                    posCode: $("#queryStr").val(),
                    branchId: $('#branchMenu_r').val()
                }
            });
        }
        function cleardata() {
            formclear("myForm")
        }
        function statusFm(val, row) {
            if (val != null) {
                if (val == 1) return '启用';
                else return '禁用'.fontcolor('red');
            }
            return val;
        }
        function deviceCodeFm(val, row) {
            if (val == null ||val=='') {
                val='未注册';
            }
            return val;
        }
        /*    function function1 (obj){
         var temp=document.getElementById("pw").value;
         if(obj.checked){
         document.getElementById("pass").innerHTML="<input class='easyui-textbox'  type='text' id='pw' name=pw>";
         }
         else
         {
         document.getElementById("pass").innerHTML="<input class='easyui-textbox' type='password' id='pw' name=pw>";
         }
         document.getElementById("pw").value=temp;
         }*/
        function fmBranch(row) {
            var s = '<span style="font-weight:bold;font-size: 14px" >' + row.name + '</span><br/>' +
                    '<span style="color:#888;margin-left: 0px">联系人:' + row.contacts + ' 地址:' + row.address + '</span>';
            return s;
        }
        function branchFm(v, r) {
            return r.branchCode + '-' + r.branchName;
        }
        function clearSearch() {
            $('#queryStr').val('');
        }
        function updatePos(id) {
            $('#p_update').show();
            var url = '<g:createLink base=".." controller="pos" action="edit"  />' + '?';
            var rowId = id ? id : null;
            if (!rowId) {
                var rows = $('#posTable').datagrid("getSelections");
                if (rows.length == 1) {
                    if (rows[0].branchId != _user_branchId) {
                        $.messager.alert('系统提示', '不能修改分店pos机【' + rows[0].posCode + ':' + rows[0].branchName + '】', 'warning');
                        return
                    }
                    rowId = rows[0].id
                } else {
                    $.messager.alert('系统提示', '请选择一条数据记录！！', 'warning');
                    return
                }
            }
            $.ajax({
                type: "GET",
                url: url + 'id=' + rowId,
                cache: false,
                async: true,
                dataType: "json",
                success: function (data) {
                    $('#posOrder_').form('load', data);
                    if(data.branchId != _user_branchId){
                        $('#p_update').hide();
                    }
                }
            });
            $('#posInfoWindow_u').dialog('open').dialog('setTitle', "pos管理-修改");
        }
        /* function updatePassword() {
         var rows = $('#posTable').datagrid("getSelections");
         var url = '<g:createLink base=".." controller="pos" action="edit"  />' + '?';
         if (rows.length == 1) {
         if (rows[0].branchId != _user_branchId) {
         $.messager.alert('系统提示', '不能重置分店pos机【' + rows[0].posCode + ':' + rows[0].branchName + '】密钥', 'warning');
         return
         }
         $('#posOrder_p').form('load', url + 'id=' + rows[0].id);
         $('#posInfoWindow_p').dialog('open').dialog('setTitle', "pos-重置密钥");
         } else {
         $.messager.alert('系统提示', '请选择一条数据记录！！', 'warning');
         }
         }*/
        function resetBranch() {
            var rows = $('#posTable').datagrid("getSelections");
            var url = '<g:createLink base=".." controller="pos" action="resetBranch"  />' + '?';
            if (rows.length == 1) {
                if (rows[0].branchId != _user_branchId) {
                    $.messager.alert('系统提示', '不能注销分店pos机【' + rows[0].posCode + ':' + rows[0].branchName + '】', 'warning');
                    return
                }
                $.messager.confirm('系统提示', '确定注销POS？注销后POS终端将无法使用，若要重新启用，需要重新注册和初始化，请谨慎操作！', function (r) {
                    if (r) {
                        $.post(url + 'id=' + rows[0].id, function (result) {
                            if (result.success == "true") {
                                $.messager.alert('系统提示', 'POS终端'+rows[0].posCode+result.msg, 'info');
                                doSearch();
                            } else {
                                $.messager.alert('系统提示', result.msg, 'error');
                            }
                        }, 'json');
                    }
                });
            } else {
                $.messager.alert('系统提示', '请选择一条数据记录！！', 'warning');
            }
        }
        function nextKindDeal(value, row, index) {
            return "<a href='javascript:void(0)' onclick=viewGoodList('" + row.id + "') style='color: #ffa200' >查看</a>"
        }
        function viewGoodList(id) {
            var url = '<g:createLink base=".." controller="pos" action="find"  />' + '?';
            $('#posOrder_list').form('load', url + 'id=' + id);
            $('#posInfoWindow_u_list').dialog('open').dialog('setTitle', "初始化信息");
        }

        function codeP(val, row) {
            if (row != null) {
                return "<a href='javascript:void(0)' class='code_open' onClick=updatePos('" + row.id + "')>" + val + "</a>";
            }
            return val;
        }
        function resetForm(){
            $('#queryStr').val('');
            $('#branchMenu_r').val($('#h_branchMenu_r').val());
            $('#branch').textbox('setText',$('#h_branchMenu_name').val());
        }

        function changePass(){
            var $input=$("#password").next("span").find("input");
            if($($input[0]).is(":password")){
                $($input[0]).attr("type","text");
            }else{
                $($input[0]).attr("type","password");
            }
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
        <li  class="icon add" onclick="myAdd()">增 加</li>
        <li  class="icon alt" onclick="updatePos()">修 改</li>
        <li  class="icon alt" onclick="resetBranch()">设备注销</li>
        %{-- <li  class="icon alt" onclick="updatePassword()">重置密钥</li>--}%
        <li  class="icon del" onclick="del()">删 除</li>
    </ul>

    <!-- 高级搜索开始 -->
    <!-- 显示全部 -->
    <p class="abs search-more " style="display:block;"><a href="#" class="icon js_show">高级查询</a></p>
    <!-- 收起全部 -->
    <p class="abs search-more " style="display:none;"><a href="#" class="pack-up icon js_hide">收起查询</a></p>

    <div class="abs search-box js_box" style="display:none;">
        <input type="hidden" class="search" id="branchMenu_r" value="${branch.id}">
        <input type="hidden" class="search" id="h_branchMenu_r" value="${branch.id}">
        <input type="hidden" class="search" id="h_branch_type" value="${branch.branchType}">
        <input type="hidden" class="search" id="h_branchMenu_name" value="${branch.name}">
        <form id="searchForm">
            <p class="p_branch_">
                <span>门店：</span>
                <input id="branch" name="searchCode" value="${branch.name}">
            </p>
        </form>

        <p style="margin-bottom: 15px"></p>

        <p class="search-box-btn">
            <input type="button" onclick="doSearch()" value="搜索">
        </p>

        <p class="search-box-btn gray">
            <input type="button" onclick="resetForm()" value="重置">
        </p>

        <p class="pack-up-bottom icon js_bottom"></p>
    </div>

    <p  class="search abs search-pos-table js_p">
        <input type="text" id="queryStr" name="queryStr" placeholder="请输入POS编号 " class="search-txt abs js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="posTable" data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{
	    field:'id',
	    checkbox:true }]]">
            <thead>
            <th data-options="field:'posCode',width:80,formatter:codeP">POS号</th>
            <th data-options="field:'branchName',formatter:branchFm,width:240,align:'center'">所属门店</th>
            <th data-options="field:'password',width:120,hidden:'hidden'">密钥</th>
            <th data-options="field:'deviceCode',formatter:deviceCodeFm,width:280,align:'left'">设备码</th>
            <th data-options="field:'status',formatter:statusFm,width:80">状态</th>
            <th data-options="field:'createAt',formatter:dateFormatter,width:120">登记日期</th>
            <th data-options="field:'appName',width:80 ">app名称</th>
            <th data-options="field:'appVersion',width:80 ">app版本</th>
            <th data-options="field:'kind',width:80,formatter:nextKindDeal ">初始化信息</th>
            <th data-options="field:'branchId',hidden: true ">本店</th>
            </thead>
        </table>

        <div id="posInfoWindow" class="easyui-dialog dialog-pad"
             data-options="modal:true,closed:true,closable:true,top:'80px',onClose:function(){$('#posOrder').form('reset');}"
             buttons="#infoWindow-buttons" style="width:auto;height:auto;padding: 0px 110px 20px 0px">
            <form id="posOrder" method="post">
                <table cellpadding="5" class="dialogForm" border="0" style="table-layout:fixed;">
                    %{--<input class="easyui-validatebox" type="hidden" name="id"/>--}%
                    <tr>
                        <td class="title"><div style="width: 124px;">POS号:</div></td>
                        <td><input type="text" name="posCode" class="easyui-textbox" readonly="readonly"/>
                        </td>
                    </tr>
                    %{--<tr id="isDelete"> update hxh--}%
                    %{--<td class="title">所属门店:</td>--}%
                    %{--<td><input id="pos_add_branch" class="easyui-combobox" style="width: 100%" name="branchCode" data-options="--}%
                    %{--url:'<g:createLink base=".." controller="branch" action="getBranchAsJson"/>?'+'&random='+Math.random(),--}%
                    %{--method:'get',--}%
                    %{--valueField:'code',--}%
                    %{--editable:false,--}%
                    %{--textField:'name',--}%
                    %{--panelWidth: 280,--}%
                    %{--panelHeight:200,--}%
                    %{--required:true,--}%
                    %{--missingMessage:'请选择门店',--}%
                    %{--formatter:fmBranch"></td>--}%
                    %{--</tr>--}%
                    <tr>
                        <td class="title">状态:</td>
                        <td>
                            <select class="easyui-combobox" editable="false" id='add_status' name="status"
                                    data-options=" panelHeight:'auto',required:true" style="width: 40%;">
                                <option value="1">启用</option>
                                <option value="0">禁用</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="hide_1">
                        <td class="title">密钥:</td>
                        <td><input class="easyui-textbox" type="password" id="password" name="password"
                                   data-options="required:true,missingMessage:'POS密钥,6位数字',validType:'validatePassword'"/>
                        </td>
                        <td><input type="checkbox"  onclick="changePass()"/>显示秘钥</td>
                    </tr>
                    <tr>
                        <th></th>
                        <td><span style="font-size: 12px">密钥在POS终端初始注册时使用，作为验证凭据</span></td>
                    </tr>
                    %{--       <tr class="hide_1">
                               <td class="title">确认密钥:</td>
                               <td><input class="easyui-textbox" type="password" id="checkPw"
                                          data-options="required:true,missingMessage:'请再次输入密钥'"
                                          validType="checkPw['#password']"/></td>
                           </tr>--}%
                </table>
            </form>
            %{--</div>--}%
        </div>

        <div id="posInfoWindow_u" class="easyui-dialog"
             data-options="modal:true,closed:true,closable:true,top:'80px',onClose:function(){$('#posOrder_').form('reset');}"
             buttons="#infoWindow-buttons_u" style="width:auto;height:auto;padding: 0px 110px 20px 0px">
            <form id="posOrder_" method="post">
                <table cellpadding="5" class="dialogForm" border="0" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id"/>
                    <tr>
                        <td class="title">POS号:</td>
                        <td><input class="easyui-textbox" type="text" name="posCode" readonly="readonly"/>
                        </td>
                    </tr>
                    %{--<tr>--}%
                    %{--<td class="title">所属门店:</td>--}%
                    %{--<td><input class="easyui-combobox" style="width: 100%" name="branchCode" id="branchCode"--}%
                    %{--data-options="--}%
                    %{--url:'<g:createLink base=".." controller="branch" action="getBranchAsJson"/>?'+'&random='+Math.random(),--}%
                    %{--method:'get',--}%
                    %{--valueField:'code',--}%
                    %{--editable:false,--}%
                    %{--textField:'name',--}%
                    %{--panelWidth: 280,--}%
                    %{--panelHeight:200,--}%
                    %{--required:true,--}%
                    %{--missingMessage:'请选择门店',--}%
                    %{--formatter:fmBranch"></td>--}%
                    %{--</tr>--}%
                    <tr>
                        <td class="title">状态:</td>
                        <td>
                            <select class="easyui-combobox" editable="false" name="status"
                                    data-options=" panelHeight:'auto',required:true" style="width: 40%;">
                                <option value="1">启用</option>
                                <option value="0">禁用</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="title">
                        <td class="title">密钥:</td>
                        <td><input class="easyui-textbox" type="password"  name="password"
                                   data-options="required:true,validType:'validatePassword'"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">设备码:</td>
                        <td><input class="easyui-textbox" type="text" name="deviceCode" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">登记日期:</td>
                        <td><input class="easyui-textbox" type="text" name="createAt" readonly="readonly"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>

        <div id="posInfoWindow_u_list" class="easyui-dialog"
             data-options="modal:true,closed:true,closable:true,top:'80px',onClose:function(){$('#posOrder_').form('reset');}"
             buttons="#infoWindow-buttons_u_list" style="width:auto;height:auto;padding: 0px 110px 20px 0px">
            <form id="posOrder_list" method="post">
                <table cellpadding="5" class="dialogForm" border="0" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id"/>
                    <tr>
                        <td class="title">商户号:</td>
                        <td><input class="easyui-textbox" type="text" name="tenantCode" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">门店号:</td>
                        <td><input class="easyui-textbox" type="text" name="branchCode" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">POS号:</td>
                        <td><input class="easyui-textbox" type="text" name="posCode" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">密钥:</td>
                        <td><input class="easyui-textbox" type="text" name="password" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">app名称:</td>
                        <td><input class="easyui-textbox" type="text" name="appName" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">app版本:</td>
                        <td><input class="easyui-textbox" type="text" name="appVersion" readonly="readonly"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>

        <div id="posInfoWindow_p" class="easyui-dialog"
             data-options="modal:true,closed:true,closable:false,top:'80px',onClose:function(){$('#posOrder_p').form('reset');}"
             buttons="#infoWindow-buttons_p" style="width:auto;height:auto;padding: 0px 110px 20px 0px">
            <form id="posOrder_p" method="post">
                <table cellpadding="5" class="dialogForm" border="0" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id"/>
                    <tr class="hide_1">
                        <td class="title">新密钥:</td>
                        <td><input class="easyui-textbox" type="password" id="password_p" name="password"
                                   data-options="required:true,missingMessage:'POS密钥,6位数字',validType:'validatePassword'"/>
                        </td>
                    </tr>
                    <tr class="hide_1">
                        <td class="title">确认密钥:</td>
                        <td><input class="easyui-textbox" type="password" id="checkPw_p"
                                   data-options="required:true,missingMessage:'请再次输入密钥'"
                                   validType="checkPw['#password_p']"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
               onclick="orderTable.mainSave()">保存</a>
            <a  href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
               onclick="saveFrom('posOrder', '<g:createLink base=".." controller="pos" action="save" />', null, '<g:createLink base=".." controller="pos" action="getNextPosCode" />')">保存并新增</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>

        <div id="infoWindow-buttons_u">
            <a  href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" id="p_update"
                onclick="saveFrom('posOrder_', '<g:createLink base=".." controller="pos" action="update"  />', 'posInfoWindow_u')">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="closedDialog('posInfoWindow_u', 'close')">取消</a>
        </div>

        <div id="infoWindow-buttons_p">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
               onclick="saveFrom('posOrder_p', '<g:createLink base=".." controller="pos" action="updatePassword"  />', 'posInfoWindow_p')">修改</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="closedDialog('posInfoWindow_p', 'close')">取消</a>
        </div>

        <div id="infoWindow-buttons_u_list">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="closedDialog('posInfoWindow_u_list', 'close')">确定</a>
        </div>
        <div id="select_dialog" class="easyui-dialog" data-options="modal:true,closed:true"
             buttons="#infoWindow-buttons_branch" style="width: 350px;height: 500px;overflow-x: hidden;overflow-y: auto">
        </div>

        <div id="infoWindow-buttons_branch">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="report_save()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closedDialog('select_dialog','close')">取消</a>
        </div>
    </div>
</div>
</body>
</html>

