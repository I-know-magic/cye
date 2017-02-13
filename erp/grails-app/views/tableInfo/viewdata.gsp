<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>桌台实时信息</title>
    <style type="text/css">
    .title {
        width: 120px;
    }

    .search-width {
        width: 220px;
        width: 226px \9;
    }

    .search-txt-width {
        width: 170px;
    }
    </style>
    <script type="text/javascript">
        var orderTable;
        %{--var areaId =${areaId};--}%
        %{--var backUrl =${backUrl};--}%
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"});
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="tableInfo" action="list" base=".." />" );
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            };
            orderTable.mainEasyUIJs();
        });

        function doSearch() {
            $("#mainGrid").datagrid({
                queryParams: {
                    codeName: $("#queryStr").val(),
                    areaId:$("#hidden_areaId").val()

                }
            });
        }
        function clearSearch() {
            $("#queryStr").val("");
        }
        function cleardata() {
            formclear("myForm")
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

    </ul>

    <p class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入编码或名称查询"
               class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
                <th data-options="field:'areaId'">区域id</th>
                <th data-options="field:'areaName'">区域名称</th>
                <th data-options="field:'name'">桌台名称</th>
                <th data-options="field:'state'">状态</th>
                <th data-options="field:'submitTime'">时间</th>
                <th data-options="field:'billSeqNo'">账单号</th>
                %{--<th data-options="field:'branchId'">门店</th>--}%

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                    <input type="hidden" name="areaId" id="areaId"/>
                    %{--<tr>--}%
                        %{--<td class="title">:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="areaId" data-options="required:true"/></td>--}%
                    %{--</tr>--}%
                    <tr>
                        <td class="title">区域名称:</td>
                        <td><input class="easyui-textbox" type="text" name="areaName" id="areaName" readonly="readonly"/></td>
                    </tr>
                    <tr>
                        <td class="title">名称:</td>
                        <td><input class="easyui-textbox" type="text" name="name" data-options="required:true"/></td>
                    </tr>
                    %{--<tr>--}%
                        %{--<td class="title">状态:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="state" data-options="required:true"/></td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">时间:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="submitTime" data-options="required:true"/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">账单号:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="billSeqNo" data-options="required:true"/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    %{--<tr>--}%
                        %{--<td class="title">:</td>--}%
                        %{--<td><input class="easyui-textbox" type="text" name="branchId" data-options="required:true"/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%


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

