<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/bootstrap/easyui.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/icon.css')}" type="text/css">
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'easyui', file: 'jquery.min.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'jquery.easyui.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'easyui.treegrid.spread.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'easyloader.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'locale/easyui-lang-zh_CN.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file:'easyui-ext.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file:'jquery.validate.js')}"></script>
</head>
<script type="text/javascript">
    $(function(){
        $("#treeGridDemo").tg({
            url:"<g:createLink controller="login" action="getData" />",
            idField:'id',
            treeField:'name',
            checkbox:true,
            columns:[[
                {title:'Name',field:'name',width:220,align:'left'},
                {field:'size',title:'size',width:100,align:'right'},
                {field:'date',title:'date',width:150}
            ]]
        });
    });
    function getChecked(){
        //var ary = $("#treeGridDemo").getChecked();//默认是数组
        //alert(ary.join(","))//可通过join方法拼接成指定分隔符的字符串
        var ary = $("#treeGridDemo").getChecked("string");//传入参数string,可直接获得,拼接的字符串
        alert(ary)

    }
    function setChecked(){
        //var ids ="2,223,3";
        var ids =["2","223","3"]
        $("#treeGridDemo").setChecked(ids);
    }
</script>
<body>
    <a href="javascript:void(0)" onclick="getChecked()">获取选中的id</a>
    <a href="javascript:void(0)" onclick="setChecked()">选中id</a>
    <table id="treeGridDemo"></table>
</body>
</html>