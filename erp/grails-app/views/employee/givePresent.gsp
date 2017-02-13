<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>菜品单位</title>
    <style type="text/css">
    .title {
        width: 120px;
    }

    .search-width {
        width: 220px;
        width: 226px \9;
    }

    .search-txt-width {
        width: 170px;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        var isHeader = ${isHeader};
        //var isHeader =false;
        $(function () {
            if (!isHeader) {
                $('.boxtab-btn').hide();
            }
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
            $("#GivePresentTable").grid({
                url: "<g:createLink base=".."  action="list" controller="givePresent" />",
                columns: [[
                    {field: "", checkbox: true},
                    {field: "id", title: "主键", width: 160, hidden: true},
                    {field: "type", title: "类型", width: 160, dicKey: '4'},
                    {field: "reason", title: "原因明细", width: 260, align: "left"}
                ]]
            })
            %{--$("#type_id").combobox({,dicKey:1--}%
            %{--required:true,--}%
            %{--editable:false,--}%
            %{--valueField:'id',--}%
            %{--textField:'typeName',--}%
            %{--url:'<g:createLink controller="vip" action="queryVipType" base=".." />'--}%

            %{--})--}%
        })

        function myAdd() {
            /*$("#editForm tr:not(.notClear)").form("clear");*/
            $("#editForm").form("clear");
            $("#type").combobox("setValue", 0)
            openDialog("赠退原因-增加");
        }
        function edit() {
            var ids = $("#GivePresentTable").datagrid("getSelections");
            if (ids.length > 0) {
                if (ids.length == 1) {
                    var id = ids[0]["id"];
                    var url = "<g:createLink base=".."  controller="givePresent" action="edit" />?id=" + id
                    $("#editForm").form("load", url, function (data) {
                        $("#editForm").form("load", data.object)
                        openDialog("赠退原因-修改")
                    });
                } else {
                    $.messager.alert("系统提示", "仅能选择一条信息!", "info")
                }
            } else {
                $.messager.alert("系统提示", "请选择一条信息!", "info")
            }
        }
        function del() {
            var ids = $("#GivePresentTable").datagrid("getSelections");
            if (ids.length > 0) {
                var id_ary = [];
                for (var key in ids) {
                    id_ary.push(ids[key].id)
                }
                $.messager.confirm("系统提示", "所选数据记录删除后将不能恢复，确定要删除吗？", function (f) {
                    if (f) {
                        $.post("<g:createLink base=".."  controller="givePresent" action="del" />", {ids: id_ary.join(",")}, function (result) {
                            if (result.success == "true") {
                                $.messager.alert("系统提示", result.msg, "info", function () {
                                    $("#GivePresentTable").datagrid("reload")
                                })
                            } else {
                                $.messager.alert("系统提示", "删除失败!", "info")
                            }
                        }, "json")
                    }
                })
            } else {
                $.messager.alert("提示消息", "请至少选择一条信息!", "info")
            }
        }
        function openDialog(title) {
            $("#editWindow").dialog('open').dialog('setTitle', title);
        }
        function closeDialog() {
            $("#editWindow").dialog('close');
        }
        function cleardata() {
            formclear("myForm")
        }
        function saveVips() {
            if (!$("#editForm").form("validate")) {
                return false;
            }

            var url = "<g:createLink base=".."  controller="givePresent" action="save" />"
            if ($("#id").val() != "") {
                url = "<g:createLink base=".."  controller="givePresent" action="update" />"
            }
            $("#editForm").attr("action", url);
            $("#editForm").ajaxSubmit({
                success: function (result) {
                    var data = eval('(' + result + ')');
                    if (data.success == "true") {
                        if ($("#id").val() != "") {
                            $.messager.alert("系统提示", "修改成功!", "info", function () {
                                closeDialog();
                                $("#GivePresentTable").datagrid("reload")
                            })
                        }
                        else {
                            $.messager.alert("系统提示", "保存成功!", "info", function () {
                                closeDialog();
                                $("#GivePresentTable").datagrid("reload")
                            })
                        }

                    } else {
                        $.messager.alert("系统提示", data.msg, "info")
                    }
                },
                error: function (xhr, status, error) {
                    //失败
                    $.messager.alert("系统提示", "保存失败!", "info")
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
        <li opId="300_224" class="icon add" onclick="myAdd()">增 加</li>
        <li opId="300_225" class="icon alt" onclick="edit()">修 改</li>
        <li opId="300_228" class="icon del" onclick="del()">删 除</li>
    </ul>

    <p opId="300_004" class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入编码或名称查询"
               class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs  js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="GivePresentTable" style="height: 100%"></table>
    </div>
</div>


<div id="editWindow" class="easyui-dialog"
     data-options="top:'80px',modal:true,closable:true,closed:true,iconCls:'icon-save'," buttons="#infoWindow-buttons"
     style="width:500px;height:210px;">
    <form id="editForm" method="post">
        <table id="vipTable" cellpadding="5" class="info_table" style="margin: auto">
            <tr>
                <td>
                    <input type="hidden" name="id" id="id"/>
                </td>
            </tr>
            <tr class="notClear">
                <td class="title">类型:</td>
                <td><select class="easyui-combobox" type="text" name="type" panelHeight="50px" id="type"
                            data-options="required:true,editable:false,dicKey:4"></select></td>
            </tr>
            <tr>
                <td class="title">原因:</td>
                <td><input class="easyui-textbox" type="text" name="reason" id="reason"
                           data-options="required:true,validType:'length[1,50]',invalidMessage:'长度不超过50个汉字或字符！'"/>
                </td>
            </tr>
        </table>
    </form>
</div>

<div id="infoWindow-buttons">
    <a href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveVips()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeDialog()">取消</a>
</div>
</body>
</html>

