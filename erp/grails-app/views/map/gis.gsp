<html>
<head>
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/bootstrap/easyui.css',base:'..')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'easyui', file: 'themes/icon.css',base:'..')}" type="text/css">
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery.1.11.3.min.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'jquery.easyui.min.js',base:'..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file: 'winmove.js',base:'..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'easyloader.js',base:'..')}"></script>
    <script type="text/javascript" src="${resource(dir: 'easyui', file: 'locale/easyui-lang-zh_CN.js',base:'..')}"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5pOe9cqol0NaNdEbtvTXMC9h"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>请选择安装位置</title>
</head>
<body>
    <style type="text/css">
        body, html {
            width: 100%;
            height: 100%;
            margin: 0;
            font-family: "微软雅黑";
            font-family: "微软雅黑";
        }
        #allmap {
            width: 100%;
            height: 100%;
        }
        p {
            margin-left: 5px;
            font-size: 14px;
        }
    </style>
    <div style="margin-top:1%;margin-bottom: 1%">
        <input class="easyui-searchbox" data-options="prompt:'请输入要查询的地名',searcher:serch" style="width: 200px;height: 20px"/>
    </div>
    <div id="allmap"></div>
    <script type="text/javascript">
        // 百度地图API功能
        var map = new BMap.Map("allmap");
//        map.centerAndZoom(new BMap.Point(116.331398,39.897445),11);
//        map.enableScrollWheelZoom(true);
//        if(isAdd()){

//        }

        map.addControl(new BMap.NavigationControl());
        map.addControl(new BMap.ScaleControl());
        map.addControl(new BMap.OverviewMapControl());
        map.enableScrollWheelZoom();
        map.addControl(new BMap.MapTypeControl());
//        map.setCurrentCity("青岛市");
        var plng;
        var plat;

        var opts = {
            width: 250,     // 信息窗口宽度
            height: 150,     // 信息窗口高度
            title: "选择", // 信息窗口标题
            enableSendToPhone: false //是否启用发送到手机
        };

        map.addEventListener("click", showInfo);

        //添加右键菜单
        var contextMenu = new BMap.ContextMenu();
        var txtMenuItem = [
            {
                text: '放大',
                callback: function () {
                    map.zoomIn()
                }
            },
            {
                text: '缩小',
                callback: function () {
                    map.zoomOut()
                }
            },
            {
                text: '放置到最大级',
                callback: function () {
                    map.setZoom(18)
                }
            },
            {
                text: '查看全国',
                callback: function () {
                    map.setZoom(4)
                }
            },
            {
                text: '在此添加标注',
                callback: function (p) {
                    var marker = new BMap.Marker(p), px = map.pointToPixel(p);
                    map.addOverlay(marker);
                }
            }
        ];
        /* var point2 = new BMap.Point(106.702637, 26.626936);
         //在王府井地铁处，再添加一个热区
         var hotSpot2 = new BMap.Hotspot(point2, {text: "森林公园"});
         map.addHotspot(hotSpot2);
         */

        for (var i = 0; i < txtMenuItem.length; i++) {
            contextMenu.addItem(new BMap.MenuItem(txtMenuItem[i].text, txtMenuItem[i].callback, 100));
            if (i == 1 || i == 3) {
                contextMenu.addSeparator();
            }
        }
        map.addContextMenu(contextMenu);
        initPoint();

        /**
         * 添加标注--修改时使用
         * @param point
         */
        function addMarker(point) {
            clean();
            var marker = new BMap.Marker(point);
            map.addOverlay(marker);
//            map.panTo(point);
            map.centerAndZoom(point,15);
            //openInfo();
    //        addClickHandler(marker);
        }
        //显示信息
        function showInfo(e) {
            plng = e.point.lng;
            plat = e.point.lat;
            var point = new BMap.Point(plng, plat);
            addMarker(point);
            //鼠标放在地图标注点，会出现提示文字
    //        var hotSpot = new BMap.Hotspot(point, {text: "我爱北京天安门!", minZoom: 8, maxZoom: 18});
    //        map.addHotspot(hotSpot);

        }

        /**
         * 查询显示点信息
         */
        function queryMark() {
            map.clearOverlays();
    //        var infoWindow = new BMap.InfoWindow(content, opts);  // 创建信息窗口对象
    //        var marker = new BMap.Marker(poi3);
    //        marker.enableDragging(); //marker可拖拽
            addMarker(point);

            //searchInfoWindow.open(marker); //在marker上打开检索信息串口
        }
        /**
         * 添加标注的监听事件
         */
        function addClickHandler(marker) {
            marker.addEventListener("click", function (e) {
                        openInfo(e)
                    }
            );
        }
        /**
         * 显示提示信息
         */
        function openInfo() {
    //        var p = e.target;
            var point = new BMap.Point(plng, plat);
            var content = '<div style="margin:0;line-height:20px;padding:2px;">' +
                    '经度：' + plng + '<br/>' +
                    '纬度：' + plat + '<br/></div>'
            var infoWindow = new BMap.InfoWindow(content, opts);  // 创建信息窗口对象
            map.openInfoWindow(infoWindow, point); //开启信息窗口
        }
        /**
         * 清除标注
         */
        function clean() {
            map.clearOverlays();
        }
        /**
         * 检索
         *
         */

        function serch(queryStr){
            var local = new BMap.LocalSearch(map, {
                renderOptions:{map: map}
            });
            local.search(queryStr);
        }
        /**
         * 修改门店时，获取坐标加载到地图上
         */
        function initPoint(){
            var array=[];
            var point=new BMap.Point(120.389158,36.072358);
            var plng = getPlng();
            var plat = getPlat();
            if(plng){
                point = new BMap.Point(plng, plat);
            }
            addMarker(point);

        }
        /**
         * 获取坐标
         * @constructor
         */
        function OKPoint(){
            if(plng!=undefined&&plat!=undefined){
                addPoint(plng,plat);
            }else{
                alertMapMsg();
            }
        }
    </script>
</body>
</html>