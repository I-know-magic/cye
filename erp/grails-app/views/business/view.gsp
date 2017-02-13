<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="${resource(dir: 'js', file: 'datePicker/jquery-ui-timepicker.css', base: '..')}"
          type="text/css">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'datePicker/jquery-ui.js', base: '..')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'datePicker/jquery-ui-timepicker-addon.js', base: '..')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'datePicker/ftrend.datepicker.js', base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'store/storeQuery.js', base: '..')}"></script>

    <title>好评统计</title>
    <style type="text/css">
    .title {
        width: 120px;
    }
    .search-width{
        width: 220px;width: 226px \9;
    }
    .search-txt-width{
        width: 100px;
    }
    .search-txt-width-cat{
        width: 50px;
    }
    .search-date-position-r {
        right: 340px;
    }
    .search-cat-position-r {
        right: 842px;
    }
    .search-date-position {
        right: 595px;
    }
    .p-search-width {
        width: 60px;
        width: 60px \9;
        right: 15px;
    }

    .search-date-style {
        right: 340px;
    }

    .search-branch-style {
        right: 80px;
    }

    .search-last-btn {
        right: 30px;
        width: 140px;
    }

    .branch-right {
        right: 350px;
    }

    .search-width-branch {
        width: 220px;
    }

    .search-btn {
        height: 34px;
        right: 5px;
        top: 2px;
    }

    .search {
        height: 34px;
        top: 1px;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
            dateTimePicker = new dateTimePicker({
                container: $('#dateTimeRangeBox'),
                defaultDateTime: [$.dateFormat(new Date, "yyyy-MM-dd") + ' 00:00', $.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59']
            });
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="businessCount" action="list"  />");
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            orderTable.mainEasyUIJs();
            loadBoxData('cusid', '<g:createLink base=".." controller="tabCustomerInfo" action="queryCusBox"/>', 'customercompany');
            loadBoxData('catid', '<g:createLink base=".." controller="category" action="queryCusBox"/>', 'catName');
        });
        function loadBoxData(id, url, textField, update) {
            $('#' + id).combobox({
                editable: false,
                valueField: 'id',
                textField: textField,
                panelHeight: 230,
                url: url,
                onLoadSuccess: function (rec) {
                    if (!update) {
                        $('#' + id).combobox("select", rec[1].id);
                    }
                }
            });
        }
        function doSearch() {
            var startTime = $("input[id*='begin']").val();
            var endTime = $("input[id*='end']").val();
            var val1 = $('#cusid').combobox('getValue');
            var val2 = $('#catid').combobox('getValue');
            var datatype = $('#datatype').combobox('getValue');
//            alert(val1);
//            if(!val1){
//                $.messager.alert("系统提示", "请选择客户！", "info");
//                return;
//            }
            $("#mainGrid").datagrid({
                queryParams: {
                    codeName: val1,
                    catid: val2,
                    datatype: datatype,
                    startDate: startTime,
                    endDate: endTime,
                }
            });
        }
        function clearSearch(){
            $("#queryStr").val("");
        }
        function cleardata() {
            formclear("myForm")
        }
        function ordercustomerconfirm(value) {
            if (value == 0) {
                return "未签收";
            }
            if (value == 1) {
                return "已签收";
            }

        }
        function ordercustomergood(value) {
            if (value == 0) {
                return "未评价";
            }
            if (value == 1) {
                return "1星";
            }
            if (value == 2) {
                return "2星";
            }
            if (value == 3) {
                return "3星";
            }
            if (value == 4) {
                return "4星";
            }
            if (value == 5) {
                return "5星";
            }
        }

    </script>
</head>

<body>
%{--<h3 class="rel ovf  js_header">--}%
%{--<span></span>--}%
%{-----}%
%{--<span></span>--}%
%{--</h3>--}%

<div class="rel clearfix function-btn">
    %{--<ul class="boxtab-btn abs">--}%
    %{--<li  class="icon add class_branch_op" onclick="myAdd()">增 加</li>--}%
    %{--<li  class="icon alt class_branch_op" onclick="edit()">修 改</li>--}%
    %{--<li  class="icon del class_branch_op" onclick="del()">删 除</li>--}%
    %{--</ul>--}%
    %{--<p class="search-date-style abs">--}%
    %{--<a id="dateTimeRangeBox"></a>--}%
    %{--</p>--}%
    <p class="search-date search-date-position abs"><a id="dateTimeRangeBox"></a></p>
    <p class="search-cat-position-r abs">
        <select id="catid" name="id" data-options="required:true" class="search-txt search-txt-width-cat" ></select>
    </p>
    <p class="search-date-position-r abs">
        <select class="easyui-combobox" name="datatype" id="datatype" panelHeight="auto" editable="false">
        <option value="0">请选择</option>
        <option value="1">年</option>
        <option value="2">月</option>
    </select></p>
    <p class="search-branch-style abs">
        <select id="cusid" name="id" data-options="required:true" class="search-txt search-txt-width" ></select>
    </p>

    <p class="search abs   search-pos-table p-search-width">
        <input type="button" onclick="doSearch()" class="search-btn icon  abs  js_enterSearch">
    </p>
    %{--<p class="search-date search-date-position abs"><a id="dateTimeRangeBox"></a></p>--}%
    %{--<i class="srh-close icon abs" onclick="clearSearch()"></i>--}%
    %{--<p  class="search search-width abs">--}%
        %{--<select id="cardriverid" name="cardriverid" data-options="required:true" class="search-txt search-txt-width" ></select>--}%
        %{--<input type="hidden" id="queryStr" name="queryStr" placeholder="输入驾驶员查询" class="search-txt search-txt-width abs  js_isFocus">--}%
        %{--<input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">--}%
        %{--<i class="srh-close icon abs" onclick="clearSearch()"></i>--}%
    %{--</p>--}%
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
            <th data-options="field:'customercompany'">客户名称</th>
            <th data-options="field:'catName'">货物名称</th>
            <th data-options="field:'ordergoodsnum'">出货量</th>
            %{--<th data-options="field:'avgnum'">评价率</th>--}%
            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="carid" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">报警状态</td>1-驶入  2-驶出 3-超速 4-路线偏离:
                        <td><input class="easyui-textbox" type="text" name="waringtype" data-options="required:true"/></td>
                    </tr>


                    %{-- 实例
                    <td class="title"><div style="width: 124px;">单位编码:</div></td>--}%
                    %{--<td>--}%
                    %{--<input class="easyui-textbox" type="text" name="unitCode" readonly="readonly"/>--}%
                    %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                    %{--<td class="title">单位名称:</td>--}%
                    %{--<td><input class="easyui-textbox" type="text" name="unitName"--}%
                    %{--data-options="required:true,validType:'length[1,10]',missingMessage:'单位名称为必填项',invalidMessage:'长度不超过10个汉字或字符！'"/></td>--}%
                    %{--</tr>--}%
                </table>
            </form>
        </div>

        <div id="infoWindow-buttons">
            <a  href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok"
                onclick="orderTable.mainSave()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
    </div>
</div>
</body>
</html>

