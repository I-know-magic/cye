/**
 * Created by LiuJie on 2016/3/3.
 */
;(function($){
    $.fn.rTree=function(){

    };
    /**
     * 分装查询条件中的分类树
     * @param options
     */
    $.fn.categoryTree=function(options){
        var _tree=this.selector;
        var params={
            url:'',
            queryParam:{},
            onSuccess:null,
            onClick:null
        };
        params= $.extend(params,options);
        $.category_Tree.init(_tree,params);
        $.category_Tree.createTree(_tree,params);
    };
    $.extend({
        category_Tree:{
            template:'<ul class="abs pop-up-listbox  categoryTree_dom for_select" style="display:none;max-height: 300px;overflow-y: auto">'
                        +'<li class="all_menu">'
                            +'<p class="first-menu" style="padding-left: 0px" >全部分类</p>'
                        +'</li>'
                        +'</ul>',
            kind_li:'<li><p class="first-menu first_menu" style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap" kindMenu></p></li>',

            kind_p:'<ul class="second-menu"><li><p class="second_menu" kindMenu style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap"></p></li></ul>',//二级分类
            three_li:'<ul class="third-menu"><li></li></ul>',
            three_menu:'<p class="three_menu" style="padding-left: 50px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap" kindMenu></p>',
            /**
             * 初始化分类树
             * @param tree
             * @param param
             */
            init:function(tree,param){
                var _tree_parent=$(tree).parent();
                var _tree_select=$(tree).next(".categoryTree_select");
                var _categoryTree = $(_tree_parent).next(".categoryTree_dom");
                var tree_template= $.category_Tree.template;
                if(_categoryTree.length==0){
                    $(_tree_parent).after(tree_template);
                }else{
                    $(_categoryTree).remove();
                    $(_tree_parent).after(tree_template);
                }
            },
            /**
             * ajax请求服务器分类数据
             * @param tree
             * @param param
             */
            createTree:function(tree,param){
                //*******ajax请求分类数据*********//
                $.ajax({
                    url:param.url,
                    type:'post',
                    async:true,
                    dataType:'json',
                    data:param.queryParam,
                    success:function(result){
                        if(result&&result.isSuccess==true){
                            //组装分类数据
                            var cateTrees= $.treeVo.newTreeVo(result);
                            //创建分类数据
                            $.category_Tree.installTree(tree,cateTrees,param);
                            if(param.onSuccess && $.isFunction(param.onSuccess)){
                                param.onSuccess();
                            }
                        }
                    },
                    error:function(){

                    }
                })
            },
            /**
             * 根据服务器分类数据 对树html元素进行组装
             * @param tree
             * @param cateTrees
             */
            installTree:function(tree,cateTrees,params){
                    var treeJSON=cateTrees;
                    var _tree_parent=$(tree).parent();
                    var _tree_select=$(tree).next(".categoryTree_select");
                    var _category_dom = $(_tree_parent).next(".categoryTree_dom");
                    var Ul_height=$(_category_dom).width();
                    if(treeJSON&&treeJSON.length>0){
                        for(var i=0;i<treeJSON.length;i++){
                            var cate_tree = treeJSON[i];//分类对象
                            var first_li= $.category_Tree.kind_li;//li元素
                            var first_child_trees=cate_tree.childrens;//第一级分类下的子分类-二级分类
                            $(_category_dom).append(first_li);
                            var _first_menu = $(_category_dom).find(".first_menu");//获取所有一级分类
                            $(_first_menu[i]).css({"width":(Ul_height-38)+"px"});
                            $(_first_menu[i]).attr("id",cate_tree["id"]);
                            $(_first_menu[i]).attr("catCode",cate_tree["catCode"]);
                            $(_first_menu[i]).attr("parentId",cate_tree["parentId"]);
                            $(_first_menu[i]).data("treeVo",cate_tree);
                            $(_first_menu[i]).text(cate_tree["catName"]);//写入一级分类的名字
                            if(first_child_trees&&first_child_trees.length>0){
                                for(var x=0;x<first_child_trees.length;x++){
                                    var second_li = $.category_Tree.kind_p;//获取二级分类模板
                                    var second_tree=first_child_trees[x];//二级分类对象
                                    var second_child_trees=second_tree.childrens;//二级分类下的子分类-三级分类
                                    $(_first_menu[i]).after(second_li);
                                    var _second_menu = $(_first_menu[i]).next("ul").find("p.second_menu");
                                    $(_second_menu).css({"width":(Ul_height-58)+"px"});
                                    $(_second_menu).attr("id",second_tree["id"]);
                                    $(_second_menu).attr("catCode",second_tree["catCode"]);
                                    $(_second_menu).attr("parentId",second_tree["parentId"]);
                                    $(_second_menu).data("treeVo",second_tree);
                                    $(_second_menu).text(second_tree["catName"]);//写入二级分类的名字
                                    if(second_child_trees&&second_child_trees.length>0){
                                        var three_li = $.category_Tree.three_li;//获取三级分类模板
                                        $(_second_menu).after(three_li);
                                        for(var y=0;y<second_child_trees.length;y++){
                                            var three_menu=$.category_Tree.three_menu;
                                            var three_tree=second_child_trees[y];//二级分类对象
                                            var _three_li = $(_second_menu).next("ul").find("li");
                                            $(_three_li).append(three_menu);
                                            var _three_menu = $(_three_li).find(".three_menu");//获取三级分类 html元素
                                            $(_three_menu[y]).css({"width":(Ul_height-68)+"px"});
                                            $(_three_menu[y]).attr("id",three_tree["id"]);
                                            $(_three_menu[y]).attr("catCode",three_tree["catCode"]);
                                            $(_three_menu[y]).attr("parentId",three_tree["parentId"]);
                                            $(_three_menu[y]).data("treeVo",three_tree);
                                            $(_three_menu[y]).text(three_tree["catName"]);//写入三级分类的名字
                                        }

                                    }
                                }

                            }
                        }
                    }else{
                        $(_category_dom).find(".all_menu").find("p").text("暂无分类");
                        $(tree).val("暂无分类");
                    }

                //$(_category_dom).show();
                //*****绑定相关事件******//
                $(_tree_select).click(function(){
                    $(".for_select").slideUp();
                    if($(_category_dom).is(":visible")){
                        $(_category_dom).slideUp();
                    }else{
                        $(_category_dom).slideDown();
                    }
                });
                var cateIds=[];
                $("[kindMenu]").click(function(){
                    $("[kindMenu]").removeClass("current");
                    $(this).addClass("current");
                    var kind_value=$(this).text();
                    $(tree).val(kind_value);
                    var treeObj=$(this).data("treeVo");
                    if(treeObj.childNum==0){
                        $("#categoryId").val(treeObj.id)
                    }else{
                        getIds(treeObj);
                        console.log("分类ids:"+cateIds);
                        $("#categoryId").val(cateIds);
                    }

                    $(_category_dom).slideUp();
                    if(params.onClick && $.isFunction(params.onClick)){
                        params.onClick();
                    }

                });
                function getIds(treeObj){
                        var childs=treeObj.childrens;
                        if(childs.length>0){
                            for(var i=0;i<childs.length;i++){
                                cateIds.push(childs[i].id);
                                if(childs[i].childNum==0){
                                    continue;
                                }else{
                                    getIds(childs[i])
                                }
                            }
                        }
                };
            }
        },
        treeVo:{
            /**
             * 组装分类树
             * @param result
             */
            newTreeVo:function(result){

                var firstTrees=[];//一级分类
                var secondTrees=[];//二级分类
                var threeTrees=[];//三级分类
                var treeVos=result.data;
                if(treeVos&&treeVos.length>0){
                    for(var i=0;i<treeVos.length;i++){
                        //分类树组装对象
                        var tree={
                            catCode:'',
                            catName:'',
                            childNum:0,
                            goodsNum:0,
                            id:0,
                            mnemonics:'',
                            parentId:0,
                            tenantId:0,
                            childrens:[]
                        };
                        var treeVo=treeVos[i];
                        tree= $.extend(tree,treeVo);
                        if(treeVo["id"]!=-1){
                            //筛选一级分类
                            if(treeVo["parentId"]==-1){
                                //tree= $.extend(tree,treeVo);
                                firstTrees.push(tree);
                            }else{
                                //筛选二级、三级分类
                                if(treeVo["childNum"]>0){
                                    //tree= $.extend(tree,treeVo);
                                    secondTrees.push(tree);
                                }else{
                                    //tree= $.extend(tree,treeVo);
                                    threeTrees.push(tree);
                                }
                            }
                        }

                    }
                }
                var delTrees =[];
                //****防止没有子节点的二级分类push到三级分类中****//
                if(threeTrees.length>0){
                    for(var i=0;i<threeTrees.length;i++){
                        if(firstTrees.length>0){
                            for(var j=0;j<firstTrees.length;j++){
                                if(i<threeTrees.length){
                                    if(threeTrees[i]["parentId"]==firstTrees[j]["id"]){
                                        secondTrees.push(threeTrees[i]);
                                        delTrees.push(threeTrees[i]);
                                    }
                                }
                            }
                        }

                    }
                }
                if(delTrees.length>0){
                    for(var i =0;i<delTrees.length;i++){
                        var delTree = delTrees[i];
                        if(threeTrees.length>0){
                            for(var j=0;j<threeTrees.length;j++){
                                if(delTree["id"]==threeTrees[j]["id"]){
                                    var index= $.inArray(threeTrees[j],threeTrees);
                                    threeTrees.splice(index,1);
                                }
                            }
                        }
                    }
                }
                //*********开始组装分类树*************//
                var trees=[];
                if(firstTrees.length>0){
                    for(var k=0;k<firstTrees.length;k++){
                        var firstTree=firstTrees[k];
                        if(secondTrees.length>0){
                            for(var n=0;n<secondTrees.length;n++){
                                var secondTree=secondTrees[n];
                                if(secondTree["parentId"]==firstTree["id"]){
                                    if(threeTrees.length>0){
                                        for(var m=0;m<threeTrees.length;m++){
                                            var threeTree=threeTrees[m];
                                            if(threeTree["parentId"]==secondTree["id"]){
                                                secondTree.childrens.push(threeTree);
                                            }
                                        }
                                    }
                                    firstTree.childrens.push(secondTree);
                                }
                            }
                        }

                        trees.push(firstTree);
                    }
                }

                return trees;
            }


        }

    })
})(jQuery);