<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>部门功能</title>
    <style type="text/css">
    .title {
        width: 120px;
    }
    .search-width{
        width: 230px;width: 236px \9;
    }
    .search-txt-width{
        width: 180px;
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="sysDept" action="list" base=".." />");
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            orderTable.mainEasyUIJs();
            url='<g:createLink base=".." controller='sysDept' action='loadZTree'/>';
            init_tree('id','parentId','name',true);
            loadMyTree(url);
        });

        function myAdd() {
//            zTree_obj = $.fn.zTree.getZTreeObj("kindTree");
            var selectedNode = tree_Obj.getSelectedNodes()[0];
            if(selectedNode && selectedNode.level<4){
                orderTable.mainAdd("", "部门-增加");
                $("#parentName").textbox("setValue", selectedNode.name);
                $("#parentId").val(selectedNode.id);
            }else {
                $.messager.alert("系统提示", "此部门下不可以再添加部门了！", "warning");
            }
        }

        function save() {
                $('#editForm').form('submit', {
                    url: "<g:createLink base=".." controller="sysDept" action="save"  />?oneCode=" + oneCode
                    ,
                    success: function (data) {
                        var result = eval('(' + data + ')')
                        if (result.success == "true") {
                            $('#editWindow').dialog('close');
                            $("#mainGrid").datagrid('load');
                            loadMyTree(url);
                            $.messager.alert("系统提示", result.msg, 'info');
                        } else {
                            $.messager.alert("系统提示", result.msg, 'error');
                        }

                    }
                });
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="sysDept" action="edit" base=".." />", "部门-修改", id);
            orderTable.formAction = "<g:createLink controller="sysDept" action="update" base=".." />";
        }

        function del() {
            var rows = $("#mainGrid").datagrid("getSelections");
            if (rows.length < 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return;
            }
            var row = $("#mainGrid").datagrid("getSelected");

//            if (row.parentid.length == 2) {
//            zTree_obj = $.fn.zTree.getZTreeObj("kindTree");
            var node = tree_Obj.getNodeByParam("id", row.id, null);
            if(node.children==undefined){
                nodes_delId = [];
                nodes_delId[0] = row.id;
            }else{
                $.messager.alert('系统提示', '此部门下有下级部门不能删除！', 'warning');
                return;
            }
            $.messager.confirm('系统提示', '您确认删除所选的部门吗？', function (r) {
                if (r) {
                    $.ajax({
                        url: "<g:createLink base=".." controller="sysDept" action="delete"  />?ids=" + nodes_delId,
                        success: function (data) {
                            var result = eval('(' + data + ')')
                            if (result.success == "true") {
                                $("#mainGrid").datagrid("load");
                                loadMyTree(url);
                                $.messager.alert("系统提示", result.msg, 'info');
                            } else {
                                $.messager.alert("系统提示", result.msg, 'error');
                            }

                        }
                    })

                }
            });
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
        function validate_deptcode(){
            var value=$("#code").textbox('getValue');
            $.ajax({
                url: "<g:createLink base=".." controller="sysDept" action="checkCode"  />?code=" + value,
                success: function (data) {
                    var result = eval('(' + data + ')')
                    if (result.success == "true") {
                        return true;
                    } else {
                        $.messager.alert("系统提示", result.msg, 'error');
                        return false;
                    }

                }
            })

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
        <input type="text" id="queryStr" name="queryStr" placeholder="输入部门名称或编码查询" class="search-txt search-txt-width abs  js_isFocus">
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
                <th data-options="field:'name'">部门名称</th>
                <th data-options="field:'code'">编码</th>
                <th data-options="field:'parentName'">上级部门名称</th>
                %{--<th data-options="field:'parentId'">上级部门名称</th>--}%
            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input type="hidden" name="id" id="id"/>
                    <input type="hidden" name="parentId" id="parentId"/>
                    <tr>
                        <td class="title">上级部门名称:</td>
                        <td><input class="easyui-textbox" type="text" name="parentName" id="parentName" readonly="readonly"/></td>
                    </tr>
                    <tr>
                        <td class="title">部门名称:</td>
                        <td><input class="easyui-textbox" type="text" name="name" id="name" data-options="required:true,missingMessage:'部门名称为必填项',invalidMessage:'长度不超过20个汉字或字符！',validType:'maxLength[20]'"/></td>
                    </tr>
                    <tr>
                        <td class="title">编码:</td>
                        <td><input class="easyui-textbox" type="text" name="code" id="code" placeholder="组织机构代码"  data-options="required:true,missingMessage:'编码为必填项',invalidMessage:'长度不超过20个汉字或字符！',validType:'maxLength[20]'"/></td>
                    </tr>
                    <tr>
                        <td class="title">备注:</td>
                        <td class="addr-details-remark"><input class="easyui-textbox" type="text" name="memo" id="memo"/></td>
                    </tr>
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok"
                onclick="save()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
    </div>
</div>
</body>
</html>


