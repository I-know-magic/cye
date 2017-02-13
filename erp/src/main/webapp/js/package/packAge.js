/**
* Created by Administrator on 2015/6/30.
*/
var rowsArray=[];
var mainRowsArray=[];
var midArray=[];
var groupId;
var isPushArray=false;
var isRequiredAdd;
var group__pushId;
var dataMap ={};
var pack_isAdd=false;
var pack_isEdit=false;
/**
 * 点击增加时加载datagrid
 * @param url
 */
function pushDataGridByAdd(url){
    $.ajax({
        url:url,
        dataType:'json',
        async:true,
        success:function(result){
            if(result.rows.length>0){
                //mainRowsArray.push(result.rows[0]);
            }
            newMainDataGrid();

        }
    })
}
function newMainDataGrid(){
    $("#mainGrid").datagrid({
        singleSelect:false,
        pagination:false,
        fit:true,
        fitColumns:false,
        idField : 'id',
        rownumbers:true,
        width : 'auto',
        height :'auto',
        border : true,
        checkOnSelect:true,
        data:mainRowsArray,
        frozenColumns:[[{field:'id', checkbox:true}]],
        columns:[[
            {field:'goodsCode',title:'菜品编码',width:80,height:20,align:'left'},
            {field:'goodsName',title:'菜品名称',width:80,height:20,align:'center'},
            {field:'goodsUnitName',title:'单位',width:80,height:20,align:'center'},
            {field:'salePrice',title:'售价',align:'right',width:80,height:20,align:'right',formatter:moneyFormatter},
            {field:'quantity',title:'数量',width:80,height:20,editor:{type:'numberspinner',options:{min:1,required:true,editable:false}}}
        ]],
        onLoadSuccess:function(data){
            if(data&&data.rows){
                for(var i=0;i<data.rows.length;i++){
                    $("#mainGrid").datagrid("beginEdit",i);
                    if(pack_isAdd==false){
                        var ed = $('#mainGrid').datagrid('getEditor', {index:i,field:'quantity'});
                        $(ed.target).numberspinner('setValue', 1);
                    }

                }
            }
            if(isRequiredAdd!="true"){
                if(isPushArray==false){
                    pushArray();
                }
            }
        },
        onLoadError:function(){
            if(isRequiredAdd!="true"){
                if(isPushArray==false){
                    pushArray();
                }
            }
        }
    });
}
/**
* 初始化数据
* @param url
*/
function initData(url){
    $("#status").combobox({
        editable:false
    }).combobox("select",'1');
    $("#unit").combobox({
        url:url,
        editable:false,
        valueField: 'id',
        textField: 'unitName',
        onLoadSuccess: function(data){
           $('#unit').combobox("select",data[1].id);
        }
    })
}
/**
* 增加可选组
*/
function pushArray(){
   midArray=rowsArray;
    rowsArray=[];
    var numLen=$("#appendDiv ._clone_this").length;
    var len = $("#appendDiv ._clone_this").length+1;
    var $clone_div=$("#_clone_div ._clone_this").clone(true);
    $clone_div.find(".js_title").text("套餐可选组"+len);
    $clone_div.attr("_group_id","branch_table_"+len);
    $clone_div.attr("_group_name","套餐可选组"+len);
    $clone_div.find("._table_here").append("<table id='branch_table_"+len+"'></table>");
    var $number_box = $clone_div.find("#_number_box");
    $number_box.attr("id","number_id"+len);
    $clone_div.find(".panel-title").append($number_box);
    $("#appendDiv").append($clone_div);
    //$clone_div.find("div").css({"width":"auto","height":"auto"});
    //$clone_div.css("height","260px")
    init_grid("branch_table_"+len,"");
}
function init_grid(id,quantityTotal){
    $("#"+id).datagrid({
        singleSelect:false,
        pagination:false,
        fit:true,
        fitColumns:false,
        idField : 'id',
        rownumbers:true,
        width : 'auto',
        height :'auto',
        border : true,
        checkOnSelect:true,
        data:rowsArray,
        frozenColumns:[[{field:'id', checkbox:true}]],
        columns:[[
            {field:'goodsCode',title:'菜品编码',width:80,align:'left'},
            {field:'goodsName',title:'菜品名称',width:80,align:'center'},
            {field:'goodsUnitName',title:'单位',width:80,align:'center'},
            {field:'salePrice',title:'售价',align:'right',width:80,align:'right',formatter:moneyFormatter},
            {field:'addPrice',title:'加价',width:80,editor:{type:'numberspinner',align:'right',options:{min:0,required:true,editable:false}}}
        ]],
        onLoadSuccess:function(data){
            for(var i=0;i<data.rows.length;i++){
                $("#"+id).datagrid("beginEdit",i);
                if(pack_isAdd==false){
                    var ed = $("#"+id).datagrid('getEditor', {index:i,field:'addPrice'});
                    $(ed.target).numberspinner('setValue',0);
                    if(pack_isEdit==true){
                        $(ed.target).numberspinner('setValue',data.rows[i].goods.addPrice);
                    }
                }
            }
            var $selectDiv = $("[_group_id='"+id+"']").find("#selectDiv");
            $selectDiv.css("height","240px");
            $selectDiv.find("div:eq(1)").find("div").css("height","auto");
            $selectDiv.find(".datagrid,.datagrid-wrap,.datagrid-view").css("height","240px");
            $selectDiv.find(".datagrid-view1").find(".datagrid-body").css("height","200px");
            $selectDiv.find(".datagrid-view2").css("height","240px");
            $selectDiv.find(".datagrid-view2").find(".datagrid-body").css("height","200px");
            if(quantityTotal!=""){
                $("[_group_id='"+id+"']").find("input[id^='number_id']").val(quantityTotal);
                rowsArray=[];
            }
        },
        onLoadError:function(){
            $("[_group_id='"+id+"']").find("#selectDiv").css("height","240px");
            $("[_group_id='"+id+"']").find("#selectDiv").find("div:eq(1)").find("div").css("height","auto");
            $("[_group_id='"+id+"']").find("#selectDiv").find(".datagrid,.datagrid-wrap,.datagrid-view").css("height","240px");
            $("[_group_id='"+id+"']").find("#selectDiv").find(".datagrid-view1").find(".datagrid-body").css("height","200px");
            $("[_group_id='"+id+"']").find("#selectDiv").find(".datagrid-view2").css("height","240px");
            $("[_group_id='"+id+"']").find("#selectDiv").find(".datagrid-view2").find(".datagrid-body").css("height","200px");
        }
    })
}

/**
* 添加菜品
*/
function addGoods(url,isRequired){
    pack_isEdit=false;
    if(isRequired=="true"){
        mainRowsArray=[];
        var rows=$("#mainGrid").datagrid("getRows");
        if(rows.length>0){
            pack_isAdd=true;
            endEdit("mainGrid",rows);
            mainRowsArray=rows;
            begin_Edit("mainGrid",rows);
        }
        isRequiredAdd="true";
    }else{
        rowsArray=[];
        var rows=$("#"+groupId+"").datagrid("getRows");
        if(rows.length>0){
            pack_isAdd=true;
            endEdit(groupId,rows);
            rowsArray=rows;
            begin_Edit(groupId,rows);
        }
        isRequiredAdd="";
    }
    $("#goodsDialog").dialog({
        href:url
    }).dialog("open");
}
/**
*
*/
function closeWin(){
    $("#goodsDialog").window("close");
}
/**
 * 开始datagrid编辑
 */
function begin_Edit(gridId,rows){
    for(var i=0;i<rows.length;i++){
        var index= $("#"+gridId+"").datagrid("getRowIndex",rows[i]);
        $("#"+gridId+"").datagrid("beginEdit",index);
    }
}
/**
* 将选中的商品添加到数组中
*/
function pushRowsArray(array){
    if(isRequiredAdd=="true"){
        if(mainRowsArray.length>0){
            for(var key in mainRowsArray){
                for(var a in array){
                    if(mainRowsArray[key].id==array[a].id){
                        array.splice(a,1);
                    }
                }
            }
        }
        for(var m in array){
            mainRowsArray.push(array[m]);
        }
        $("#mainGrid").datagrid("loadData",mainRowsArray)
    }else{
        if(mainRowsArray.length>0){
            for(var key in mainRowsArray){
                for(var a in array){
                    if(mainRowsArray[key].id==array[a].id){
                        array.splice(a,1);
                    }
                }
            }
        }
        if(midArray.length>0){
            for(var i in midArray){
                for(var n in array){
                    if(midArray[i].id==array[n].id){
                        array.splice(n,1);
                    }
                }
            }
        }
        if(rowsArray.length>0){
            for(var x in rowsArray){
                for(var v in array){
                if(array[v].id==rowsArray[x].id){
                    array.splice(v,1)
                }
                }
            }
        }
        //var keyArray=dataMap[group__pushId];
        //if(keyArray!=undefined){
        //    for(var k in keyArray){
        //        rowsArray.push(keyArray[k]);
        //    }
        //}
        for(var r in array){
            rowsArray.push(array[r]);
        }

        $("#"+groupId).datagrid("loadData",rowsArray);
    }
    closeWin();
}
/**
* 点击添加菜品
*/
function clickAddGood(myself){
    getGroupIdOrGridId(myself)
}
/**
* 点击删除菜品
*/
function deleteGood(myself){
    getGroupIdOrGridId(myself);
    if(rowsArray.length>0) {
        var rows = $("#" + groupId).datagrid("getSelections");
        if (rows.length > 0) {
            $.messager.confirm('系统提示', '确定要删除吗？', function (r) {
                if (r) {
                    for (var i = 0; i < rows.length; i++) {
                        var index = $.inArray(rows[i], rowsArray);
                        rowsArray.splice(index, 1);
                    }
                    $("#" + groupId).datagrid("loadData", rowsArray);
                    $("#" + groupId).datagrid("clearSelections");
                }
            });
        } else {
            $.messager.alert("系统提示", "请至少选择一条数据！", "info");
        }
    }
    else{
        var keyArray=dataMap[group__pushId];
        var rows = $("#" + groupId).datagrid("getSelections");
        if (rows.length > 0) {
            $.messager.confirm('系统提示', '确定要删除吗？', function (r) {
                if (r) {
                    for (var i = 0; i < rows.length; i++) {
                        var index = $.inArray(rows[i], keyArray);
                        keyArray.splice(index, 1);
                    }
                    $("#" + groupId).datagrid("loadData", keyArray);
                    $("#" + groupId).datagrid("clearSelections");
                }
            });
        } else {
            $.messager.alert("系统提示", "请至少选择一条数据！", "info");
        }
    }
}
/**
* 公用得套餐可选组ID or datagrid ID
* @param myself
*/
function getGroupIdOrGridId(myself){
    groupId=$(myself).parents("._clone_this").attr("_group_id");
    group__pushId=$(myself).parents("._clone_this").attr("_group_pushId");
}

/**
* 删除套餐可选组
*/
function deleteGroup(myself){
    getGroupIdOrGridId(myself);
    var children=$("#appendDiv").find("._clone_this");
    if(children.length==1){
        $.messager.alert("系统提示","最后一个可选分组不能被删除！","info");
        return;
    }
    $("[_group_id='"+groupId+"']").remove();
}
function save(formId,url){
    var isSelected=getRequiredGroupData();
    var unit=$("#unit").combobox("getValue");
    if(unit==""){
        $.messager.alert("系统提示","请选择单位!","info");
        return;
    }
    if(isSelected=="false"){
        $.messager.alert("系统提示","请至少选择一条套餐必选组的菜品!","info");
        return;
    }
    getCheckGroup();
    submitForm(formId,url);
}
/**
* 套餐必选组
* @type {string}
*/
function getRequiredGroupData(){
    var groupString="套餐必选组%%";
    $("#mainGrid").datagrid("checkAll");
    var rows=$("#mainGrid").datagrid("getSelections");
    if(rows.length==0){
        return "false";
    }
    endEdit("mainGrid",rows);
    for(var i=0;i<rows.length;i++){
        var goodsId=rows[i].id;
        var groupGoods_quantity=rows[i].quantity;
        groupString+=goodsId+"##"+groupGoods_quantity+"%#%";
    }
    var mainString=groupString.substring(0,groupString.length-3);
    $("input[name='requiredGroupStr']").val(mainString);
    return "true";
}
/**
* 获取套餐可选组数据
*/
function getCheckGroup(){
    var midString="";
    var gridArr=$("#appendDiv").find(".datagrid-f");
    $.each(gridArr, function(i, n){
        var checkGroupString="";
        $("#"+$(n).attr("id")).datagrid("checkAll");
        var rows=$("#"+$(n).attr("id")).datagrid("getSelections");
        if(rows.length>0){
            var groupName=$(n).parents("._clone_this").attr("_group_name");
            var groupTotal=$(n).parents("._clone_this").find("input").val();
            midString+=""+groupName+"##"+groupTotal+"%%";
            endEdit($(n).attr("id"),rows);
            for(var a=0;a<rows.length;a++){
                var goodsId=rows[a].id;
                var groupGoods_addPrice=rows[a].addPrice;
                checkGroupString+=""+goodsId+"##"+groupGoods_addPrice+"%#%";
            }
            midString+=checkGroupString.substring(0,checkGroupString.length-3)+"#%#"
        }
    });
    if(midString!=""){
        var mainString=midString.substring(0,midString.length-3);
        $("input[name='optionalGroupVoStr']").val(mainString);
    }
}
/**
* 公用form表单提交方式
* @param formId
* @param url
*/
function submitForm(formId,url){
    $("#"+formId+"").form('submit',{
        url:url,
        onSubmit: function(){
            if($("#goodsUnitOrder").form('validate')){
                $('#sub').attr('disabled',true);
                return true;
            }else{
                return false;
            }
        },
        success: function(result){
            var result = eval('('+result+')');
            if (result.success == "false"){
                var msg="保存失败！"
                if(result.tmxz==1){
                    msg=result.msg
                }
                $.messager.alert('系统提示',msg, 'error',function(){
                    $("#mainGrid").datagrid("checkAll");
                    var required_rows=$("#mainGrid").datagrid("getSelections");
                    begin_Edit("mainGrid",required_rows);
                    var gridArr=$("#appendDiv").find(".datagrid-f");
                    $.each(gridArr, function(i, n){
                        $("#"+$(n).attr("id")).datagrid("checkAll");
                        var rows=$("#"+$(n).attr("id")).datagrid("getSelections");
                        if(rows.length>0){
                           begin_Edit($(n).attr("id"),rows);
                        }
                    });
                } );
            } else {
                $("input[name='id']").val(result.object.id);
                $.messager.alert('系统提示', ""+result.msg+"","info", function(){
                        callBack();
                });
            }
        }
    });
}
/**
* 结束表格编辑
* @param arr
*/
function endEdit(gridId,arr){
    for(var i=0;i<arr.length;i++){
        var rowIndex=$('#'+gridId).datagrid("getRowIndex",arr[i]);
        $('#'+gridId).datagrid("endEdit",rowIndex);
    }
}
/**
* 修改加载旧数据
* @param url
* @param url1
*/
function pullEditData(url,url1){
    $.post(url,function(data){
        $("#goodsUnitOrder").form("load",data.package[0].aPackage);
        $("#status").combobox({
            editable:false
        }).combobox("select",''+data.package[0].aPackage.status);
        $("#unit").combobox({
            url:url1,
            editable:false,
            valueField: 'id',
            textField: 'unitName',
            onLoadSuccess: function(result){
                for(var key in result){
                    if(result[key].unitName.trim()==data.package[0].goodsUnitName){
                        $('#unit').combobox("select",result[key].id);
                    }
                }
            }
        })
        $("input[name='isTakeout']").prop("checked",data.package[0].aPackage.isTakeout);
        $("input[name='isHere']").prop("checked",data.package[0].aPackage.isHere);
        $("input[name='isTake']").prop("checked",data.package[0].aPackage.isTake);
        $("input[name='isOrder']").prop("checked",data.package[0].aPackage.isOrder);
        $("input[name='isScore']").prop("checked",data.package[0].aPackage.isScore);
        $("input[name='isDsc']").prop("checked",data.package[0].aPackage.isDsc);
        var groupArr=data.package[0].groups;
        $.each(groupArr,function(i,n){
            var groupId=n.group.id;
            var groupname=n.group.groupName;
            if(n.group.total!=null){
               var quantityTotal= n.group.total;
            }
            var rArray=n.groupGoodsVos;

            if(groupname==="套餐必选组"){
                pack_isAdd=true
              for(var key in rArray){
                  mainRowsArray.push(rArray[key]);
              }
              isPushArray=true;
              newMainDataGrid();
            }else{
              for(var key in rArray){
                  rowsArray.push(rArray[key]);
              }
                dataMap[groupId]=rowsArray;
              pushEditArray(groupname,groupId,quantityTotal);
            }
            });
        if(!isHeader){
            $('.class_branch_op').hide();
            disAble();
        }
        },'json')
}
function pushEditArray(groupName,groupId,quantityTotal){
    var numLen=$("#appendDiv ._clone_this").length;
    var len = $("#appendDiv ._clone_this").length+1;
    var $clone_div=$("#_clone_div ._clone_this").clone(true);
    $clone_div.find(".js_title").text(""+groupName+"");
    $clone_div.attr("_group_id","branch_table_"+len);
    $clone_div.attr("_group_name",""+groupName+"");
    $clone_div.attr("_group_pushId",""+groupId+"");
    $clone_div.find("._table_here").append("<table id='branch_table_"+len+"'></table>");
    var $number_box = $clone_div.find("#_number_box");
    $number_box.attr("id","number_id"+len);
    //$clone_div.find(".panel-title").append($number_box);
    $("#appendDiv").append($clone_div);
    //$clone_div.find("div").css({"width":"auto","height":"auto"});
    //$clone_div.css("height","260px");
    pack_isEdit=true;
    init_grid("branch_table_"+len,quantityTotal)
}
function disAble(){
     $("#packName").textbox("readonly",true);
     $("#status").combobox("readonly",true);
     $("#unit").combobox("readonly",true);
     $("#salePrice").numberbox("readonly",true);
     $("#vipPrice").numberbox("readonly",true);
     $("#vipTPrice").numberbox("readonly",true);
     $("input[type='checkbox']").each(function(){
         $(this).attr("disabled",true);
     });
    $("#add").linkbutton("disable",true);
}
function enAble(){
    $("#packName").textbox("readonly",false);
    $("#status").combobox("readonly",false);
    $("#unit").combobox("readonly",false);
    $("#salePrice").numberbox("readonly",false);
    $("#vipPrice").numberbox("readonly",false);
    $("#vipTPrice").numberbox("readonly",false);
    $("input[type='checkbox']").each(function(){
        $(this).attr("disabled",false);
    });
    $("#add").linkbutton("enable",true);
}
function deRequiredGood(){
    var rows=$("#mainGrid").datagrid("getSelections");
    if(rows.length>0){
        $.messager.confirm('系统提示','确定要删除吗？',function(r){
            if (r){
                isRequiredAdd="true";
                for(var i=0;i<rows.length;i++){
                    var index= $.inArray(rows[i],mainRowsArray);
                    mainRowsArray.splice(index,1);
                }
                $("#mainGrid").datagrid("loadData",mainRowsArray);
                $("#mainGrid").datagrid("clearSelections");
            }
        });
    }else{
        $.messager.alert("系统提示","请至少选择一条数据！","info");
    }
}
/**
 * 点击修改时调用的方法
 */
function updatePack(){
    enAble();
}
function cancel(){
    $("#goodsUnitOrder").form("reset");
    disAble();
}
/**
 * 判断选中菜品是否重复
 * @returns {Array}
 * @private
 */
function _get_push(){
    var pushArray=[];
    for(var key in mainRowsArray){
        pushArray.push(mainRowsArray[key]);
    }
    var keyArray=dataMap[group__pushId];
    if(keyArray!=undefined){
        for(var k in keyArray){
            pushArray.push(keyArray[k]);
        }
    }
    if(midArray.length>0){
        for(var key in midArray){
            pushArray.push(midArray[key]);
        }
    }else{
        for(var key in rowsArray){
            pushArray.push(rowsArray[key]);
        }
    }
    return pushArray;
}