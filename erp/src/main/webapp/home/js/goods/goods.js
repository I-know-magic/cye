
var del_temp_goodsBar;//将要删除的条码输入框
/**
 * 增加商品条码
 * @param flag 为true, 去掉多余的加号,只留下最后一项的
 */
function addGoodsBar(){
    var $div = $("#_clone_div").find(".code_div").clone(true);
    $div.find(".js_barcode").text("条码"+($("#add_goodsbar .js_barcode").length+1));
    //删除条码事件
    $div.find(".del").click(function(){
        del_temp_goodsBar = $(this);

        $.message.confirm('您确定要删除此条码吗？','系统提示',function(r){
            if(r){
                delGoodsBar()
            }else{

            }
        })
    });
    $('#add_goodsbar').append($div);
    var delLength = $("#add_goodsbar").find(".del").length;
    if(delLength == 1){
        //将调整的商品名称的top调回来
        $('div').find('.spmc').css('top','0px');
    }
}
function delGoodsBar(){
    del_temp_goodsBar.parents(".code_div").remove();
    $("#add_goodsbar .js_barcode").each(function(i,e){
        $(e).text("条码"+(i+1))
    });
    var delLength = $("#add_goodsbar").find(".del").length;
    if(delLength == 0){
        //没有多条码时调整商品名称的top
        $('div').find('.spmc').css('top','3px');
    }
}

var store_num = 1;
/**
 * 是否管理库存
 */
function is_store(){
    if (store_num == 0) {
        $("#storeImg").removeClass("switch-off");
        store_num = 1;
        $("#isStore").val('true');
    } else {
        $("#storeImg").addClass("switch-off");
        store_num = 0;
        $("#isStore").val('false');
    }
}
var dis_num = 1;
/**
 * 是否可折扣
 */
function is_dsc(){
    if (dis_num == 0) {
        $("#dscImg").removeClass("switch-off");
        dis_num = 1;
        $("#isDsc").val('true');
    } else {
        $("#dscImg").addClass("switch-off");
        dis_num = 0;
        $("#isDsc").val('false');
    }
}
var status_num = 1;
/**
 * 商品状态
 */
function goodsStatus(){
    if(status_num == 1){
        $("#statusImg").addClass("switch-off");
        $("#goodsStatus").val(1);
        status_num = 0;
    }else{
        $("#statusImg").removeClass("switch-off");
        $("#goodsStatus").val(0);
        status_num = 1;
    }
}
var priceType_num = 0;
/**
 * 计价方式 是称重商品还是普通商品
 */
function is_weighing(){
    if(priceType_num == 0){
        $("#priceTypeImg").removeClass("switch-off");
        priceType_num = 1;
        $("#isWeigh").val('true');
    }else{
        $("#priceTypeImg").addClass("switch-off");
        priceType_num = 0;
        $("#isWeigh").val('false');
    }
}


/**
 * 生成商品条码
 */
function createBar(){
    $.post(createBar_url,function(result){
        $("#goodsBar").val(result)
    })
}
/**
 * 录入商品名称之后设置商品简称和助记码
 */
function setShortName(){
    var goodsName = $("#goodsName").val();
    $("#shortName").val(goodsName);
    goods_Name(getMnemonic_url);
}
/**
 * 生成助记码
 */
function goods_Name(url) {
    var gn = $('#shortName').val();
    if (gn == '' || gn == null) {
        $('#mnemonic').val('');
        return;
    }
    url = url + '?code=' + gn;
    $.post(encodeURI(url), function (data) {
        if (true) {
            mnemonicFlage = 1;
            if (mnemonicFlage > 0) {
                $('#mnemonic').val(data);
            }
            mnemonicFlage = 2;
        }
        else {
        }
    });
}
function change_mnemonic(newVal,oldVal){
    if(newVal){
        var is = /^[a-zA-Z0-9]+$/.test(newVal);
        if(!is){
            $("#mnemonic").val(oldVal);
        }
    }
}
/**
 * 得到商品状态、商品单位对象
 * @param name
 * @param value
 * @returns {Object}
 */
function getObj(name,value){
    var obj = new Object();
    obj.name = name;
    obj.value = value;
    return obj;
}
/**
 * 检查商品条码是否重复
 * @param arr
 * @returns {boolean}
 */
function isRepeat(arr){
    if(arr && arr.length>0){
        for(var a =0;a<arr.length;a++){
            for(var b =0; b<arr.length;b++){
                if(a != b){
                    if(arr[a] == arr[b]){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    //var hash = {};
    //for(var i in arr) {
    //    if(hash[arr[i]]){
    //        return true;
    //    }
    //    hash[arr[i]] = true;
    //}
    //return false;
}
/**
 * 保存商品信息
 * @param url
 * @param flag 新增或修改
 * @param isReset true 保存并新增 false 只保存
 */
function saveInfo(url,flag,isReset) {
    var goodsInfoId;
    $("#goodsInfoForm").validation(function(){
        if(flag == 'add'){
            if ($("#isStore").val() == '') {
                $("#isStore").val('true');
            }
            if ($("#isDsc").val() == '') {
                $("#isDsc").val('true');
            }
            if($("#goodsStatus").val() == ''){
                $("#goodsStatus").val(0);
            }
            if($("#isWeigh").val() == ''){
                $("#isWeigh").val('false');
            }
        }
        var params = $("#goodsInfoForm").serializeArray();
        if(flag == 'edit'){
            var barCode = getObj("barCode",$("#goodsBar").val());
            params.push(barCode);
            var id = getObj("id",goodsId);
            params.push(id);
        }
        var jsonParms = {};
        for (var item in params) {
            jsonParms[params[item].name] = params[item].value;
        }
        var barCode = '';
        var goodsBars = document.getElementsByName("goodsBar");
        var goodsBarsVal = [];
        if(goodsBars && goodsBars.length>0){
            $.each(goodsBars,function(index,value){
                if($(goodsBars[index]).val()!=''){
                    goodsBarsVal.push($(goodsBars[index]).val()) ;
                }
            });
        }

        goodsBarsVal.push($("#goodsBar").val());
        if(isRepeat(goodsBarsVal)){
            $.message.alert('商品条码不可以重复，请修改！');
            return
        }
        $.each(goodsBars,function(index,value){
            if($(goodsBars[index]).val()!=''){
                if(index == 0){
                    barCode = $(goodsBars[index]).val();
                }else{
                    barCode = barCode + "," + $(goodsBars[index]).val();
                }
            }
        });
        var params_data = {
            goods:JSON.stringify(jsonParms),
            bars: barCode
        };//保存商品档案参数
        $.ajax({
            url:url,
            data:params_data,
            type:'post',
            dataType:'json',
            success:function(data){
                if(data.isSuccess){
                    var tipStr;
                    if(flag == 'edit'){
                        tipStr = '商品档案修改成功！'
                    }else if(flag == 'add'){
                        tipStr = '添加商品档案成功！'
                    }
                    if(isReset){
                        //保存并新增
                        $.message.alert(tipStr,function(){
                            $.post(url_addGoods,function(data){
                                $('#content').html(data)
                            })
                        });
                    }else{
                        if(flag == 'edit'){
                            goodsInfoId = goodsId;

                        }else if(flag == "add"){
                            goodsInfoId = data.data.id;
                        }
                        //商品档案添加成功之后跳转到商品信息文本页面
                        $.message.alert(tipStr,function(){
                            $.post(goodsInfoText_url,{goodsId:goodsInfoId},function(data){
                                $('#content').html(data)
                            })
                        });
                    }
                }else{
                    if(flag == 'add'){
                        $.message.alert("添加商品档案失败！");
                    }else if(flag == 'edit'){
                        $.message.alert("修改商品档案失败！");
                    }
                }
            }
        });
    });

}
/**
 * 加载商品档案文本信息
 * @param url
 */
function loadGoodsText(url){
    $.ajax({
        url:url,
        cache:false,
        dataType:'json',
        async:true,
        success:function(data){
            $("#barCodeTxt").text(data.barCode);
            if(data.goodsStatus == 0){
                $("#statusTxt").text("是")
            }else{
                $("#statusTxt").text("否")
            }
            if(data.spec){
                $("#specTxt").text(data.spec);
            }else{
                $("#specTxt").text("无");
            }
            $("#goodsNameTxt").text(data.goodsName);
            $("#categoryTxt").text(data.catName);
            $("#purchasingPriceTxt").text(parseFloat(data.purchasingPrice).toFixed(2));
            $("#salePriceTxt").text(parseFloat(data.salePrice).toFixed(2));
            $("#vipPrice1Txt").text(parseFloat(data.vipPrice1).toFixed(2));
            if(data.brandName){
                $("#brandTxt").text(data.brandName);
            }else{
                $("#brandTxt").text("无");
            }
            if(data.unitName){
                $("#goodsUnitTxt").text(data.unitName);
            }else{
                $("#goodsUnitTxt").text("无");
            }
            $("#shortNameTxt").text(data.shortName);
            $("#mnemonicTxt").text(data.mnemonic);
            if(data.isWeigh){

            }else{
                $("#isWeighingTxt").addClass("switch-off");
            }
            if(data.isStore){

            }else{
                $("#isStoreTxt").addClass("switch-off");
            }
            if(data.isDsc){

            }else{
                $("#isDscTxt").addClass("switch-off");
            }
            if(data.photo){
                $("#imgTxt").attr("src",visitDomain+data.photo);
            }
            /*if(data.goodsBars!=null){
                var goodsBarsArray = [];
                goodsBarsArray = data.goodsBars.split(",");
                var $p;
                $.each(goodsBarsArray,function(index,item){
                    $p = $(".clone_bar").find('.rel').clone();
                    $p.find("span").text("条码"+(index + 1)+": ");
                    $p.find('.barVal').text(item);
                    $("#goodsBars").append($p);
                });
            }else{
                $("#barNone").show();
            }*/
            if(data.goodsBars!=null){
                var goodsBarsArray = [];
                goodsBarsArray = data.goodsBars.split(",");
                var len=goodsBarsArray.length;
                var team=Math.ceil(len/2);
                if(len%2==0){
                    var doubleCol=true
                }else{
                    var doubleCol=false
                }
                var htmlBars=""
                for(i=1;i<team+1;i++){
                    var a=i*2-1
                    var b=i*2
                    if(i<team){
                        htmlBars=htmlBars+'<div class="clearfix rel goodsbars"><p class="rel sptm"><span>条码'
                        +a+'：</span><t id="barCodeTxt">'+goodsBarsArray[a-1]+'</t><span>条码'
                        +b+'：</span><t id="barCodeTxt">'+goodsBarsArray[b-1]+'</t></p></div>'
                    }else{
                        if(doubleCol){
                            htmlBars=htmlBars+'<div class="clearfix rel goodsbars"><p class="rel sptm"><span>条码'
                            +a+'：</span><t id="barCodeTxt">'+goodsBarsArray[a-1]+'</t><span>条码'
                            +b+'：</span><t id="barCodeTxt">'+goodsBarsArray[b-1]+'</t></p></div>'
                        }else{
                            htmlBars=htmlBars+'<div class="clearfix rel goodsbars"><p class="rel sptm"><span>条码'
                            +a+'：</span><t id="barCodeTxt">'+goodsBarsArray[a-1]+'</t></p></div>'
                        }
                    }
                }
                $("#addGoodBar").after(htmlBars);
            }
        }
    })
}
/**
 * 将数据加载到表单中
 * @param jsonStr
 */
function loadData(jsonStr){
    //var obj = eval("("+jsonStr+")");
    var obj = jsonStr;
    var key,value,tagName,type,arr;
    for(x in obj){
        key = x;
        value = obj[x];

        $("[name='"+key+"'],[name='"+key+"[]']").each(function(){
            tagName = $(this)[0].tagName;
            type = $(this).attr('type');
            if(tagName=='INPUT'){
                if(type=='radio'){
                    $(this).attr('checked',$(this).val()==value);
                }else if(type=='checkbox'){
                    arr = value.split(',');
                    for(var i =0;i<arr.length;i++){
                        if($(this).val()==arr[i]){
                            $(this).attr('checked',true);
                            break;
                        }
                    }
                }else{
                    if(key =="purchasingPrice" || key == "salePrice" || key == "vipPrice1" || key == "vipPrice2"){
                        if(value.toString().indexOf(".")==-1){
                            value = value + ".00";
                        }else if(value.toString().substring(value.toString().indexOf('.')+1,value.toString().length).length == 1){
                            value = value + "0"
                        }
                    }
                    $(this).val(value);
                }
            }else if(tagName=='SELECT' || tagName=='TEXTAREA'){
                $(this).val(value);
            }

        });
    }
}
/**
 * 加载编辑数据
 * @param url
 */
function loadUpdateData(url){
    $.ajax({
        url: url,
        cache: false,
        dataType: 'json',
        async: true,
        success: function (data) {
            loadData(data);
            $("#categoryId").val(data.categoryId);
            $("#category").val(data.catName);
            $("#brandId").val(data.brandId);
            $("#brand").val(data.brandName);
            if(data.goodsUnitId!=null && data.goodsUnitId!=0){
                $("#goodsUnitId").val(data.goodsUnitId);
                $("#goodsUnit").val(data.unitName);
            }
            $("#goodsStatus").val(data.goodsStatus);
            if(data.goodsStatus == 1){
                $("#statusImg").addClass("switch-off");
                status_num = 0;
            }else{
                status_num = 1;
            }
            if(data.photo!=null){
                $("#img").attr("src",visitDomain+data.photo);
                $("input[name='photo']").val(""+data.photo+"");
            }
            if(data.goodsBars!=null){
                //如果已经存在条码输入框则删除
                if($("#add_goodsbar").children().length > 0){
                    $("#add_goodsbar").find(".code_div").remove();
                }
                var goodsBarsArr = data.goodsBars.split(",");
                //循环生成多条码的输入框
                for(var i = 0;i<goodsBarsArr.length;i++){
                    addGoodsBar();
                }
                var goodsBarObjs = document.getElementsByName("goodsBar");
                $.each(goodsBarObjs,function(index,item){
                    $(item).val(goodsBarsArr[index]);
                });
            }
            if(data.isStore == false){
                $("#storeImg").addClass("switch-off");
                store_num = 0;

            }else if(data.isStore == true){
            }
            $("#isStore").val(data.isStore);

            if(data.isDsc == false){
                $("#dscImg").addClass("switch-off");
                dis_num = 0;
            }else if(data.isDsc == true){
            }
            $("#isDsc").val(data.isDsc);

            if(data.isWeigh == false){

            }else if(data.isWeigh == true){
                $("#priceTypeImg").removeClass("switch-off");
                priceType_num = 1;
            }
            $("#isWeigh").val(data.isWeigh);
        }

    })
}
/**
 * 删除商品
 * @param goodsId
 */
function delGoods(){
    $.message.confirm('您确定要删除此商品吗？','系统提示',function(r){
        if(r){
            var url = url_deleteGoods+ "?ids="+goodsInfoId;
            $.post(url,function(data){
                var delResult = data;
                if(delResult.isSuccess){
                    data = data.data;
                    $("#goodTable").dataTable("reload");
                    var mes = "&nbsp";
                    if (data.errors.length > 0) {
                        mes = mes + "删除失败";
                        $.each(data.errors,function(index, item){
                            mes = mes + "<br>" + item.mes;
                        });
                        $.message.alert(mes);
                    } else{
                        mes = mes + "删除成功";
                        $.message.alert(mes,function(){
                            changeContent(url_goodsList);
                        });
                    }
                }else{
                    $.message.alert("删除失败！");
                }
            },"json");
        }
    });
}
/**
 * 分类自动补全
 */
function getCategoryData(){
    $( "#category" ).autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: getCategory_url,
                dataType: "json",
                data:{
                    codeOrName: $("#category").val()
                },
                success: function( data ) {
                    response( $.map( data.data, function( item ) {
                        return {
                            catId:item.id,
                            value: item.catName
                        }
                    }));
                }
            });
        },
        minLength: 2,
        select: function( event, ui ) {
            $("#categoryId").val(ui.item.catId);
            $(".ff").find(".wrong-icon").remove();//把之前的分类错误提示清除
        }
    });
}
/**
 * 图片上传
 */
function ajaxFileUpLoad(){
    $.ajaxFileUpload({
        url:imgUpLoad_url,
        async:true,
        secureuri:false,
        fileElementId:"fileUpLoad",
        dataType:"JSON",
        success:function(data){
            if(data.success=="false"){
                $.message.alert(data.msg,"info");
                return;
            }
            $("#img").attr("src",data.visitDomain+data.dbPath);
            $("input[name='photo']").val(""+data.dbPath+"");
        }
    })
}
function openFileDialog(){
    $("#fileUpLoad").click();
}
/**
 * 从商品库中检索数据 自动补全
 */
function getLibraryData(){
    $( "#goodsBar" ).autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: searchFromLibrary_url,
                dataType: "json",
                data:{
                    barCod: $("#goodsBar").val()
                },
                success: function( data ) {
                    response( $.map( data, function( item ) {
                        return {
                            value:item.barCode,
                            goodsName:item.goodsName,
                            spec:item.spec,
                            photo:item.photo
                        }
                    }));
                }
            });
        },
        minLength: 1,
        select: function( event, ui ) {
            $("#goodsName").val(ui.item.goodsName);
            //$("#spec").val(ui.item.spec);
            if(ui.item.photo){
                $("#img").attr("src",visitDomain+ui.item.photo);
                $("input[name='photo']").val(""+ui.item.photo+"");
            }

        }
    });
}
function reBack(){
    window.location.href = goodsIndex_url;
}
/**
 * 格式化进货价、零售价、会员价为两位小数，并且录入零售价
 * 的时候设置会员价
 * @param inputId
 */
function numFormatter(inputId){
    var data = $("#"+inputId).val();
    var result;
    if(data &&!isNaN(data)){
       result = parseFloat(data).toFixed(2);
    }else{
        result = parseFloat(0).toFixed(2);
    }
    $("#"+inputId).val(result);
    if(inputId == "salePrice" && result!=null){
        $("#vipPrice1").val(result);
        $("#vipPrice2").val(result);
    }
}
/**
 * 设置输入框只能输入整数和小数
 * @returns {boolean}
 */
function keydown(){
    var kc = event.keyCode;
    if(
        (kc >= 48 && kc <= 57) // [0-9]
        || kc == 189  // - 负号
        || kc == 190  // . 小数点
        || kc == 8 // backspace
        || kc == 37 // 左箭头
        || kc == 39 // 右键头
        || (kc <= 105 && kc >= 96)//小键盘
        || kc == 110 //小键盘的小数点
    ){
        return true;
    }else{
        return false;
    }
}
function set(){
}
/**
 * 验证商品条码是否有商品在使用
 * @param barCode
 */
function validateCode(barCode){
    $.post(validateCode_url,{barCode:barCode},function(result){
        if(result.length > 0){
            $.message.confirm('商品条码已存在，是否继续录入？','系统提示',function(r){
                if(r){

                }else{
                    clearCode();
                }
            });
        }
    });
}
/**
 * 清空商品条码输入框
 */
function clearCode(){
    $("#goodsBar").val('');
}
//窗口的高度
var windowHeight;
//窗口的宽度
var windowWidth;
//弹窗的高度
var popHeight;
//弹窗的宽度
var popWidth;
//滚动条滚动的高度
var scrollTop;
//滚动条滚动的宽度
var scrollleft;
//延时的时间
var timeout;
function init(){
//获得窗口的高度
    windowHeight=$(window).height();
//获得窗口的宽度
    windowWidth=$(window).width();
//获得弹窗的高度
    popHeight=$(".window").height();
//获得弹窗的宽度
    popWidth=$(".window").width();
//获得滚动条的高度
    scrollTop=$(window).scrollTop();
//获得滚动条的宽度
    scrollleft=$(window).scrollLeft();
}
function popcenterWindow(dialogId){
//先清空上一次的延迟
    clearTimeout(timeout);
    timeout=setTimeout(function (){
        init();
        var popY=(windowHeight-popHeight)/2+scrollTop;
        var popX=(windowWidth-popWidth)/2+scrollleft;
        //$("#"+dialogId).animate({top:popY,left:popX},300).show("slow");
        $("#"+dialogId).modelDialog('open');
        $("#"+dialogId).css({top:popY,left:popX});
    },300);
}
/**
 * 商品档案修改
 */
function updataGoods(id){
    if(id!="" && id!=null){
        goodsInfoId = id;
    }
    $.post(url_addGoods,{id:goodsInfoId},function(data){
        $('#content').html(data)
    })
}
/**
 * 跳转到商品分类页面，在新窗口中打开
 */
function categoryView(){
    $(".fl-icon").find('.add').click(function(){
        var url = mainFrame_url+"?isOpenCat=true";
        window.open(url);
    });
}