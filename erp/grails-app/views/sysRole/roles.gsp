<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title></title>
</head>
<script type="text/javascript">
    $(function(){
        $("#treeGridDemo").tg({
            url:"<g:createLink base=".." controller="login" action="getData" />",
            idField:'id',
            treeField:'name',
            checkbox:true,
            columns:[[
                {title:'Name',field:'name',width:220,align:'left'},
                {field:'size',title:'size',width:100,align:'right'},
                {field:'date',title:'date',width:150}
            ]]
        })
    });
</script>
<body>
    <table id="treeGridDemo"></table>
</body>
</html>