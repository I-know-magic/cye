
/**
 **********************************EasyUI自定义类开始*************************************************
 *实现在一个JSP页面中包括多个DataGrid控件并存问题
 * */
var tempDataGrid;
var tempWindow;
var postdatagrid;
function EasyUIExt(dataGrid, url, onloadfunction) {
    //DataGrid默认属性参数定义
    /**
     * dataGrid数据表格
     * */
    this.dataGrid = dataGrid;
    /**
     * 数据表格加载数据的URL
     * */
    this.dataurl = url;

    /**
     * 数据表格的添加或编辑弹出窗口
     * */
    this.window = null;
    /**
     * 数据表格的添加或编辑Form
     * */
    this.form = null;
    this.iconCls = "icon-edit";
    this.width = "auto";
    this.height = "auto";
    this.nowrap = false;
    this.striped = true;
    this.border = true;
    this.collapsible = false;
    this.fit = true;
    this.remoteSort = false;
    this.rownumbers = true;
    this.singleSelect = false;
    this.pagination = true;
    this.showFooter = false;
    this.ajaxcache = false;
    this.queryParams = null;
    this.page_size=20;
    this.sortName=null
    this.sortOrder='asc'
    this.remoteSort=true
    this.multiSort=true
    /**
     * 行点击事件函数接口;
     **/
    this.clickRow;
    /**
     * 行双击点击事件函数接口;
     **/
    this.dblClickRow;
    /**
     * DataGrid加载完成事件函数接口;
     **/
    this.loadSuccess;
    /**
     *单击datagrid单元格时触发事件
     */
    this.clickCell;
    /**
     * 勾选一行时触发
     */
    this.check;
    this.uncheck;
    /**
     * 设置行样式
     */
    this.rowStyle;
    this.endEdit;
    this.formAction = "";
    this.reset = true
    this.mainEasyUIJs = function () {
        var dom = this;
        this.dataGrid.datagrid({
            title : this.title,
            iconCls : this.iconCls,// 图标
            width : this.width,
            height : this.height,
            nowrap : this.nowrap,
            striped : this.striped,
            border : this.border,
            collapsible : this.collapsible,// 是否可折叠的
            fit : this.fit,// 自动大小
            singleSelect : this.singleSelect, // 是否单选
            url : this.dataurl,
            checkOnSelect:true,
            onLoadSuccess:function(data){
                $(this).datagrid('clearSelections');
                var selector = dom.dataGrid.selector;
                if(dom.singleSelect){
                    $(selector).parent().find(".datagrid-header-check").empty()
                }
                //这处理公用业务
                if(dom.loadSuccess){
                    dom.loadSuccess(data);
                }
            },
            onClickRow:this.clickRow,
            onClickCell: this.clickCell,
            onDblClickRow:this.dblClickRow,
            onEndEdit:this.endEdit,
            onCheck:this.check,
            onUncheck: this.uncheck,
            rowStyler:this.rowStyle,
            onLoadError:function(){
                $.messager.alert('系统提示', "数据加载错误请稍后再试！", 'error' );
            },
            remoteSort : this.remoteSort,
            showFooter : this.showFooter,
            pagination : this.pagination,// 分页控件
            rownumbers : this.rownumbers,// 行号
            queryParams:this.queryParams,
            pageSize:this.page_size,
            pageList:[5,10,20,35,50,100]
        }).datagrid('unselectAll');
        var pg = this.dataGrid.datagrid("getPager");
        var opts = this.dataGrid.datagrid("options");
        var tempDataGrid = this.dataGrid;
        pg.pagination({
            total : 0,
            onSelectPage:function(pageNumber, pageSize){
                opts.pageNumber = pageNumber;
                opts.pageSize = pageSize;
                tempDataGrid.datagrid('reload').datagrid('unselectAll');
            }
        });
    };
    /**
     *清除缓存
     */
    this.clearCache = function(){
        $.ajaxSetup ({
            cache: false //关闭AJAX相应的缓存
        });
    }

    /**
     * 添加操作
     * @param url 添加action url
     * @param title 弹出框标题
     *保存的url去掉，放到form下。
     */
    this.mainAdd = function(url,title,clearArea,fn){
        if(this.window == null){
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info' );
            return false;
        }
        var win = this.window;
        var addForm = this.form;
        if (this.reset) {
            if(clearArea){
                $(addForm).find(clearArea).form('clear')
            }else{
                addForm.form('clear');
            }
        }
        if(url){
            $.post(url,function(data){
                if(true){
                    addForm.form('load',url,function(){
                        if(fn){
                            fn();
                        }
                    });
                }
                else{
                    $.messager.alert("系统提示","您没有权限，进行此操作！","info");
                }
            });
        }
        this.window.dialog('open').dialog('setTitle',title);
    };
    /**
     * 编辑操作
     * url:点击编辑时，调用后台update方法
     * @param url1 查看action url
     */
    this.mainEditRole = function (url1, title, id) {
        if(this.window == null){
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info' );
            return false;
        }
        this.form.form("clear");
        var rowId = id ? id : null;
        if(!rowId){
            var rows=this.dataGrid.datagrid("getSelections");
            if(rows.length==0){
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
                return
            }
            if(rows.length>1){
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
                return
            }
        }
        rowId = rowId ? rowId : this.dataGrid.datagrid("getSelections")[0][this.dataGrid.datagrid("options").idField];
        if (rowId) {
            if(url1.indexOf("?")>=0){
                url1 += "&";
            }else{
                url1 += "?";
            }
            this.form.form('load', url1 + 'id=' + rowId);
            this.window.dialog('open').dialog('setTitle',title);
            } else {
               $.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
        }


    };
    this.mainEdit = function (url1, title, id) {
        if (this.window == null) {
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info');
            return false;
        }
        this.form.form("clear");
        var rowId = id ? id : null;
        if (!rowId) {
            var rows = this.dataGrid.datagrid("getSelections");
            if (rows.length == 0) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return
            }
            if (rows.length > 1) {
                $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
                return
            }
        }
        rowId = rowId ? rowId : this.dataGrid.datagrid("getSelections")[0][this.dataGrid.datagrid("options").idField];
        if (rowId) {
            if (url1.indexOf("?") >= 0) {
                url1 += "&";
            } else {
                url1 += "?";
            }
            this.form.form('load', url1 + 'id=' + rowId);
            this.window.dialog('open').dialog('setTitle', title);
        } else {
            $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
        }


    };
    /**
     * 编辑操作
     * url:点击编辑时，调用后台update方法
     * @param url1 查看action url
     */
    this.mainEdit2 = function (url1, title, id,fn) {
        var dataT;
        if(this.window == null){
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info' );
            return false;
        }
        var rowId = id ? id : null;
        if (this.dataGrid.datagrid("getSelections").length != 0) {
            rowId = rowId ? rowId : this.dataGrid.datagrid("getSelections")[0][this.dataGrid.datagrid("options").idField];
        }

        if (!rowId) {
            $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
            return;
        }
        if (rowId) {
            //var id = eval('('+'rows[0].'+this.dataGrid.datagrid("options").idField+')');
            var id = rowId;
            if(url1.indexOf("?")>=0){
                url1 += "&";
            }else{
                url1 += "?";
            }
            var url= url1 + 'id=' + id;
            var ttf = this;
            $.ajax({
                type: "GET",
                url: url,
                cache: false,
                async: false,
                dataType: "json",
                success:function(data){
                    ttf.form.form('load',data);
                    if(fn){
                        fn(data);
                    }
                    ttf.window.dialog('open').dialog('setTitle',title);
                    dataT = data;
                }
            });
        }
        return dataT;
    };
    this.mainEditDish = function (url1, title, id) {
        debugger;
        var dataT;
        if (this.window == null) {
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info');
            return false;
        }
        var rowId = id ? id : null;
        if (!rowId) {
            var rows = $('#goodsTable').datagrid("getSelections");
            if (rows.length == 1) {
                rowId = rows[0].id
            } else {
                $.messager.alert('系统提示', '请选择一条数据记录！！', 'warning');
                return
            }
        }
        if (!rowId) {
            $.messager.alert('系统提示', '请选择一条数据记录！', 'info');
            return;
        }
        if (rowId) {
            //var id = eval('('+'rows[0].'+this.dataGrid.datagrid("options").idField+')');
            var id = rowId;
            if (url1.indexOf("?") >= 0) {
                url1 += "&";
            } else {
                url1 += "?";
            }
            var url = url1 + 'id=' + id;
            var ttf = this;
            $.ajax({
                type: "GET",
                url: url,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    ttf.form.form('load', data);
                    ttf.window.dialog('open').dialog('setTitle', title);
                    dataT = data;
                }
            });
        }
        return dataT;
    };
    /**
     * 选择一行，并打开iframe对话框
     * @param iw 弹出框对象
     * @param ife iframe对象
     * @param url 获取数据url
     * */
    this.openIframeSelect = function(iw,ife, url){
        var rows = this.dataGrid.datagrid("getSelections");
        if (rows.length == 1) {
            var id = eval('('+'rows[0].'+this.dataGrid.datagrid("options").idField+')');
            if(url.indexOf("?")>=0){
                url + "&";
            }else{
                url += "?";
            }
            ife.attr("src",url+"id="+id);
            iw.window("open");
        } else {
            $.messager.alert('系统提示', '请选择一条数据记录！', 'info' );
        }
    };
    /**
     * 无需选择行，打开iframe对话框
     * @param iw 弹出框对象
     * @param ife iframe对象
     * @param url 获取数据url
     */
    this.openIframeWindow = function(iw,ife, url){
        ife.attr("src",url);
        iw.window("open");
    };

    /**
     * 保存操作
     */
    this.mainSave = function(url){
        if(this.window == null){
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info' );
            return false;
        }
        tempDataGrid = this.dataGrid;
        tempWindow = this.window;
        var addForm = this.form;
        this.form.form('submit',{
            url: this.formAction,
            onSubmit: function(){
                if($(this).form('validate')){
                    $('#sub').linkbutton('disable');
                    return true;
                }else{
                    return false;
                }
            },
            success: function(result){
                var result = eval('('+result+')');
                if (result.success == "false"){
                    $('#sub').linkbutton('enable');
                    $.messager.alert('错误', result.msg, 'error' );
                } else {
                    $('#sub').linkbutton('enable');
                    $.messager.alert('系统提示', result.msg, 'info' );
                    if(url){
                        addForm.form("clear");
                        addForm.form("load",url);
                    }else{
                        tempWindow.dialog('close');
                    }

                    tempDataGrid.datagrid('reload');
                }
            },
            onLoadError:function(){
                $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error' );
            }
        });
    };

    this.mainSaveAndAdd = function(){
        if(this.window == null){
            $.messager.alert('系统提示', "当前列表没有设置弹出窗口！", 'info' );
            return false;
        }
        tempDataGrid = this.dataGrid;
        tempWindow = this.window;
        var tempForm=this.form;
        this.form.form('submit',{
            url: this.formAction,
            onSubmit: function(){
                if($(this).form('validate')){
                    $('#sub').linkbutton('disable');
                    return true;
                }else{
                    return false;
                }
            },
            success: function(result){
                var result = eval('('+result+')');
                if (result.success == "false"){
                    $('#sub').linkbutton('enable');
                    $.messager.alert('错误', result.msg, 'error' );
                } else {
                    $('#sub').linkbutton('enable');
                    $.messager.alert('系统提示', result.msg, 'info' );
                    // tempWindow.dialog('close');
                    tempForm.form('clear');
                    tempDataGrid.datagrid('reload');
                }
            },
            onLoadError:function(){
                $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error' );
            }
        });
    };

    /**
     * 删除操作
     * @param url 删除action url
     */
    this.mainDel = function(url,fn){
        var rows = this.dataGrid.datagrid("getSelections");
        if (rows.length < 1) {
            $.messager.alert('系统提示', '操作失败，请至少选择一条数据记录！', 'info');
            return;
        }
        var ids = [];
        for ( var i = 0; i < rows.length; i++) {
            ids.push(eval('('+'rows[i].'+this.dataGrid.datagrid("options").idField+')'));
        }
        tempDataGrid = this.dataGrid;
        $.messager.confirm('系统提示', '所选数据记录删除后将不能恢复，确定要删除吗？', function (r) {
            if (r){
                $.post(url+'?ids='+ids,function(result){
                    if (result.success=="true"){
                        tempDataGrid.datagrid('reload').datagrid('unselectAll');
                        if(fn){
                            fn();
                        }
                        $.messager.alert('系统提示', result.msg, 'info');

                    } else {
                        $.messager.alert('系统提示', result.msg, 'error');
                    }
                },'json');
            }
        });
    };

    /**
     * POST提交公共函数
     * @param msg：提示信息
     * @param url：url
     * @param flag:判断是否单选,true为单选,false为多选
     */
    this.mainPost=function(msg,url,flag){
        var rows=this.dataGrid.datagrid("getSelections");
        if(rows.length<1){
            $.messager.alert('系统提示', '操作失败，请至少选择一条数据记录！', 'info');
            return;
        }

        postdatagrid=this.dataGrid;
        if(url.indexOf("?")>=0){
            url + "&";
        }else{
            url += "?";
        }
        if(flag=="true"){
            var id = eval('('+'rows[0].'+postdatagrid.datagrid("options").idField+')');

            $.messager.confirm('系统提示',msg,function(r){
                if(r){
                    $.post(url+"ids="+id,function(result){
                        if (result.success=="true"){
                            postdatagrid.datagrid('reload').datagrid('unselectAll');
                        } else {
                            $.messager.alert('系统提示', result.msg, 'error');
                        }

                    },"json");
                }
            });
        }

        if(flag=="false"){
            var ids=[];
            for ( var i = 0; i < rows.length; i++) {
                ids.push(eval('('+'rows[i].'+this.dataGrid.datagrid("options").idField+')'));
            }
            $.messager.confirm('系统提示',msg,function(r){
                if(r){
                    $.post(url+"ids="+ids,function(result){
                        if (result.success=="true"){
                            postdatagrid.datagrid('reload').datagrid('unselectAll');
                        } else {
                            $.messager.alert('系统提示', result.msg, 'error');
                        }

                    },"json");
                }
            });
        }
    };
    /**
     * 关闭窗口
     */
    this.mainClose = function(){
        if(this.window == null){
            $.messager.alert('系统提示', "操作失败，当前DataGrid没有设置弹出窗口！", 'info');
            return false;
        }
        this.window.dialog('close');
    };
    /**
     * 重置表单
     */
    this.mainReset = function(){
        this.form.form('reset');
    };

    this.submitForm = function() {
        submitFormByObject($("#myForm"));
    }


    this.submitFormByObject = function(f) {
        if(f.form('validate')){
            $('#sub').linkbutton('disable');
            f.submit();
            return true;
        }
        return false;
    }

    this.clearForm = function() {
        clearFormByObject($("#myForm"));
    }

    this.clearFormByObject = function(f) {
        f.form("reset");
    }

}
function formclear(){
    $("#myForm").form('clear');
}
/**
 * ********************************************************EasyUI自定义类结束**********************
 * */

$.extend($.fn.form.methods, {
    myLoad : function (jq, param) {
        return jq.each(function () {
            load(this, param);
        });

        function load(target, param) {
            if (!$.data(target, "form")) {
                $.data(target, "form", {
                    options : $.extend({}, $.fn.form.defaults)
                });
            }
            var options = $.data(target, "form").options;
            if (typeof param == "string") {
                var params = {};
                if (options.onBeforeLoad.call(target, params) == false) {
                    return;
                }
                $.ajax({
                    url : param,
                    data : params,
                    dataType : "json",
                    success : function (rsp) {
                        loadData(rsp);
                    },
                    error : function () {
                        options.onLoadError.apply(target, arguments);
                    }
                });
            } else {
                loadData(param);
            }
            function loadData(dd) {
                var form = $(target);
                var formFields = form.find("input[name],select[name],textarea[name]");
                formFields.each(function(){
                    var name = this.name;
                    var value = jQuery.proxy(function(){try{return eval('this.'+name);}catch(e){return "";}},dd)();
                    var rr = setNormalVal(name,value);
                    if (!rr.length) {
                        var f = form.find("input[numberboxName=\"" + name + "\"]");
                        if (f.length) {
                            f.numberbox("setValue", value);
                        } else {
                            $("input[name=\"" + name + "\"]", form).val(value);
                            $("textarea[name=\"" + name + "\"]", form).val(value);
                            $("select[name=\"" + name + "\"]", form).val(value);
                        }
                    }
                    setPlugsVal(name,value);
                });
                options.onLoadSuccess.call(target, dd);
                $(target).form("validate");
            };
            function setNormalVal(key, val) {
                var rr = $(target).find("input[name=\"" + key + "\"][type=radio], input[name=\"" + key + "\"][type=checkbox]");
                rr._propAttr("checked", false);
                rr.each(function () {
                    var f = $(this);
                    if (f.val() == String(val) || $.inArray(f.val(), val) >= 0) {
                        f._propAttr("checked", true);
                    }
                });
                return rr;
            };
            function setPlugsVal(key, val) {
                var form = $(target);
                var cc = ["combobox", "combotree", "combogrid", "datetimebox", "datebox", "combo"];
                var c = form.find("[comboName=\"" + key + "\"]");
                if (c.length) {
                    for (var i = 0; i < cc.length; i++) {
                        var combo = cc[i];
                        if (c.hasClass(combo + "-f")) {
                            if (c[combo]("options").multiple) {
                                c[combo]("setValues", val);
                            } else {
                                c[combo]("setValue", val);
                            }
                            return;
                        }
                    }
                }
            };
        };
    }
});
/*********************************************************EasyUI 常用公共方法开始******************************/
///**
// * 禁用backspace键
// */
//$(document).keydown(function (e) {
//    if (e.keyCode == 8) {
//        return false;
//    }
//});
function textToShort(value,row,index){
    var result = "";
    if(value != null && value != ""){
        if(value.length > 60){
            result = '<label title="'+value+'">'+value.substring(0,60)+'......</label>';
        }else{
            result = '<label title="'+value+'">'+value+'</label>';
        }
    }
    return result;
}
function closeSubTab(title){
    $('#main-tab').tabs('close',title);
}
function addSubTab(title,url,refresh){
    var jq = top.jQuery;
    if (jq("#main-tab").tabs('exists', title)){
        if(refresh==true){
            jq("#main-tab").tabs('close', title);
            var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
            jq("#main-tab").tabs('add',{
                title:title,
                content:content,
                closable:true
            });
        }else{
            jq("#main-tab").tabs('select', title);
        }

    } else {
        var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
        jq("#main-tab").tabs('add',{
            title:title,
            content:content,
            closable:true
        });
    }
}

var treeNodes;
var zTree;
/**
 *公共加载树方法
 * @param url
 * @param trId
 */
function loadTree(url,trId,setting){
    $.ajax({
        async:true,
        url:url,
        type:"post",
        dataType:'json',
        success:function(data){
            treeNodes=data;
            for(var key in treeNodes){
                treeNodes[key].open = true;
            }
            zTree= $.fn.zTree.init(trId,setting,treeNodes);
        }
    })
}

/**
 * 公共save方法
 */
function mySave(formId,url,dialogId){
    $("#"+formId+"").form('submit',{
        url:url,
        onSubmit: function(){
            if($(this).form('validate')){
                $('#sub').linkbutton('disable');
                return true;
            }else{
                return false;
            }
        },
        success: function(result){
            var result = eval('('+result+')');
            if (result.success == "false"){
                $('#sub').linkbutton('enable');
                $.messager.alert('错误', result.msg, 'error' );
            } else {
                $('#sub').linkbutton('enable');
                $.messager.alert('系统提示', result.msg, 'info' );
                if(dialogId!=""){
                    $("#"+dialogId+"").window("close");
                }

            }
        },
        onLoadError:function(){
            $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error' );
        }
    });
}


/**
 *公共打开window下iframe方法
 * @param win
 * @param ifrea
 * @param url
 */
function openIframe(win,ifra, url){
    $("#"+ifra+"").attr("src",url);
    $("#"+win+"").window("open");
}
$(function() {
    var buttons = $.extend([], $.fn.datebox.defaults.buttons);
    buttons.splice(1, 0, {
        text: '清空',
        handler: function(target){
            $(target).datebox('clear');
        }
    });
    $("input[class='easyui-ext-datebox']").datebox({
        buttons: buttons
    });
    var timebuttons = $.extend([], $.fn.datetimebox.defaults.buttons);
    timebuttons.splice(1, 0, {
        text: '清空',
        handler: function(target){
            $(target).datetimebox('clear');
        }
    });
    $("input[class='easyui-ext-datetimebox']").datetimebox({
        buttons: timebuttons
    });
});