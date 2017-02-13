<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>菜品分类</title>
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
        $(function () {

            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            //创建datagrid对象
            orderTable = new EasyUIExt($("#categoryTable"), "<g:createLink base=".." controller="category" action="list"  />");
            orderTable.singleSelect = true;//是否单选
            orderTable.window = $("#categoryInfoWindow");//dialog
            orderTable.form = $("#categoryOrder");//表单
            orderTable.pagination = true;//是否分页
            orderTable.loadSuccess = function () {
                $("#categoryTable").datagrid('clearSelections');
            };
            orderTable.mainEasyUIJs();
            loadMyTree();
        });

        var setting = {
            view: {
                selectedMulti: false,
                expandSpeed: "fast"
            },
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "parentId",

                    rootId: ""
                },
                key: {
                    name: 'catName'
                }
            },
            callback: {
                onClick: clickTree
            }
        }
        var treeNodes;
        var zTree;
        function loadMyTree() {
            $.ajax({
                async: false,
                url: '<g:createLink base=".." controller='category' action='loadZTree'/>',
                type: "post",
                dataType: 'json',
                success: function (data) {
                    treeNodes = data;
                    for (var key in treeNodes) {
                        treeNodes[key].open = true;
                    }
                    zTree = $.fn.zTree.init($("#kindTree"), setting, treeNodes);
                    var treeObj = $.fn.zTree.getZTreeObj("kindTree");
                    var node = treeObj.getNodeByParam("id", -1, null);
                    treeObj.selectNode(node);

                }
            })
        }
        var text;
        var code;
        var kindId;
        var nodes;
        function clickTree(event, treeId, treeNode) {
            text = treeNode.name;
            code = treeNode.catCode;
            kindId = treeNode.id;
            nodes = treeNode;
            $('#categoryTable').datagrid({
                queryParams: {
                    kindId: kindId
                }
            });
            isSelect = true;
        }
        var score_num = 1;
        function myAdd() {
            var tree = $.fn.zTree.getZTreeObj("kindTree");
            var selectedNode = tree.getSelectedNodes()[0];
            if (selectedNode.id == -1) {
                oneCode = null;
                orderTable.mainAdd("<g:createLink base=".." controller="category" action="getMaxOneCode"/>", "菜品分类-增加");
                $("#parentName").textbox("setValue", selectedNode.catName);
                $("#parentId").val(selectedNode.id);
                score_num = 1;
//                $('#isRaw').show();
            } else {
                var secondeNode = nodes.getParentNode();
                var firstNode = secondeNode.getParentNode();
                if (firstNode == null) {
                    $.ajax({
                        url: "<g:createLink base=".." controller="category" action="queryCatGoods"  />?id=" + selectedNode.id,
                        success: function (data) {
                            var result = eval('(' + data + ')')
                            if (result.success == "true") {
                                oneCode = nodes.catCode;
//                                $('#isRaw').hide();
                                orderTable.mainAdd("<g:createLink base=".." controller="category" action="getMaxTwoCodeByCatCode"/>?oneCode=" + oneCode, "菜品分类-增加");
                                $("#parentName").textbox("setValue", nodes.catName);
                                $("#parentId").val(nodes.id);
                                $("#categoryType").val(nodes.categoryType);//添加二级分类时categoryType为一级分类的值

                            } else {
                                $.messager.alert("系统提示", result.msg, 'warning');
                            }

                        }
                    });

                } else {
                    $.messager.alert("系统提示", "此分类下不可以再添加分类了！", "warning");
                }

            }
            document.getElementById("categoryTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/off.png', base:'..')}";
        }
        var oneCode;//一级分类编码

        function saveCategory() {
            if ($("#categoryType").val() == '') {
                $("#categoryType").val(0);
            }
            $('#categoryOrder').form('submit', {
                url: "<g:createLink base=".." controller="category" action="save"  />?oneCode=" + oneCode
                ,
                success: function (data) {
                    var result = eval('(' + data + ')')
                    if (result.success == "true") {
                        $('#categoryInfoWindow').dialog('close');
                        $("#categoryTable").datagrid('load');
                        loadMyTree();
                        $.messager.alert("系统提示", result.msg, 'info');
                    } else {
                        $.messager.alert("系统提示", result.msg, 'error');
                    }

                }
            });


        }

        function edit(id) {
//            $('#isRaw').hide();
            var data = orderTable.mainEdit2("<g:createLink base=".." controller="category" action="edit"  />", "菜品分类-修改", id);
            if (data) {
                %{--if(data.categoryType==1){--}%
                %{--document.getElementById("categoryTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/on.png', base:'..')}";--}%
                %{--score_num=0--}%
                %{--}else{--}%
                %{--document.getElementById("categoryTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/off.png', base:'..')}";--}%
                %{--score_num=1--}%
                %{--}--}%

                orderTable.formAction = "<g:createLink base=".." controller="category" action="update"  />";
            }
        }
        var nodes_delId = [];
        function del() {
            var rows = $("#categoryTable").datagrid("getSelections");
            if (rows.length < 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return;
            }
            var row = $("#categoryTable").datagrid("getSelected");

            if (row.catCode.length == 2) {
                var treeObj = $.fn.zTree.getZTreeObj("kindTree");
                var node = treeObj.getNodeByParam("id", row.id, null);
                var childNodes = treeObj.transformToArray(node);

                for (i = 0; i < childNodes.length; i++) {
                    nodes_delId[i] = childNodes[i].id;
                }
                if (nodes_delId.length > 1) {
                    $.messager.alert('系统提示', '此分类下有分类不能删除！', 'warning');
                    return;
                }

            } else {
                nodes_delId = [];
                nodes_delId[0] = row.id;
            }
            $.messager.confirm('系统提示', '您确认删除所选的分类吗？', function (r) {
                if (r) {
                    $.ajax({
                        url: "<g:createLink base=".." controller="category" action="del"  />?ids=" + nodes_delId,

                        success: function (data) {
                            var result = eval('(' + data + ')')
                            if (result.success == "true") {
                                $("#categoryTable").datagrid("load");
                                loadMyTree();
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
            $('#categoryTable').datagrid({
                queryParams: {
                    categoryInfo: $("#queryStr").val()
                }
            });
        }
        function clearSearch() {
            $("#queryStr").val("");
        }
        function cleardata() {
            formclear("myForm")
        }
        function nextKind(value, row, index) {
            return "<a href='javascript:void(0)' onclick=viewGood('" + row.id + "') style='color: #ffa200' >查看菜品</a>"
        }
        function viewGood(id) {
            var rebackUrl = "<g:createLink base=".." controller="category" action="index"  />";
            var url = "<g:createLink base=".." controller='goods' action='index'  />?categoryId=" + id + "&backUrl=" + rebackUrl;
            $.redirect(url, {_position: "查看菜品"})
        }
        function initop() {

            var rid = $("#resid").val()
            $.ajax({
                async: false,
                url: '<g:createLink base=".." controller='opration' action='opload'/>?rid=' + rid,
                type: "post",
                dataType: 'json',
                success: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        var op = '.' + data[i]
                        $(op).show()
                    }

                }
            })
        }

        function codeT(val, row) {
            /* if (row != null) {
             return  "<a href='#' class='code_open' onClick='edit()'>"+val+"</a>";
             }
             return val;*/
            if (row != null) {
                return "<a href='javascript:void(0)' class='code_open' onClick=edit('" + row.id + "')>" + val + "</a>";
            }
            return val;
            //return "<a href='#' class='code_open' onClick='edit(" + row.id + ")'>" + val + "</a>";
        }
        function isOriginalProduct(val, row) {
            if (val==1){
                return val='是'
            }else{
                return val='否'
            }
            return val;
        }
        function is_score() {
            if (score_num == 0) {
                document.getElementById("categoryTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/off.png', base:'..')}";
                score_num = 1;
                $("#categoryType").val(0);
            } else {
                document.getElementById("categoryTypeImg").src = "${resource(dir:'css', file:'mainFrame/img/on.png', base:'..')}";
                score_num = 0;
                $("#categoryType").val(1);
            }
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
        <input type="button" onclick="doSearch()" class="search-btn icon abs  js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-l fl" style="background:#dfe3e5;">
        <ul id="kindTree" class="ztree">
        </ul>
    </div>

    <div class="table-list-r fr" style="background:#b6b6b6;">
        <table id="categoryTable"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
                <thead>
                    <th data-options="field:'catCode',width:80,align:'left',formatter:codeT">分类编码</th>
                    <th data-options="field:'catName',width:120,align:'left'">中文名称</th>
                    <th data-options="field:'catName2',width:120,align:'left'">英文名称</th>
                    <th data-options="field:'kind',formatter:nextKind ">操作</th>
                </thead>
        </table>

        <div id="categoryInfoWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="categoryOrder" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input type="hidden" name="id" id="id"/>
                    <input type="hidden" name="categoryType" id="categoryType"/>
                    <input type="hidden" name="parentId" id="parentId"/>
                    <tr>
                        <td class="title"><div style="width: 124px;">上级分类:</div></td>
                        <td>
                            <input class="easyui-textbox" type="text" name="parentName" id="parentName"
                                   readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">分类编码:</td>
                        <td>
                            <input class="easyui-textbox" type="text" name="catCode" id="catCode" readonly="readonly"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">分类名称:</td>
                        <td><input class="easyui-textbox" type="text" name="catName" id="catName"
                                   data-options="required:true,validType:'length[1,20]',missingMessage:'分类名称为必填项',invalidMessage:'长度不超过20个汉字或字符！'"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">英文名称:</td>
                        <td><input class="easyui-textbox" type="text" name="catName2" id="catName2"
                                   data-options="required:true,validType:['nochina','length[1,20]'],missingMessage:'分类名称为必填项',invalidMessage:'请录入英文,数字或字符长度不超过20个字符！'"/>
                        </td>
                    </tr>
                    %{--<tr id="isRaw" style="display: none">--}%
                        %{--<td class="title">是否原料:</td>--}%
                        %{--<td>--}%
                            %{--<img src="${resource(dir: 'css', file: 'mainFrame/img/off.png', base: '..')}"--}%
                                 %{--onclick="is_score()"--}%
                                 %{--id="categoryTypeImg">--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" class="easyui-linkbutton  class_branch_op" iconCls="icon-ok"
               onclick="saveCategory()">保存</a>
            %{--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAndAddCategory()">保存并新增</a>--}%
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
    </div>
</div>
</body>
</html>

