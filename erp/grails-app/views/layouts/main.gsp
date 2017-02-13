<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="app_version" content="_GSP_VERSION">
    %{--<meta http-equiv="pragma" content="no-cache">--}%
    %{--<meta http-equiv="cache-control" content="no-cache">--}%
    %{--<meta http-equiv="expires" content="0">--}%
    <title><g:layoutTitle default="Grails"/></title>

    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/bootstrap/easyui.css',base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/icon.css',base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mainFrame/main.css',base: '..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'zTree', file: 'css/metroStyle/metroStyle.css',base: '..')}" type="text/css">
    <script type="text/javascript">
        var _dic_all_url = "<g:createLink controller="sysDict" action="qryAllDics" base=".."  />"
        var _dic_key_url = "<g:createLink controller="sysDict" action="qryDicByKey" base=".."  />";
    </script>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>
    %{--<script type="text/javascript" src="${resource(dir:'easyui',file:'jquery.min.js',base: '..')}"></script>--}%
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.validate.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'easyui',file:'jquery.easyui.min.js',base: '..')}"></script>

    <script type="text/javascript" src="${resource(dir:'easyui',file:'easyloader.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'easyui',file:'locale/easyui-lang-zh_CN.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.form.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'easyui-ext.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'zTree', file: 'js/jquery.ztree.all-3.5.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'zTree', file: 'js/jquery.ztree.exhide-3.5.js',base: '..')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'branch/addAreaSet.js',base: '..')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file:'jquery.json.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(base:"..",dir: "js", file: "common/jquery.cookie.js")}" ></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'jquery.easyui.datagrid.spreads.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-formatDate.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'formatterUtils.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file: 'winmove.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'common/dateFormat.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'common/jquery.custom.common.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'common/jquery.custom.init.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'common/ajaxfileupload.js',base: '..')}"></script>
    <script src="${resource(base:"..",dir:"resources",file:"js/common/datetime.until.js")}"></script>

    %{--<script type="text/javascript" src="${resource(dir:'js',file:'branch/branchSet.js',base: '..')}"></script>--}%
    <g:layoutHead/>
</head>
<body style="width: 100%;height: 100%;">
<g:layoutBody/>
</body>
</html>
