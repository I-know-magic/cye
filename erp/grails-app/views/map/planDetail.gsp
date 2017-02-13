<>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>请选择公司位置</title>
</head>
<body>
<script type="text/javascript">
     var planTable;
     $(function () {
//         //debugger;
        var cid = getCarid();
//        alert(cid)
         var url = "<g:createLink controller="tabCarPlan" action="curlist" />" + "?carid=" + cid;
         planTable = new EasyUIExt($("#mainGrid"), url);
         planTable.singleSelect = true;
         planTable.pagination = true;
         planTable.loadSuccess = function (data) {
             if (data.rows == 0) {
             }
         }

         planTable.mainEasyUIJs();
         //planTable.load();

     });


     //easyui 自带  列功能函数   列数值为value
     function formatstatus(value){
         if (value == 1) {
             return "已送达";
         }else{
             return "未送达";
         }

     }

</script>

<div class="table-list">
    <div class="table-list-r-1 fl" style="background:#b6b6b6;">
        <table id="mainGrid"
               data-options="fit:true, fitColumns:false, idField : 'id',frozenColumns:[[{field:'id',checkbox:true}]]">
            <thead>
            <th data-options="field:'orderid'">订单号</th>
            <th data-options="field:'planstatus',formatter:formatstatus">送达状态</th>%{--0-未送达  1-送达--}%
            </thead>
        </table>
    </div>
</div>
</body>

</html>
