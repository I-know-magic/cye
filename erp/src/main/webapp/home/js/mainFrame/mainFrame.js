/**
 * 初始化首页的方法
 */
function initMaFrame(){
    //点击收缩菜单
    $("#phead1").click(function(){
        $("#showMenu").addClass("nav-s");
        $(".wrap").addClass("wrap-s");
        $(".wrap").find("header").addClass("wrap-s-header");
        $("#s1 #showMenu .txt").fadeOut();
        $("#s1 .nav").animate({
            width: "50px"
        },1000,function(){
            $("#phead2").fadeIn();
        });
        $(this).parents(".head-logo").fadeOut(1000);
        $("#ubox1").animate({
            height: "0px"
        },450);
        $("#ubox2").delay(450).fadeIn();
        $("#sys_menu li").attr("state","0");//记录菜单栏展开，收缩状态;0收缩
    });
    //点击展开菜单
    $("#phead2").click(function(){
        $(this).fadeOut(1000);
        $("#s1 #showMenu .txt").delay(450).fadeIn();
        $("#s1 .nav").animate({
            width: "100px"
        },1000,function(){
            $("#phead1").parents(".head-logo").fadeIn();
            $(".wrap").removeClass("wrap-s");
            $(".wrap").find("header").removeClass("wrap-s-header");
        });
        $("#ubox1").delay(450).animate({
            height: "192px"
        },450);
        $("#ubox2").fadeOut();
        $("#sys_menu li").attr("state","1");//记录菜单栏展开，收缩状态;1展开
    });
    //菜单点击事件
    $("#sys_menu li").click(function(){
        $(this).css({background:""});
        $(".nav-box .current").removeClass("current");
        $(this).addClass("current");
        if($(this).hasClass("not_menu")){
            var menu_txt=$(this).find(".txt");
            var menuUrl=$(this).attr("menu_url");
            if(menuUrl==null){
                $("#content").empty();
            }else{
                changeContent(menuUrl,function(){
                    if($(menu_txt).is(":hidden")){
                        $(".wrap").addClass("wrap-s");
                        $(".wrap").find("header").addClass("wrap-s-header");
                    }
                });
            }
        }
    });
    //菜单悬停事件
    $("#sys_menu li").hover(
        function(){
            var states = $(this).attr("state");
            var $second_menu = $(this).find(".secondary-menu");
            var $head_p = $second_menu.find("p");
            var $span = $second_menu.find("span");
            $("#sys_menu li").css({background:""});
            $(this).css({background:"#5c5c5c"});
            if(states == "1"){
                $head_p.hide();
                $span.css({width:"80%",padding:"0 20px"});
                $second_menu.css({top:'0px',left:"99px"});
                $second_menu.show();
            }
            if(states == "0"){
                if($head_p.is(":hidden")){
                    $head_p.show();
                }
                $span.css({width:"64%",padding:"0 36px"});
                $second_menu.css({top:'0px',left:"50px"});
                $second_menu.show();
            }
        },
        function(){
            $(this).css({background:""});
            $(this).find(".secondary-menu").hide();
        }
    );
    //二级菜单点击事件
    $(".secondary-menu span").bind("click",function(){
            $(".secondary-menu span").find("a").removeClass("secondary-menu_span_a");
            $(this).find("a").addClass("secondary-menu_span_a");
            var menuUrl=$(this).attr("menu_url");
            if(menuUrl==null){
                $("#content").empty();
            }else{
                changeContent(menuUrl);
            }
    });
    $("#ubox1 li").eq(0).click(function(){
        $("#ubox1").animate({
            height: "0px"
        },1000);
        $("#ubox2").delay(1000).fadeIn();
    });
    $("#ubox2").click(function(){
        $(this).fadeOut();
        $("#ubox1").delay(450).animate({
            height: "192px"
        },1000);
    });
    //初始化个人信息dialog
    $("#person_dialog").retailDialog({
        title:"个人信息",
        content:"person"
    });
    //点击个人信息 加载个人信息数据
    $(".person_msg").click(function(){
        getEmployeeMsg();
        var personName=$("#employeeName").data("person_name");
        $("#employeeName").attr("disabled",true);
        $("#person").find(".person_con").hide();
        $(".edit_person_name").css({"display":"inline-block"});
        $("#employeeName").val(personName);
        $("#person_dialog").retailDialog("open");
    });

    //绑定商户信息编辑事件
    $(".person_edit").click(function(){
        var _inputs=$(this).parents("form").find("input[type='text']").filter(":enabled");
        if(_inputs.length>0){
            $.message.alert("请结束编辑本行！");
            return
        }
        var p_span=$(this).prev("span");
        var _input=$(p_span).find("input");
        if($(_input).is(":disabled")){
            $(_input).attr("disabled",false);
            $(_input).data("tenantInfo",$(_input).val());
            $(this).next(".person_con").css({"display":"inline-block"});
            $(this).hide();
        }
    });
    //个人信息点击编辑事件
    $(".edit_person_name").click(function(){
        var name_value= $("#employeeName").val();
        $("#employeeName").data("person_name",name_value);
        var p_span=$(this).prev("span");
        var _input=$(p_span).find("input");
        if($(_input).is(":disabled")){
            $(_input).attr("disabled",false);
            $(this).next(".person_con").css({"display":"inline-block"});
            $(this).hide();
        }
    });
    //修改个人信息  确定方法
    $(".person_yes").click(function(){
        var employee_name = $("#employeeName").val();
        if(!(employee_name&&employee_name.length<=20)){
            $("#person").validateAlert("姓名不能为空，并且不超过20字符！");
            return;
        }
        var employee_sex = $("#user_sex").val();
        var employee_birthday = $("#user_birthday").val();
        $.post(editEmployeeMessage_url,{name:employee_name,sex:employee_sex,birthday:employee_birthday},function(data){
            if(data){
                if(data.success=="true"){
                    $("#employeeName").attr("disabled",true);
                    $(".person_yes").parent(".person_con").hide();
                    $(".edit_person_name").css({"display":"inline-block"});
                    $(".tenant_name").text(employee_name);
                    $.message.alert(data.msg);
                }else{
                    $.message.alert(data.msg);
                }
            }else{
                $.message.alert("非常抱歉，请求服务异常，请联系工作人员!");
            }

        },"json");
    });
    //取消修改个人信息
    $(".person_no").click(function(){
        var personName=$("#employeeName").data("person_name");
        $("#employeeName").attr("disabled",true);
        $(this).parent(".person_con").hide();
        $(".edit_person_name").css({"display":"inline-block"});
        $("#employeeName").val(personName);
    });

    //点击绑定手机号
    $("#bindPhone").click(function(){
        var _msg=$("#phoneMsg").val();
        if(!_msg){
            $("#person").validateAlert("请输入短信验证码");
            return
        }
        var _phone=$("#bindMobile").val();
        if(!_phone){
            $("#person").validateAlert("请输入手机号!");
            return
        }
        if(!(_phone.length==11)){
            $("#person").validateAlert("输入手机号格式不正确");
            return
        }
        $.post(bindMobile_url,{checkPhone:_phone,authCode:_msg},function(data){
            if(data){
                if(data.success=="true"){
                    $("#bindPhone").parent("p.phone_msg").prev("p").find("#bindMobile").attr("disabled",true);
                    $("#bindPhone").hide();
                    $("#unBindPhone").show();
                    $(".phone_msg").hide();
                    $("#msg_phone").hide();
                    $.message.alert("手机号绑定成功!")
                }else{
                    $.message.alert(data.msg);
                }
            }else{
                $.message.alert("非常抱歉，请求服务异常，请联系工作人员!");
            }
        },"json");

    });
    //点击发送短信
    $("#sentMsg").click(function(){
        var _phone=$("#bindMobile").val();
        if(!_phone){
            $("#person").validateAlert("请输入手机号!");

            return
        }
        if(!(_phone.length==11)){
            $("#person").validateAlert("输入手机号格式不正确");

            return
        }
        $.post(sentMsg_url,{phone:_phone},function(data){
            if(data){
                if(data.success=="true"){
                    $("#phoneMsg").attr("disabled",false);
                    $("#phoneMsg").attr("placeholder","请输入短信验证码");
                    $(".phone_msg").show();
                    $("#bindPhone").show();

                    setTime();
                }else{
                    $.message.alert(data.msg);
                }
            }else{
                $.message.alert("非常抱歉，请求服务异常，请联系工作人员!");
            }

        },"json");

    });
    $("#unBindPhone").click(function(){
        $.post(unBindPhone_url,null,function(data){
            if(data){
                if(data.success=="true"){
                    $("#unBindPhone").prevAll(".bind_phone_span").find("input").attr("disabled",false);
                    $("#unBindPhone").hide();
                    $("#sentMsg").show();
                    $.message.alert("解绑手机成功！")
                }else{
                    $.message.alert(data.msg);
                }
            }else{
                $.message.alert("非常抱歉，请求服务异常，请联系工作人员!");
            }

        },"json");
    });
    //初始化商户信息dialog
    $("#tenantDialog").retailDialog({
        title:"商户信息",
        content:"tenantForm"
    });
    //点击打开商户信息
    $(".tenant_msg").click(function(){
        getTenantMsg();
        $("#tenantForm").find("input[type!='file']").attr("disabled",true);
        $("#tenantForm").find(".person_con").hide();
        $("#tenantForm").find(".person_edit").filter(":hidden").css({"display":"inline-block"});
        $("#tenantDialog").retailDialog("open");
    });
    //商户信息点击取消按钮
    $(".tenant_cancel").click(function(){
        var _input=$(this).parent(".person_con").prevAll(".input_span").find("input");
        var _person_edit=$(this).parent(".person_con").prev();
        $(_input).val($(_input).data("tenantInfo"));
        $(_input).attr("disabled",true);
        $(this).parent(".person_con").hide();
        $(_person_edit).css({"display":"inline-block"});
    });
    //点击图片上传
    $(".upload_logo").click(function(){
        $("#logoImg").click();
    });

    //点击打开密码修改
    $(".pwd_msg").click(function(){
        $(".pwd_dialog").show();
    });
    $(".pwd_dialog .close").click(function(){
        $("#oldPwd").val("");
        $("#newPwd1").val("");
        $("#newPwd2").val("");
        $(".pwd_dialog").hide();
        if($(".pwd_dialog").find("#error-box") && $(".pwd_dialog").find("#error-box").length>0 ){
            $(".pwd_dialog").find("#error-box").remove();
        }
    });
    $(".pwd_dialog .save").click(function(){
        var oldPwd=$("#oldPwd").val();
        var newPwd1=$("#newPwd1").val();
        var newPwd2=$("#newPwd2").val();
        /*passReg=/[0-9A-Za-z]{6,20}/改为passReg=/^[0-9A-Za-z]{6,20}$/
        author：genghui*/
        var passReg=/^[0-9A-Za-z]{6,20}$/;
        if(!passReg.test(oldPwd)){
            $("#pwdForm").validateAlert("请输入正确的原始密码！");
            return;
        }
        if(!passReg.test(newPwd1)){
            $("#pwdForm").validateAlert("请输入6-20位的数字与字母组合的新密码！");
            return;
        }
        if(!passReg.test(newPwd2)){
            $("#pwdForm").validateAlert("请确认6-20位的数字与字母组合的新密码！");
            return;
        }
        if(newPwd1!=newPwd2){
            $("#pwdForm").validateAlert("两次输入的新密码不一致！");
            return;
        }
        $.post(pwd_url,{oldPass:oldPwd,newPass:newPwd2},function (data){
            if(data["success"]=="false"){
                $.message.alert("请输入正确的原始密码！");
            }else{
                $.message.alert("密码修改成功！");
                $("#oldPwd").val("");
                $("#newPwd1").val("");
                $("#newPwd2").val("");
                $(".pwd_dialog").hide();
                if($(".pwd_dialog").find("#error-box") && $(".pwd_dialog").find("#error-box").length>0 ){
                    $(".pwd_dialog").find("#error-box").remove();
                }
            }
        },'json')
    });
}

/**
 * 格式化用户角色
 * @param type
 */
function getUserType(type){
    var type_val=[1,2,3,4,5,6];
    var type_name=["商户","代理商","商户员工","营运人员","维护人员","顾客"];
    for(var k in type_val){
        if(type==type_val[k]){
            return type_name[k];
        }
    }
}
/**
 *格式化业态
 * @param business
 */
function getBusiness(business){
    var bus_value=[1,2];
    var bus_name=["餐饮","零售"];
    for(var k in bus_value){
        if(business==bus_value[k]){
            return bus_name[k];
        }
    }
}


/**
 * 60s倒计时获取验证码
 * @type {number}
 */
var countdown=60;
function setTime(p) {
    if(p){
        return false;
    }
    if (countdown == 0) {
        $("#sentMsg").show();
        $("#timeOut").hide();
        countdown = 60;
        return;
    } else {
        $("#sentMsg").hide();
        $("#timeOut").show();
        countdown--;
        $("#mins").text(countdown);
    }
    setTimeout(function() {
        setTime()
    },1000)
}
/**
 * 查询个人信息
 */
function getEmployeeMsg(){
    $.get(getEmployeeMessage_url,null,function(data){
        if(data){
            if(data.result=="SUCCESS"){
                var employee=data.data.employee;
                var user    =data.data.user;
                $(".tenant_name").text(user["name"]);
                $("#employeeName").val(user["name"]);
                $("#userType").val(getUserType(user["userType"]));
                $("#userCode").val(employee["code"]);
                $("#user_sex").val(employee["sex"]);
                $("#user_birthday").val(employee["birthday"]);
                if(user["bindMobile"]){
                    $("#sentMsg").hide();
                    $("#bindMobile").val(user["bindMobile"]);
                }else{
                    $("#bindMobile").attr("disabled",false);
                    $("#bindMobile").attr("placeholder","暂无绑定手机号");
                    $("#unBindPhone").hide();
                    $("#sentMsg").show();
                }
            }else{
                $.message.alert(data.msg);
            }
        }else{
            $.message.alert("非常抱歉，请求服务异常，请联系工作人员!");
        }

    },"json");
}

function getTenantMsg(){
    $.get(getTenantMessage_url,null,function(data){
        if(data){
            var tenantVo=data;
            $(".tenant_Code").text(tenantVo["code"]);
            for(var k in tenantVo){
                var _value=tenantVo[k];
                if(k=="business1"){
                    _value=getBusiness(_value);
                }
                if(_value=="" || _value==null){
                    _value="";
                }
                if(k=="imgUrl" && _value!=""){
                    $("#upload_logo").hide();
                    $("#logo_img").show();
                    $("#logo_img").attr("src",visitDomain+_value);
                }
                $("#tenantForm").find("input[name='"+k+"']").val(_value);
            }

        }
    },"json");
}

function checkPwd(){
    var oldPwd=$("#oldPwd").val();
    var newPwd1=$("#newPwd1").val();
    var newPwd2=$("#newPwd2").val();
    if(oldPwd==""){
        $.message.alert("请输入原始密码！");
        return;
    }
    if(newPwd1==""){
        $.message.alert("请输入新密码！");
        return;
    }
    if(newPwd2==""){
        $.message.alert("请确认新密码！");
        return;
    }
}