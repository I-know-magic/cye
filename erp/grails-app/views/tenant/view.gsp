<!DOCTYPE>
<html>
<head>
    <meta name="layout" content="main">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商户信息表</title>
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
            orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink controller="tenant" action="list"  />");
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
            orderTable.mainAdd("<g:createLink controller="tenant" action="create"/>","商户信息表-增加");
            orderTable.formAction = "<g:createLink controller="tenant" action="save"  />";
        }
        function edit(id) {
            orderTable.mainEdit("<g:createLink controller="tenant" action="edit"  />", "商户信息表-修改", id);
            orderTable.formAction = "<g:createLink controller="tenant" action="update"  />";
        }
        function del() {
            orderTable.mainDel("<g:createLink controller="tenant" action="delete"  />");
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
                <th data-options="field:'userId'">对应的用户ID，sys_user.id</th>
                    <th data-options="field:'code'">商户ID，8位纯数字</th>
                    <th data-options="field:'name'">商户名称</th>
                    <th data-options="field:'address'">详细地址</th>
                    <th data-options="field:'province'">所在省份区划代码</th>
                    <th data-options="field:'city'">所在地市区划代码</th>
                    <th data-options="field:'county'">所在区县区划代码</th>
                    <th data-options="field:'phoneNumber'">手机号</th>
                    <th data-options="field:'linkman'">联系人</th>
                    <th data-options="field:'business'">行业：1-快餐店</th>
                    <th data-options="field:'business1'">一级业态：1-餐饮，2-零售</th>
                    <th data-options="field:'business2'">二级业态</th>
                    <th data-options="field:'business3'">三级业态</th>
                    <th data-options="field:'email'"></th>
                    <th data-options="field:'qq'"></th>
                    <th data-options="field:'status'">状态：0-未激活，1-启用，2-停用</th>
                    <th data-options="field:'paidTotal'">缴费额（指商户激活以来，支付的软件费总金额）</th>
                    <th data-options="field:'goodsId'">当前激活的软件版本ID，goods.id</th>
                    <th data-options="field:'remark'">备注</th>
                    <th data-options="field:'isTest'">是否是测试环境下的账号-1为测试账号-0为正式账号</th>
                    <th data-options="field:'cashierName'">安全收银账号</th>
                    <th data-options="field:'cashierPwd'">安全收银密码</th>
                    <th data-options="field:'imgUrl'">商户logo存储路径</th>

            </thead>
        </table>

        <div id="editWindow" class="easyui-dialog "
             data-options="modal:true,closed:true,closable:true,iconCls:'icon-save',top:'80px'"
             buttons="#infoWindow-buttons" style="width:500px;height:auto;">
            <form id="editForm" method="post">
                <table cellpadding="5" style="table-layout:fixed;">
                    <input class="easyui-validatebox" type="hidden" name="id" id="id"/>
                                <tr>
                <td class="title">对应的用户ID，sys_user.id:</td>
                <td><input class="easyui-textbox" type="text" name="userId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">商户ID，8位纯数字:</td>
                <td><input class="easyui-textbox" type="text" name="code" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">商户名称:</td>
                <td><input class="easyui-textbox" type="text" name="name" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">详细地址:</td>
                <td><input class="easyui-textbox" type="text" name="address" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所在省份区划代码:</td>
                <td><input class="easyui-textbox" type="text" name="province" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所在地市区划代码:</td>
                <td><input class="easyui-textbox" type="text" name="city" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">所在区县区划代码:</td>
                <td><input class="easyui-textbox" type="text" name="county" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">手机号:</td>
                <td><input class="easyui-textbox" type="text" name="phoneNumber" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">联系人:</td>
                <td><input class="easyui-textbox" type="text" name="linkman" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">行业：1-快餐店:</td>
                <td><input class="easyui-textbox" type="text" name="business" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">一级业态：1-餐饮，2-零售:</td>
                <td><input class="easyui-textbox" type="text" name="business1" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">二级业态:</td>
                <td><input class="easyui-textbox" type="text" name="business2" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">三级业态:</td>
                <td><input class="easyui-textbox" type="text" name="business3" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="email" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">:</td>
                <td><input class="easyui-textbox" type="text" name="qq" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">状态：0-未激活，1-启用，2-停用:</td>
                <td><input class="easyui-textbox" type="text" name="status" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">缴费额（指商户激活以来，支付的软件费总金额）:</td>
                <td><input class="easyui-textbox" type="text" name="paidTotal" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">当前激活的软件版本ID，goods.id:</td>
                <td><input class="easyui-textbox" type="text" name="goodsId" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">备注:</td>
                <td><input class="easyui-textbox" type="text" name="remark" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">是否是测试环境下的账号-1为测试账号-0为正式账号:</td>
                <td><input class="easyui-textbox" type="text" name="isTest" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">安全收银账号:</td>
                <td><input class="easyui-textbox" type="text" name="cashierName" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">安全收银密码:</td>
                <td><input class="easyui-textbox" type="text" name="cashierPwd" data-options="required:true"/></td>
            </tr>
            <tr>
                <td class="title">商户logo存储路径:</td>
                <td><input class="easyui-textbox" type="text" name="imgUrl" data-options="required:true"/></td>
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

