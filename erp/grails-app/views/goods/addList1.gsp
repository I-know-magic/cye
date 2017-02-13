<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>商品批量添加</title>
    <style type="text/css">
    .datagrid-row-editing .textbox, .datagrid-row-editing .textbox-text {
        width: 160px !important;
    }
    </style>
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
<script type="text/javascript">
    $(function () {
        var height = $(window).height();
        $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
    });
    $.extend($.fn.datagrid.defaults.editors, {
        numberspinner: {
            init: function (container, options) {
                var input = $('<input type="text" name="aaf" onchange="insert()">').appendTo(container);
                return input.textbox(options);
            },
            destroy: function (target) {
                $(target).textbox('destroy');
            },
            getValue: function (target) {
                return $(target).textbox('getValue');
            },
            setValue: function (target, value) {
                $(target).textbox('setValue', value);
            },
            resize: function (target, width) {
                $(target).textbox('resize', width);
            }
        }
    });
    function backIndex() {
        $.messager.confirm('系统提示', '还未保存，确定返回 ?', function (r) {
            if (r) {
                $.redirect('${backUrl}', {_remove_position: "批量添加"})
            }
        });
    }
//    $.extend($validateRules, {
//
//    });
    function saveGoodsList() {
        var row = $('#tt').datagrid('getRows');
        var par = [];
        var str = '';
        // 触发表格的验证
        for(var key in row){
            var index = $('#tt').datagrid('getRowIndex', row[key]);
            if(!$("#tt").datagrid("validateRow",index)){
                return false;
            }
        }
        $.each(row, function (i, item) {
            var index = $('#tt').datagrid('getRowIndex', item);
            if(!$("#tt").datagrid("validateRow",index)){
                return false;
            }
//            $('#tt').datagrid('endEdit', index);
            endEdit(index,item);
//            if (item.add == e + d) {
//                for (var p in item) {
//                    if (p != 'add') {
//                        par.push(item[p] == '' ? ' ' : item[p]);
//                    }
//                }
                par.push(item.goodsName);
                par.push(item.categoryId);
                par.push(item.goodsUnitId);
                par.push(item.salePrice);
                par.push(item.vipPrice);
                par.push(item.vipPrice2);
//            }
            if (par.length > 0) {
                str = str + par + ';';
                par = [];
            }
        });
        str = str.substr(0, str.length - 1);
//        if (str == '') {
//            $.messager.alert('错误', '请添加商品', 'error');
//            return;
//        }
        $.messager.confirm('系统提示', '确定保存,点取消继续添加', function (r) {
            if (r) {
                $.post("<g:createLink base=".." controller="goods" action="saveList"  />", {goodsList: str}, function (result) {
                    if (result.success == "true") {
//                        backIndex();
                        $.redirect('${backUrl}', {_remove_position: "批量添加"})
                        %{--window.location.href = '<g:createLink base=".." controller="goods" action="index"  />';--}%
                    } else {
                        $.messager.alert('系统提示', result.msg, 'error');
                    }
                }, 'json');
            }
        });

    }
    function endEdit(index,row){
        $('#tt').datagrid('endEdit', index);
        row.vipPrice = row.vipPrice == '' ? row.salePrice : row.vipPrice;
        row.vipPrice2 = row.vipPrice2 == '' ? row.salePrice : row.vipPrice2;
        var row = $('#tt').datagrid('refreshRow', index);
    }
    var goodsUnitId;
    var categoryId;

    var rowdata = null;
    var num = 0;
    var e = '<a href="#" onclick="editrow(this)"><img src="${resource(dir: 'easyui/themes/icons/', file: 'pencil.png',base:'..')}"></a> ';
    var d = '<a href="#" onclick="deleterow(this)"><img src="${resource(dir: 'easyui/themes/icons/', file: 'delete.png',base:'..')}"></a> ';
    var add = '<a href="#" onclick="insert(this,true)"><img src="${resource(dir: 'easyui/themes/icons/', file: 'edit_add.png',base:'..')}"></a> ';
    $(function () {
        $('#tt').datagrid({
            idField: 'id',
            rownumbers: true,
            columns: [[
                {
                    field: 'add', title: '操作', width: 80
                },
                {
                    field: 'goodsName', title: '商品名称', width: 180, align: 'center',
                    editor: {
                        type: 'textbox',
                        options: {
                            required: true, missingMessage: '请输入商品名称', validType: 'length[1,20]',missingMessage:'商品名称为必填项',invalidMessage:'长度不超过20个汉字或字符！'
                        }
                    }
                },
                {
                    field: 'categoryId', title: '分类', width: 180,
                    editor: {
                        type: 'combotree',
                        value: '--请选择--',
                        options: {
                            panelWidth: 240,
                            data: [{}],
                            required: true,
                            missingMessage:'分类为必填项',
                            editable: false,
                            validType: 'NotEqual["--请选择--"]',
                            onBeforeSelect: function (node) {

                                // 判断父节点是否是根节点
                                if(node.id===-1){
                                    return true
                                }
                                var parent = $(this).tree('getParent', node.target);
                                var isLeaf = $(this).tree('isLeaf', node.target);
                                if(isLeaf){
                                    return true
                                }
                                return false

                            },
                            onLoadSuccess: function (node, data) {

                                categoryId = data;
                                var rootNode = $(this).tree('getRoot');
                                $(this).tree("select", rootNode.target);
                            },
                            onChange: function (newValue, oldValue) {
                                if (newValue == "undefined") $(this).combotree("setValue", '');
                            }
                        }
                    },
                    formatter: function (value) {
                        if (categoryId) {
                            CatText = null;
                            VisitCategoryByValue(value, categoryId[0])
                            return CatText
                        }
                        return value;
                    }
                },
                {
                    field: 'goodsUnitId', title: '单位', width: 180,
                    editor: {
                        type: 'combobox',
                        options: {
                            valueField: 'id',
                            textField: 'unitName',
                            data: [{}],
                            required: true,
                            missingMessage:'单位为必填项',
                            editable: false,
                            validType: 'NotEqual["-- 请选择 --"]',
                            onLoadSuccess: function (rec) {

                                goodsUnitId = rec[1];
                                if (goodsUnitId) {
                                    $(this).combobox("setValue",goodsUnitId.id)
                                }
                            }
                        }
                    },
                    formatter: function (value) {
                        if (goodsUnitId) {
                            for (var i = 1; i < goodsUnitId.length; i++) {
                                if (goodsUnitId[i].id == value) return goodsUnitId[i].unitName;
                            }
                        }
                        return value;
                    }
                },
                {
                    field: 'salePrice', title: '售价', width: 180,
                    editor: {
                        type: 'numberbox',
                        options: {
                            required: true, min:0,precision:2,max:9999.99,missingMessage:'售价为必填项'
                        }
                    },
                    formatter: function (v) {
                        return moneyFormatter2(v);
                    }
                },
                {
                    field: 'vipPrice', title: '会员价-1', width: 180,
                    editor: {
                        type: 'numberbox',
                        options: {
                            required: false, min: 0, precision: 2, max: 9999.99
                        }
                    },
                    formatter: function (v) {
                        return moneyFormatter2(v);
                    }
                },
                {
                    field: 'vipPrice2', title: '会员价-2', width: 180,
                    editor: {
                        type: 'numberbox',
                        options: {
                            required: false, min: 0, precision: 2, max: 9999.99, value: 0.00
                        }
                    },
                    formatter: function (v) {
                        return moneyFormatter2(v);
                    }
                }
//                ,
//                {
//                    field: 'instoreCode', title: '店内码', width: 180,
//                    editor: {
//                        type: 'numberspinner',
//                        options: {
//                            required: false, validType: 'length[1,8]'
//                        }
//                    }
//                }
            ]]//,
//            onEndEdit: function (index, row) {
//                num = num + 1;
//                row.add = e + d;
//                $('#tt').datagrid('updateRow', {
//                    index: index,
//                    row: {}
//                });
//            }
        });
//        一次性加载类型和单位
        $.post('<g:createLink base=".." controller='goods' action='getCatAndUnitJson'/>', function (result) {
            var dataCat = [];
            dataCat.push(result.cat);
            categoryId = result.cat
            goodsUnitId = result.unit
            $('#tt').datagrid('options').columns[0][2].editor.options.data = categoryId
            $('#tt').datagrid('options').columns[0][3].editor.options.data = goodsUnitId
//            for (var a = 0; a < 2; a++) {
//                insert();
//            }
            rowdata = {
                add: operate(),
                salePrice:'0',
                categoryId:categoryId[0].id,
                goodsUnitId:goodsUnitId&&goodsUnitId.length>2?goodsUnitId[1].id:goodsUnitId[0].id
            }
            insert();
        }, 'json');
    });
    function operate() {
        return add + d;
    }
    function insert(item,isCopy) {
        if(isCopy){
            var len = $("#tt").datagrid("getRows").length;
            for(var i=0;i<len;i++){
                $("#tt").datagrid("endEdit",i);
            }
            var data = $("#tt").datagrid("getRows")[len-1];
            $('#tt').datagrid('appendRow',data.categoryId==null? $.extend({},rowdata): $.extend({},data));
            for(var i=0;i<len+1;i++){
                $("#tt").datagrid("beginEdit",i);
            }
        }else{
            $('#tt').datagrid('appendRow',$.extend({},rowdata));
        }
        var row = $('#tt').datagrid('getRows');
        if (row) {
            var num = row.length - 1
            var index = $('#tt').datagrid('getRowIndex', row[num]);
            if (item) {
                row[num].goodsName = item.goodsName
//                row[num].shortName = item.shortName
                row[num].categoryId = item.categoryId
                row[num].goodsUnitId = item.goodsUnitId
                row[num].salePrice = item.salePrice
                row[num].vipPrice = item.vipPrice
                row[num].vipPrice2 = item.vipPrice2
//                row[num].instoreCode = item.instoreCode
            }
        } else {
            index = 0;
        }
        $('#tt').datagrid('beginEdit', index);
//        keydown(index)
    }
    function keydown(index) {
        $(".datagrid-view2 .datagrid-body [datagrid-row-index=" + index + "]").find("[name='aaf']").prev().keydown(function (event) {
            if (event.keyCode && event.keyCode == 13) {
                var rowNumber = $(event.target).parents('[datagrid-row-index]').attr("datagrid-row-index")
                var vid = $('#tt').datagrid('validateRow', rowNumber);
                if (vid) {
                    $('#tt').datagrid('endEdit', rowNumber);
                    var row = $('#tt').datagrid('getRows');
                    $.each(row, function (i, item) {
                        var index = $('#tt').datagrid('getRowIndex', item);
                        if (index == rowNumber) {
                            insert(item)
                        }
                    });
                }
            }
        })
    }
    function deleterow(target) {
        var row = $('#tt').datagrid('getRows');
        if (row.length > 1) {
            $.messager.confirm('系统提示', '你确定删除?', function (r) {
                if (r) {

                    $('#tt').datagrid('deleteRow', getRowIndex(target));
                }
            });
        }
    }
    function getRowIndex(target) {
        var tr = $(target).closest('tr.datagrid-row');
        return parseInt(tr.attr('datagrid-row-index'));
    }
    function editrow(target) {
        var index = getRowIndex(target)
        $('#tt').datagrid('beginEdit', index);
        keydown(index)
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

</body>
</html>