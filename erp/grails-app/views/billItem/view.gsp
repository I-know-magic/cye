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

    <title>菜品销售统计</title>
    <style type="text/css">
    .title {
        width: 120px;
    }
    .search-width{
        width: 220px;width: 226px \9;
    }
    .search-txt-width{
        width: 170px;
    }

    .search-date {
        right: 240px;
        font-size: 11px;
        color: #979a9b;
        top: 4px;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="billItem" action="list" base=".." />");
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.showFooter = true;
            orderTable.page_size = 100;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            };
            orderTable.mainEasyUIJs();

            dateTimePicker = new dateTimePicker({
                container: $('#dateTimeRangeBox'),
                defaultDateTime: [$.dateFormat(new Date, "yyyy-MM-dd") + ' 00:00', $.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59']
            });
        });

        function myAdd() {
            orderTable.mainAdd("<g:createLink  base=".." controller="billItem" action="create"/>", "-增加");
            orderTable.formAction = "<g:createLink  base=".." controller="billItem" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink  base=".." controller="billItem" action="edit"  />", "-修改", id);
            orderTable.formAction = "<g:createLink  base=".." controller="billItem" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink  base=".." controller="billItem" action="delete"  />");
        }
        function doSearch() {
            var startTime = $("input[id*='begin']").val();
            var endTime = $("input[id*='end']").val();
            $("#mainGrid").datagrid({
                queryParams: {
                    codeName: $("#queryStr").val(),
                    startDate: startTime,
                    endDate: endTime
                }
            });
        }
        function clearSearch() {
            $("#queryStr").val("");
        }
        function cleardata() {
            formclear("myForm")
        }
        function exportExcel(e, url) {
            $.messager.alert("系统提示", "正在导出,请稍后查看导出文件！", "warning");
            var startTime = $("input[id*='begin']").val();
            var endTime = $("input[id*='end']").val();
            ban_bubbling(e);
            window.location.href = url + '?codeName=' + $("#queryStr").val()+'&startDate='+startTime+'&endDate='+endTime;

        }
    </script>
</head>

<body>
<h3 class="rel ovf  js_header">
    <span></span>
    -
    <span></span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li class="icon daochu "
            onclick="exportExcel(event, '<g:createLink base=".." controller="billItem" action="exportExcel"  />')">导出</li>
        %{--<li class="icon alt class_branch_op" onclick="edit()">修 改</li>--}%
        %{--<li class="icon del class_branch_op" onclick="del()">删 除</li>--}%
    </ul>

    <p class="search-date search-date-position abs"><a id="dateTimeRangeBox"></a></p>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入类别查询" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id'">
            <thead>
            <th data-options="field:'itemId'" hidden="hidden"></th>
            <th data-options="field:'categoryId'" hidden="hidden"></th>
            <th data-options="field:'catName',width:120">类别</th>
            <th data-options="field:'goodsName',width:120">品名</th>
            <th data-options="field:'taste',width:500">口味</th>
            <th data-options="field:'price'">价格</th>
            <th data-options="field:'qty'">数量</th>
            <th data-options="field:'sum'">金额</th>
            %{--<th data-options="field:'sendQty'"></th>--}%
            %{----}%
            %{----}%

            %{--<th data-options="field:'memo'"></th>--}%
            %{--<th data-options="field:'addTime'"></th>--}%
            %{--<th data-options="field:'submitTime'"></th>--}%
            %{--<th data-options="field:'confirmTime'"></th>--}%
            %{--<th data-options="field:'cancelTime'"></th>--}%
            %{--<th data-options="field:'printTime'"></th>--}%
            %{--<th data-options="field:'sendTime'"></th>--}%
            %{--<th data-options="field:'state'"></th>--}%
            %{--<th data-options="field:'seqNo'"></th>--}%
            %{--<th data-options="field:'branchId'"></th>--}%
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
                        <td><input class="easyui-textbox" type="text" name="billId" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="billSeqNo" data-options="required:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="itemId" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="qty" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="sendQty" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="price" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="sum" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="taste" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="memo" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="addTime" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="submitTime" data-options="required:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="confirmTime" data-options="required:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="cancelTime" data-options="required:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="printTime" data-options="required:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="sendTime" data-options="required:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="state" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="seqNo" data-options="required:true"/></td>
                    </tr>
                    <tr>
                        <td class="title">:</td>
                        <td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/>
                        </td>
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
            <a href="javascript:void(0)" id="sub" class="easyui-linkbutton" iconCls="icon-ok"
               onclick="orderTable.mainSave()">保存</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
               onclick="orderTable.mainClose()">取消</a>
        </div>
    </div>
</div>
</body>
</html>

