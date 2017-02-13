// 商品条码验证 13位数字
$.validator.addMethod("thirteen",function(value,element){
        var tel = /^\d{13}$/;
        return this.optional(element) || (tel.test(value));
},"请输入13位整数");
//商品条码验证  数字 字母 下划线的组合
$.validator.addMethod("barCodeVal",function(value,element){
        var tel = /^[a-zA-Z0-9_ ]+$/;
        return this.optional(element) || (tel.test(value));
},"请输入数字、字母、下划线的组合");
//验证数字为小数点后两位小数
$.validator.addMethod("num",function(value,element){
        return this.optional( element ) || /^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d{2})?$/.test( value );
},"请输入两位小数");
//验证填写的分类是否存在
$.validator.addMethod("catName",function(value,element){
        var result;
        if($.inArray(value,categoryArray)==-1){
                result = false;
        }else{
                result = true;
        }
        return this.optional(element) || result
},"填写分类不存在，请重新填写！");
//验证非零的正整数
$.validator.addMethod("positiveVal",function(value,element){
        var tel = /^\+?[1-9][0-9]*$/;
        return this.optional(element) || (tel.test(value));
},"请填写非零正整数");
