<!DOCTYPE>
<html>
<head>

    %{--<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">--}%
    %{--<meta http-equiv="X-UA-Compatible" content="IE=edge">--}%
    <title>分组</title>
    <style type="text/css">
    .title {
        width: 120px;
    }

    .search-width {
        width: 190px;
        width: 226px \9;
    }

    .search-txt-width {
        width: 170px;
    }
    /*.class_light_level .textbox{  width: 45px !important; }*/
    /*.class_light_level .textbox-text{  width: 45px !important;  }*/
    /*.class_light_level .textbox-invalid{  width: 45px !important;  }*/

    </style>

</head>
<body>

<script type="text/javascript">
    var orderTable;
    $(function () {
        //debugger;
//        var height = $(window).height();
//        $(".table-list").css({"height":(height-40-24-20-8-($.browser("isMsie")?0:70))+"px"});
        var tid=$("#h_terminal_id").val();
        orderTable = new EasyUIExt($("#mainGrid"), "<g:createLink base=".." controller="baseGroup" action="list"  />?kindId="+tid);
        orderTable.singleSelect = true;
        orderTable.pagination = true;
        orderTable.loadSuccess = function (data) {
            if (data.rows == 0) {
            }
        }
        orderTable.mainEasyUIJs();
//        $('#light_level').combobox({ width: '45px' });
        $("").css("width","45px");
    });
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
    function open_group_light(_fn_group,num){
        //debugger;
        openwidow();
        var row = $("#mainGrid").datagrid("getSelected");
        if(row){
            var baseGroupCode=row.baseGroupCode;
            var terminal=row.baseTerminalAddr;
            var baseGroupName=row.baseGroupName;
            var msg= "集中控制器:"+terminal+"开始对分组="+baseGroupName+"进行操作！";
            var data=null;
            if(num){
                num= $("#light_level").combobox('getValue');
                data=new Array(baseGroupCode,num+'');
            }else{
                data=new Array(baseGroupCode);
            }
            init(afn_group,_fn_group,pn,terminal,mas,msgtype);
            setData(data,0,0);
            var lst=pack();
            if(flag_test=="0"){
                output_ptl(lst);
            }
        }else{
            msg="请选择要操作的分组！";
        }
        output_state(msg);
    }

</script>
<div class="rel clearfix function-btn">
    <ul class="boxtab-btn abs">
        <li  class="icon add class_branch_op" style="line-height:40px" onclick="open_group_light('004')">开灯</li>
        <li  class="icon alt class_branch_op" style="line-height:40px" onclick="open_group_light('005')">关灯</li>
        <li  class="class_branch_op class_light_level" style="line-height:40px">
            <select class="easyui-combobox"  id="light_level" panelHeight="auto">
                <option value="20">1级</option>
                <option value="40">2级</option>
                <option value="60">3级</option>
                <option value="80">4级</option>
            </select>
        </li>
        <li  class="icon alt class_branch_op" style="line-height:40px" onclick="open_group_light('006','50')">调光</li>
    </ul>

    %{--<p  class="search-d search-width abs">--}%
        %{--<input type="text" id="queryStr" name="queryStr" placeholder="输入编码或名称查询" class="search-txt-d search-txt-width abs  js_isFocus">--}%
        %{--<input type="button" onclick="doSearch()" class="search-btn-d icon abs js_enterSearch">--}%
        %{--<i class="srh-close icon abs" onclick="clearSearch()"></i>--}%
    %{--</p>--}%
</div>

<div class="table-list" style="overflow:hidden">
    <div class="table-list-r-1-d fr" style="background:#b6b6b6;overflow:hidden">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]" style="overflow:hidden">
            <thead>
                <th data-options="field:'baseGroupName'">分组名称</th>
                <th data-options="field:'baseGroupCode'">编号</th>
                <th data-options="field:'baseTerminalId'" hidden="hidden">集中控制器id</th>
                <th data-options="field:'baseTerminalAddr'">集中控制器地址</th>
                %{--<th data-options="field: 'goodsCode', title: '菜品编码', width: 255, align: 'center',editor: {type:'textbox',options:{required: true,missingMessage:'菜品编码为必填项',editable:true">集中控制器地址</th>--}%

            </thead>
        </table>
    </div>
</div>
</body>
</html>

