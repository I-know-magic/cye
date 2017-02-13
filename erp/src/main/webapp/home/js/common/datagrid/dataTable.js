/**
 * Created by LiuJie on 2016/3/2.
 */
;(function($){
    /**
     * 自定义零售的表格
     * @param options//页面传入对象
     * @param _params//传入参数
     */
    $.fn.dataTable=function(options,_params){
        var $table=this.selector;//表格对象
        /***表格默认属性***/
        var _default={
            filedId:"id",//默认对象Id
            url:"",//请求后台url
            table_selector:$table,//表格对象
            rownumber:false,//是否显示行号 默认显示 true  false:不显示
            checkrow:true,//是否显示单行复选框 true：显示  false：不显示
            singleSelect:false,//是否单选，默认多选
            dynamicColspan:null,//动态合并列：针对于动态加载支付方式  备注：严重损害我的表格，以后再也不这样玩了，，，，
            editor:false,
            queryParams:{},//查询数据参数,需要外部传入
            pageParams:{page:1, rows:10},//分页参数，可从外部传入 进行更改
            pagination:true,//是否展示分页
            _params:_params,
            rowsObjs:null,//row对象
            data:[],//本地数据
            columns:[],//表格行数据
            operations:[],
            footer:{showFooter:false,idKey:'',foots:[]},
            isDeleteRows:false,//是否展示删除操作列
            spanColumns:[],//需要合并的表头
            onLoadSuccess:null,//数据加载成功事件
            onClick:null,//单元格单击事件 可扩展
            dbOnClick:null,//单元格双击事件 可扩展
            onDelete:null//批量删除行函数 可扩展
        };
        //传入参数为对象，则加载列表
        if(typeof (options)=="object"){
            //设置列表的参数
            $($table).data("setting")?function(){
                _default= $.extend($($table).data("setting"),options)
            }():function(){
                _default=$.extend(_default,options);$($table).data("setting",_default)
            }();
            if(_default.pagination){
                _default.queryParams.rows=_default.pageParams.rows;
                _default.queryParams.page=_default.pageParams.page;
            }
            //初始化列表的thead和tbody
            $.gridMethod.initTable($table);
            if(!_default.editor){
                $.gridMethod.createTable($table,_default);
            }else{
                $.gridMethod.createEditTable($table,_default);
            }

        }
        //*********表格相关操作**********//
        if(typeof (options)=="string"){
                //获取选中行方法
                if(options=="getSelected"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    var _row=$.gridMethod.getSelected(setting);
                    return _row;
                }
                //获取选中多行操作
                if(options=="getSelections"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    var rows= $.gridMethod.getSelections(setting);
                    return rows;
                }
                //重新加载表格方法
                if(options=="reload"){
                    $($table).data("isPage",false);
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.pageParams.page=1;
                    setting.pageParams.rows=10;
                    $.gridMethod.reload(setting);
                }
                //获取表格总行数
                if(options=="getRowsNumber"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    var length=$.gridMethod.getRowsNumber(setting);
                    return length;
                }
                //对表格进行查询操作
                if(options=="search"){
                    $($table).data("isPage",false);
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.queryParams = {};
                    for(var key in _params){
                        setting.queryParams[""+key]=_params[key];
                    }
                    if(_params.url){
                        setting.url = _params.url;
                    }
                    $($table).dataTable(setting);
                }
                //获取当前页数以及当前页应显示多少条数据
                if(options=="getPager"){
                    var $page={pager:1,rows:10};
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    $page.pager=setting.pageParams.page;
                    $page.rows=setting.pageParams.rows;
                    return $page
                }
                //获取当前页数以及当前页应显示多少条数据
                if(options=="load"){
                    $($table).data("isPage",false);
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.pageParams.page=1;
                    setting.pageParams.rows=10;
                    setting.data=_params;
                    $.gridMethod.loadLocalData(setting);
                }
                //获取当前页数以及当前页应显示多少条数据
                if(options=="getRows"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    var _row=$.gridMethod.getRows(setting);
                    return _row;
                }
                //获取当前页数以及当前页应显示多少条数据
                if(options=="selectionRow"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    $.gridMethod.selectionRow(setting,_params);
                }
                //获取编辑行的数据
                if(options=="getEditRowData"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    return $.gridMethod.getEditRowData(setting,_params);
                }
                //重新加载表格方法
                if(options=="deleteRowById"){
                    $($table).data("isPage",false);
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.pageParams.page=1;
                    setting.pageParams.rows=10;
                    $.gridMethod.deleteRowById(setting,_params);
                }
                //全部选中表格
                if(options=="selectAll"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    $.gridMethod.selectAll(setting,_params);
                }
                //取消全部选中表格
                if(options=="cancelSelectAll"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    $.gridMethod.cancelSelectAll(setting,_params);
                }
                //得到行对象
                if(options=="getRow"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    return $.gridMethod.getRow(setting,_params);
                }
                if(options=="getFooter"){
                    var setting=$($table).data("setting")?$($table).data("setting"):_default;
                    setting.rowsObjs= $($table).data("_table");
                    return $.gridMethod.getFooter(setting,_params);
                }
        }


    };
    //*********扩展编辑表格校验方法***************//
    $.fn.validateTable=function(fn){
        var $table=this.selector;//表格对象
        var edit_inputs=$($table).find(":text");
        if(edit_inputs && edit_inputs.length>0){
                for(var e = 0;e<edit_inputs.length;e++){
                      var validates = $(edit_inputs[e]).attr("validation");
                      var validname = $(edit_inputs[e]).attr("filed-role");
                      var valids =  validates.split(",");
                      if(valids && valids.length>0){
                            for(var v = 0;v<valids.length;v++){
                                var rule=valids[v].split("[");
                                var rule_name;//规则名称
                                var rule_params=[];//需要传入的规则的参数
                                if(rule.length>1){
                                    var r_array;
                                    rule_name=rule[0];
                                    r_array=rule[1].split("]");
                                    if(r_array[0].indexOf(";")!=-1){
                                        var p_array = r_array[0].split(";");
                                        if(p_array && p_array.length>0){
                                            for(var p in p_array){
                                                rule_params.push(parseFloat(p_array[p]).toFixed(2));
                                            }
                                        }
                                    }else{
                                        var _p=parseFloat(r_array[0]).toFixed(2);
                                        rule_params.push(_p);
                                    }

                                }else{
                                    rule_name=rule[0];
                                }
                                var $validate = $validateRules[rule_name];
                                if($validate && $validate.validator){
                                    var validate_fn = $validate.validator;
                                    var _value = $(edit_inputs[e]).val();
                                    var result;
                                    if(rule_params.length>0){
                                        result = validate_fn(_value,rule_params);
                                    }else{
                                        result = validate_fn(_value);
                                    }
                                    if(!result){
                                        var msg=$validate.message;
                                        var _message;
                                        if(msg.indexOf("]")!=-1){
                                            var msg_rs = msg.split("]");
                                            if(msg_rs && msg_rs.length>0){
                                                if(msg_rs[1]){
                                                    _message = validname+msg_rs[1];
                                                }else{
                                                    _message = validname+msg_rs[0];
                                                }
                                            }
                                        }
                                        if(msg.indexOf("}")!=-1){
                                            _message = msg;
                                            for(var k in rule_params){
                                                _message = _message.replaceAll("\\{"+k+"\\}",rule_params[k]);
                                            }
                                            _message = validname+_message;
                                        }
                                        if($("#error-box") && $("#error-box").length==0){
                                            $("body").find("div.wrap").append($.validateTemplate)
                                        }
                                        $("#error-box").show();
                                        $("#content-box").text(_message);
                                        setTimeout(function(){
                                            if($("#error-box").is(":visible")){
                                                $("#error-box").hide();
                                            }
                                        },3000);
                                        return false;
                                    }
                                }
                            }
                      }
                }
            fn();
        }else{
            $.message.alert("您还没有选择任何商品！");
        }
    };
    //********所有关于表格的操作************//
    $.extend({
        //****************表格模板（可根据UI变化而替换）*****************//
            gridTemplate:{
                tableTemplate: "<thead class='_thead'>"
                +"<tr class='mainHead'></tr>"
                +"</thead>"
                +"<tbody class='_tbody'>"
                +"</tbody>",
                trOddTemplate:'<tr class="_summary" rowIndex="" filedId=""></tr>',
                trEvenTemplate:'<tr class="table-color _summary" rowIndex="" filedId=""></tr>',
                tdTemplate:'<td filed=""></td>',
                thTemplate:'<th></th>',
                tfootTemplate:'<tr class="table-page-box _tfoot">'
                +'</tr>',
                delTemplate:'<span class="icon del delete_rows"></span>',

                tableTotalTemplate:'<tr class="table-total footer_total">'
                +'</tr>',
                check_td_tem:'<td idkey="checkbox"><span class="icon choice-box check_box"></span></td>'
                },
            editGrid:{
                /**
                 * 获取编辑表格的模板
                 * @param type
                 * @returns {string}
                 */
                getTemByType:function(type){
                    var t=type?type:"text";
                    var array=["text"];
                    var _template=['<span style="display: none"></span><input type="text">'];
                    for(var a in array){
                        if(t==array[a]){
                            return _template[a];
                        }
                    }
                },

                getValueType:function(val,valType){
                    if(!valType){
                        return val;
                    }
                    if(null == val && val==undefined){
                        return val;
                    }
                    var _valTypes=["int","float"];
                    var _valMethods=[parseInt,parseFloat];
                    for(var n in _valTypes ){
                        if(valType[0]==_valTypes[n]){
                            if(valType[1]){
                                return _valMethods[n](val).toFixed(valType[1]);
                            }
                            return _valMethods[n](val)
                        }
                    }

                    return val;
                }

            },
        //****************表格相关的方法 对象*****************//
            gridMethod:{
                /**
                 * 初始化表格
                 * @param table
                 */
                initTable:function(table){
                    var _thead=$(table).find("._thead");
                    var _tbody=$(table).find("._tbody");
                    if($(_thead).length==0&&$(_tbody).length==0){
                        $(table).append($.gridTemplate.tableTemplate);
                    }else{
                        $(_thead).remove();
                        $(_tbody).remove();
                        $(table).append($.gridTemplate.tableTemplate);
                    }
                },
                /**
                 * 创建列表 注：加载服务器数据
                 * @param table//table element
                 * @param param//列表参数
                 */
                createTable:function(table,param){
                    var _th= $.gridTemplate.thTemplate;//获取th模板
                    var _tfoot= $.gridTemplate.tfootTemplate;
                    var _colums;//表格列数
                    var thead_tr= $(table).find("._thead").children("tr");//获取thead中的tr
                    var tbody=$(table).find("._tbody");
                    if(param.columns.length>0){
                        _colums=param.columns;
                        //****是否显示序号*****//
                        if(param.rownumber){
                            $(thead_tr).append(_th);//向列表thead中添加th.
                        }
                        //****是否显示复选框*****//
                        if(param.checkrow){
                            $(thead_tr).append(_th);//向列表thead中添加th.
                            if(param.rownumber){
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i+2]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i+2]).text(_colums[i].title);//向th中写入表头
                                }
                            }else{
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i+1]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i+1]).text(_colums[i].title);//向th中写入表头
                                }
                            }

                        }else{
                            if(param.rownumber){
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i+1]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i+1]).text(_colums[i].title);//向th中写入表头
                                }
                            }else{
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i]).text(_colums[i].title);//向th中写入表头
                                }
                            }

                        }
                        //********需要合并的表头*******//
                        if(param.spanColumns.length>0){
                            $(thead_tr).before("<tr id='spanHead'></tr>");
                            var $span_tr = $(table).find("tr#spanHead");
                            var _spans = param.spanColumns;
                            var ths_length = $(thead_tr).find("th").length;
                            for(var s =0;s<_spans.length;s++){
                                var _span = _spans[s];
                                for(var c =0 ;c<_colums.length;c++){
                                    var span_colum = _colums[c];
                                    if(_span.filed == span_colum.filed){
                                        var c_index = $.inArray(span_colum,_colums);//获取需要合并的列的索引
                                        if(param.checkrow){
                                            c_index+=1;
                                        }
                                        if(param.rownumber){
                                            c_index+=1;
                                        }
                                        var span_ths = $span_tr.find("th");
                                        var colspan_num = 0;
                                        if(span_ths && span_ths.length>0){
                                            for(var p =0;p<span_ths.length;p++){
                                                var $span_th = $(span_ths[p]);
                                                var num = $span_th.attr("colspan");
                                                if(num){
                                                    colspan_num+=parseInt(num);
                                                }
                                            }
                                        }
                                        c_index =parseInt(c_index)- parseInt(colspan_num);
                                        if(c_index>0){
                                            $span_tr.append("<th style='background:#fbfbfb;' colspan='"+c_index+"'></th>");
                                        }
                                        $span_tr.append("<th style='padding:0 0;border-bottom:1px dashed #ccc;background:#fbfbfb;' colspan='"+_span.colspan+"'>"+_span.title+"</th>");

                                    }
                                }
                            }

                            var span_ths_num = $span_tr.find("th");
                            if(span_ths_num && span_ths_num.length>0){
                                var span_ths_length =0;
                                for(var p =0;p<span_ths_num.length;p++){
                                    var $span_th_num = $(span_ths_num[p]);
                                    var num = $span_th_num.attr("colspan");
                                    if(num){
                                        span_ths_length+=parseInt(num);
                                    }
                                }
                                if(span_ths_length < ths_length){
                                    var span_num = parseInt(ths_length) - parseInt(span_ths_length);
                                    $span_tr.append("<th style='background:#fbfbfb;' colspan='"+span_num+"'></th>");
                                }
                            }

                        }
                        //*******ajax请求后台数据*********//
                        if(param.url){
                            $.ajax({
                                url:param.url,
                                dataType:"json",
                                type:"post",
                                data:param.queryParams,
                                async:true,
                                cache: false,
                                success:function(data){
                                    if(data){
                                        var _rows;//数据
                                        var total;//数据总数
                                        var payMeants;//支付方式，只用于报表动态支付方式（暂不支持扩展，特殊列表特殊对待）
                                        var gridFooter;//针对报表合计行
                                        if(data.rows){
                                            _rows=data.rows;//获取到的服务器数据
                                            total=data.total;//数据总数
                                        }else if(data.result&&data.result=="SUCCESS"){
                                            _rows=data.data.rows;//获取到的服务器数据
                                            total=data.data.total;//数据总数
                                            if(data.data.usedPay){
                                                payMeants=data.data.usedPay;
                                            }
                                            if(data.data.sumTotal){
                                                gridFooter=data.data.sumTotal;
                                            }
                                            if(data.data.footer){
                                                gridFooter=data.data.footer;
                                            }
                                        }else{
                                            var error_tr='<tr><td style="text-align: center" colspan="'+_colums.length+'">抱歉！请求服务器数据失败 错误原因：'+data.message+'</td></tr>';
                                            $(tbody).append(error_tr);
                                            return false
                                        }
                                        if(_rows.length>0){
                                            $(table).data("_table",_rows);//将数据缓存到页面 后面会用
                                            var number_index = 0;//行序号
                                            if($(table).data("_table_columns_number") &&  $(table).data("isPage")){
                                                var y = parseInt($(table).data("_table_columns_number"));
                                                number_index = y;
                                            }
                                            for(var i=0;i<_rows.length;i++){
                                                var rowElement=_rows[i];
                                                var rowId=rowElement[param.filedId];//获取行对象的id
                                                var rowIndex=parseInt(i+1);
                                                var tr_template= $.gridTemplate.trOddTemplate;//获取奇数行模板
                                                if(rowIndex%2==0){
                                                    tr_template=$.gridTemplate.trEvenTemplate;//获取偶数行模板
                                                }
                                                //向tbody中插入tr
                                                $(tbody).append(tr_template);
                                                var table_trs=$(tbody).find("tr");//获取tbody下的行
                                                var tb_tr=table_trs[i];//
                                                $(tb_tr).attr("rowIndex",i);//对行写入行号rowIndex
                                                $(tb_tr).attr("filedId",rowId);//对行写入 对象id
                                                if(param.rownumber){
                                                    number_index+=1;
                                                    $(tb_tr).append("<td>"+parseInt(number_index)+"</td>");
                                                }
                                                if(param.checkrow){
                                                    $(tb_tr).append($.gridTemplate.check_td_tem);
                                                }
                                                //循环列数，写入td
                                                for(var k=0;k<_colums.length;k++){
                                                    var _td= $.gridTemplate.tdTemplate;//获取td模板
                                                    //循环行对象
                                                    for(var key in rowElement){
                                                        //判断行对象中的字段与cloumn中的filed相等
                                                        if(key==_colums[k].filed){
                                                            $(tb_tr).append(_td);//将添加到tr中
                                                            var tb_tds=$(tb_tr).find("td");
                                                            var tb_td = tb_tds[k];
                                                            if(param.rownumber && param.checkrow){
                                                                tb_td =  tb_tds[k+2];
                                                            }else if(param.checkrow){
                                                                tb_td =  tb_tds[k+1];
                                                            }else if(param.rownumber){
                                                                tb_td =  tb_tds[k+1];
                                                            }
                                                            if(rowElement[key]){
                                                                $(tb_td).text(rowElement[key]);//将值写入td中
                                                            }else if(rowElement[key] == 0){
                                                                $(tb_td).text("0");//将值写入td中
                                                            }else{
                                                                $(tb_td).text("");//将值写入td中
                                                            }
                                                            //如果存在格式化函数
                                                            if(_colums[k].formatter){
                                                                var formatFn=_colums[k].formatter;
                                                                var tdValue=formatFn(rowElement,rowElement[key],rowIndex);
                                                                $(tb_td).html(tdValue);
                                                            }
                                                        }
                                                    }
                                                }
                                                //******加载动态支付方式*****//
                                                if(payMeants&& payMeants.length>0){
                                                    var $span_tr;
                                                    var dy_ths_length;
                                                    if(param.dynamicColspan){
                                                        if(i==0){
                                                            $(thead_tr).before("<tr id='spanHead'></tr>");
                                                            $span_tr = $(table).find("tr#spanHead");
                                                            dy_ths_length = $(thead_tr).find("th").length;
                                                            $span_tr.append("<th style='background:#fbfbfb;' colspan='"+dy_ths_length+"'></th>");
                                                            $span_tr.append("<th style='padding:0 0;background:#fbfbfb;' colspan='"+payMeants.length+"'>"+param.dynamicColspan.title+"</th>");
                                                        }
                                                    }
                                                    for(var p = 0;p < payMeants.length;p++){
                                                        var pay=payMeants[p];
                                                        if(i==0){
                                                            $(thead_tr).append(_th);
                                                            for(var pk in pay){
                                                                var $last_th = $(thead_tr).find("th").filter(":last");
                                                                $last_th.text(pay[pk]);
                                                                $last_th.attr("filed",pk)
                                                            }

                                                        }
                                                        $(tb_tr).append(_td);//将添加到tr中
                                                        for(var pk in pay){
                                                            $(tb_tr).find("td").filter(":last").text("￥"+parseFloat(rowElement[pk]).toFixed(2));
                                                        }
                                                    }
                                                }
                                                //只针对于单纯的操作列
                                                if(param.operations && param.operations.length>0){
                                                    var operation=param.operations;
                                                    if(i==0){
                                                        $(thead_tr).append(_th);
                                                        $(thead_tr).find("th").filter(":last").text("操作").attr("colspan",operation.length);
                                                    }
                                                    for(var x=0;x<operation.length;x++){
                                                        $(tb_tr).append(_td);//将添加到tr中
                                                        var tb_td = $(tb_tr).find("td").filter(":last");
                                                        $(tb_td).text("");//将值写入td中
                                                        //如果存在格式化函数
                                                        if(operation[x].formatter){
                                                            var formatFn=operation[x].formatter;
                                                            var tdValue=formatFn(rowElement,"",rowIndex);
                                                            $(tb_td).html(tdValue);
                                                        }
                                                    }
                                                }
                                                if(param.isDeleteRows){
                                                    $(thead_tr).append(_th);
                                                    $(tb_tr).append(_td);//将添加到tr中
                                                    var tb_td=$(tb_tr).find("td").filter(":last");
                                                    $(tb_td).html($.gridTemplate.delTemplate);
                                                }
                                            }
                                            //*******展示表格底部********//
                                            if(param.footer.showFooter){
                                                $(tbody).append($.gridTemplate.tableTotalTemplate);
                                                var f_ths=$(table).find("tr.mainHead").find("th");
                                                if(f_ths && f_ths.length>0){
                                                    var tfoot_td='<td class="tl total-txt">合计</td>';
                                                    for(var f=1;f<f_ths.length;f++){
                                                        var _filed=$(f_ths[f]).attr("filed");
                                                        if(_filed){
                                                            tfoot_td+='<td class="total-nbm" filed_name="'+_filed+'"></td>';
                                                        }else{
                                                            tfoot_td+='<td class="total-nbm"></td>';
                                                        }
                                                    }
                                                    $(tbody).find(".footer_total").append(tfoot_td);
                                                    if(param.footer.foots){
                                                        var _foots = param.footer.foots;
                                                        if(_foots && _foots.length>0){
                                                            for(var t = 0;t<_foots.length;t++){
                                                                var _name=_foots[t]["name"];
                                                                if(gridFooter && gridFooter.length>0){
                                                                    var foot_value = gridFooter[0][_name];
                                                                    //foot_value = parseFloat(foot_value).toFixed(2);
                                                                    if(_foots[t]["formatter"]){
                                                                        var formatter_fn = _foots[t]["formatter"];
                                                                        foot_value = formatter_fn(foot_value);
                                                                    }
                                                                    $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_name+"']").text(foot_value);
                                                                }else if(typeof gridFooter == "object" && gridFooter){
                                                                    var foot_value = gridFooter[_name];
                                                                    //foot_value = parseFloat(foot_value).toFixed(2);
                                                                    if(_foots[t]["formatter"]){
                                                                        var formatter_fn = _foots[t]["formatter"];
                                                                        foot_value = formatter_fn(foot_value);
                                                                    }
                                                                    $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_name+"']").text(foot_value);
                                                                }
                                                            }
                                                        }else{
                                                            for(var x=1;x<f_ths.length;x++){
                                                                var _filed_name = $(f_ths[x]).attr("filed");
                                                                if(gridFooter && gridFooter.length>0){
                                                                    var foot_value = gridFooter[0][_filed_name];
                                                                    if(foot_value !=null && foot_value!="" && foot_value!=undefined && !isNaN(foot_value)){
                                                                        foot_value = "￥"+parseFloat(foot_value).toFixed(2);
                                                                        $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_filed_name+"']").text(foot_value);
                                                                    }
                                                                }else if(typeof gridFooter == "object" && gridFooter){
                                                                    var foot_value = gridFooter[_filed_name];
                                                                    if(foot_value !=null && foot_value!="" && foot_value!=undefined && !isNaN(foot_value)){
                                                                        foot_value = "￥"+parseFloat(foot_value).toFixed(2);
                                                                        $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_filed_name+"']").text(foot_value);
                                                                    }
                                                                }
                                                            }

                                                        }

                                                    }

                                                }
                                            }
                                            var table_tfoot=$(table).find("._tfoot");
                                            if(table_tfoot.length==0){
                                                $(tbody).append($.gridTemplate.tfootTemplate);
                                            }
                                            var pages=param.pageParams.rows;//一页显示多少条数据
                                            var page=param.pageParams.page;//页数
                                            var lastTh=$(table).find("th").filter(":last");
                                            var last_th_len=0;
                                            if(parseInt($(lastTh).attr("colspan"))>1){
                                                last_th_len=parseInt($(lastTh).attr("colspan"))-1;
                                            }
                                            var length=$(table).find("th").length+last_th_len;
                                            if(param.pagination){
                                                $.gridPage.init_pageTemplate(table,total,pages,page,length);
                                            }
                                            if(!param.isDeleteRows){
                                                $(table).find(".delete_rows").hide();
                                            }
                                            //}

                                            //***********绑定相关事件（可扩展）***************//
                                            var $tr= $(table).find("._summary");
                                            //点击行事件
                                            $($tr).click(function(){
                                                var table_id=$(this).parents("._tbody").parent("table").attr("id");
                                                var _span=$(this).find(".check_box");
                                                if($(_span).hasClass("choice-box-yes")){
                                                    $(_span).removeClass("choice-box-yes");
                                                }else{
                                                    if(param.singleSelect){
                                                        $($("#"+table_id).find(".check_box")).removeClass("choice-box-yes");
                                                        $(_span).addClass("choice-box-yes");
                                                    }else{
                                                        $(_span).addClass("choice-box-yes");
                                                    }
                                                }
                                                if(param.onClick&& $.isFunction(param.onClick)){
                                                    param.onClick();
                                                }
                                            });
                                            //双击行事件
                                            $($tr).dblclick(function(){
                                                var table_id=$(this).parents("._tbody").parent("table").attr("id");
                                                var _span=$(this).find(".check_box");
                                                if($(_span).hasClass("choice-box-yes")){
                                                    $(_span).removeClass("choice-box-yes");
                                                }else{
                                                    if(param.singleSelect){
                                                        $($("#"+table_id).find(".check_box")).removeClass("choice-box-yes");
                                                        $(_span).addClass("choice-box-yes");
                                                    }else{
                                                        $(_span).addClass("choice-box-yes");
                                                    }
                                                }
                                                if(param.dbOnClick&& $.isFunction(param.dbOnClick)){
                                                    param.dbOnClick();
                                                }

                                            });
                                            /**
                                             * 表格加载成功事件
                                             */
                                            if(param.onLoadSuccess && $.isFunction(param.onLoadSuccess)){
                                                param.onLoadSuccess()
                                            };
                                            /**
                                             * 封装删除行方法
                                             */
                                            if(param.isDeleteRows){
                                                var $del=$(table).find(".delete_rows");
                                                $del.bind("click",function(){
                                                    var rowId=$(this).parents("tr").attr("filedId");
                                                    if(param.onDelete && $.isFunction(param.onDelete)){
                                                        param.onDelete(rowId);
                                                    }
                                                });
                                            }
                                        }else{
                                            var cols_len = $(table).find("tr.mainHead").find("th").length;
                                            var error_tr='<tr><td style="text-align: center" colspan="'+cols_len+'">没有查询到符合条件的数据！</td></tr>';
                                            $(table).find("tbody").append(error_tr);
                                        }
                                    }else{
                                        var cols_len = $(table).find("tr.mainHead").find("th").length;
                                        var error_tr='<tr><td style="text-align: center" colspan="'+cols_len+'">没有查询到符合条件的数据！</td></tr>';
                                        $(tbody).append(error_tr);
                                    }
                                    //表格加载成功后清除传入的相关参数，防止下次请求参数重复
                                    var _p=$(table).data("setting")?$(table).data("setting"):param;
                                    _p.pageParams.rows=10;
                                    _p.pageParams.page=1;
                                    $(table).data("setting",_p);
                                },
                                error:function(XMLHttpRequest, textStatus, errorThrown){
                                    var cols_len = $(table).find("tr.mainHead").find("th");
                                    var error_tr='<tr><td style="text-align: center" colspan="'+cols_len+'">没有查询到符合条件的数据！</td></tr>';
                                    $(tbody).append(error_tr);
                                    console.log("异步请求列表数据异常:"+textStatus);
                                    throw  new Error("异步请求列表数据，服务器异常！");
                                }
                            });
                        }



                    }

                },
                /**
                 * 创建列表 注：加载本地数据
                  * @param table
                 * @param param
                 */
                createEditTable:function(table,param){
                    var _th= $.gridTemplate.thTemplate;//获取th模板
                    var _tfoot= $.gridTemplate.tfootTemplate;
                    var _colums;//表格列数
                    var thead_tr= $(table).find("._thead").children("tr");//获取thead中的tr
                    var tbody=$(table).find("._tbody");
                    if(param.columns.length>0){
                        _colums=param.columns;
                        //****是否显示序号*****//
                        if(param.rownumber){
                            $(thead_tr).append(_th);//向列表thead中添加th.
                        }
                        //****是否显示复选框*****//
                        if(param.checkrow){
                            $(thead_tr).append(_th);//向列表thead中添加th.
                            if(param.rownumber){
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i+2]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i+2]).text(_colums[i].title);//向th中写入表头
                                }
                            }else{
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i+1]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i+1]).text(_colums[i].title);//向th中写入表头
                                }
                            }

                        }else{
                            if(param.rownumber){
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i+1]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i+1]).text(_colums[i].title);//向th中写入表头
                                }
                            }else{
                                //循环添加th
                                for(var i=0;i<_colums.length;i++){
                                    $(thead_tr).append(_th);//向列表thead中添加th
                                    var $th=$(thead_tr).find("th");//获取thead tr中的th；
                                    $($th[i]).attr("filed",_colums[i].filed);//向th中写入表头
                                    $($th[i]).text(_colums[i].title);//向th中写入表头
                                }
                            }

                        }
                        //********需要合并的表头*******//
                        if(param.spanColumns.length>0){
                            $(thead_tr).before("<tr id='spanHead'></tr>");
                            var $span_tr = $(table).find("tr#spanHead");
                            var _spans = param.spanColumns;
                            var ths_length = $(thead_tr).find("th").length;
                            for(var s =0;s<_spans.length;s++){
                                var _span = _spans[s];
                                for(var c =0 ;c<_colums.length;c++){
                                    var span_colum = _colums[c];
                                    if(_span.filed == span_colum.filed){
                                        var c_index = $.inArray(span_colum,_colums);//获取需要合并的列的索引
                                        if(param.checkrow){
                                            c_index+=1;
                                        }
                                        if(param.rownumber){
                                            c_index+=1;
                                        }
                                        var span_ths = $span_tr.find("th");
                                        var colspan_num = 0;
                                        if(span_ths && span_ths.length>0){
                                            for(var p =0;p<span_ths.length;p++){
                                                var $span_th = $(span_ths[p]);
                                                var num = $span_th.attr("colspan");
                                                if(num){
                                                    colspan_num+=num;
                                                }
                                            }
                                        }
                                        c_index =parseInt(c_index)- parseInt(colspan_num);
                                        if(c_index>0){
                                            $span_tr.append("<th style='background:#fbfbfb;' colspan='"+c_index+"'></th>");
                                        }
                                        $span_tr.append("<th style='padding:0 0;border-bottom:1px dashed #ccc;background:#fbfbfb;' colspan='"+_span.colspan+"'>"+_span.title+"</th>");

                                    }
                                }
                            }

                            var span_ths_num = $span_tr.find("th");
                            if(span_ths_num && span_ths_num.length>0){
                                var span_ths_length =0;
                                for(var p =0;p<span_ths_num.length;p++){
                                    var $span_th_num = $(span_ths_num[p]);
                                    var num = $span_th_num.attr("colspan");
                                    if(num){
                                        span_ths_length+=parseInt(num);
                                    }
                                }
                                if(span_ths_length < ths_length){
                                    var span_num = parseInt(ths_length) - parseInt(span_ths_length);
                                    $span_tr.append("<th style='background:#fbfbfb;' colspan='"+span_num+"'></th>");
                                }
                            }

                        }

                        //*******加载本地数据*********//
                        var _rows=[];
                        var total;
                        if(param.data){
                            _rows=param.data;
                            total=param.data.length;
                            if(_rows.length>0){
                                var number_index = 0;//行序号
                                $(table).data("_table",_rows);//将数据缓存到页面 后面会用
                                for(var i=0;i<_rows.length;i++){
                                    var rowElement=_rows[i];
                                    var rowId=rowElement[param.filedId];//获取行对象的id
                                    var rowIndex=parseInt(i+1);
                                    var tr_template= $.gridTemplate.trOddTemplate;//获取奇数行模板
                                    if(rowIndex%2==0){
                                        tr_template=$.gridTemplate.trEvenTemplate;//获取偶数行模板
                                    }
                                    //向tbody中插入tr
                                    $(tbody).append(tr_template);
                                    var table_trs=$(tbody).find("tr");//获取tbody下的行
                                    var tb_tr=table_trs[i];//
                                    $(tb_tr).attr("rowIndex",i);//对行写入行号rowIndex
                                    $(tb_tr).attr("filedId",rowId);//对行写入 对象id
                                    if(param.rownumber){
                                        number_index+=1;
                                        $(tb_tr).append("<td>"+parseInt(number_index)+"</td>");
                                    }
                                    if(param.checkrow){
                                        $(tb_tr).append($.gridTemplate.check_td_tem);
                                    }
                                    //循环列数，写入td
                                    for(var k=0;k<_colums.length;k++){
                                        var _td= $.gridTemplate.tdTemplate;//获取td模板
                                                $(tb_tr).append(_td);//将添加到tr中
                                                if(_colums[k].editor){
                                                    var edit_dom=$.editGrid.getTemByType(_colums[k].editor.type);
                                                    var tb_tds=$(tb_tr).find("td");
                                                    var tb_td = tb_tds[k];
                                                    if(param.rownumber && param.checkrow){
                                                        tb_td =  tb_tds[k+2];
                                                    }else if(param.checkrow){
                                                        tb_td =  tb_tds[k+1];
                                                    }else if(param.rownumber){
                                                        tb_td =  tb_tds[k+1];
                                                    }
                                                    $(tb_td).html(edit_dom);
                                                    $(tb_td).attr("edit","true");
                                                    $(tb_td).attr("td_filed",_colums[k].filed);
                                                    var _input = $(tb_td).find("input");
                                                    var _span = $(tb_td).find("span");
                                                    if(_colums[k].editor.validator.validType){
                                                        $(_input).attr("validation",_colums[k].editor.validator.validType);
                                                        $(_input).attr("filed-role",_colums[k].editor.validator.name);
                                                    }
                                                    if(_colums[k].editor.editType){
                                                        $(_input).attr("editType",_colums[k].editor.editType);
                                                    }
                                                    $(_input).attr("name",_colums[k].filed);
                                                    var _input_val="";
                                                    for(var key in rowElement){
                                                        if(key==_colums[k].filed){
                                                            if(rowElement[key]!=null && rowElement[key]!=undefined ){
                                                                _input_val=rowElement[key];
                                                            }else{
                                                                _input_val="";
                                                            }
                                                            //如果存在格式化函数
                                                            if(_colums[k].formatter){
                                                                var formatFn=_colums[k].formatter;
                                                                var tdValue=formatFn(rowElement,rowElement[key],rowIndex);
                                                                _input_val=tdValue;
                                                                //$(_input).val(tdValue);
                                                                //$(tb_td).html(tdValue);
                                                            }
                                                        }
                                                    }
                                                    if(_colums[k].editor.valueType){
                                                        _input_val= $.editGrid.getValueType(_input_val,_colums[k].editor.valueType);
                                                    }
                                                    $(_input).val(_input_val);
                                                    $(_span).attr("edit_value",_input_val);
                                                    $(_span).text(_input_val);

                                                }else{
                                                    var tb_tds=$(tb_tr).find("td");
                                                    var tb_td = tb_tds[k];
                                                    if(param.rownumber && param.checkrow){
                                                        tb_td =  tb_tds[k+2];
                                                    }else if(param.checkrow){
                                                        tb_td =  tb_tds[k+1];
                                                    }else if(param.rownumber){
                                                        tb_td =  tb_tds[k+1];
                                                    }

                                                    var td_val="";

                                                    for(var key in rowElement){
                                                        if(key==_colums[k].filed){
                                                            if(rowElement[key]!=null && rowElement[key]!=undefined){
                                                                td_val=rowElement[key];
                                                                //$(tb_td).text(rowElement[key]);//将值写入td中
                                                            }else{
                                                                td_val="";
                                                                //$(tb_td).text("无");//将值写入td中
                                                            }
                                                            //如果存在格式化函数
                                                            if(_colums[k].formatter){
                                                                var formatFn=_colums[k].formatter;
                                                                var tdValue=formatFn(rowElement,rowElement[key],rowIndex);
                                                                td_val=tdValue;
                                                            }
                                                        }
                                                    }
                                                    $(tb_td).attr("td_filed",_colums[k].filed);
                                                    $(tb_td).html(td_val);

                                                }

                                    }
                                    //只针对于单纯的操作列
                                    if(param.operations && param.operations.length>0){
                                        var operation=param.operations;
                                        if(i==0){
                                            $(thead_tr).append(_th);
                                            $(thead_tr).find("th").filter(":last").text("操作").attr("colspan",operation.length);
                                        }
                                        for(var x=0;x<operation.length;x++){
                                            $(tb_tr).append(_td);//将添加到tr中
                                            var tb_td = $(tb_tr).find("td").filter(":last");
                                            $(tb_td).text("");//将值写入td中
                                            //如果存在格式化函数
                                            if(operation[x].formatter){
                                                var formatFn=operation[x].formatter;
                                                var tdValue=formatFn(rowElement,"",rowIndex);
                                                $(tb_td).html(tdValue);
                                            }
                                        }

                                    }

                                    if(param.isDeleteRows){
                                        $(thead_tr).append(_th);
                                        $(tb_tr).append(_td);//将添加到tr中
                                        var tb_td=$(tb_tr).find("td").filter(":last");
                                        $(tb_td).html($.gridTemplate.delTemplate);
                                    }
                                }
                                //***展示表格footer*****//
                                if(param.footer.showFooter){
                                    $(tbody).append($.gridTemplate.tableTotalTemplate);
                                    var f_ths=$(table).find("th");
                                    if(f_ths && f_ths.length>0){
                                        var tfoot_td='<td class="tl total-txt"></td>';
                                        for(var f=1;f<f_ths.length;f++){
                                            var _filed=$(f_ths[f]).attr("filed");
                                            if(_filed){
                                                tfoot_td+='<td class="total-nbm" filed_name="'+_filed+'"></td>';
                                            }else{
                                                tfoot_td+='<td class="total-nbm"></td>';
                                            }
                                        }
                                        $(tbody).find(".footer_total").append(tfoot_td);
                                        if(param.footer.foots && param.footer.foots.length>0){
                                            var _foots = param.footer.foots;
                                            for(var t = 0;t<_foots.length;t++){
                                                var _name=_foots[t]["name"];
                                                if(_foots[t]["isSum"]){
                                                    $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_name+"']").text("合计");
                                                    continue;
                                                }
                                                var _inputs = $(tbody).find("tr._summary").find("td").find("input").filter("[name='"+_name+"']");//获取需要计算的input
                                                var tds_amount = $(tbody).find("tr._summary").find("td").filter("[td_filed='"+_name+"']");//获取需要计算的td
                                                if(_inputs && _inputs.length>0){
                                                    var _amount=0;
                                                    for(var a = 0;a<_inputs.length;a++){
                                                        _amount =parseFloat(_amount)+parseFloat($(_inputs[a]).val());
                                                    }
                                                    $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_name+"']").text(parseFloat(_amount).toFixed(2));
                                                }
                                                if(tds_amount && tds_amount.length>0){
                                                    var td_amount=0;
                                                    for(var m = 0;m<tds_amount.length;m++){
                                                        td_amount =parseFloat(td_amount)+parseFloat($(tds_amount[m]).text());
                                                    }
                                                    $(tbody).find(".footer_total").find("td").filter("[filed_name='"+_name+"']").text(parseFloat(td_amount).toFixed(2));
                                                }

                                            }
                                        }

                                    }
                                }
                                var table_tfoot=$(table).find("._tfoot");
                                if(table_tfoot.length==0){
                                    $(tbody).append($.gridTemplate.tfootTemplate);
                                }
                                //*********对表格进行分页************//
                                var pages=param.pageParams.rows;//一页显示多少条数据
                                var page=param.pageParams.page;//页数
                                var lastTh=$(table).find("th").filter(":last");
                                var last_th_len=0;
                                if(parseInt($(lastTh).attr("colspan"))>1){
                                    last_th_len=parseInt($(lastTh).attr("colspan"))-1;
                                }
                                var length=$(table).find("th").length+last_th_len;
                                if(param.pagination){
                                    $.gridPage.init_pageTemplate(table,total,pages,page,length);
                                }
                                if(!param.isDeleteRows){
                                    $(table).find(".delete_rows").hide();
                                }
                                //}

                                //***********绑定相关事件（可扩展）***************//
                                var $tr= $(table).find("._summary");
                                //点击行事件
                                $($tr).click(function(){
                                    var table_id=$(this).parents("._tbody").parent("table").attr("id");
                                    var _span=$(this).find(".check_box");
                                    if($(_span).hasClass("choice-box-yes")){
                                        $(_span).removeClass("choice-box-yes");
                                    }else{
                                        if(param.singleSelect){
                                            $($("#"+table_id).find(".check_box")).removeClass("choice-box-yes");
                                            $(_span).addClass("choice-box-yes");
                                        }else{
                                            $(_span).addClass("choice-box-yes");
                                        }
                                    }
                                    if(param.onClick&& $.isFunction(param.onClick)){
                                        param.onClick();
                                    }
                                });
                                //双击行事件
                                $($tr).dblclick(function(){
                                    var table_id=$(this).parents("._tbody").parent("table").attr("id");
                                    var _span=$(this).find(".check_box");
                                    if($(_span).hasClass("choice-box-yes")){
                                        $(_span).removeClass("choice-box-yes");
                                    }else{
                                        if(param.singleSelect){
                                            $($("#"+table_id).find(".check_box")).removeClass("choice-box-yes");
                                            $(_span).addClass("choice-box-yes");
                                        }else{
                                            $(_span).addClass("choice-box-yes");
                                        }
                                    }
                                    if(param.dbOnClick&& $.isFunction(param.dbOnClick)){
                                        param.dbOnClick();
                                    }

                                });
                                var numbers_input = $(table).find("._summary").find("td").find("input").filter("[editType='number']");
                                if(numbers_input && numbers_input.length>0){
                                    $(numbers_input).bind("keydown",function(e){
                                        var code = window.event ? e.keyCode : e.which;
                                        if($(this).val().length>6){
                                            if(code == 190 || code == 110 ||code == 8 // backspace
                                                || code == 37 // 左箭头
                                                || code == 39){
                                                  return true
                                            }else if($(this).val().indexOf(".")!=-1){
                                                return true;
                                            }else{
                                                return false;
                                            }
                                        }
                                        if(
                                            (code >= 48 && code <= 57) // [0-9]
                                            || code == 189  // - 负号
                                            || code == 190  // . 小数点
                                            || code == 8 // backspace
                                            || code == 37 // 左箭头
                                            || code == 39 // 右键头
                                            || (code <= 105 && code >= 96)//小键盘
                                            || code == 110 //小键盘的小数点
                                        ){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    });
                                }

                                /**
                                 * 表格加载成功事件
                                 */
                                if(param.onLoadSuccess && $.isFunction(param.onLoadSuccess)){
                                    param.onLoadSuccess()
                                };
                                /**
                                 * 封装删除行方法
                                 */
                                if(param.isDeleteRows){
                                    var $del=$(table).find(".delete_rows");
                                    $del.bind("click",function(){
                                        var rowId=$(this).parents("tr").attr("filedId");
                                        if(param.onDelete && $.isFunction(param.onDelete)){
                                            param.onDelete(rowId);
                                        }
                                    });
                                }
                            }else{
                                var cols_len = $(table).find("tr.mainHead").find("th").length;
                                var error_tr='<tr><td style="text-align: center" colspan="'+cols_len+'">暂无数据，请添加商品！</td></tr>';
                                $(tbody).append(error_tr);
                            }
                            //表格加载成功后清除传入的相关参数，防止下次请求参数重复
                            var _p=$(table).data("setting")?$(table).data("setting"):param;
                            _p.pageParams.rows=10;
                            _p.pageParams.page=1;
                            $(table).data("setting",_p);
                        }else{
                            var cols_len = $(table).find("tr.mainHead").find("th").length;
                            var error_tr='<tr><td style="text-align: center" colspan="'+cols_len+'">暂无数据，请添加商品！</td></tr>';
                            $(tbody).append(error_tr);
                        }
                    }
                },
                /**
                 * 重新加载表格
                 * @param ob
                 */
                reload:function(ob){
                    var selector=ob.table_selector;
                    $(selector).dataTable(ob);
                },
                /**
                 * 加载本地数据
                 * @param ob
                 * @param params
                 */
                loadLocalData:function(ob,params){
                    var selector=ob.table_selector;
                    $(selector).dataTable(ob);
                },
                /**
                 * 得到选中单行对象
                 * @param obj
                 * @returns {*}
                 */
                getSelected:function(obj){
                    var tableobj=obj.table_selector;
                    var checkeds=$(tableobj).find(".choice-box-yes");
                    if(checkeds.length>1||checkeds.length==0){
                    }else{
                        var rowId=$(checkeds[0]).parents("._summary").attr("filedId");
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
                    var checkeds = $(tableobj).find(".choice-box-yes");
                    var rowArray=[];
                    for(var i=0;i<checkeds.length;i++){
                        var rowId = $(checkeds[i]).parents("._summary").attr("filedId");
                        for (var k in rows) {
                            if (rows[k][obj.filedId] == rowId) {
                                rowArray.push(rows[k]);
                            }
                        }
                    }
                    return rowArray;
                },
                /**
                 * 根据id获取行对象
                 * @param obj
                 * @param _param
                 * @returns {*}
                 */
                getRow:function(obj,_param){
                    var tableobj = obj.table_selector;
                    var rows = obj.rowsObjs;
                    var row;
                    for (var k in rows) {
                        if (rows[k][obj.filedId] == _param) {
                            row = rows[k];
                            return row;
                        }
                    }
                },
                /**
                 * 获取表格下的所有行
                 * @param ob
                 */
                getRows:function(ob){
                    //var tableobj=obj.table_selector;
                    //var $(tableobj).find("tbody").find("tr._summary");
                    return ob.rowsObjs;

                },
                //*****获取选中的行的数量****//
                getRowsNumber:function(ob){
                    var table_obj = ob.table_selector;
                    var checked_rows = $(table_obj).find(".choice-box-yes");
                    var chooseLength=checked_rows.length;
                    return chooseLength;
                },
                //********获取当前选中页数*******//
                getPager:function(){

                },

                selectRow:function(ob,params){

                },
                /**
                 * 选中行
                 * @param ob
                 * @param params
                 */
                selectionRow:function(ob,params){
                    var table_obj = ob.table_selector;
                    //var rows= $.gridMethod.getRows(ob);
                    if(params && params.length>0){
                        for(var m=0;m<params.length;m++){
                            var id=params[m].id;
                            $(table_obj).find("tbody").find("tr._summary").filter("[filedId='"+id+"']").addClass("choice-box-yes");
                        }
                    }

                },
                /**
                 * 选中表格全部的行
                 * @param ob
                 * @param params
                 */
                selectAll:function(ob,params){
                    var table_obj = ob.table_selector;
                    //$($("#"+table_id).find(".check_box")).removeClass("choice-box-yes");
                    $(table_obj).find("tbody").find(".check_box").addClass("choice-box-yes");
                },
                /**
                 * 取消表格全部选中的行
                 * @param ob
                 * @param params
                 */
                cancelSelectAll:function(ob,params){
                    var table_obj = ob.table_selector;
                    //$($("#"+table_id).find(".check_box")).removeClass("choice-box-yes");
                    $(table_obj).find("tbody").find(".check_box").removeClass("choice-box-yes");
                },
                /**
                 * 结束编辑行
                 * @param ob
                 * @param params
                 */
                endEditor:function(ob,params){
                    var table_obj = ob.table_selector;
                    var edit_tds=$(table_obj).find("tbody").find("tr._summary").find("td").filter("[edit='true']");
                    //$(edit_tds).find("input").hide();
                    //$(edit_tds).find("span").show();
                },
                /**
                 * 缓存编辑表格的数据
                 * @param ob
                 * @param params
                 */
                sessionData:function(ob,params){

                },
                /**
                 * 得到编辑行的数据
                 * @param ob
                 * @param params
                 */
                getEditRowData:function(ob,params){
                    var table_obj = ob.table_selector;
                    var edit_trs=$(table_obj).find("tbody").find("tr._summary");
                    var rows = ob.rowsObjs;
                    var newRows=[];
                    if(edit_trs && edit_trs.length>0){
                        for(var e = 0;e<edit_trs.length;e++){
                              if(rows && rows.length>0){
                                    for(var r = 0;r<rows.length;r++){
                                        if($(edit_trs[e]).attr("filedId")==rows[r]["id"]){
                                            var tds= $(edit_trs[e]).find("td").filter("[td_filed]");
                                            if(tds && tds.length>0){
                                                for(var t = 0; t<tds.length;t++){
                                                    var _flied,_value;
                                                    if( $(tds[t]).find("input").length>0){
                                                        _flied = $(tds[t]).find("input").attr("name");
                                                        _value = $(tds[t]).find("input").val();
                                                    }else{
                                                        _flied = $(tds[t]).attr("td_filed");
                                                        _value = $(tds[t]).text();
                                                    }
                                                    rows[r][_flied]=_value;
                                                }
                                                newRows.push(rows[r]);
                                            }

                                        }
                                    }
                              }
                        }
                        return newRows;
                    }
                },
                /**
                 * 获取表格footer数据
                 * @param ob//参数
                 * @param params
                 */
                getFooter:function(ob,params){
                    var tableobj = ob.table_selector;
                    var _footers = ob.footer.foots;
                    var _foot={};
                    if(_footers && _footers.length>0){
                         for(var f =0;f<_footers.length;f++){
                             var _footer = _footers[f];
                            var td_val = $(tableobj).find("tr.footer_total").find("td[filed_name='"+_footer["name"]+"']").text();
                             _foot[_footer["name"]] = td_val
                         }
                        return _foot
                    }
                },
                /**
                 * 根据tr filedId删除表格的行（注:只用于删除html元素）
                 * @param ob
                 * @param params
                 */
                deleteRowById:function(ob,params){
                    var table_obj = ob.table_selector;
                    var rowId = params;
                    $(table_obj).find("tr._summary").filter("[filedId='"+rowId+"']").remove();
                }
            },
        //********************************表格分页操作对象***********************//
        gridPage:{
            /**
             * 分页模板
             */
            page_template:'<td colspan="2" class="tl table-page-txt total">共 0 条数据</td>'
                            +'<td  class="tr table-page-list pageDiv">'
                                +'<ul class="clearfix">'
                                    +'<li class="first_li"><span class="icon left " onclick="$.gridPage.prevPage(this)"></span></li>'
                                    +'<li class="last_li"><span class="icon right " onclick="$.gridPage.nextPage(this)"></span></li>'
                                +'</ul>'
                            +'</td>',
            page_omitted:'<li class="center_li"><span class="center is_center">...</span></li>',

            create_empty_page : function(obj){
                //if($(obj).find("._tfoot td").is(":empty")){
                //    $(obj).find("._tfoot td").empty().append($.gridPage.grid_page_template);
                //    $(obj).find("._tfoot td:not([colspan])").remove();
                //}
            },
            /**
             * 初始化 分页模板
             * @param obj
             * @param total
             * @param rows
             */
            init_pageTemplate:function(obj,total,rows,page,length){
                var $page_tem=$(obj).find(".pageDiv");
                if($page_tem.length>0){
                    $($page_tem).remove();
                }
                $page_tem=$.gridPage.page_template;
                $(obj).find("._tfoot").append($page_tem);
                if(length>4){
                    $(obj).find(".pageDiv").attr("colspan",length-2);
                }else{
                    $(obj).find(".total").attr("colspan",1);
                    $(obj).find(".pageDiv").attr("colspan",length-1);
                }
                $.gridPage.page(obj,total,rows,page);
                //$(obj).find("._tfoot td:not([colspan])").remove();
            },
            /**
             * 得到分页数据
             * @param total  总数
             * @param rows 每页显示的数据
             */
            page:function(obj,total,rows,page){
                var $pageDiv=$(obj).find(".pageDiv");//查找分页的div
                $(obj).find(".total").text("共 "+total+" 条数据");//写入共多少条数据
                $pageDiv.data("is_center","false");
                var pageIndex=0;
                if(total<=rows){//总的数据小于每页显示的条数
                    pageIndex+=1;
                    $pageDiv.find(".first_li").after("<li pageId='page0'><span  pageValue='1' class='pageA' onclick='$.gridPage.clickPage(this)'>1</span></li>");
                }else{
                    if(total%rows==0){//总的数据 可以整除每页显示的条数
                        pageIndex=total/rows;
                        $.gridPage.paging($pageDiv,pageIndex);
                    }
                    else{
                        pageIndex=Math.ceil(total/rows);
                        $.gridPage.paging($pageDiv,pageIndex);
                    }
                }
                page = page?page:1;
                var this_page=$pageDiv.find("[pageValue='"+page+"']");
                $(this_page).addClass("current");
                $(this_page).attr("pgSelect","true");
                if($($pageDiv).data("is_center")=="true"){
                    $.gridPage.pageOperate($pageDiv,this_page,page);
                }

            },
            /**
             * 进行分页
             * @param $pageDiv //分页元素jquery对象
             * @param pageIndex//分页总数
             */
            paging:function($pageDiv,pageIndex){
                if(pageIndex>5){
                    $pageDiv.data("is_center","true");
                    for(var i=1;i<=pageIndex;i++){
                        //append进第一个分页
                        if(i==1){
                            $pageDiv.find(".first_li").after("<li pageId='page"+i+"' class='page_li'><span  pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)'>"+i+"</span></li>");
                        }else{//根据以第一页依次after其他的页
                            var p=i-1;
                            if(i>5 && i<parseInt(parseInt(pageIndex)-1)){
                                $pageDiv.find("[pageId='page"+p+"']").after("<li pageId='page"+i+"' style='display:none' class='page_li'><span  pageValue='"+i+"'  class='pageA pageHide' onclick='$.gridPage.clickPage(this)' >"+i+"</span></li>");
                            }else{
                                $pageDiv.find("[pageId='page"+p+"']").after("<li pageId='page"+i+"' class='page_li'><span  pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)' >"+i+"</span></li>");
                            }
                        }
                    }
                    var page_om = $pageDiv.find("[pageId='page"+parseInt(parseInt(pageIndex)-2)+"']");
                    if($(page_om).is(":hidden")){
                        $(page_om).after($.gridPage.page_omitted);
                    }
                }else{
                    for(var i=1;i<=pageIndex;i++){
                        if(i==1){
                            $pageDiv.find(".first_li").after("<li pageId='page"+i+"' class='page_li'><span  pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)'>"+i+"</span></li>");
                        }else{
                            var p=i-1;
                            $pageDiv.find("[pageId='page"+p+"']").after("<li pageId='page"+i+"' class='page_li'><span  pageValue='"+i+"'  class='pageA' onclick='$.gridPage.clickPage(this)' >"+i+"</span></li>");
                        }
                    }
                }
            },
            /**
             * 点击单页函数
             * @param obj
             */
            clickPage:function(obj){
                if($(obj).attr("pgSelect")=="true"){
                    return false;
                }
                var $pageDiv=$(obj).parents(".pageDiv");
                var $pageA=$($pageDiv.find(".pageA"));
                $pageA.each(function(i,e){
                    $(e).removeClass("current");
                    $(e).attr("pgSelect","false");
                });
                $(obj).attr("pgSelect","true");
                var page=$(obj).attr("pageValue");
                //$.gridPage.pageOperate($pageDiv,obj,page);
                $(obj).addClass("current");
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
                    $(e).removeClass("current");
                    var select_value=$(e).attr("pgSelect");
                    if(select_value=="true"){
                        var page_value=$(e).attr("pageValue");
                        if(page_value=="1"){
                            $(e).addClass("current");
                            return false;
                        }
                        var prev_a=$(e).parent().prev().find("a");
                        //$.gridPage.pageOperate($pageDiv,obj,page_value,true);
                        $(prev_a).addClass("current");
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
                    $(e).removeClass("current");
                    var select_value=$(e).attr("pgSelect");
                    if(select_value=="true"){
                        var _next = $(e).parent().next();
                        if(_next.hasClass("center_li")){
                            if(_next.next().attr("pageId")==undefined){
                                $(e).addClass("current");
                                return false;
                            }
                        }else if(_next.attr("pageId")==undefined){
                            $(e).addClass("current");
                            return false;
                        }
                        var page_value=$(e).attr("pageValue");
                        var next_a=$(e).parent().next().find("a");
                        //$.gridPage.pageOperate($pageDiv,obj,page_value,false);
                        $(next_a).addClass("current");
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
             * @param page//页数
             * @param row
             */
            gridPageSearch:function(obj,page,row){
                var _row=parseInt(row?row:10);
                var pageObj=$(obj).parents(".pageDiv");
                var table_obj= $(pageObj).parents("table").attr("id");
                var table_clomuns_num = parseInt(parseInt(page)-1) * _row;
                $("#"+table_obj).data("isPage",true);
                $("#"+table_obj).data("_table_columns_number",table_clomuns_num);
                $("#"+table_obj).dataTable({
                    pageParams:{
                        page:page,
                        rows:_row
                    }
                })
            },
            /**
             * 分页操作
             * @param pageDiv//分页dom 对象
             * @param obj//点击页数本身
             * @param page//页数
             */
            pageOperate:function(page_Div,obj,page,isPrev){
                var pageDiv=$(obj).parents(".pageDiv");
                if($(pageDiv).data("is_center")=="true"){
                    $(page_Div).data("paging","true");
                    var parent_li = $(obj).parent("li");//被点击的页数li
                    var next_li = $(parent_li).next(".page_li");//被点击的li相邻的下一个li
                    var prev_li = $(parent_li).prev(".page_li");//被点击的li相邻的上一个li
                    var li_list = $(pageDiv).find("li").filter(".page_li");//获取所有分页li元素
                    if(page>=5){
                        if($(obj).is(":hidden")){
                            $(parent_li).show();
                        }
                        //展示被选中的分页相邻的后两个分页
                        var next_index = parseInt(parseInt(page)+1);//索引
                        if($(next_li).is(":hidden")){
                            $(next_li).show();
                        }
                        if($(next_li).next("li").is(":hidden")){
                            $(next_li).next("li").show();
                        }
                        var next_hide_li = $(li_list).filter(".page_li:lt("+parseInt(li_list.length-2)+"):gt("+next_index+")");
                        if(next_hide_li && next_hide_li.length>0){
                            $(next_hide_li).hide();
                        }
                        if($(li_list).eq(parseInt(li_list.length-3)).is(":visible")){
                            $(pageDiv).find("[pageid='page"+parseInt(li_list.length-1)+"']").prev(".center_li").hide();
                        }
                        //隐藏分页页数比被选中的分页的页数小于2并且页数大于2的元素
                        if($(prev_li) && $(prev_li).length>0){
                            if($(prev_li).is(":hidden")){
                                $(prev_li).show();
                            }
                            if($(prev_li).prev("li").is(":hidden")){
                                $(prev_li).prev("li").show();
                            }
                        }else if($(parent_li).prev("li").hasClass("center_li")){
                            prev_li = $(parent_li).prev("li").prev(".page_li");
                            if($(prev_li).is(":hidden")){
                                $(prev_li).show();
                            }
                            if($(prev_li).prev("li").is(":hidden")){
                                $(prev_li).prev("li").show();
                            }
                            if($(prev_li).prev("li").prev("li").is(":hidden")){
                                $(parent_li).prev("li").remove();
                                $(prev_li).prev("li").before($.gridPage.page_omitted);
                            }else{
                                $(parent_li).prev("li").remove();
                            }
                        }

                        var prev_index = parseInt(parseInt(page)-3);//索引
                        var prev_hide_li = $(li_list).filter(".page_li:lt("+prev_index+"):gt(1)");
                        if(parseInt(page) < parseInt(li_list.length-1)){
                            if(prev_hide_li && prev_hide_li.length>0){
                                $(prev_hide_li).hide();
                                $(pageDiv).find("[pageid='page2']").after($.gridPage.page_omitted);
                            }
                        }

                    }
                }
            }
        }
    })
})(jQuery);