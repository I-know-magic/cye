<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/9/6
  Time: 16:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>菜品分类</title>
    <meta name="layout" content="main">

</head>

<body>
<script type="text/javascript">
    $(function () {
        loadMyTree();
    })
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
        check: {
            enable: true,
            chkStyle: "radio",
            chkboxType: {"Y": "s", "N": "s"},
            radioType: "all"
        }
    }
    var treeNodes;
    var zTree;
    function loadMyTree() {
        $.ajax({
            async: true,
            url: '<g:createLink base=".." controller='saleReport' action='getCategory'/>',
            type: "post",
            dataType: 'json',
            success: function (data) {
                treeNodes = data;
                for (var key in treeNodes) {
                    treeNodes[key].open = true;
                    if (treeNodes[key].id == -1) {
                        treeNodes[key].nocheck = true;
                    }
                }
                zTree = $.fn.zTree.init($("#kindTree"), setting, treeNodes);
            }
        })
    }
    function report_save() {
        var treeObj = $.fn.zTree.getZTreeObj("kindTree");
        var nodes = treeObj.getCheckedNodes(true);
        if (nodes.length > 0) {
            setSelectObj(nodes[0].id, nodes[0].catName, "3");
            $("#queryStr").attr("disabled", true);
            $("#queryStr").css({"background-color": "rgb(223, 227, 229)"});
        }
    }
</script>
<ul id="kindTree" class="ztree"></ul>

</body>
</html>