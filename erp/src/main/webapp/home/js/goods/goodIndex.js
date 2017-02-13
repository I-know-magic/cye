/**
 * Created by LiuJie on 2016/3/5.
 */
/**
 * 导入表格
 */
function importExcel() {
    $('#textfield').val('');
    $("#fileField").val('');
    $("#importExcelDialog").show();
}

/**
 * 导出表格
 * @param url
 */
function exportExcel(url){
    url += "goodsStatus=" + $("#status").val() + "&categoryIds=" + $("#categoryId").val()
    +"&barCodeOrName="+$("#goodNameOrCode").val()
    +"&brandId="+$("#brandId").val()+"&startSalePrice="
    +$("#startSalePrice").val()+"&endSalePrice="
    +$("#endSalePrice").val()+"&startPurchasingPrice="
    +$("#startPurchasingPrice").val()
    +"&endPurchasingPrice="+$("#endPurchasingPrice").val();
    window.location.href = encodeURI(url);
}
/**
 * 上传表格
 */
function upLoadExcel(){
    document.getElementById('textfield').value = $("#fileField").val();
}
function moneyFormatter(row,val,index) {
    if (val) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === 0) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === undefined || val === "" || val == null) {
        return "￥" + parseFloat(0).toFixed(2);
    } else {
        return "￥" + parseFloat(0).toFixed(2);
    }
}

/**
 *导入商品
 */
function importGood(url_importGoods){
        var fileName = $('#textfield').val();
        var fl = fileName.split(".");
        if(fl[1]=="xls" || fl[1]=="xlsx"){
            if (fileName) {
                $("#submitUploadFileForm").ajaxSubmit({
                    type: 'post',
                    dataType:'json',
                    url: url_importGoods,
                    success: function (data) {
                        if (data.success){
                            $.message.alert(data.msg);
                            $('#textfield').val('');
                            $("#fileField").val('');
                            $('#importExcelDialog').hide();
                            $("#goodTable").dataTable("reload");
                        }else{
                            $.message.alert("导入商品异常！请稍后重试");
                        }

                    }
                });
            } else {
                $("#importTipDialog").modelDialog("open");
            }
        }else{
            $.message.alert("上传文件格式不正确！请选择excel表格");
        }

}