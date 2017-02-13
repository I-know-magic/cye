/**
 * Created by LiuJie on 2016/3/19.
 * 封装关于dataTable表格的通用js方法
 * 注： 此js要放到dataTable.js后面加载
 */
;(function($){
    $.fn.extend({
        /**
         * 通用删除表格数据方法
         * @param url  请求服务器url
         * @param ids  id array
         * @param fn   自定义函数
         * @param params 自定义参数
         */
        dataDel:function(url,ids,fn,params){
            var grid=this.selector;
            if(!url && !(typeof (url)== "string")){

            }
            $.message.confirm("确定要删除一条数据吗？","确认删除",function(t){
                if(t){
                    $.post(url+"?ids="+ids,function(result){
                        if(result&&result.isSuccess){
                            if(fn && $.isFunction(fn)){
                                $(grid).dataTable("reload");
                                fn(result);
                            }
                        }
                    },"json")
                }
            });
        }
    })
})(jQuery);