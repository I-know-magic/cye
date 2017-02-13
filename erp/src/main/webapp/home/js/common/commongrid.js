/**
 * Created by LiuJie on 2015/11/6.
 */
;(function($){
    $.fn.extend({
        /**
         * 自定义bootstrap样式的表格
         * $().bootsgrid({url:""...})
         * @param _params
         * @param options
         */
        commongrid:function(options,_params){
            var $table=this.selector;//表格对象
            /***表格默认属性***/
            var _default={
                filedId:"id",//默认对象Id
                url:"",//请求后台url
                table_selector:$table,//表格对象
                rownumber:true,//是否显示行号 默认显示 true  false:不显示
                checkrow:true,//是否显示单行复选框 true：显示  false：不显示
                singleSelect:false,//是否单选，默认多选
                queryParams:{},//查询数据参数
                pageParams:{page:1, rows:10},//分页参数，可从外部传入 进行更改
                _params:_params,
                visitDomain:"",
                rowsObjs:null,//row对象
                columns:[],//表格行数据
                detailsColumn:[],//表格行详情数据
                imgFiled:"",//表格详情 图片字段
                operation:true,//是否展示表格操作列
                isDeleteRows:true,
                onLoadSuccess:null,//数据加载成功事件
                onClick:null,//单元格单击事件 可扩展
                dbOnClick:null,//单元格双击事件 可扩展
                deleteFn:null,//删除单行函数 可扩展
                deleteRowsFn:null//批量删除行函数 可扩展

            };
            if(typeof (options)=="object"){
                $($table).addClass("area");
                $($table).data("setting")?function(){_default= $.extend($($table).data("setting"),options)}():function(){_default=$.extend(_default,options);$($table).data("setting",_default)}();
                _default.queryParams.rows=_default.pageParams.rows;
                _default.queryParams.page=_default.pageParams.page;
                $.gridInit.init_template($table);
                var _th='<th class="data-check-box-thead"></th>';
                var _colums;
                var details_colum=_default.detailsColumn;
                if(_default.columns.length>0){
                    _colums=_default.columns;
                    for(var i=0;i<_colums.length;i++){
                        _th+='<th>'+_colums[i].title+'</th>';
                    }
                    if(_default.operation){
                        _th+='<th>操作</th>';
                    }
                    //_th+='<th style="width: 12px;"></th>'
                    var _thead= $($table).find("._thead");
                    $(_thead).children("tr").append($(_th));
                    var th_Array= $(_thead).find("th");
                    $($table).find(".loading-div").show();
                    $($table).find("._tbody td.data-table-area").attr("colspan",$($table).find("._thead").find("tr:first th").length)
                    if($($table).find("._tfoot").length == 0){
                        $($table).append("<tfoot class='_tfoot' valign='bottom'><tr><td style='padding: 0px;' colspan='"+$($table).find("._thead").find("tr:first th").length+"'><td></tr></tfoot>")
                    }
                    $($table).find(".data-table > td:not(.data-table-area)").remove()
                    $.gridPage.create_empty_page($($table))
                    // 计算表头宽度调整,在未加载数据前填充至整个区域
                    $($table).find(".data-check-box-tr,.data-check-box-thead").css("width","5%");
                    var cols_len = _thead.find("th").length-2;
                    $($table).find("th:not(.data-check-box-thead),td:not(.data-check-box-tr)").css("width",((100-5)/cols_len)+"%")
                    $($table).find("._tbody,.data-div").css("height",($($table).parent().height()-100)+"px");
                    $.post(_default.url,_default.queryParams,function(data){
                            var _rows=data.rows;
                            if(_rows.length>0){
                                $($table).data("_table",_rows);
                                for(var i=0;i<_rows.length;i++){
                                    var rowIndex=parseInt(i+1);
                                    var tr_template='<tr class="_summary" rowIndex="'+rowIndex+'"><td class="data-check-box-tr"><span class="icon _checktd"></span></td>';
                                    if(rowIndex%2==0){
                                        tr_template='<tr class="blue-bg _summary" rowIndex="'+rowIndex+'"><td class="data-check-box-tr"><span class="icon _checktd" ></span></td>';
                                    }
                                    var _td='<td style="display: none" filedId="true"><input type="hidden"  value="'+_rows[i][_default.filedId]+'"></td>';
                                    for(var j=0;j<_colums.length;j++){
                                        for(var key in _rows[i]){
                                            if(_colums[j].filed==key){
                                                if(_colums[j].formatter){
                                                    var formatFn=_colums[j].formatter;
                                                    var tdValue=formatFn(_rows[i],_rows[i][key],rowIndex);
                                                    _td+='<td filed="">'+tdValue+'</td>';
                                                }else{
                                                    _td+='<td filed="">'+_rows[i][key]+'</td>';
                                                }
                                            }
                                        }
                                    };
                                    tr_template+=_td;
                                    if(_default.operation){
                                        tr_template+='<td class="oper-btn">'+
                                            '<a href="#" class="list-down icon grid_updown"></a>'+
                                            '<a href="#" class="del icon _delete_tr"></a>'+
                                            '</td>';
                                    }
                                    tr_template+='</tr>';
                                    var details_tr='';
                                    if(details_colum.length>0) {
                                        details_tr = '<tr style="display: none" class="_details_tr"><td colspan="' + parseInt(th_Array.length + 1) + '"><div class="details-box clearfix">' +
                                        '<div class="fl details-img">';
                                        if (rowIndex % 2 == 0) {
                                            details_tr = '<tr class="blue-bg _details_tr" style="display: none"><td colspan="' + parseInt(th_Array.length + 1) + '"><div class="details-box clearfix">' +
                                            '<div class="fl details-img">';
                                        }
                                        if (_rows[i][_default.imgFiled]) {
                                            if(_default.visitDomain){
                                                details_tr += '<img src="'+_default.visitDomain + _rows[i][_default.imgFiled] + '" alt=""/>'
                                            }else{
                                                details_tr += '<img src="'+ _rows[i][_default.imgFiled] + '" alt=""/>'
                                            }
                                        } else {
                                            details_tr += '<img src="/css/mainFrame/img/img-bg.png" alt=""/>'
                                        }
                                        var op_p = '<p>';
                                        //******详情 库存 折扣******//
                                        if (_rows[i]["isStore"]) {
                                            op_p += '<span class="icon kc rel store_icon "><em class="abs" style="display:none;">库存管理</em></span>'
                                        } else {
                                            op_p += '<span class="icon kc-no rel store_icon"><em class="abs" style="display:none;">库存管理</em></span>'
                                        }
                                        if (_rows[i]["isDsc"]) {
                                            op_p += '<span class="icon zk rel dsc_icon"><em class="abs" style="display:none;">允许折扣</em></span>';
                                        } else {
                                            op_p += '<span class="icon zk-no rel dsc_icon"><em class="abs" style="display:none;">允许折扣</em></span>';
                                        }
                                        op_p += '<span class="icon ph-no rel ph_icon"><em class="abs" style="display:none;">配货管理</em></span> </p>';
                                        op_p += '<span style="display: none;position: relative;left: 0px" class="store_name"></span>';
                                        details_tr += op_p;
                                        details_tr += '</div>' +
                                        '<div class="fl details-txt">';
                                        var p = '';
                                        for (var c = 0; c < details_colum.length; c++) {
                                            for (var k in _rows[i]) {
                                                if (details_colum[c].filed == k) {
                                                    if (details_colum[c].formatter) {
                                                        var formatsFn = details_colum[c].formatter;
                                                        var result = formatsFn(_rows[i], _rows[i][k], rowIndex);
                                                        if(k=="spec"){
                                                            p += '<p style="line-height: 22px">' + details_colum[c].title + ':' + result + '</p>';
                                                        }else{
                                                            p += '<p>' + details_colum[c].title + ':' + result + '</p>';
                                                        }
                                                    } else {
                                                        p += '<p>' + details_colum[c].title + ':' + _rows[i][k] + '</p>';

                                                    }
                                                }
                                            }
                                        };
                                        details_tr += p;
                                        details_tr += '</div>' +
                                        '</div></td></tr>';

                                        tr_template += details_tr;
                                    }
                                        $($table).find("._tbody table").append(tr_template);
                                    }
                            }else{

                            }
                            $($table).find(".loading-div").hide();
                            // 表格的表头和表格内容宽度统一调整,使其位置统一
                            var $data_tr = $($table).find("._tbody td.data-table-area").find("tr:first");
                            $($table).find(".data-check-box-tr,.data-check-box-thead").css("width","5%");
                            if($data_tr.length>0){
                                var cols_len = $data_tr.find("td").length - 2;
                                $($table).find("th:not(.data-check-box-thead),td:not(.data-check-box-tr)").css("width",((100-5)/cols_len)+"%")
                            }
                            //************数据加载完成后进行分页********************//
                            if(!$($table).data("isPage")){
                                var total=data.total;//数据总数
                                var pages=_default.pageParams.rows;//一页显示多少条数据
                                $.gridPage.init_pageTemplate($table,total,pages);
                                if(!_default.isDeleteRows){
                                    $($table).find(".delete_rows").hide();
                                }
                            }
                            //************表格加载完成后  绑定相应事件**************//
                            var grid_down=$($table).find(".grid_updown");
                            $(grid_down).click(function(){
                                if($(this).hasClass("list-up")){
                                    $(this).removeClass("list-up").addClass("list-down");
                                    $(this).parents("._summary").next("._details_tr").hide();
                                }else if($(this).hasClass("list-down")){
                                    $(".grid_updown").removeClass("list-up").addClass("list-down");
                                    $("._details_tr").hide();
                                    $(this).removeClass("list-down").addClass("list-up");
                                    $(this).parents("._summary").next("._details_tr").show();
                                }
                            });
                            var $tr= $($table).find("._summary");
                            $($tr).click(function(){
                                var table_id=$(this).parents("._tbody").parent("table").attr("id");
                                var _span=$(this).find("._checktd");
                                if($(_span).hasClass("choose")){
                                    $(_span).removeClass("choose");
                                }else{
                                    if(_default.singleSelect){
                                        $($("#"+table_id).find("._checktd")).removeClass("choose");
                                        $(_span).addClass("choose");
                                    }else{
                                        $(_span).addClass("choose");
                                    }
                                }
                                if(_default.onClick){
                                    _default.onClick();
                                }
                            });
                            $($tr).dblclick(function(){
                                var table_id=$(this).parents("._tbody").parent("table").attr("id");
                                var _span=$(this).find("._checktd");
                                if($(_span).hasClass("choose")){
                                    $(_span).removeClass("choose");
                                }else{
                                    if(_default.singleSelect){
                                        $($("#"+table_id).find("._checktd")).removeClass("choose");
                                        $(_span).addClass("choose");
                                    }else{
                                        $(_span).addClass("choose");
                                    }
                                }
                                if(_default.dbOnClick){
                                    _default.dbOnClick();
                                }

                            });
                            $("._delete_tr").click(function(){
                                if(_default.deleteFn){
                                    var row_id=$(this).parents("._summary").find("td[filedId='true']").find("input").val();
                                    _default.deleteFn(row_id);
                                }
                            });
                            $(".delete_rows").click(function(){
                                if(_default.deleteRowsFn){
                                    _default.deleteRowsFn();
                                }

                        });
                        /**
                         * 表格加载成功事件
                         */
                        if(_default.onLoadSuccess){
                            _default.onLoadSuccess()
                        };
                        $(".store_icon").hover(function(){
                            if( $(this).hasClass("kc")||$(this).hasClass("kc-no")){
                                //$(".store_name").text("库存");
                                //$(".store_name").slideDown().stop(true);
                                $(this).find(".abs").show();
                            }


                        },function(){
                            //$(".store_name").text("");
                            //$(".store_name").slideUp().stop(true);
                            $(this).find(".abs").hide();
                        });
                        $(".dsc_icon").hover(function(){
                            if($(this).hasClass("zk")||$(this).hasClass("zk-no")){
                                //$(".store_name").text("折扣");
                                //$(".store_name").slideDown().stop(true);
                                $(this).find(".abs").show();
                            }
                        },function(){
                            $(this).find(".abs").hide();
                        });
                        $(".ph_icon").hover(function(){
                            if($(this).hasClass("ph")||$(this).hasClass("ph-no")){
                                //$(".store_name").text("配货");
                                //$(".store_name").slideDown().stop(true);
                                $(this).find(".abs").show();
                            }
                        },function(){
                            $(this).find(".abs").hide();
                        })
                    },"json")
                };
            }
            if(typeof (options)=="string"){
                if(options=="getSelected"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    var _row=$.gridMethod.getSelected(setting);
                    return _row;
                }
                if(options=="getSelections"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    var rows= $.gridMethod.getSelections(setting);
                    return rows;
                }
                if(options=="reload"){
                    $($table).data("isPage",false);
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    $.gridMethod.reload(setting);
                }
                if(options=="getRowsNumber"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    var length=$.gridMethod.getRowsNumber(setting);
                    return length;
                }
            }
        }

    });
    $.extend({
        gridInit:{
            /**
             * 表格head和body模板
             */
            table_template:
                        "<thead class='_thead'>" +
                            "<tr></tr>" +
                        "</thead>" +
                        "<tbody class='_tbody'>" +
                            "<tr class='data-table'>" +
                                "<td style='vertical-align: top;padding: 0px' class='data-table-area' >" +
                                    "<div class='data-div' style='width: 100%;height: 100%;overflow: auto;position: relative'>" +
                                        "<table style='width: 100%;'></table>" +
                                        "<div class='loading-div' style='width: 100%;height: 100%;overflow: hidden;background-color:white;position:absolute;display:none;z-index:9000;top: 0px;;opacity:0.5;filter:alpha(opacity=50);-moz-opacity:0.5;'>" +
                                                "<img src='"+ _loading_gif +"' style='height: 48px;width: 48px;position: absolute;top: 40%;left: 48%;' />" +
                                        "</div>" +
                                    "</div>" +
                                "<td>" +
                            "</tr>" +
                        "</tbody>",
            /**
             * 初始化表格head和body
             * @param ob
             */
            init_template:function(ob){
                var _thead=$(ob).find("._thead");
                var _tbody=$(ob).find("._tbody");
                if($(_thead).length==0&&$(_tbody).length==0){
                    $(ob).append($.gridInit.table_template);
                }else{
                    $(_thead).remove();
                    $(_tbody).remove();
                    $(ob).append($.gridInit.table_template);
                }
            }
        },
        gridMethod:{
            deleteGrid:function(fileId){

            },
            /**
             * 重新加载表格
             * @param ob
             */
            reload:function(ob){
                var selector=ob.table_selector;
                $(selector).commongrid(ob);
            },
            /**
             * 得到选中单行对象
             * @param obj
             * @returns {*}
             */
            getSelected:function(obj){
                var tableobj=obj.table_selector;
                var checkeds=$(tableobj).find(".choose");
                if(checkeds.length>1||checkeds.length==0){
                    //alert("请选择一条数据！");
                }else{
                    var rowId=$(checkeds[0]).parents("._summary").find("td[filedId='true']").find("input").val();
                    //alert(rowId);
                    var rows=obj.rowsObjs;
                    for(var k in rows){
                        if(rows[k][obj.filedId]==rowId){
                            return rows[k];
                        }
                    }
                }
            },
            /**
             * 得到多行对象
             * @param obj
             * @returns {Array}
             */
            getSelections:function(obj) {
                var tableobj = obj.table_selector;
                var rows = obj.rowsObjs;
                var checkeds = $(tableobj).find(".choose");
                var rowArray=[];
                for(var i=0;i<checkeds.length;i++){
                    var rowId = $(checkeds[i]).parents("._summary").find("td[filedId='true']").find("input").val();
                    for (var k in rows) {
                        if (rows[k][obj.filedId] == rowId) {
                            rowArray.push(rows[k]);
                        }
                    }
                }
                return rowArray;
            },
            //*****获取选中的行的数量****//
            getRowsNumber:function(ob){
                var table_obj = ob.table_selector;
                var checked_rows = $(table_obj).find(".choose");
                var chooseLength=checked_rows.length;
                return chooseLength;
            }
        },
        gridPage:{
            /**
             * 分页模板
             */
            grid_page_template:
                '<div  class="table-foot clearfix pageDiv">'+
                    '<div class="fl table-foot-btn">'+
                        '<input type="button" value="批量删除" class="all-del icon delete_rows">'+
                    '</div>'+
                    '<div class="fr table-foot-page">'+
                        '<ul class="clearfix">'+
                            '<li class="first_li"><a href="#" class="icon left" onclick="$.gridPage.prevPage(this)"></a></li>'+
                            '<li class="last_li"><a href="#" class="icon right" onclick="$.gridPage.nextPage(this)"></a></li>'+
                        '</ul>'+
                    '</div>'+
                '</div>',
            create_empty_page : function(obj){
                if($(obj).find("._tfoot td").is(":empty")){
                    $(obj).find("._tfoot td").empty().append($.gridPage.grid_page_template);
                    $(obj).find("._tfoot td:not([colspan])").remove();
                }
            },
            /**
             * 初始化 分页模板
             * @param obj
             * @param total
             * @param rows
             */
            init_pageTemplate:function(obj,total,rows){
                var $page_tem=$(obj).find(".pageDiv");
                if($page_tem.length==0){
                    $page_tem=$.gridPage.grid_page_template;
                    $(obj).find("._tfoot td").append($page_tem);
                    $.gridPage.page(obj,total,rows)
                }else{
                    $($page_tem).remove();
                    $page_tem=$.gridPage.grid_page_template;
                    $(obj).find("._tfoot td").append($page_tem);
                    $.gridPage.page(obj,total,rows)
                }
                $(obj).find("._tfoot td:not([colspan])").remove();
            },
            /**
             * 得到分页数据
             * @param total  总数
             * @param rows 每页显示的数据
             */
            page:function(obj,total,rows){
                var $pageDiv=$(obj).find(".pageDiv");
                var pageIndex=0;
                if(total<=rows){
                    pageIndex+=1;
                    $pageDiv.find(".first_li").after("<li pageId='page0'><a href='javascript:void(0)' pageValue='1' class='pageA' onclick='$.gridPage.clickPage(this)'>1</a></li>");
                }else{
                    if(total%rows==0){
                        pageIndex=total/rows;
                        if(pageIndex>6){
                            $pageDiv.data("is_center","true");
                            for(var i=1;i<=pageIndex;i++){
                                if(i==1){
                                    $pageDiv.find(".first_li").after("<li pageId='page"+i+"' class='page_li'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)'>"+i+"</a></li>");
                                }else{
                                    var p=i-1;
                                    if(3<i<pageIndex-2){
                                        $pageDiv.find("[pageId='page"+p+"']").after("<li pageId='page"+i+"' style='display:none' class='page_li'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA pageHide' onclick='$.gridPage.clickPage(this)' >"+i+"</a></li>");
                                    }else{
                                        $pageDiv.find("[pageId='page"+p+"']").after("<li pageId='page"+i+"' class='page_li'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)' >"+i+"</a></li>");
                                    }
                                }
                            }
                            $pageDiv.find("[pageId='"+(pageIndex-3)+"']").after('<li><span class="icon center is_center"></span></li>');
                        }else{
                            for(var i=1;i<=pageIndex;i++){
                                if(i==1){
                                    $pageDiv.find(".first_li").after("<li pageId='page"+i+"' class='page_li'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)'>"+i+"</a></li>");
                                }else{
                                    var p=i-1;
                                    $pageDiv.find("[pageId='page"+p+"']").after("<li pageId='page"+i+"' class='page_li'><a href='javascript:void(0)' pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)' >"+i+"</a></li>");
                                }
                            }
                        }
                    }
                    else{
                        pageIndex=Math.ceil(total/rows);
                        for(var i=1;i<=pageIndex;i++){
                            if(i==1){
                                $pageDiv.find(".first_li").after("<li  pageId='page"+i+"'><a href='javascript:void(0)' pageValue='"+i+"' class='pageA' onclick='$.gridPage.clickPage(this)' >"+i+"</a></li>");
                            }else{
                                var p=i-1;
                                $pageDiv.find("[pageid='page"+p+"']").after("<li pageId='page"+i+"'><a href='javascript:void(0)' pageValue='"+i+"' class='pageA' onclick='$.gridPage.clickPage(this)' >"+i+"</a></li>");
                            }
                        }
                    }
                }
                $pageDiv.find(".last_li").after('<li>共'+pageIndex+'页，'+total+'条数据</li>');
            },
            /**
             * 点击单页函数
             * @param obj
             */
            clickPage:function(obj){
                var $pageDiv=$(obj).parents(".pageDiv");
                var $pageA=$($pageDiv.find(".pageA"));
                $pageA.each(function(i,e){
                    $(e).css({"background-color":"",color:""});
                    $(e).attr("pgSelect","false");
                });
                $(obj).attr("pgSelect","true");
                var page=$(obj).attr("pageValue");
                $.gridPage.pageOperate($pageDiv,obj,page);
                $(obj).css({"background-color":"#00aaee","color":"#fff"});
                $.gridPage.gridPageSearch(obj,page);
            },
            /**
             * 点击向前翻页函数
             * @param obj
             */
            prevPage:function(obj){
                var $pageDiv=$(obj).parents(".pageDiv");
                var $pageA=$($pageDiv.find(".pageA"));
                $pageA.each(function(i,e){
                    $(e).css({"background-color":"",color:""});
                    var select_value=$(e).attr("pgSelect");
                    if(select_value=="true"){
                        var page_value=$(e).attr("pageValue");
                        if(page_value=="1"){
                            $(e).css({"background-color":"#00aaee",color:"#fff"});
                            return false;
                        }
                        var prev_a=$(e).parent().prev().find("a");
                        $.gridPage.pageOperate($pageDiv,obj,page_value,true);
                        $(prev_a).css({"background-color":"#00aaee","color":"#fff"});
                        $(prev_a).attr("pgSelect","true");
                        $(e).attr("pgSelect","false");
                        $.gridPage.gridPageSearch(obj,parseInt(page_value)-1);
                        return false;
                    }
                })
            },
            /**
             * 点击向后翻页函数
             * @param obj
             */
            nextPage:function(obj){
                var $pageDiv=$(obj).parents(".pageDiv");
                var $pageA=$($pageDiv.find(".pageA"));
                $pageA.each(function(i,e){
                    $(e).css({"background-color":"",color:""});
                    var select_value=$(e).attr("pgSelect");
                    if(select_value=="true"){
                        if($(e).parent().next().attr("pageId")==undefined){
                            $(e).css({"background-color":"#00aaee","color":"#fff"});
                            return false;
                        }
                        var page_value=$(e).attr("pageValue");
                        var next_a=$(e).parent().next().find("a");
                        $.gridPage.pageOperate($pageDiv,obj,page_value,false);
                        $(next_a).css({"background-color":"#00aaee","color":"#fff"});
                        $(next_a).attr("pgSelect","true");
                        $(e).attr("pgSelect","false");
                        $.gridPage.gridPageSearch(obj,parseInt(page_value)+1);
                        return false;
                    }
                })
            },
            /**
             * 点击分页查询数据表格方法
             * @param pageObj
             * @param page
             * @param row
             */
            gridPageSearch:function(obj,page,row){
                var _row=parseInt(row?row:10);
                var pageObj=$(obj).parents(".pageDiv");
                var table_obj= $(pageObj).parents("table").attr("id");
                $("#"+table_obj).data("isPage",true);
                $("#"+table_obj).commongrid({
                    pageParams:{
                        page:page,
                        rows:_row
                    }
                })
            },
            /**
             * 分页操作
             * @param pageDiv
             * @param obj
             * @param page
             */
            pageOperate:function(page_Div,obj,page,isPrev){
                var pageDiv=$(obj).parents(".pageDiv");
                if($(pageDiv).data("is_center")=="true"){
                    var _center=$(pageDiv).find(".is_center");
                    var parent_li=$(obj).parent("li");
                    var center_next=$(_center).next("li");
                    var center_next_val=parseInt($(center_next).find("a").attr("pageValue"));
                    //var center_prev=$(_center).prev("li");
                    //var center_prev_val=parseInt($(center_prev).find("a").attr("pageValue"));
                    var next_li= $(parent_li).next(".page_li");
                    var next_li_val=parseInt($(next_li).find("a").attr("pageValue"));
                    var prev_li_list=$(_center).prevAll().filter(".page_li,:visible");
                    var page_first_li=$(prev_li_list).filter(":first");
                    var prev_li_last=$(prev_li_list).filter(":last");
                    var next_li_list=$(_center).nextAll().filter(".page_li,:visible");
                    var page_last_li=$(next_li_list).filter(":last");
                    if($(_center).is(":visible")){
                        $(prev_li_list).each(function(i,e){
                            if($(e).attr("pageValue")==page){
                                if($(next_li).is(":hidden")){
                                    $(page_first_li).hide();
                                    $(next_li).show();
                                    if(next_li_val+1==center_next_val){
                                        $(_center).hide();
                                    }
                                }
                                var parent_li_prev=$(parent_li).prev(".page_li");
                                $(parent_li_prev).is(":hidden")?function(){
                                    $(parent_li_prev).show();
                                    $(_center).is(":hidden")?$(_center).show():null;
                                    $(prev_li_last).hide();
                                }():null;
                            }
                        });
                        if(isPrev){
                            $(next_li_list).each(function(i,e){
                                if($(e).attr("pageValue")==page_value){
                                    var prev_li=$(e).parent().prev("li");
                                    if($(prev_li).hasClass("is_center")){
                                        var center_prev_li=$(_center).prev("li");
                                        var center_left_li=$(center_prev_li).prev("li");
                                        $(center_prev_li).is(":hidden")?$(_center).prev("li").show():null;
                                        $(page_last_li).hide();
                                        $(center_left_li).is(":hidden")?function(){
                                            $(_center).remove() ;
                                            $(center_prev_li).before('<li><span class="icon center is_center"></span></li>')
                                        }():function(){$(_center).hide();}();
                                    }
                                }
                            });
                        }else{
                            $(next_li_list).each(function(i,e){
                                if($(e).attr("pageValue")==page_value){
                                    var next_li=$(e).parent().next(".page_li");
                                    var center_li=$(next_li).next("li");
                                    if($(next_li).is(":hidden")){
                                        $(page_first_li).hide();
                                        $(next_li).show();
                                        if($(center_li).hasClass("is_center")){
                                            $(_center).hide();
                                        }
                                    }
                                }
                            });
                        }


                        //$(next_li_list).each(function(i,e){
                        //    if($(e).attr("pageValue")==page){
                        //        if($(next_li).is(":hidden")){
                        //            $(page_first_li).hide();
                        //            $(next_li).show();
                        //            if(next_li_val+1==center_next_val){
                        //                $(_center).hide();
                        //            }
                        //        }
                        //        var parent_li_prev=$(parent_li).prev(".page_li");
                        //        $(parent_li_prev).is(":hidden")?function(){
                        //            $(parent_li_prev).show();
                        //            $(_center).show();
                        //            $(_center).prev("li").hide();
                        //        }():null;
                        //    }
                        //})


                    }else{
                        $(prev_li_list).each(function(i,e){
                            if($(e).attr("pageValue")==page){
                                var parent_li_prev=$(parent_li).prev(".page_li");
                                $(parent_li_prev).is(":hidden")?function(){
                                    $(parent_li_prev).show();
                                    $(_center).is(":hidden")?$(_center).show():null;
                                    $(prev_li_last).hide();
                                }():null;
                            }
                        });
                    }
                }
            }
        },


        //***********提示消息组件********//
        message:{
            msg_template:'<div class="popup-box msg_alert" style="display: none;" id="delDialog">'+
                            '<h4 class="rel">'+
                            '系统提示'+
                            '<i class="abs icon" onclick="reLoadGoods()"></i>'+
                            '</h4>'+
                            '<p class="popup-box-txt"></p>'+
                            '<p class="popup-box-btn">'+
                            '<input type="button" value="确 定" class="sure success_Btn" id="delSuccessBtn" >'+
                             '<input type="button" value="取 消" id="delfailBtn"></p></div>',

            init:function(){
                var _alert=$(".msg_alert");
                if(_alert.length==0){
                    _alert= $.message.msg_template;
                    $("body").append(_alert);
                }
            },
            alert:function(msg,fn){

            },
            confirm:function(){

            },
            sure:function(fn){
                if(fn){
                    $(".success_Btn").bind("click",function(){
                        fn();
                    })
                }
            },
            cancel:function(){

            }

        }
    });
})(jQuery);





