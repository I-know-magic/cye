/**
 * Created by LiuJie on 2015/5/8.
 */
var $validateRules = $.extend({},{
    CHS: {
        validator: function (value, param) {
            return /^[\u0391-\uFFE5]+$/.test(value);
        },
        message: '请输入汉字'
    },
    english : {// 验证英语
        validator : function(value) {
            return /^[A-Za-z]+$/i.test(value);
        },
        message : '请输入英文'
    },
    ip : {// 验证IP地址
        validator : function(value) {
            return /\d+\.\d+\.\d+\.\d+/.test(value);
        },
        message : 'IP地址格式不正确'
    },
    ZIP: {
        validator: function (value, param) {
            return /^[0-9]\d{5}$/.test(value);
        },
        message: '邮政编码不存在'
    },
    sixNumber:{
        validator:function(value){
            return /^[0-9]\d{5}$/.test(value);
        },
        message:'请输入六位数字'

    },
    fourNumber:{
        validator:function(value){
           return /^[0-9]\d{3}$/.test(value);
        },
        message:'请输入四位数字'
    },
    eighteenNumber:{
        validator:function(value){
            return /^[0-9]\d{17}$/.test(value);
        },
        message:'请输入十八位数字'
    },
    QQ: {
        validator: function (value, param) {
            return /^[1-9]\d{4,10}$/.test(value);
        },
        message: 'QQ号码不正确'
    },
    mobile: {
        validator: function (value, param) {
            return/^1[0-9]{10}$/.test(value);
        },
        message: '手机号码不正确'
    },
    mobilePhone:{
       validator:function(value, param){
           return/^1[0-9]{10}$/.test(value);
       },
        message:'手机号码不正确'
    },
    mobilePhoneAndPhone:{
        validator:function(value, param){
            return/(^1[0-9]{10}$)|(^[0-9]{3,5}\-[0-9]{7,8}$)/.test(value);
        },
        message:'手机号码或者座机不正确,正确格式如下：\n座机号码：区号-座机号码(或)\n手机号码：11位手机号码'
    },
    tel:{
        validator:function(value,param){
            return/^[0-9]{3,5}\-[0-9]{7,8}$/.test(value);
        },
        message:'请出入正确的座机号码,区号-座机号码'
    },
    mobileAndTel: {
        validator: function (value, param) {
            return /(^([0\+]\d{2,3})\d{3,4}\-\d{3,8}$)|(^([0\+]\d{2,3})\d{3,4}\d{3,8}$)|(^([0\+]\d{2,3}){0,1}13\d{9}$)|(^\d{3,4}\d{3,8}$)|(^\d{3,4}\-\d{3,8}$)/.test(value);
        },
        message: '请正确输入电话号码'
    },
    number: {
        validator: function (value, param) {
            return /^[0-9]+.?[0-9]*$/.test(value);
        },
        message: '请输入数字'
    },
    money:{
        validator: function (value, param) {
            return (/^(([1-9]\d*)|\d)(\.\d{1,2})?$/).test(value);
        },
        message:'请输入正确的金额'

    },
    mone:{
        validator: function (value, param) {
            return (/^(([1-9]\d*)|\d)(\.\d{1,2})?$/).test(value);
        },
        message:'请输入整数或小数'

    },
    integer:{
        validator:function(value,param){
            return /^[+]?[1-9]\d*$/.test(value);
        },
        message: '请输入最小为1的整数'
    },
    integ:{
        validator:function(value,param){
            return /^[+]?[0-9]\d*$/.test(value);
        },
        message: '请输入整数'
    },
    range:{
        validator:function(value,param){
            if(/^[1-9]\d*$/.test(value)){
                return value >= param[0] && value <= param[1]
            }else{
                return false;
            }
        },
        message:'输入的数字在{0}到{1}之间'
    },
    minLength:{
        validator:function(value,param){
            return value.length >=param[0]
        },
        message:'至少输入{0}个字'
    },
    maxLength:{
        validator:function(value,param){
            return value.length<=param[0]
        },
        message:'最多{0}个字'
    },
    //select即选择框的验证
    selectValid:{
        validator:function(value,param){
            if(value == param[0]){
                return false;
            }else{
                return true ;
            }
        },
        message:'请选择'
    },
    idCode:{
        validator:function(value,param){
            return /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(value);
        },
        message: '请输入正确的身份证号'
    },
    loginNameVal: {
        validator: function (value, param) {
            return /^[\u0391-\uFFE5\w]+$/.test(value);
        },
        message: '登录名称只允许汉字、英文字母、数字及下划线。'
    },
    branchNameVal:{
        validator: function (value, param) {
            return /^[\u4e00-\u9fa5_a-zA-Z0-9]+$/.test(value);
        },
        message: '公司名称只允许汉字、英文字母、数字'
    },
    passVal:{
        validator: function (value) {
            return /^[0-9a-zA-Z]{6,20}$/.test(value);
        },
        message: '密码只允许6-20位数字和字母组合的表达式'
    },
    loginName: {
        validator: function (value, param) {
            if(value.length>20)
                return false
            else
                return /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/.test(value)||/^1\d{10}$/.test(value);
        },
        message: '请输入邮箱或手机号,且长度不能大于20。'
    },
    equalTo: {
        validator: function (value, param) {
            return value == $(param[0]).val();
        },
        message: '两次输入的字符不一致'
    },
    englishOrNum : {// 只能输入英文和数字
        validator : function(value) {
            return /^[a-zA-Z0-9_ ]{1,}$/.test(value);
        },
        message : '请输入英文、数字、下划线或者空格'
    },
    nochina : {// 只能输入英文和数字
        validator : function(value) {
            return /^[a-zA-Z0-9@!#$%^&*()-=+_ ]{1,}$/.test(value);
        },
        message : '请输入英文、数字或者字符'
    },
    xiaoshu:{
        validator : function(value){
            return /^(([1-9]+)|([0-9]+\.[0-9]{1,2}))$/.test(value);
        },
        message : '最多保留两位小数！'
    },
    ddPrice:{
        validator:function(value,param){
            if(/^[1-9]\d*$/.test(value)){
                return value >= param[0] && value <= param[1];
            }else{
                return false;
            }
        },
        message:'请输入1到100之间正整数'
    },
    jretailUpperLimit:{
        validator:function(value,param){
            if(/^[0-9]+([.]{1}[0-9]{1,2})?$/.test(value)){
                return parseFloat(value) > parseFloat(param[0]) && parseFloat(value) <= parseFloat(param[1]);
            }else{
                return false;
            }
        },
        message:'请输入0到100之间的最多俩位小数的数字'
    },
    rateCheck: {
        validator: function (value, param) {
            if (/^[0-9]+([.]{1}[0-9]{1,2})?$/.test(value)) {
                return parseFloat(value) > parseFloat(param[0]) && parseFloat(value) <= parseFloat(param[1]);
            } else {
                return false;
            }
        },
        message: '请输入0到1000之间的最多俩位小数的数字'
    },
    NotEqual: {
        validator: function (value, param) {
            return value != param;
        },
        message: '此项必选择'
    },
    validatePassword: {
        validator: function (value) {
            if (/^[0-9]*$/g.test(value) && value.length == 6) {
                return true;
            } else {
                return false;
            }
        },
        message: '请输入6位数字'
    },
    checkPw: {
        validator: function (value, param) {
            return value == $('' + param).val();
        },
        message: '输入错误'
    },
    /**
    * 本验证规则,与jquery.easyui绑定使用
    * 脱离使用参数2中的msg将不能正确显示
    */
    ajaxValidate:{
        /**
         *
         * @param value 验证对象的值
         * @param param 参数
         * @returns {boolean}
         * param:[
         *      0:url验证请求,
         *      1:alias传递到后台的别名,
         *      [2:{
         *          [params:['id']其他的参数],
         *          [msg:验证不通过时的消息]默认消息,输入值不符合验证规则,请修改
         *      }]非必选参数
         * ]
         */
        validator: function(value,param){
            var data={};
            data[param[1]]=value;
            if(param[2]){
                if(param[2]["params"]){
                    for(var key in param[2]["params"]){
                        //对easyui进行兼容,先按照ID作为选择器查找
                        var param_obj = $("#"+param[2]["params"][key]);
                        if(param_obj.length==0){//如果选择器未筛选元素
                            //把参数当做name筛选
                            param_obj = $("[name='"+param[2]["params"][key]+"']");
                        }else{//如果能找到对应元素则判断是easyui元素
                            if(param_obj.is("[texboxname]")){
                                //如果是,则找当前元素的兄弟节点的下一个中的有name属性的对象
                                param_obj = param_obj.next().find("[name]");
                            }//不是,则要找的对象就是它本身
                        }
                        if(param_obj.length>0){
                            data[param[2]["params"][key]]=param_obj.val();
                        }
                    }
                }
            }
            var resultJson= $.parseJSON($.ajax({url:param[0],dataType:"json",data:data,async:false,cache:false,type:"post"}).responseText);
            return resultJson.success == 0;
            return false
        },
        message: "输入值不符合验证规则,请修改"
    },
    validateStartDate :{
        validator: function (value) {
            var cronEndAt = $('#cronEndAt').datebox('getValue')
            if(cronEndAt){
                return value <= cronEndAt
            }else{
                return true;
            }
        },
        message:'生效日期不能大于结束日期'
    },
    validateEndDate :{
        validator: function (value) {
            var cronStartAt = $('#cronStartAt').datebox('getValue')
            if(cronStartAt){
                return value >= cronStartAt
            }else{
                return true;
            }
        },
        message:'结束日期不能小于生效日期'
    },
    goodsNameValid:{
        validator: function (value) {
            if(value == "美团外卖" || value == "饿了么外卖"){
                return false
            }else{
                return true;
            }
        },
        message:'商品名称不能为“美团外卖”或“饿了么外卖”'
    },
    goodsBarValid:{
        validator: function (value) {
            if(value == "美团外卖" || value == "饿了么外卖"){
                return false
            }else{
                return true;
            }
        },
        message:'商品名称不能为“美团外卖”或“饿了么外卖”'
    }

})