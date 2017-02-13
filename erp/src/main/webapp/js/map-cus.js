
function openMap() {
    $("#mapWin").dialog('open');
}
function getPlng() {
    var point = $("#g_lng").val();
    return point;
}
function getPlat() {
    var point = $("#g_lat").val();
    return point;
}
function closeMap() {
    $("#mapWin").dialog("close");
}
function addPoint(x, y) {
    var geolocation = x + "," + y;
    $("#g_lng").val(x);
    $("#g_lat").val(y);
    $("#geolocat").text("已选择安装位置")
    $("#mapWin").dialog("close");
}