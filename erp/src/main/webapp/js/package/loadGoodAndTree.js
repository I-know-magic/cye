/**
 * Created by Administrator on 2015/7/2.
 */
var dataGridArray=[];
/**
 *所有类别树的setting
 */
var setting={
    view:{
        selectedMulti:false,
        expandSpeed:"fast"
    },
    data:{
        simpleData:{
            enable:true,
            idKey:"id",
            pIdKey:"parentId",
            rootId:""
        },
        key:{
            name:'catName'
        }
    },
    callback:{
        onClick:treeClick
    }
}
/*促销模块专用方法*/
var setting1={
    view:{
        selectedMulti:false,
        expandSpeed:"fast"
    },
    data:{
        simpleData:{
            enable:true,
            idKey:"id",
            pIdKey:"parentId",
            rootId:""
        },
        key:{
            name:'catName'
        }
    },
    callback:{
        onClick:treeClick1
    }
}

/**
 * 分类树点击事件
 * @param event
 * @param treeId
 * @param treeNode
 */
function treeClick(event,treeId,treeNode){
    var categoryIds=[];
    if(treeNode.id==-1){
        $("#categoryIds").val("");
    }else{
        var boolean=treeNode.isParent;
        if(boolean==true){
            var childrens=treeNode.children;
            for(var c=0;c<childrens.length;c++){
                categoryIds.push(childrens[c].id);
            }
        }
        else{
            categoryIds.push(treeNode.id);
        }
        $("#categoryIds").val(categoryIds);
    }
    if($('#isStore').val()==''){
        doSearch2();
    }else{
        doSearch();
    }

}
/*促销模块专用方法*/
function treeClick1(event,treeId,treeNode){
    var categoryIds=[];
    if(treeNode.id==-1){
        categoryIds=[]
    }else{
        var boolean=treeNode.isParent;
        if(boolean==true){
            var childrens=treeNode.children;
            for(var c=0;c<childrens.length;c++){
                categoryIds.push(childrens[c].id);
            }
        }
        else{
            categoryIds.push(treeNode.id);
        }
    }
    $("#categoryIds1").val(categoryIds);
    doSearch1();
}


function doSearch(url) {
    $('#goodsTable').datagrid($.extend({
        queryParams: {
            goodsCodeOrName: $("#queryStr").val(),
            categoryIds: $("#categoryIds").val(),
            isStore:$('#isStore').val()
        }
    },url?{url:url}:{}));
}
//function doSearch11(url) {
//    $('#goodsTable').datagrid({
//        url:''+url+'',
//        queryParams: {
//            goodsCodeOrName: $("#queryStr").val(),
//            categoryIds: $("#categoryIds").val(),
//            isStore:$('#isStore').val()
//        }
//    });
//}
/*促销模块专用方法*/
function doSearch1() {
    $('#goodsTable1').datagrid({
        queryParams: {
            goodsCodeOrName: $("#queryStr1").searchbox("getValue"),
            categoryIds: $("#categoryIds1").val()
        }
    });
}
/*菜牌功能专用方法*/
function doSearch2(){
    $('#goodsTable').datagrid({
        queryParams: {
            goodsCodeOrName: $("#queryStr").val(),
            categoryIds: $("#categoryIds").val()
        }
    });
}
function pushDataByAddGood(url){
    $.ajax({
        url:url,
        cache: false,
        dataType:'json',
        async:true,
        success:function(result){
            dataGridArray=result.rows;
        }
    })
}

//***********加载datagrid数据*****************//
var dataArray=[];//定义datagrid array
var isSelect=true;
var selectedIds = [];
var unselectedIds = [];
function newDataGrid(url,dataRows){
    $("#goodsTable").datagrid({
        url:''+url+'',
        singleSelect:singleSelect,
        pagination:false,
        fit:true,
        fitColumns:false,
        idField : 'id',
        rownumbers:true,
        width : 'auto',
        height :'auto',
        nowrap :false,
        striped :true,
        border : true,
        frozenColumns:[[{field:'id', checkbox:true}]],
        columns:[[
            {field: 'barCode', title: '商品编码', width: 60},
            {field: 'goodsName', title: '商品名称', width: 80, align: 'left'},
            {field:'salePrice',title:'零售价',align:'right',width:80,align:'right',formatter:moneyFormatter},
            {field:'goodsUnitName',title:'单位',width:40,align:'center'},
            {field:'purchasingPrice',title:'进价', hidden: true}
        ]],
        onBeforeSelect:function(index,row){
            isSelect=true;
            if(dataRows.length>0){
                for(var key in dataRows){
                    if(row.id==dataRows[key].id){
                        isSelect=false;
                        $.messager.alert('系统提示',"此商品已经选择，不能重复选择！",'warning');
                        return;
                    }
                }
            }
        },
        onSelect:function(index,row){
            if(isSelect==false){
                $(this).datagrid('unselectRow',index);
            }
            if(selectedIds.indexOf(row.id) == -1){
                selectedIds.push(row.id);
            }
            for(var i=0;i<unselectedIds.length;i++){
                if(unselectedIds[i] == row.id){
                    unselectedIds.splice(i,1)
                }
            }
        },
        onUnselect:function(index,row){
            for(var i =0;i<selectedIds.length;i++){
                if(selectedIds[i]==row.id){
                    selectedIds.splice(i,1);
                    unselectedIds.push(row.id);
                }
            }
        },
        onLoadSuccess:function(data){
            checkSelectedItem();
            if(selectedIds.length>0){
                for(var i =0;i<selectedIds.length;i++){
                    $('#goodsTable').datagrid('selectRecord',selectedIds[i]);
                }
            }

        },
        onCheck:function(index, row){
            if(isSelect==false){
                $(this).datagrid('uncheckRow',index);
            }
            dataArray.push(row);
        },
        onUncheck:function(index, row){
            if(dataArray!=[]){
                for(var i=0;i<dataArray.length;i++){
                    if(row.id==dataArray[i].id){
                        dataArray.splice(i,1);
                        return;
                    }
                }
            }
        },
        onCheckAll:function(rows){
            for(var r=0;r<rows.length;r++){
                if(dataArray!=[]&&dataArray[r]!=undefined){
                    if(rows[r].id==dataArray[r].id){
                        dataArray.splice(r,1);
                    }
                }
                dataArray.push(rows[r]);
            }
        },
        onUncheckAll:function(rows){
            if(dataArray!=[]){
                for(var i=0;i<rows.length;i++){
                    var index= $.inArray(rows[i],dataArray);
                    dataArray.splice(index,1);
                }
            }
        }
    })
}

/**
 * 点击触发加载datagrid方法
 */
function loadDataGrid(){
    $('#goodsTable').datagrid("loadData",{"rows":promotionArray1});
}


function loadDataGrid1(){
    $('#goodsTable1').datagrid("loadData",{"total":1,"rows":promotionArray2});
}



/**
 * 促销管理添加促销时加载数据
 * @param url
 * @param dataRows
 */

var promotionArray1=[];//定义datagrid array
var promotionArray2=[];//定义datagrid array


function promotionGoodsTable1(url,dataRows){
    $("#goodsTable").datagrid({
        url:''+url+'',
        singleSelect:false,
        pagination:false,
        fit:true,
        fitColumns:false,
        idField : 'id',
        rownumbers:true,
        width : 'auto',
        height :'auto',
        nowrap :false,
        striped :true,
        border : true,
        frozenColumns:[[{field:'id', checkbox:true}]],
        columns:[[
            {field:'barCode',title:'商品编码',width:60,align:'left'},
            {field:'goodsName',title:'商品名称',width:80,align:'center'},
            {field:'salePrice',title:'零售价',align:'right',width:80,align:'right',formatter:moneyFormatter},
            {field:'goodsUnitName',title:'单位',width:40,align:'center'}
        ]],

        onBeforeSelect:function(index,row){
            isSelect=true;
            if(dataRows.length>0){
                for(var key in dataRows){
                    if(row.id==dataRows[key].id){
                        isSelect=false;
                        $.messager.alert('系统提示',"此商品已经选择，不能重复选择！",'warning');
                        return;
                    }
                }
            }
        },
        onSelect:function(index,row){
            if(isSelect==false){
                $(this).datagrid('unselectRow',index);
            }
        },
        onLoadSuccess:function(data){
            if(data.rows==0){

            }
        },
        onCheck:function(index, row){
            if(isSelect==false){
                $(this).datagrid('uncheckRow',index);
            }
            promotionArray1.push(row);
        },
        onUncheck:function(index, row){
            if(promotionArray1!=[]){
                for(var i=0;i<promotionArray1.length;i++){
                    if(row.id==promotionArray1[i].id){
                        promotionArray1.splice(i,1);
                        return;
                    }
                }
            }
        },
        onCheckAll:function(rows){
            for(var r=0;r<rows.length;r++){
                if(promotionArray1!=[]&&promotionArray1[r]!=undefined){
                    if(rows[r].id==promotionArray1[r].id){
                        promotionArray1.splice(r,1);
                    }
                }
                promotionArray1.push(rows[r]);
            }
        },
        onUncheckAll:function(rows){
            if(promotionArray1!=[]){
                for(var i=0;i<rows.length;i++){
                    var index= $.inArray(rows[i],promotionArray1);
                    promotionArray1.splice(index,1);
                }
            }
        }
    })
}


function promotionGoodsTable2(url,dataRows){
    $("#goodsTable1").datagrid({
        url:''+url+'',
        singleSelect:false,
        pagination:false,
        fit:true,
        fitColumns:false,
        idField : 'id',
        rownumbers:true,
        width : 'auto',
        height :'auto',
        nowrap :false,
        striped :true,
        border : true,
        frozenColumns:[[{field:'id', checkbox:true}]],
        columns:[[
            {field:'barCode',title:'商品编码',width:60,align:'left'},
            {field:'goodsName',title:'商品名称',width:80,align:'center'},
            {field:'salePrice',title:'零售价',align:'right',width:80,align:'right',formatter:moneyFormatter},
            {field:'goodsUnitName',title:'单位',width:40,align:'center'}
        ]],
        onBeforeSelect:function(index,row){
            isSelect=true;
            if(dataRows.length>0){
                for(var key in dataRows){
                    if(row.id==dataRows[key].id){
                        isSelect=false;
                        $.messager.alert('系统提示',"此商品已经选择，不能重复选择！",'warning');
                        return;
                    }
                }
            }
        },
        onSelect:function(index,row){
            if(isSelect==false){
                $(this).datagrid('unselectRow',index);
            }
        },
        onLoadSuccess:function(data){
            if(data.rows==0){
                $.messager.alert('系统提示',"没有查询到您需要的数据",'warning')
            }
        },
        onCheck:function(index, row){
            if(isSelect==false){
                $(this).datagrid('uncheckRow',index);
            }
            promotionArray2.push(row);
        },
        onUncheck:function(index, row){
            if(promotionArray2!=[]){
                for(var i=0;i<promotionArray2.length;i++){
                    if(row.id==promotionArray2[i].id){
                        promotionArray2.splice(i,1);
                        return;
                    }
                }
            }
        },
        onCheckAll:function(rows){
            for(var r=0;r<rows.length;r++){
                if(promotionArray2!=[]&&promotionArray2[r]!=undefined){
                    if(rows[r].id==promotionArray2[r].id){
                        promotionArray2.splice(r,1);
                    }
                }
                promotionArray2.push(rows[r]);
            }
        },
        onUncheckAll:function(rows){
            if(promotionArray2!=[]){
                for(var i=0;i<rows.length;i++){
                    var index= $.inArray(rows[i],promotionArray2);
                    promotionArray2.splice(index,1);
                }
            }
        }
    })
}