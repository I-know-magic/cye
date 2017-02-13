function init() {
    $('#pagination').pagination({
        pageSize: 20,
        pageList: [20, 5, 10, 35, 50, 100],
        loading: true,
        onRefresh: function (pageNumber, pageSize) {
            $('.table_list').empty();
            doSearch(pageNumber, pageSize);
        },
        onChangePageSize: function (pageSize) {
            $('.table_list').empty();
            doSearch($(this).pagination('options').pageNumber, pageSize);
        },
        onSelectPage: function (pageNumber, pageSize) {
            $('.table_list').empty();
            doSearch(pageNumber, pageSize);
        }
    });
    doSearch(1, 20);

    $('#msgType').change(function () {
        $('.table_list').empty();
        $('#pagination').pagination('refresh', {total: 0, pageNumber: 1, pageSize: 20});
        doSearch(1, 20);
    });
}


function doSearch(page, rows) {
    var url = search_url + "page=" + page + "&rows=" + rows + "&msgType=" + $('#msgType').val();
    $('#pagination').pagination('loading');
    $.ajax({
        type: "GET",
        url: url,
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $('#pagination').pagination('refresh', {total: data.total});
            tableList = data.rows;
            $('.table_list').empty();
            printRows(tableList);
            $('#pagination').pagination('loaded');
        }
    });
}
/**
 * 打印row
 * @param rows
 */
function printRows(rows) {
    var htmlRow = $('#row_hide');
    var table_list = $('.table_list');
    $.each(rows, function (index, row) {
        var newRow = htmlRow.clone();
        if (row.msgType == 1) {
            newRow.find("a").html("【公告】" + row.title).click(function () {
                showNotice(this);
            }).attr("id", row.id);
            ;
            table_list.append(newRow);
            newRow.find("span:last").html($.formatDate("yyyy-MM-dd HH:mm", row.lastUpdateAt));
        } else {
            newRow.find("a").attr("href", row.content).html("【推广】" + row.title).attr('target', "_blank");
            newRow.find("span:last").html($.formatDate("yyyy-MM-dd HH:mm", row.lastUpdateAt));
            table_list.append(newRow);
        }
        newRow.mouseover(function () {
            $(this).css({ background: '#F4FCFF','border-radius': '10px'});
        });
        newRow.mouseout(function () {
            $(this).css({ background: '#FFFFFF','border-radius': '0px'});
        });
    });
    $.each(table_list.find("[class='clearfix']"), function (index, item) {
        $(item).show();
    });
}
function checkType(msgType) {
    alert(msgType)
}

function back(url) {
    window.location.href = url;
}
function colseNotice() {
    $('#noticeInfoWindow').dialog('close');
}
function showNotice(obj) {
    var id = $(obj).attr('id');
    var title = '';
    var content = '';
    $.each(tableList, function (index, item) {
        if (item.id == id) {
            title = '主题： &nbsp; &nbsp;' + item.title + "<br/>";
            content = '内容： &nbsp; &nbsp;' + item.content;
            return;
        }
    });
    $(".notice_content").html(title + content);
    $('#noticeInfoWindow').dialog('open').dialog('setTitle', '【公告】');
}