<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/10/24
  Time: 16:34
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>完善商户信息</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'init/init.css', base: '..')}" type="text/css">
    <link type="text/css" rel="stylesheet" href="${resource(dir:'js', file:'artDialog/css/ui-dialog.css', base:'..')}"/>
    <script type="text/javascript" src="${resource(dir:'js',file: 'artDialog/dist/dialog.js', base:'..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file: 'common/commonExt.js', base:'..')}"></script>

    <script type="text/javascript">
        var businessId;
        var provinceId;
        var cityId;
        var countryId;
        var addressDetail;
        var type = "${type}";
        var sessionId = "${sessionId}";
        $(function () {
            initBusiness();
            initArea();
            if("${addressDetail}"){
                $("#addressDetail").val("${addressDetail}");
            }
        });
        function selectValue(sId,value){
                var s = document.getElementById(sId);
                var ops = s.options;
                for(var i=0;i<ops.length; i++){
                        var tempValue = ops[i].value;
                        if(tempValue == value)
                            {
                                ops[i].selected = true;
                            }
                    }
            }

        function initBusiness(){
                $.get('${resource(dir:'easyui',file:'business.json',base: '..')}',function(data){
                    var result2;
                    if(type == 1){
                        result2 = data[0].children;
                    }else if(type == 2){
                        result2 = data[1].children;
                    }
                    var selectBusiness2 = $("#business2");
                    document.getElementById("business2").disabled = 'false';//二级业态不可选,默认为小吃快餐
//                    var result2 = data[0].children;
                    $.each(result2,function(index,value){
                        if(index == 0){//只显示小吃快餐
                            $("<option value='" + value.code + "' >" +value.name + "</option>").appendTo(selectBusiness2);
                        }
                    });
                    var selectBusiness3 = $("#business3");
                    var result3 = result2[0].children;
                    $("<option value='" + "00000" + "'>" + "--请选择--" + "</option>").appendTo(selectBusiness3);
                    $.each(result3,function(index,value){
                        $("<option value='" + value.code + "'>" +value.name + "</option>").appendTo(selectBusiness3);
                    });
                    if("${businessId}"!=""){
                        selectValue('business3',"${businessId}");
                    }
                },'json');
        }
        function initArea(){
            $.post('<g:createLink base=".." controller='district' action='qryDistrictByPid'/>?pId=0',function(data){
                var provinceSelector = $("#province");
                $("<option value='" + "000000" + "'>" + "--请选择--" + "</option>").appendTo(provinceSelector);
                $.each(data, function(index, value) {
                        $("<option value='" + value.id + "'>" + value.name + "</option>").appendTo(provinceSelector);
                });
                var citySelector = $("#city");
                var countySelector = $("#country");
                if("${provinceId}"!=""){
                    $.post('<g:createLink base=".." controller='district' action='qryDistrictByPid'/>?pId='+"${provinceId}",function(data){
                        $.each(data,function(index,value){
                            $("<option value='" + value.id + "'>" + value.name + "</option>").appendTo(citySelector);
                        });

                    });
                    $.post('<g:createLink base=".." controller='district' action='qryDistrictByPid'/>?pId='+"${cityId}",function(data){
                        $.each(data,function(index,value){
                            $("<option value='" + value.id + "'>" + value.name + "</option>").appendTo(countySelector);
                        });

                    });
                    selectValue('province',"${provinceId}");
                    selectValue('city',"${cityId}");
                    selectValue('country',"${countryId}")
                }else{

                    $("<option value='" + "000000" + "'>" + "--请选择--" + "</option>").appendTo(citySelector);

                    $("<option value='" + "000000" + "'>" + "--请选择--" + "</option>").appendTo(countySelector);
                }

            });
        }
        function changeProvince(provinceId) {
            $.post('<g:createLink base=".." controller='district' action='qryDistrictByPid'/>?pId='+provinceId,function(data){
                var citySelector = $("#city");
                citySelector.empty();
                var cityId;
                $.each(data, function(index, value) {
                    if(index == 0){
                        cityId = value.id
                    }
                    $("<option value='" + value.id + "'>" + value.name + "</option>").appendTo(citySelector);
                });
                changeCity(cityId);
            });
        }
        function changeCity(cityId) {
            $.post('<g:createLink base=".." controller='district' action='qryDistrictByPid'/>?pId='+cityId,function(data){
                var countySelector = $("#country");
                countySelector.empty();
                $.each(data, function(index, value) {
                    $("<option value='" + value.id + "'>" + value.name + "</option>").appendTo(countySelector);
                });
            });
        }
        function next(){
            if($("#business3").val() == "00000"){
                msgDialog("请选择行业！");
                return
            }
            if($("#province").val() == "000000"){
               msgDialog("请选择地区！");
                return
            }
            if($("#addressDetail").val() == ""){
                msgDialog("请填写详细地址！");
                return
            }
            if($("#addressDetail").val().length > 100){
                msgDialog("长度不超过100个汉字或字符！");
                return
            }

            var businessIndex = document.getElementById("business3").selectedIndex;
            businessId = document.getElementById("business3").options[businessIndex].value;
            var provinceIndex = document.getElementById("province").selectedIndex;
            provinceId =document.getElementById("province").options[provinceIndex].value;
            var cityIndex = document.getElementById("city").selectedIndex;
            cityId =document.getElementById("city").options[cityIndex].value;
            var countryIndex = document.getElementById("country").selectedIndex;
            countryId =document.getElementById("country").options[countryIndex].value;
            addressDetail = $("#addressDetail").val();
            location.replace("<g:createLink base=".." controller='mainFrame' action='initCategory'/>?businessId="+businessId+"&provinceId="+provinceId+"&countryId="
            +countryId+"&cityId="+cityId+"&addressDetail="+addressDetail+"&type="+type+"&sessionId="+sessionId)
        }
    </script>
</head>

<body>
<div class="wrap">
    <h2 class="logo rel clearfix">
        <img class="fl" src="${resource(dir: 'css', file: 'mainFrame/img/logo.png', base: '..')}">
        <span class="abs">初始化设置</span>
    </h2>

    <div class="step">
        <ul class="clearfix">
            <li class="current">
                <p class="rel line line-l">
                    <span class="abs">1</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">完善商户信息</p>
            </li>
            <li class="">
                <p class="rel line">
                    <span class="abs">2</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">菜品分类</p>
            </li>
            <li class="">
                <p class="rel line">
                    <span class="abs">3</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">菜品单位</p>
            </li>
            <li class="">
                <p class="rel line line-r">
                    <span class="abs">4</span>
                    <i class="abs"></i>
                </p>

                <p class="txt">菜品口味</p>
            </li>
        </ul>
    </div>

    <div class="monitor">
        <p class="mon-txt">
            <span>行业：</span>
            <select name="business2" id="business2">
                %{--<option></option>--}%
            </select>
            <select name="business3" id="business3">
                %{--<option></option>--}%
            </select>
        </p>

        <p class="mon-txt area-mon-txt rel">
            <span>地区：</span>
            <select name="" id="province" onchange="changeProvince(this.value)">
            </select>
            <select name="" id="city" onchange="changeCity(this.value)">
            </select>
            <select name="" id="country">
            </select>
            <span class="abs area-abs">请填写真实的区域和地址信息，您将可以获得完善的售后服务保障。</span>
        </p>

        <p class="mon-txt clearfix">
            <span class="fl">详细地址：</span>
            <textarea class="fl" name="addressDetail" id="addressDetail" autocomplete="off" role="combobox"
                      aria-combobox="list"></textarea>
        </p>

        <p class="button">
            <input type="button" class="btn" value="下一步" onclick="next()">
        </p>
    </div>

    <div class="copy-bottom">
        <p>Copyright © 2015 智汇方象（青岛）软件有限公司 鲁ICP备15025493号</p>
    </div>
</div>
</body>
</html>