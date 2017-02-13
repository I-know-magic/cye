<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="main"/>
    %{--<meta http-equiv="pragma" content="no-cache">--}%
    %{--<meta http-equiv="cache-control" content="no-cache">--}%
    %{--<meta http-equiv="expires" content="0">--}%
    %{--<meta http-equiv="kiben" content="no-cache">--}%
    %{--<%--}%
        %{--response.setHeader("Expires", "0");--}%
        %{--response.setHeader("Cache-Control", "no-store,no-cache,must-revalidate");--}%
        %{--response.addHeader("Cache-Control", "post-check=0, pre-check=0");--}%
        %{--response.setDateHeader("Last-Modified", 0);--}%
    %{--%>--}%
    <title>出入库主界面</title>
    <link rel="stylesheet" href="${resource(base: "..", dir: 'js', file: 'datePicker/jquery-ui-timepicker.css')}"
          type="text/css">
    <script type="text/javascript" src="${resource(base: "..", dir: 'js', file: 'datePicker/jquery-ui.js')}"></script>
    <script type="text/javascript"
            src="${resource(base: "..", dir: 'js', file: 'datePicker/jquery-ui-timepicker-addon.js')}"></script>
    <script type="text/javascript"
            src="${resource(base: "..", dir: 'js', file: 'datePicker/ftrend.datepicker.js')}"></script>
    <script type="text/javascript" src="${resource(base: '..', dir: 'js', file: 'jquery.validate.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'combox-cus.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(base: '..', dir: 'js', file: 'storeOrder/storeOrder.js')}"></script>
    <style type="text/css">
    /*.code_open{*/
    /*text-decoration: underline;*/
    /*}*/
    .single_date {
        right: 282px;
    }
    .search-width{
        width: 150px;width: 150px\9;
    }
    </style>
    <script type="text/javascript">
        var dgMain;
        var h_branch_url = '<g:createLink base=".." controller="saleReport" action="branchview"/>';
        var backStr = '${backParams}';
        $(function () {
            var height = $(window).height();
            $(".table-list").css({"height": (height - 40 - 24 - 20 - 8 - ($.browser("isMsie") ? 0 : 70)) + "px"})
            dateTimePicker = new dateTimePicker({
                container: $('#dateTimeRangeBox'),
                defaultDateTime: [$.dateFormat(new Date, "yyyy-MM-dd") + ' 00:00', $.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59']
            });
            var startDate=$("input[id*='begin']").val();
            var endDate=$("input[id*='end']").val();
//            dgMain = new EasyUIExt($("#mainGrid"), '');
            dgMain = new EasyUIExt($("#mainGrid"), '<g:createLink controller="storeOrder" action="queryPager" base=".." />?orderType=${orderType}&startDate='+startDate+'&endDate='+endDate);
            dgMain.singleSelect = false;
            dgMain.showFooter = true;
            dgMain.window = $("#editWindow");
            dgMain.form = $("#editForm");
            dgMain.pagination = true;
            dgMain.loadSuccess = function (data) {
            }
            dgMain.mainEasyUIJs();
            loadBoxData_cus('q_makeName', '<g:createLink base=".." controller="storeOrder" action="queryEmployeeAsJson"/>','userId' ,'name',false);
            loadBoxData_cus('q_auditName', '<g:createLink base=".." controller="storeOrder" action="queryEmployeeAsJson"/>','userId' ,'name',false);
//            doSearch_so();
            %{--initHUser("<g:createLink controller="storeOrder" action="queryEmployeeAsJson" base=".." />")--}%
//            initBranch();
            $(".js_show").bind("click", function () {
                $(this).parent().hide(300);
                $(".js_hide").parent().show(300);
                $(".js_box").slideDown("slow");
            })
            $(".js_hide").bind("click", function () {
                $(this).parent().hide(300);
                $(".js_show").parent().show(300);
                $(".js_box").slideUp("slow");
            })
            $(".js_bottom").bind("click", function () {
                $(".js_hide").parent().hide(300);
                $(".js_show").parent().show(300);
                $(".js_box").slideUp("slow");
            })
            $(".js_i").bind("click", function () {
                $("#queryStr").val("");
            })
        });

        function myAdd() {
            var orderType = $('#h_order_type').val();
            location.replace('<g:createLink controller="storeOrder" action="initForm" base=".." />?opType=1&orderType=' + orderType);
        }
        function del() {
            var url = '<g:createLink controller="storeOrder" action="deleteOrder" base=".." />?orderId=';
            var ids = []
            if (!validOrder(ids,true)) {
                return false;
            }
            $.messager.confirm('系统提示', '确定删除?', function (r) {
                if (r) {
                    $.post(url + ids.toString(), function (data) {
                        if (data.success == 'true') {
                            doSearch_so();
                        }
                        $.messager.alert('系统提示', data.msg, 'info');
                    }, 'json');
                }
            });
        }
        function audit() {
            var url = '<g:createLink controller="storeOrder" action="auditOrder" base=".." />?orderId=';
            var ids = []
            if (!validOrder(ids,false)) {
                return false;
            }
            $.messager.confirm('系统提示', '确定审核?', function (r) {
                if (r) {
                    $.post(url + ids.toString(), function (data) {
                        if (data.success == 'true') {
                            doSearch_so();
                        }
                        $.messager.alert('系统提示', data.msg, 'info');
                    }, 'json');
                }
            });
        }
        function validOrder(ids,isDel) {
            var pRow = $('#mainGrid').datagrid('getSelections');
            var flag = true;
            var msg;
            $.each(pRow, function (index, item) {
                if(item.branchId != $('#h_branchMenu_r').val()){
                    if(isDel){
                        msg = '分店单据【' + item.code + '】不能删除！';
                    }else{
                        msg = '分店单据【' + item.code + '】不能审核！';
                    }
                    $.messager.alert('系统提示', msg, 'info');
                    flag = false;
                    return false;
                }
                if (item.status == 1) {
                    if(isDel){
                        msg = '单据【' + item.code + '】已审核,不能删除！';
                    }else{
                        msg = '单据【' + item.code + '】已审核';
                    }
                    $.messager.alert('系统提示', msg, 'info');
                    flag = false;
                    return false;
                }
                ids.push(item.id);
            });
            if (!flag) {
                return flag;
            }
            if (ids.length == 0) {
                $.messager.alert('系统提示', '请选择一条单据！', 'info');
                flag = false;
            }
            return flag;
        }
        function doSearch_so() {
            setBackInitParams();
            $('#mainGrid').datagrid('clearSelections');
            var status=$('#af_status').combobox('getValue');
            var makeBy=$('#q_makeName').combobox('getValue');
            var auditBy=$('#q_auditName').combobox('getValue');
            $("#mainGrid").datagrid({
                url: "<g:createLink controller="storeOrder" action="queryPager" base=".." />",
                queryParams: {
                    orderType: $('#h_order_type').val(),
                    code: $("#queryStr").val(),
                    branchId: $('#branchMenu_r').val(),
                    status: status,
                    makeBy: makeBy,
                    auditBy: auditBy,
                    startDate: $("input[id*='begin']").val(),
                    endDate: $("input[id*='end']").val()
                },
                onLoadSuccess:function(data){
                    if( $("#h_rowIndex").val()!=""){
                        $('#mainGrid').datagrid('selectRecord', $("#h_rowIndex").val());
                    }

                }
            });
        }
        function clearSearch() {
            $("#queryStr").val("");
        }
        function dateF(val) {
            if (val != null) {
                return $.formatDate("yyyy-MM-dd", val);
            }
            return val
        }
        function statusF(val) {
            switch (val) {
                case 2:
                    val = '未审核';
                    break;
                case 1:
                    val = '已审核';
                    break;
                default :
                    val = ''
            }
            return val
        }
        function codeF(val, row) {
            if (row != null) {
                if (row.code == '合计' || row.code == '小计') {
                    return val;
                }
                return "<a href='#' class='code_open' onClick='open_p(" + row.id + ",4,"+row.status+")'>" + val + "</a>";
            }
            return val;
        }
        function open_p(id, opType,status) {
            if (id === null) {
                var pRow = $('#mainGrid').datagrid('getSelections');
                if (pRow.length != 1) {
                    $.messager.alert('系统提示', '请选择一条单据！', 'info')
                    return;
                }
                if(pRow[0].branchId != $('#h_branchMenu_r').val()){
                    $.messager.alert('系统提示', '分店单据【' + pRow[0].code + '】不能修改！', 'info');
                    return;
                }
                id = pRow[0].id;
            }
            if(opType == 2){
                if (pRow[0].status == '1') {
                    $.messager.alert('系统提示', '单据【' + pRow[0].code + '】已审核,不能修改！', 'info');
                    return;
                }
            }
            if (opType == 3) {
                if (pRow[0].status == '1') {
                    $.messager.alert('系统提示', '单据【' + pRow[0].code + '】已审核！', 'info');
                    return;
                }
                var url_99 = '<g:createLink controller="storeOrder" action="initForm" base=".." />?'
                        + 'opType=3' + '&orderId=' + id + '&orderType=' + $('#h_order_type').val();
            } else {
                var url_99 = '<g:createLink controller="storeOrder" action="initForm" base=".." />?'
                        + 'opType=2' + '&orderId=' + id + '&orderType=' + $('#h_order_type').val();
            }
            //通过单据号的连接进入的明细
            if(opType == 4){
                if(status == '1'){
                    opType = 3;
                }else{
                    opType = 2;
                }
                var url_99 = '<g:createLink controller="storeOrder" action="initForm" base=".." />?'
                        + 'opType='+opType+ '&orderId=' + id + '&orderType=' + $('#h_order_type').val();
            }
            location.replace(url_99 + '&backParams=' + getBackInitParams(id));
        }
        <%--
            添加返回参数
        --%>
        function getBackInitParams(id) {
            var backStr1 = '';
            backStr1 += $('#af_status').combobox('getValue') + ';';
            backStr1 += $('#q_makeName').combobox('getValue') + ';';
            backStr1 += $('#q_auditName').combobox('getValue') + ';';
            backStr1 += $('#queryStr').val() + ';';
            backStr1 += $('#branchMenu_r').val() + ';';
//            backStr1 += $('#branch').textbox('getText') + ';';
            backStr1 += $("input[id*='begin']").val() + ';';
            backStr1 += $("input[id*='end']").val() + ';';
            backStr1 += id;
            return backStr1;
        }
        <%--
            设置返回参数
        --%>
        function setBackInitParams() {
            if (backStr != '') {
                var backs = backStr.split(';');
                backStr = '';
                $('#af_status').combobox('setValue', backs[0]);
                $('#q_makeName').combobox('setValue', backs[1]);
                $('#q_auditName').combobox('setValue', backs[2]);
                $('#queryStr').val(backs[3]);
                $('#branchMenu_r').val(backs[4]);
                $('#branch').textbox('setText', backs[5]);
                $("input[id*='begin']").val(backs[6])
                $("input[id*='end']").val(backs[7])
                $("#h_rowIndex").val(backs[8]);
            }

        }
        function resetForm() {
            $('#af_status').combobox('setValue', '');
            $('#q_makeName').combobox('setValue', '');
            $('#q_auditName').combobox('setValue', '');
            $('#queryStr').val('');
            $('#branchMenu_r').val($('#h_branchMenu_r').val());
//            $('#branch').textbox('setText', $('#h_branchMenu_name').val());
            $("input[id*='begin']").val($.dateFormat(new Date, "yyyy-MM-dd") + ' 00:00')
            $("input[id*='end']").val($.dateFormat(new Date, "yyyy-MM-dd ") + ' 23:59')
        }
    </script>
</head>

<body>
<h3 class="rel ovf js_header">
    <span>库存管理</span>
    -
    <span>
        <g:if test="${orderType == 1}">入库管理</g:if>
        <g:else>出库管理</g:else>
    </span>
</h3>

<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li class="icon bat" onclick="audit()">审 核</li>
        <li class="icon add" onclick="myAdd()">增 加</li>
        <li class="icon alt" onclick="open_p(null, 2)">修 改</li>
        <li class="icon del" onclick="del()">删 除</li>
    </ul>
    <!-- 高级搜索开始 -->
    <!-- 显示全部 -->
    <p class="abs search-more " style="display:block;"><a href="#" class="icon js_show">高级查询</a></p>
    <!-- 收起全部 -->
    <p class="abs search-more " style="display:none;"><a href="#" class="pack-up icon js_hide">收起查询</a></p>

    <div class="abs search-box js_box" style="display:none;">
        <input type="hidden" value="${orderType}" id="h_order_type">
        <input type="hidden" class="search" id="branchMenu_r" value="${branch.id}">
        <input type="hidden" id="h_rowIndex"/>
        <input type="hidden" class="search" id="h_branchMenu_r" value="${branch.id}">
        <input type="hidden" class="search" id="h_branchMenu_name" value="${branch.name}">
        <input type="hidden" class="search" id="h_branch_type" value="${branch.branchType}">
        <input type="hidden" class="search" id="h_back_params" value="">

        <form id="searchForm">
            %{--<p class="p_branch_">--}%
                %{--<span>门店：</span>--}%
                %{--<input id="branch" name="searchCode" value="${branch.name}">--}%
            %{--</p>--}%

            <p>
                <span>单据状态：</span>
                <select id="af_status" class="easyui-combobox" name="status" style="width:80px;height: 25px"
                        editable="false" panelHeight="auto">
                    <option value="">全部</option>
                    <option value="1">已审核</option>
                    <option value="2">未审核</option>
                </select>
            </p>


            <p>
                <span>制单人：</span>
                <select id="q_makeName" name="q_makeName" data-options="required:true"  ></select>
                %{--class="search-txt search-txt-width"--}%
                </select>
                %{--<input id="q_makeName" class="easyui-combobox" name="q_makeName"--}%
                       %{--data-options="method:'get',valueField:'userId',editable:false, textField:'name',panelHeight:150">--}%
            </p>

            <p>
                <span>审核人：</span>
                <select id="q_auditName" name="q_auditName" data-options="required:true"  ></select>
                </select>
                %{--<input id="q_auditName" class="easyui-combobox" name="q_auditName"--}%
                       %{--data-options="method:'get',valueField:'userId',editable:false, textField:'name',panelHeight:150">--}%
            </p>
        </form>

        <p style="margin-bottom: 15px"></p>

        <p class="search-box-btn">
            <input type="button" onclick="doSearch_so()" value="搜索">
        </p>

        <p class="search-box-btn gray">
            <input type="button" onclick="resetForm()" value="重置">
        </p>

        <p class="pack-up-bottom icon js_bottom"></p>
    </div>

    <p class="search-date single_date abs"><a id="dateTimeRangeBox"></a></p>

    <p class="search abs   search-pos-table js_p">
        <input type="text" id="queryStr" name="queryStr" placeholder="输入单据号查询"
               class="search-txt abs js_p  search-txt-width search-width js_isFocus">
        <input type="button" class="search-btn icon abs js_button js_enterSearch" onclick="doSearch_so()">
        <i class="srh-close icon abs js_i" onclick="clearSearch()"></i>
    </p>
</div>

<div class="table-list">
    <div class="table-list-r-1 fr" style="background:#b6b6b6;">
        <table id="mainGrid" data-options="fit:true, fitColumns:false, showFooter:true,idField : 'id',frozenColumns:[[{
	    field:'id',
	    checkbox:true
	}]]">
            <thead>
            <th data-options="field:'code',width:160,formatter:codeF">单号</th>
            <th data-options="field:'status',width:100,formatter:statusF">状态</th>
            <th data-options="field:'quantity',width:100,formatter:numberF,align: 'right'">
                ${orderType == 2 ? '出库数量':'入库数量'}
            </th>
            <th data-options="field:'amount',width:120,formatter:moneyFormatter,align: 'right'">
                ${orderType == 2 ? '出库金额':'入库金额'}
            </th>
            <th data-options="field:'makeName',width:130,align:'left'">制单人</th>
            <th data-options="field:'makeAt',width:150,formatter:dateFormatterToHM">制单时间</th>
            <th data-options="field:'auditName',width:130,align:'left'">审核人</th>
            <th data-options="field:'auditAt',width:150,formatter:dateFormatterToHM">审核时间</th>
            <th data-options="field:'memo',width:350,align: 'left'">备注</th>
            </thead>
        </table>
    </div>

    <div id="select_dialog" class="easyui-dialog" data-options="modal:true,closed:true,closable:true"
         buttons="#infoWindow-buttons" style="width: 350px;height: 500px;overflow-x: hidden;overflow-y: auto">
    </div>

    <div id="infoWindow-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="report_save()">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="closeReport()">取消</a>
    </div>
</div>
</body>
</html>

