package smart.light.base

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.PinYinHelper
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import com.smart.common.util.ZTree
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.Validate

//TODO 修改类注释
/**
 * CategoryService
 * @author CodeGen
 * @generate at 2016-06-12 15:39:40
 */
@Transactional
class CategoryService {

    GoodsService goodsService
    /**
     * 查询Category列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    def queryCategoryList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            //TODO 判断是否存在isDelete
            // where 1 = 1
            StringBuffer query = new StringBuffer(" from Category t where t.isDeleted = false  and tenantId= :tenantId ")
            StringBuffer queryCount = new StringBuffer("select count(t) from Category t where t.isDeleted = false  and tenantId= :tenantId ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            String sid=LightConstants.querySid();
//            namedParams.tenantId = new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_TENANT_ID));
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

            //TODO 处理查询条件
            def kindId = params.kindId
            if (kindId != null && kindId != "-1") {
                query.append(" and ( t.parentId=:kindId or t.id=:kindId)")
                queryCount.append(" and ( t.parentId=:kindId or t.id=:kindId)")
                namedParams.put("kindId", new BigInteger(kindId))
            }
            def categoryInfo = params.categoryInfo
            if (categoryInfo) {
                query.append(" and (t.catCode like '%" + categoryInfo + "%' or t.catName like '%" + categoryInfo + "%') ")
                queryCount.append(" and ( t.catCode like '%" + categoryInfo + "%' or t.catName like '%" + categoryInfo + "%') ")

            }

            query.append(" order by t.catCode");

            def list = Category.executeQuery(query.toString(), namedParams, queryParams)
            def count = Category.executeQuery(queryCount.toString(), namedParams)
            map.put("total", count.size() > 0 ? count[0] : 0)
            map.put("rows", list)
            if (list.size() == 0) {
                result.setMsg("无数据")
            }

            result.jsonMap = map
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

    def getZTreeJson(def isHavePackage,def isHaveMaterial) {
        StringBuffer query = new StringBuffer(" from Category t where t.isDeleted = false  and tenantId= :tenantId ");
        if(isHaveMaterial == "false"){
            query.append(" and t.categoryType = 0")
        }
        def namedParams = new HashMap();
        String sid=LightConstants.querySid();
//        namedParams.tenantId = new BigInteger(RedisClusterUtils.getFromSession(sid, SessionConstants.KEY_TENANT_ID));
        namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

        def list = Category.executeQuery(query.toString(), namedParams);
        Category category = new Category();
        category.id = -1;
        category.catName = "所有分类";
        category.catCode = "00";
        list << category;
//        if(isHavePackage == "true"){
//            Category category1 = new Category();
//            category1.id = -9900;
//            category1.parentId = -1;
//            category1.catName = "套餐";
//            category1.catCode = "9900";
//            list << category1
//        }
        return list
    }

    def queryTreeDataByParentId() {
        String sid=LightConstants.querySid();
        StringBuffer query = new StringBuffer(" from Category t where t.isDeleted = false  and t.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))} ")
        def list = Category.executeQuery(query.toString())
        return list

    }


    def getJson() {
        def list = queryTreeDataByParentId();
        List<ZTree> treeList = new ArrayList<ZTree>();
        ZTree treeParent = new ZTree();
        treeParent.id = -1;
        treeParent.text = "所有分类";
        treeParent.state = "open";
        treeParent.checked = true;
        Map<String, Object> mapParent = new HashMap<String, Object>();
        mapParent.put("code", "00");
        treeParent.attributes = mapParent;
        treeList.add(treeParent);

        for (int i = 0; i < list.size(); i++) {
            createTree(list.get(i), treeList)

        }
        return treeList

    }

    public ZTree createTree(Category category, List<ZTree> result) {
        BigInteger parentid = category.parentId
        ZTree node = new ZTree();
        node.id = category.id;
        node.text = category.catName;
        node.state = "open";
        Map<String, Object> mapChild = new HashMap<String, Object>();
        mapChild.put("code", category.catCode)
        mapChild.categoryType = category.categoryType
        node.attributes = mapChild
        ZTree parent = ZTree.findInList(result, parentid);
        if (null == parent) {
            result.add(node);
        } else {

            parent.addChild(node);
            parent.state = "open";
        }
        return node
    }

    /**
     * 新增或更新Category
     * @param category
     * oneCode== null 一级 否则 一级编码
     * @return
     */
    def save(Category category, String oneCode) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (!category.validate()) {
                result.success = false
                category.errors.allErrors.each {
                    result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
                }
                result.object = category
            } else if (category.id != null) {
                def oCategory = Category.findById(category.id)
                oCategory.catName = category.catName
                oCategory.mnemonics = PinYinHelper.stringFirstLetter(StringUtils.trimToEmpty(category.catName))
                oCategory.categoryType=category.categoryType
                oCategory.catName2=category.catName2
                LightConstants.setFiledValue(Category.class,true,oCategory);
                oCategory.save flush: true
                goodsService.updateGoodsByCat(oCategory.id,oCategory.catName,oCategory.categoryType==1?3:1)
                result.setMsg("修改成功")
                result.isSuccess = true
            } else {

                if (oneCode) {
                    def code = this.getMaxTwoCodeByCatCode(oneCode)
                    if (code) {
                        category.catCode = SerialNumberGenerate.getNextCatTwoCode(code)
                    } else {
                        category.catCode = SerialNumberGenerate.getNextCatTwoCode(oneCode + "00")
                    }
                } else {
                    category.catCode = SerialNumberGenerate.getNextCode(2, this.getMaxOneCode())
                }
                LightConstants.setFiledValue(Category.class,false,category);

                category.save flush: true
                result.setMsg("添加成功")
                result.isSuccess = true
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 编辑Category
     * @param id Category主键id
     * @return
     */
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Category category = Category.findById(Integer.parseInt(id))
                if (String.valueOf(category.parentId).equals("-1")) {
                    category.parentName = "所有分类"

                } else {
                    Category tempCategory = Category.findById(category.parentId)
                    category.parentName = tempCategory.catName
                }
                result.jsonMap.put("parentName", category.parentName)
                result.object = category

            } else {
                throw new Exception("无效的id")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "编辑失败", e.message)
            throw se
        }
    }

    /**
     * 删除Category，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            Map<String, String> categoryParams = new HashMap<String, String>()
            categoryParams.put("categoryIds", params.ids.toString())//要删除分类的Id
            if (params.ids) {
                def hasGoods = goodsService.queryGoodsList(categoryParams)//判断此分类下是否有菜品
                if (hasGoods.jsonMap.get("total").intValue() > 0) {
                    result.setMsg("此分类下有菜品，不可删除！")
                    result.isSuccess = false
                } else {
                    for (String id : params.ids.split(",")) {
                        Category category = Category.findById(Integer.parseInt(id))
                        category.isDeleted = true
                        category.save flush: true
                    }
                    result.setMsg("删除成功!")
                    result.isSuccess = true
                }

            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1004", "删除数据失败", e.message)
            throw se
        }
    }
    //验证分类名称是否重复
    def checkCode(String catName, BigInteger tenantId, BigInteger categoryId) {
        ResultJSON result = new ResultJSON()
        try {
            List<Category> countList = Category.findAllByCatName(catName)
            int count = countList.size()

            if (count == 0) {
                result.success = "true";
            } else if (count == 1) {
                if (categoryId) {
                    if (categoryId.compareTo(countList[0].id) == 0) {
                        result.success = "true";
                    } else {
                        result.success = "false";
                    }
                } else {
                    result.success = "false";
                }

            } else {
                result.success = "false";
            }


        } catch (Exception e) {
            ServiceException se = new ServiceException("106", "商户内分类名称唯一校验失败", e.message)
            throw se

        }
        return result;
    }

    /**
     * 获取Category
     * @author hxh
     * @return
     */
    @Transactional(readOnly = true)
    def List<Category> getCategoryList() {
        String sid=LightConstants.querySid();
        return Category.executeQuery("from Category c where c.isDeleted = false  and c.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))} ")
    }
    /**
     * 获取Category
     * @author hxh
     * @return
     */
    @Transactional(readOnly = true)
    def List<Category> getNoChildCategoryList() {
        //return Category.executeQuery('from Category c where c.parentId != -1')
        String sid=LightConstants.querySid();
        List<Category> list=Category.executeQuery("from Category c where c.isDeleted = false  and c.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))} ");
        List<Category> result=new ArrayList<Category>()
        for (Category c :list){
            List<Category> l=Category.executeQuery("from Category c where c.isDeleted = false  and c.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))} and c.parentId=${c.id}");
            if(l.size()==0){
                result.add(c)
            }
        }
        return result
    }

    /**
     * 获得最大的二级分类编码
     * @param catCode 一级分类编码
     * @return
     */
    def getMaxTwoCodeByCatCode(String catCode) {
        Validate.notNull(catCode, 'catCode is not null')
        String sid=LightConstants.querySid();
        def hql = "SELECT MAX(b.catCode) FROM Category AS b where b.parentId != -1 and b.catCode like:catCode and length(b.catCode)=4 and b.isDeleted = false  and b.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))}"
        String max
        Category.withSession { s ->
            max = s.createQuery(hql).setParameter('catCode', "${catCode}%".toString()).list().get(0)
        }
        return max
    }
    /**
     * 获得一级分类最大编码
     * @return
     */
    def getMaxOneCode() {
        String sid=LightConstants.querySid();
        def hql = "SELECT MAX(b.catCode) FROM Category AS b where b.parentId = -1 and b.isDeleted = false  and b.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))}"
        String max
        Category.withSession { s ->
            max = s.createQuery(hql).list().get(0)
        }
        return max
    }
}
