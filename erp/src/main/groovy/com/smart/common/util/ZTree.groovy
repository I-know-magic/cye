package com.smart.common.util/** * ZTree抽象类 * hexiaohong on 2015/7/3. */class ZTree {    /**     * 节点数据中保存唯一标识的属性名称     */    String id    /**     * 节点数据中保存其父节点唯一标识的属性名称     */    String pId    /**     * zTree 节点数据保存节点名称的属性名称。     */    String name    /**     * zTree 节点数据保存节点提示信息的属性名称     * 默认为name     */    String title    /**     * zTree 节点数据保存节点链接的目标 URL 的属性名称     * 默认为name     */    String url    /**     * 设置节点是否隐藏 checkbox / radio [setting.check.enable = true 时有效]     */    boolean nocheck = false    /**     * 1、初始化节点数据时，根据 treeNode.children 属性判断，有子节点则设置为 true，否则为 false     * 2、初始化节点数据时，如果设定 treeNode.isParent = true，即使无子节点数据，也会设置为父节点     */    boolean isParent  = null    /**     * 节点类型(扩展属性)，标示节点的类型     */    String nodeType    /**     * title 默认name     * @return     */    public String getTitle(){        if (title){            return title        }        return name    }    /**     * 备注(扩展属性)     */    String memo    BigInteger childNumber//    String limitDate    boolean chkDisabled    boolean checked    boolean  open=false    boolean  isHidden=false    String text    String state    Map<String,Object> attributes    List<ZTree> children=new ArrayList<ZTree>()    def addChild(ZTree tree){        children.add(tree)    }    /**     * 递归，多级树     * @param list     * @param id     * @return     */    public static ZTree findInList(List<ZTree> list, Integer id) {        for(ZTree node : list) {            if (node.getId()==id.toString()){                return node;            }            else{                ZTree childNode =findInList(node.children, id);                if(null!=childNode){                    return childNode;                }            }        }        return null;    }}