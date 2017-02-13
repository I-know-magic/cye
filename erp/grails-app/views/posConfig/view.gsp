<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>pos参数设置</title>
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
    </style>
    <script type="text/javascript">
        var orderTable;
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="posConfig" action="list"  />");
            orderTable.singleSelect = true;
            orderTable.window = $("#editWindow");
            orderTable.form = $("#editForm");
            orderTable.pagination = true;
            orderTable.loadSuccess = function (data) {
                if (data.rows == 0) {
                }
            }
            orderTable.mainEasyUIJs();
        });

        function myAdd() {
            orderTable.mainAdd("<g:createLink controller="posConfig" action="create"/>","pos参数设置-增加");
            orderTable.formAction = "<g:createLink controller="posConfig" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="posConfig" action="edit"  />", "pos参数设置-修改", id);
            orderTable.formAction = "<g:createLink controller="posConfig" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink controller="posConfig" action="delete"  />");
        }
        function doSearch() {
        $("#mainGrid").datagrid({
                queryParams: {
                    codeName: $("#queryStr").val()
                }
            });
        }
        function clearSearch(){
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
        <li  class="icon add class_branch_op" onclick="myAdd()">增 加</li>
        <li  class="icon alt class_branch_op" onclick="edit()">修 改</li>
        <li  class="icon del class_branch_op" onclick="del()">删 除</li>
    </ul>

    <p  class="search search-width abs">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入编码或名称查询" class="search-txt search-txt-width abs  js_isFocus">
        <input type="button" onclick="doSearch()" class="search-btn icon abs js_enterSearch">
        <i class="srh-close icon abs" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
                <th data-options="field:'posId'"></th>
    <th data-options="field:'packageName'">POS配置参数
配置参数可以分组，每组作为一个参数包，具有不同的用途</th>
    <th data-options="field:'posConfgVersion'">版本

程序升级后，如果设置参数的结构发生变化，需要同时改变设置参数的版本标识，原则上与第一个使用的程序版本一致</th>
    <th data-options="field:'config'">各设置参数以json格式文本保存在字段中，完成支持json语法

空设置
{}

基本结构
{
    "key1": {
        “key1-1": 'value', 
        "key1-2": 3000 ,
        desc:'说明1'
    },
        "key2-1": {
        "ip": "localhost",
        "port": 8000
        desc:'说明2'
  },
}</th>
    <th data-options="field:'lsDirty'">数据在本地被修改0否1是</th>

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
                <td><input class="easyui-textbox" type="text" name="posId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">POS配置参数
配置参数可以分组，每组作为一个参数包，具有不同的用途:</td>
                <td><input class="easyui-textbox" type="text" name="packageName" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">版本

程序升级后，如果设置参数的结构发生变化，需要同时改变设置参数的版本标识，原则上与第一个使用的程序版本一致:</td>
                <td><input class="easyui-textbox" type="text" name="posConfgVersion" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">各设置参数以json格式文本保存在字段中，完成支持json语法

空设置
{}

基本结构
{
    "key1": {
        “key1-1": 'value', 
        "key1-2": 3000 ,
        desc:'说明1'
    },
        "key2-1": {
        "ip": "localhost",
        "port": 8000
        desc:'说明2'
  },
}:</td>
                <td><input class="easyui-textbox" type="text" name="config" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">数据在本地被修改0否1是:</td>
                <td><input class="easyui-textbox" type="text" name="lsDirty" data-options="required:true"/></td>
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

