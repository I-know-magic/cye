/**
 * tree
 * @type {{view: {selectedMulti: boolean, expandSpeed: string}, data: {simpleData: {enable: boolean, idKey: string, pIdKey: string, rootId: string}, key: {name: string}}, callback: {onClick: clickTree}}}
 */
var tree_obj;
var treeNodes_obj;
var zTree_obj;
var _idKey="id1";
var _pIdKey="parentId1"
var _name="name1";
var _clickTree=true;
var tree_Obj;
var text;
var code;
var kindId;
var nodes;
var setting;
var _url;
var _fn=function clickTree(event, treeId, treeNode) {
    debugger;
    text = treeNode.name;
    var id=0;
    var isArea=0;
//            code = treeNode.catCode;
    if(_clickTree){
        kindId = treeNode.id;
    }else{
        kindId = treeNode.tid;
        id=treeNode.id;
        isArea=treeNode.isArea;
    }


    nodes = treeNode;
    if(_clickTree || (!_clickTree&&isArea==1)||(!_clickTree&&id==-1)){
        if(_url){
            $('#mainGrid').datagrid({
                url:_url,
                queryParams: {
                    kindId: kindId
                }
            });
        }else{
            $('#mainGrid').datagrid({
                queryParams: {
                    kindId: kindId
                }
            });
        }

    }

    isSelect = true;
}

/**
 *
 * @param id 当前节点id
 * @param pid 父节点id
 * @param name 显示名称
 */
function init_tree(id,pid,name,flag,url,fn){
    //debugger;
    _idKey=id;
    _pIdKey=pid;
    _name=name;
    _clickTree=flag;
    if(fn){
        _fn=fn;
    }

    _url=url;
    setting = {
        view: {
            selectedMulti: false,
            expandSpeed: "fast"
        },
        data: {
            simpleData: {
                enable: true,
                idKey: _idKey,
                pIdKey: _pIdKey,
                rootId: ""
            },
            key: {
                name: _name
            }
        },
        callback: {
            onClick: _fn
        }
    }
}
function loadMyTree(url) {
    $.ajax({
        async: false,
        url: url,
        type: "post",
        dataType: 'json',
        success: function (data) {
            treeNodes_obj = data;
            for (var key in treeNodes_obj) {
                treeNodes_obj[key].open = true;
            }
            zTree_obj = $.fn.zTree.init($("#kindTree"), setting, treeNodes_obj);
            tree_Obj = $.fn.zTree.getZTreeObj("kindTree");
            var node = tree_Obj.getNodeByParam("id", -1, null);
            tree_Obj.selectNode(node);

        }
    })
}

