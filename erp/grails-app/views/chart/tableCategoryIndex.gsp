<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="taglibs"/>
    <title>品类销售分析</title>
    <link type="text/css" rel="stylesheet" href="${resource(base:"..",dir: "resources",file:"css/frontManageTableDay/tableDay.css")}"/>
    <script type="text/javascript">
        $(function () {
            var params = Until.getParameter();
            $.get("<g:createLink base=".." action="findcls" controller="chart" />", params, function (data) {
                var sum = 0, index = 0;
                for (var key in data) {
                    var rowData = data[key];
                    var $row = $("#_tr_clone").find("tr").clone(true);
                    //_u_name,_progress
                    var per = rowData["u_percent"] * 100;
                    $row.find("#_u_name").text(rowData["u_name"]);
                    $row.find("#_u_count").text(rowData["i_count"]);
                    $row.find("#_progress").text("" + rowData["c_total"].toFixed(2) + "(" + per.toFixed(1) + "%)");
                    /*$row.find("#_progress").css({
                        "width": per.toFixed(1) + "%",
                        "background-color": "#009999"
                    });*/
                    index++;
                    $row.find("#_u_index").text(index);
                    sum += rowData["c_total"];
                    $("._clone_here").append($row);
                }
                $("#_total").text(sum.toFixed(2));
            }, "json")
        });
    </script>
</head>
<body>
    <div class="container-fluid day-main navbar">
        <div class="row navbar-fixed-top center-block" style="top: 60px;">
            <div class="col-xs-12 col-sm-12">
                <section class="table-wrap" style="background-color: #353639">
                    <div class="money-percent">
                        <p class="money-all">总金额：<span id="_total">0.00</span>元</p>
                    </div>
                    <table>
                        <thead>
                        <tr>
                            <th style="width: 15%;">排名</th>
                            <th>名称</th>
                            <th>销量</th>
                            <th>金额(占比)</th>
                        </tr>
                        </thead>
                    </table>
                </section>
            </div>
        </div>
        <div class="row center-block">
            <div style="height: 150px;"></div>
            <section class="table-wrap">
                <table>
                    <tbody class="_clone_here"></tbody>
                </table>
            </section>
        </div>
        <div class="row navbar-fixed-bottom center-block" style="bottom: 0px;">
            <div class="col-xs-12 col-sm-12" style="background-color: #353639;height: 40px;line-height: 40px;">
                <table class="table">
                    <tbody>
                    <tr class="table-c">
                        <td style="width: 18%;padding:0px;text-align: left;line-height: 32px;" id="">
                            <img src="${resource(base:"..",dir: "resources",file:"css/common/img/change.png")}" class="changeShow" style="padding: 4px 0 0 4px;"/>
                        </td>
                        <td colspan="3"></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="_tr_clone" style="display: none;">
        <table class="table">
            <tbody>
            <tr class="table-c">
                <td style="width: 15%;" id="_u_index"></td>
                <td id="_u_name" class="u_name"></td>
                <td id="_u_count"></td>
                <td id="_progress">
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</body>
</html>