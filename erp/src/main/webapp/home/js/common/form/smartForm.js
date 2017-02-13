/**
 * Created by LiuJie on 2016/2/26.
 */
;String.prototype.replaceAll = function(reallyDo, replaceWith) {
    return this.replace(new RegExp(reallyDo, ("gm")), replaceWith);
};
;(function($){
    $.fn.extend({
        form:function(param,options){
            var this_form=this.selector;
            var params={
                url:'',
                data:'',
                data_type:'json',
                queryParams:{},//需要传入后台的额外参数
                onSubmit:null,
                onSuccess:null,//提交表单成功函数
                onError:null,//提交表单失败函数
                onLoadSuccess:null,//加载表单数据成功函数
                onLoadError:null//加载表单失败函数
            };
            params= $.extend(params,options);
            if(typeof (param)=="string"){
                //表单提交
                if(param=="submit"){
                    $.retailForm.submitForm(this_form,params);
                }
                //表单加载远程服务器数据
                if(param=="load"){
                    $.retailForm.loadForm(this_form,params);
                }
                //清除表单数据
                if(param=="clear"){
                    $.retailForm.clearForm(this_form);
                }
                //重置表单元素
                if(param=="reset"){
                    $.retailForm.resetForm(this_form);
                }
            }
        },
        /**
         * 表单校验
         * @param fn 表单校验成功后执行的函数
         */
        validation:function(fn){
            var _form=this.selector;
            if($.isFunction(fn)){
                var fields=$(_form).find("[validate]");//获取需要校验的input
                for(var i=0;i<fields.length;i++){
                    var rules=$(fields[i]).attr("validate").split(",");//获取当前input的校验的规则
                    var _value=$(fields[i]).val();//获取当前input的值
                    var _valid_name = $(fields[i]).attr("filed-role");
                    for(var j=0;j<rules.length;j++){
                        var rule=rules[j].split("[");
                        var rule_name;//规则名称
                        var rule_params=[];//需要传入的规则的参数
                        if(rule.length>1){
                            var r_array;
                            var p_array = [];
                            rule_name=rule[0];
                            r_array=rule[1].split("]");
                            if(r_array[0].indexOf(";")!=-1){
                                p_array = r_array[0].split(";");
                                if(p_array && p_array.length>0){
                                    for(var p in p_array){
                                        rule_params.push(parseFloat(p_array[p]).toFixed(2));
                                    }
                                }
                            }else{
                                var _p=parseInt(r_array[0]);
                                rule_params.push(_p);
                            }

                        }else{
                            rule_name=rule[0];
                        }
                        var validate_rule=$validateRules[rule_name];//获取校验规则
                        if(validate_rule&&validate_rule.validator){
                            var validate_fn=validate_rule.validator;
                            var result;
                            if(rule_params.length>0){
                                result = validate_fn(_value,rule_params);
                            }else{
                                result = validate_fn(_value);
                            }
                            if(!result){
                                var msg=validate_rule.message;
                                var _message;
                                if(msg.indexOf("]")!=-1){
                                    var msg_rs = msg.split("]");
                                    if(msg_rs && msg_rs.length>0){
                                        if(msg_rs[1]){
                                            _message = _valid_name+msg_rs[1];
                                        }else{
                                            _message = _valid_name+msg_rs[0];
                                        }
                                    }
                                }
                                if(msg.indexOf("}")!=-1){
                                    _message = msg;
                                    for(var k in rule_params){
                                        _message = _message.replaceAll("\\{"+k+"\\}",rule_params[k]);
                                    }
                                    _message = _valid_name+_message;
                                }
                                if($(_form).parent("div.dialog_box_body").length>0 && $(_form).parent("div.dialog_box_body").find("#error-box").length==0){
                                        $("body").find("div.dialog_box_body").append($.validateTemplate);
                                        $("#error-box").css({"position":"absolute","left":"-1px","top":"0px"});
                                        $("#error-box").find("p").css({"height":"30px","line-height":"30px"});
                                }else{
                                    $("body").find("div.wrap").append($.validateTemplate);
                                    $("#error-box").css({"width":"92.8%","top":"129px"});
                                }
                                $("#error-box").show();
                                $("#content-box").text(_message);
                                setTimeout(function(){
                                    if($("#error-box").is(":visible")){
                                        $("#error-box").hide();
                                    }
                                },3000);

                                //$.message.alert(_message);
                                return;
                            }
                        }
                    }
                }
                fn();
            }else{
                alert("传入参数不合法!");
            }
        },
        validateAlert:function(msg,fn){
            var _form=this.selector;
                var $error_box = $(_form).parent("div.dialog_box_body").find("#error-box");
                var $dialog_box = $(_form).parent("div.dialog_box_body");
                if($dialog_box.length>0 && $error_box.length==0){
                    $dialog_box.append($.validateTemplate);
                    var $_error_box = $(_form).parent("div.dialog_box_body").find("#error-box");
                    $_error_box.css({"position":"absolute","left":"-1px","top":"0px","z-index":"9999"});
                    $_error_box.find("p").css({"height":"30px","line-height":"30px"});
                    $_error_box.show();
                    $_error_box.find("#content-box").text(msg);
                }else{
                    $error_box.show();
                    $error_box.find("#content-box").text(msg);
                }

                setTimeout(function(){
                    if($("#error-box").is(":visible")){
                        $("#error-box").hide();
                    }
                },3000);
        }


    });
    $.extend({
        validateTemplate:'<div class="error-box" id="error-box" style="width: 100%;display: none">'
                            +'<p>'
                            +'<i class="error-box-icon">!</i>'
                            +'<span id="content-box"></span>'
                            +'</p>'
                            +'</div>',
        retailForm:{
            submitForm:function(form,p){
                if($(form).data("disabled_submit_form")){
                    return $.message.alert("请不要重复提交表单！")
                }
                $(form).data("disabled_submit_form",true);

                $.ajax({
                   url:p.url,
                   type:"POST",
                   dataType: p.data_type,
                   data:$(form).serialize(),
                   async:true,
                   success:function(data){
                       $(form).data("disabled_submit_form",false);
                         if(data){
                              if($.isFunction(p.onSuccess)){
                                   p.onSuccess(data);
                              }
                         }else{
                              if($.isFunction(p.onError)){
                                 p.onError();
                              }
                         }
                   },
                   error:function(XMLHttpRequest, textStatus, errorThrown){
                       $(form).data("disabled_submit_form",false);
                       console.log("异步提交表单异常:"+textStatus);
                   }
                });
            },
            clearForm:function(form){
                var inputs=$(form).find("input");
                for(var i=0;i<inputs.length;i++){
                        $(inputs[i]).val("");
                }
            },
            loadForm:function(form,p){
                $.ajax({
                    url:p.url,
                    type:"POST",
                    dataType: p.data_type,
                    data: p.queryParams,
                    async:true,
                    success:function(data){
                        if(data){
                            if($.isFunction(p.onSuccess)){
                                p.onSuccess();
                            }
                        }else{
                            if($.isFunction(p.onError)){
                                p.onError();
                            }
                        }
                    },
                    error:function(XMLHttpRequest, textStatus, errorThrown){
                        console.log("异步提交表单异常:"+textStatus);
                    }
                });
            },
            resetForm:function(form){
                    var resetTem='<input type="reset" id="reset_form" style="display: none">';
                    var reset_input=$(form).find("#reset_form");
                    if(reset_input.length>0){
                        $("#reset_form").trigger("click");
                    }else{
                        $(form).append(resetTem);
                        $("#reset_form").trigger("click");
                    }
            }
        }

    })
})(jQuery);
