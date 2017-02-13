<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'goods/goodsBatch.js', base: '..')}"></script>
    <title>商品批量添加</title>
    <style type="text/css">
    .datagrid-row-editing .textbox, .datagrid-row-editing .textbox-text {
        width: 166px !important;
    }
    .datagrid-row {
        height: 52px;
    }
    </style>
    <script type="text/javascript">
        var goodsUnitId;
        var categoryId;
        var save_url = '<g:createLink base=".." controller="goods" action="saveList"  />';
        var back_url = '${backUrl}';
        var num = 0;
        var cop = '<a href="#" class="easyui-tooltip" title="复制当前行" onclick="insertRow(this,false) ">' +
                '<img src="${resource(dir: 'easyui/themes/icons/', file: 'shenhe.png',base:'..')}"></a>  ';
        var del = '<a href="#" class="easyui-tooltip" title="删除当前行" onclick="deleterow(this)">' +
                '<img src="${resource(dir: 'easyui/themes/icons/', file: 'delete.png',base:'..')}"></a>  ';
        var addGood = '<a href="#" class="easyui-tooltip" title="添加新行" onclick="insertRow(this,true)">' +
                '<img src="${resource(dir: 'easyui/themes/icons/', file: 'edit_add.png',base:'..')}"></a>  ';
//        $.extend($.fn.datagrid.defaults.editors, {
//            numberbox: {
//                init: function (container, options) {
//                    var input = $('<input type="text" name="aaf" >').appendTo(container);
//                    return input.textbox(options);
//                },
//                destroy: function (target) {
//                    $(target).textbox('destroy');
//                },
//                getValue: function (target) {
//                    return $(target).textbox('getValue');
//                },
//                setValue: function (target, value) {
//                    $(target).textbox('setValue', value);
//                },
//                resize: function (target, width) {
//                    $(target).textbox('resize', width);
//                }
//            }
//        });
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            init();
//        一次性加载类型和单位
            $.post('<g:createLink base=".." controller='goods' action='getCatAndUnitJson'/>', function (result) {
                var dataCat = [];
                dataCat.push(result.cat);
                categoryId = result.cat
                goodsUnitId = result.unit
                $('#tt').datagrid('options').columns[0][2].editor.options.data = categoryId
                $('#tt').datagrid('options').columns[0][3].editor.options.data = goodsUnitId
                insertRow(null,true);
            }, 'json');
        });

        function backIndex() {
            $.messager.confirm('系统提示', '还未保存，确定返回 ?', function (r) {
                if (r) {
                    $.redirect('${backUrl}', {_remove_position: "批量添加"})
                }
            });
        }
        var CatText = null
        function VisitCategoryByValue(v, op) {
            if (v == op.id) {
                CatText = op.text;
                return;
            }
            if (op.children.length > 0) {
                $.each(op.children, function (i, it) {
                    VisitCategoryByValue(v, it)
                    if (CatText != null) return false
                })
            }
            return
        }
    </script>
</head>

<body>
<h3 class="rel ovf js_header">
    <span></span>-<span></span>-<span></span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li class="icon add" onclick="saveGoodsList()">保 存</li>
        <li class="icon back" onclick="backIndex()">返 回</li>
    </ul>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" >
        <table id="tt" style="height: 100%"></table>
    </div>
</div>
</body>
</html>