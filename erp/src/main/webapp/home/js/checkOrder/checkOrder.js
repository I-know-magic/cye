/**
 * Created by LiuJie on 2016/3/26.
 * 商品盘点js
 */
//保存采购商品集合
var  checkGoodsData=[];
//盘点添加的商品对象
var checkGood=function(){
    return this.name={
        "id":0,
        "barCode":"",
        "goodsName":'',
        "unitName":"",
        "storeQuantity":0.00,//库存数量
        "reallyQuantity":0.00,//盘点数量
        "checkQuantity":0.00,//盈亏数量
        "checkAmount":0.00,//盈亏金额
        "storeAvgAmount":0.00//库存成本
    }
};
//保存采购的订单对象
var checkOrder=function(){
    return this.name={
        "goodsId":"",
        "reallyQuantity":0.00
    }
};
/**
 * 获取选中的商品
 * @param rows
 */
function getCheckGoodsData(rows){
    var stockGoods=[];
    checkGoodsData=$("#stockTable").dataTable("getEditRowData");
    if(rows.length>200){
        $.message.alert("一次性盘点商品不能超过200条！");
        return false;
    }
    if(rows && rows.length>0){
        if(checkGoodsData && checkGoodsData.length>0){
            //去除重复的数组元素
            for(var i=0;i<checkGoodsData.length;i++){
                for(var y=0;y<rows.length;y++){
                    if(checkGoodsData[i].id==rows[y].id){
                        var _stock_Good= $.extend(rows[y],checkGoodsData[i]);
                        var index = $.inArray(rows[y],rows);
                        rows.splice(index,1,_stock_Good);
                    }
                }
            }

        }
        var ids=[];
        for(var x=0;x<rows.length;x++){
            ids.push(rows[x].id);
            var _stockGood = new  checkGood();
            var stock_Good= $.extend(_stockGood,rows[x]);
            stockGoods.push(stock_Good);
        }
        $.post(getStoreByGoodIdUrl+"?goodsIds="+ids,function(data){
            if(data && data.isSuccess){
                var storeInfos=data.data;
                if(storeInfos && storeInfos.length>0){
                    for(var s=0;s<storeInfos.length;s++){
                        var storeInfo = storeInfos[s];
                        var goodId = storeInfo["goodsId"];
                        if(storeInfo["storeId"]){
                            var storeQuantity = storeInfo["storeQuantity"];
                            for(var t = 0;t<stockGoods.length;t++){
                                    if(goodId==stockGoods[t]["id"]){
                                        stockGoods[t]["storeQuantity"]=storeQuantity;
                                        stockGoods[t].checkQuantity =parseFloat(parseFloat(stockGoods[t]["reallyQuantity"])-parseFloat(storeInfo["storeQuantity"])).toFixed(2);
                                        stockGoods[t].storeAvgAmount = storeInfo["storeAvgAmount"];
                                        if(storeQuantity == 0){
                                            stockGoods[t].checkAmount = parseFloat(parseFloat(stockGoods[t].checkQuantity) * parseFloat(stockGoods[t].purchasingPrice)).toFixed(2);
                                        }else{
                                            stockGoods[t].checkAmount = parseFloat(parseFloat(stockGoods[t].checkQuantity) * parseFloat(stockGoods[t].storeAvgAmount)).toFixed(2);
                                        }
                                    }
                            }
                        }
                    }
                }

            }
            $(".selectGoodsByDialog").hide();
            $("#stockTable").dataTable("load",stockGoods);
        },"json");


    }

}

/**
 * 选中已添加的菜品
 */
function selectRows(){
    var rows= $("#stockTable").dataTable("getRows");
    $("#goodGrid").dataTable("selectionRow",rows);
}
/**
 * 保存商品盘点进货单
 */
function saveCheck(){
    var rows= $("#stockTable").dataTable("getEditRowData");
    var orders=[];
    if(rows && rows.length>0){
        for(var i=0;i<rows.length;i++){
            var _storeOrder=new checkOrder();
            _storeOrder.goodsId=rows[i].id;
            _storeOrder.reallyQuantity=rows[i].reallyQuantity;
            orders.push(_storeOrder);
        }
        $.post(saveCheckUrl,{detailStr:JSON.stringify(orders)},function(data){
            if(data){
                $("#stockTable").data("disable_submit_form",false);

                if(data.isSuccess){
                        $.message.alert("保存商品盘点单成功！",function(){
                            checkGoodsData=[];
                            changeContent(viewCheckGoodUrl);
                            $("#stockTable").dataTable("load",checkGoodsData);
                        })
                }else{
                    $.message.alert("抱歉！保存商品盘点单失败！ 异常信息:"+data.message);
                }
            }else{
                $("#stockTable").data("disable_submit_form",false);

                $.message.alert("系统异常！请联系工作人员")
            }
        },"json");
    }else{
        $.message.alert("您还没有选择任何商品！");
    }

}

function dataCompute(table){
    $(table).find("tbody").find("input").filter("[name='reallyQuantity']").bind("change",function(){
        var this_val = $(this).val();
        if(this_val && !isNaN(this_val)){
            $(this).val(parseFloat(this_val).toFixed(2));
        }else{
            $(this).val(parseFloat(0).toFixed(2));
        }
        this_val = $(this).val();
        if(this_val.length>10){
            return false
        }
        var store_val = $(this).parents("tr").find("[td_filed='storeQuantity']").text();
        var checkQuantity = parseFloat(parseFloat(this_val)-parseFloat(store_val)).toFixed(2);//盈亏数量
        //var amount = parseFloat(this_val) * parseFloat(number_val);
        $(this).parents("tr").find("[td_filed='checkQuantity']").text(parseFloat(checkQuantity).toFixed(2));
        //计算损益金额 checkAmount
        var rowId = $(this).parents("tr._summary").attr("filedid");
        var _row = $(table).dataTable("getRow",rowId);
        var checkAmount;
        if(_row["storeQuantity"] == 0){
            checkAmount =parseFloat(parseFloat(checkQuantity) * parseFloat(_row["purchasingPrice"])).toFixed(2);
        }else{
            checkAmount =parseFloat(parseFloat(checkQuantity) * parseFloat(_row["storeAvgAmount"])).toFixed(2);
        }
        $(this).parents("tr").find("[td_filed='checkAmount']").text(checkAmount);
        var inputs = $(table).find("tbody").find("input").filter("[name='reallyQuantity']");
        if(inputs && inputs.length>0){
            var plusAmount = 0;
            for(var s=0;s<inputs.length;s++){
                plusAmount = parseFloat(plusAmount)+parseFloat($(inputs[s]).val());
            }
            if(isNaN(plusAmount)){
                plusAmount=0;
            }
            $(table).find("tbody").find(".footer_total").find("[filed_name='reallyQuantity']").text(parseFloat(plusAmount).toFixed(2));
        }
        //损益数量合计
        var check_quantitys =  $(table).find("tbody").find("tr._summary").find("[td_filed='checkQuantity']");
        if(check_quantitys && check_quantitys.length){
            var c_q_amout = 0;
            for(var i =0; i<check_quantitys.length;i++){
                    var c_q = $(check_quantitys[i]).text();
                     c_q_amout= parseFloat(c_q_amout)+parseFloat(c_q);
            }
            $(table).find("tbody").find(".footer_total").find("[filed_name='checkQuantity']").text(parseFloat(c_q_amout).toFixed(2));

        }
        //损益金额合计
        var check_amouts =  $(table).find("tbody").find("tr._summary").find("[td_filed='checkAmount']");
        if(check_amouts && check_amouts.length){
            var c_a_amout = 0;
            for(var i =0; i<check_amouts.length;i++){
                var c_a = $(check_amouts[i]).text();
                c_a_amout= parseFloat(c_a_amout)+parseFloat(c_a);
            }
            $(table).find("tbody").find(".footer_total").find("[filed_name='checkAmount']").text(parseFloat(c_a_amout).toFixed(2));

        }
    });
}

/**
 * 删除表格本地数据
 * @param id
 */
function delCheckRowData(id){
    var editDataArray=$("#stockTable").dataTable("getEditRowData");
    if(editDataArray && editDataArray.length>0){
        $("#stockTable").dataTable("load",editDataArray);
    }
}




