/**
 * Created by LiuJie on 2016/3/23.
 * 采购进货js
 */
//保存采购商品集合
var  stockGoodsData=[];
//采购添加的商品对象
var stockGood=function(){
    return this.name={
        "id":0,
        "barCode":"",
        "goodsName":'',
        "unitName":"",
        "purchasingPrice":0.00,
        "number":1.00,
        "amount":0.00
    }
};
//保存采购的订单对象
var storeOrder=function(){
    return this.name={
        "goodsId":"",
        "purchaseAmount":0.00,
        "quantity":0.00
    }
};
/**
 * 获取选中的商品
 * @param rows
 */
function getStockGoodsData(rows){
    var stockGoods=[];
    stockGoodsData=$("#stockTable").dataTable("getEditRowData");
    if(rows && rows.length>0){
        if(stockGoodsData && stockGoodsData.length>0){
            //去除重复的数组元素
            for(var i=0;i<stockGoodsData.length;i++){
                for(var y=0;y<rows.length;y++){
                    if(stockGoodsData[i].id==rows[y].id){
                        //var _stock_Good= $.extend(rows[y],stockGoodsData[i]);
                        var index = $.inArray(rows[y],rows);
                        rows.splice(index,1);
                    }
                }
            }
            for(var x=0;x<rows.length;x++){
                var _stockGood = new  stockGood();
                var stock_Good= $.extend(_stockGood,rows[x]);
                stock_Good.amount = parseFloat(parseFloat(stock_Good["purchasingPrice"]) * parseFloat(stock_Good["number"])).toFixed(2);
                stockGoodsData.push(stock_Good);
            }
            return stockGoodsData;

        }else{
            for(var x=0;x<rows.length;x++){
                var _stockGood = new  stockGood();
                var stock_Good= $.extend(_stockGood,rows[x]);
                stock_Good.amount = parseFloat(parseFloat(stock_Good["purchasingPrice"]) * parseFloat(stock_Good["number"])).toFixed(2);
                stockGoods.push(stock_Good);
            }
            return stockGoods
        }


    }

}
/**
 * 根据商品条码获取商品
 * @param data
 */
function getGoodByBarCode(data){
    var goods_array = [];
    var _stockGood = new  stockGood();
    var stock_Good= $.extend(_stockGood,data);
    stock_Good.amount = parseFloat(parseFloat(stock_Good["purchasingPrice"]) * parseFloat(stock_Good["number"])).toFixed(2);
    goods_array.push(stock_Good);
    $("#stockTable").dataTable("load",goods_array);
}


/**
 * 选中已添加的菜品
 */
function selectRows(){
    var rows= $("#stockTable").dataTable("getRows");
    $("#goodGrid").dataTable("selectionRow",rows);
}
/**
 * 保存采购进货单
 */
function saveStock(type){
    var rows= $("#stockTable").dataTable("getEditRowData");
    var orders=[];
    if(rows.length==0){
        $.message.alert("您还没有选择任何商品！");
        return false;
    }
    if(rows.length>200){
        $.message.alert("一次保存商品不能超过200条！");
        return false;
    }
    if($("#stockTable").data("disable_submit_form")){
        return $.message.alert("请不要重复提交数据！");
    }
    $("#stockTable").data("disable_submit_form",true);
    if(rows && rows.length>0){
        for(var i=0;i<rows.length;i++){
            var _storeOrder=new storeOrder();
            _storeOrder.goodsId=rows[i].id;
            _storeOrder.purchaseAmount=rows[i].purchasingPrice;
            _storeOrder.quantity=rows[i].number;
            orders.push(_storeOrder);
        }

        $.post(saveStockUrl,{orderType:type,detailStr:JSON.stringify(orders)},function(data){
            if(data){
                $("#stockTable").data("disable_submit_form",false);
                if(data.isSuccess){
                    if(type==2){
                        $.message.alert("保存采购退货单成功！",function(){
                            stockGoodsData=[];
                            changeContent(viewCancelStockUrl);
                        })
                    }else{
                        $.message.alert("保存采购进货单成功！",function(){
                            stockGoodsData=[];
                            changeContent(viewStockUrl);
                        })
                    }

                }else{
                    $.message.alert("抱歉！保存采购进货单失败！ 异常信息:"+data.message);
                }
            }else{
                $("#stockTable").data("disable_submit_form",false);
                $.message.alert("系统异常！请联系工作人员")
            }
        },"json");
    }

}
/**
 * 计算列
 * @param table
 */
function dataCompute(table){
    $(table).find("tbody").find("input").filter("[name='purchasingPrice']").bind("change",function(){
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
            var number_val = $(this).parents("tr").find("input[name='number']").val();
            var amount = parseFloat(this_val) * parseFloat(number_val);
            $(this).parents("tr").find("[td_filed='amount']").text(parseFloat(amount).toFixed(2));
            var inputs = $(table).find("tbody").find("td").filter("[td_filed='amount']");
            if(inputs && inputs.length>0){
                var plusAmount = 0;
                for(var s=0;s<inputs.length;s++){
                    plusAmount = parseFloat(plusAmount)+parseFloat($(inputs[s]).text());
                }
                $(table).find("tbody").find(".footer_total").find("[filed_name='amount']").text(parseFloat(plusAmount).toFixed(2));
            }
    });

    $(table).find("tbody").find("input").filter("[name='number']").bind("change",function(){
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
        var number_val = $(this).parents("tr").find("input[name='purchasingPrice']").val();
        var amount = parseFloat(this_val) * parseFloat(number_val);
        $(this).parents("tr").find("[td_filed='amount']").text(parseFloat(amount).toFixed(2));
        var inputs = $(table).find("tbody").find("input").filter("[name='number']");
        if(inputs && inputs.length>0){
            var plusAmount = 0;
            for(var s=0;s<inputs.length;s++){
                plusAmount = parseFloat(plusAmount)+parseFloat($(inputs[s]).val());
            }
            $(table).find("tbody").find(".footer_total").find("[filed_name='number']").text(parseFloat(plusAmount).toFixed(2));
        }

        var td_inputs = $(table).find("tbody").find("td").filter("[td_filed='amount']");
        if(td_inputs && td_inputs.length>0){
            var td_Amount = 0;
            for(var s=0;s<td_inputs.length;s++){
                td_Amount = parseFloat(td_Amount)+parseFloat($(td_inputs[s]).text());
            }
            $(table).find("tbody").find(".footer_total").find("[filed_name='amount']").text(parseFloat(td_Amount).toFixed(2));
        }
    });
}
/**
 * 删除表格本地数据
 * @param id
 */
function delRowData(id){
    var editDataArray=$("#stockTable").dataTable("getEditRowData");
    if(editDataArray && editDataArray.length>0){
        $("#stockTable").dataTable("load",editDataArray);
    }
}



