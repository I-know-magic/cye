

function showTreeDialog(dialogName, handlerTrue) {
    $('#saas-treeDialog').dialog({
        title: dialogName,
        width: 1050,
        height: 550,
        closed: false,
        cache: false,
        collapsible: true,
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function () {
                handlerTrue()
            }
        }, {
            text: '取消',
            iconCls: 'icon-cancel',
            handler: function () {
                $('#saas-treeDialog').dialog('close');
            }
        }]
    });
    $('#tt_datagrid').datagrid({
        border: false,
        rownumbers: true,
        pagination: true,
        striped: true,
        fit: true,
        fitColumns: true,
        loadMsg: '正在查询...',
        singleSelect: true,
        idField: 'id',
        toolbar: '#query',
        rownumbers:true,
        sortName:'orderNo',
        scrollbarSize:14,
        frozenColumns: [[{field: 'id', checkbox: true},
            {field: 'orderNo', title: '订单编号', align: 'center', width: 120},
            {field: 'orderNso', title: '订单编号', align: 'center', width: 80}
        ]],
        columns: [[
            {field: 'city', title: '所属区域', align: 'center', width: 120},
            {field: 'phoneNumber', title: '联系电话', align: 'center'},
            {field: 'address', title: '地址', align: 'center'}
        ]]
    });

    var p = $('#tt_datagrid').datagrid('getPager');
    $(p).pagination({
        pageSize: 10,//每页显示的记录条数，默认为10
        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',
        total:11,
        showPageList:false,
        layout:['list','sep','first','prev','links','next','last','sep']
    });

    $('#query_text').textbox({
        buttonText: '查询',
        iconCls: 'icon-search',
        iconAlign: 'left',
        prompt: '请输入商品ID或商品名称',
        width: 220
    });
    $('#bigType_combobox').combobox({
        url:'http://localhost:9001/mainFrame/showTree?t=1',
        panelHeight: 'auto',
        valueField: 'label',
        textField: 'value',
        editable: false,
    onSelect: function (rec) {
        $('#type_tree').tree({url: 'http://localhost:9001/mainFrame/showTree?id=333'});
    },
        onLoadSuccess:function(node){
            $('#type_tree').tree({url: 'http://localhost:9001/mainFrame/showTree'});
        }

    });
    $('#bigType_combobox').combobox('setValues', ['1']);
    $('#type_tree').tree({
        url: '',
        lines:true,
        animate:true,
        onClick: function(node){
            alert(node.text);
        },
        onLoadSuccess : function(node, data) {
            var t = $(this);
            if (data) {
                $(data).each(function(index, d) {
                    if (this.id == '0') {
                        t.tree('expand',t.tree('getRoot').target);
                    }
                });
            }
        }
    });
}