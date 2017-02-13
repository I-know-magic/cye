package smart.light.base

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import smart.light.bus.Store
import smart.light.web.vo.GoodsVo

//TODO 修改类注释
/**
 * GoodsService
 * @author CodeGen
 * @generate at 2016-06-12 15:39:49
 */
@Transactional
class GoodsService extends BaseServiceImpl {

    CategoryService categoryService
    /**
     * 查询Goods列表
     * 支持不分页查询 rows,page 为null
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    def queryGoodsList(Map<String, String> params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()
            StringBuffer query = new StringBuffer("from Goods t where t.isDeleted = false  and tenantId= :tenantId  ")
            StringBuffer queryCount = new StringBuffer("select count(t.id) from Goods t where t.isDeleted = false  and tenantId= :tenantId  ")
            def queryParams = new HashMap()
//            if (params['notMaterial'] == "true") {
//                query.append(" and t.goodsType!=3")
//                queryCount.append(" and t.goodsType!=3")
//            }
            if (params['rows'] && params['page']) {
                queryParams.max = params['rows'] ? params['rows'] : 20
                queryParams.offset = (Integer.parseInt(params['page']) - 1) * Integer.parseInt(queryParams['max'])
            }
            def namedParams = new HashMap()
            String sid=LightConstants.querySid();
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

            params.each { k, v ->
                if ('goodsCodeOrName'.equals(k) && v) {
                    query.append(' AND (t.barCode like :goodsName or t.goodsName like :goodsName) ')
                    queryCount.append(' AND (t.barCode like :goodsName or t.goodsName like :goodsName) ')
                    namedParams.goodsName = "%$v%"
                }
                if ('branchId'.equals(k) && (v =~ /\d+/).matches()) {
                    query.append(' AND t.branchId= :branchId ')
                    queryCount.append(' AND t.branchId= :branchId ')
                    namedParams.branchId = v.asType(BigInteger)
                }
                if ('categoryIds'.equals(k) && v) {
                    query.append(' AND t.categoryId in( :categoryId )')
                    queryCount.append(' AND t.categoryId in( :categoryId ) ')
                    def categoryIds = []
                    v?.split(',') each {
                        categoryIds.add(it.asType(BigInteger))
                    }
                    namedParams.categoryId = categoryIds
                }
//                if ('isStore'.equals(k) && v) {
//                    query.append(' AND t.isStore = :isStore ')
//                    queryCount.append(' AND t.isStore = :isStore  ')
//                    namedParams.isStore = v.asType(boolean)
//                }
            }
//            query.append('order by tenantCode ,status')
            def count = Goods.executeQuery(queryCount.toString(), namedParams)
            def list = []
            if (count[0] > 0) {
                list = Goods.executeQuery(query.toString(), namedParams, queryParams)
            }
            def voList=[];
            list.each {
                GoodsVo goodsVo=new GoodsVo();
                String strtemp="";
                BigDecimal salePrice=it.salePrice;
                if(it.tastesIds){
                    def tastes=it.tastesIds.split(",")
                    if(tastes){
                        tastes.each {def id ->
                            GoodsSpec goodsSpec=GoodsSpec.findById(new BigInteger(id));
                            if(goodsSpec){
                                strtemp=strtemp+goodsSpec?.specName+",";
                                salePrice=salePrice.add(goodsSpec?.price);
                            }
                        }
                    }

                    if(strtemp){
                        goodsVo.tastes=strtemp.substring(0,strtemp.length()-1);

                    }
                }else{
                    goodsVo.tastes="";
                }
                goodsVo.salePrice=salePrice;
                goodsVo.goodsName=it.goodsName
                goodsVo.goodsName2=it.goodsName2
                goodsVo.categoryName=it.categoryName
                goodsVo.goodsStatus=it.goodsStatus
                goodsVo.id=it.id
                voList.add(goodsVo)
            }
            map.put("total", count.size() > 0 ? count[0] : 0)
            map.put("rows", voList)
            if (list.size() == 0) {
                result.setMsg("无数据")
            }

            result.jsonMap = map
            return result
        } catch (Exception e) {
            e.printStackTrace()
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }
    /**
     * 商品选择对话框加载商品包括套餐
     */
    def queryGoods(Map<String, String> params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()
            StringBuffer query = new StringBuffer("from Goods t where t.isDeleted = false  and tenantId= :tenantId  ")
            StringBuffer queryCount = new StringBuffer("select count(t.id) from Goods t where t.isDeleted = false  and tenantId= :tenantId  ")
//            if (params['isStore'] == "1") {
//                query.append("and goodsType!= 2 ")
//                queryCount.append("and goodsType!= 2 ")
//            } else {
//                query.append("and goodsType!= 3 ")
//                queryCount.append("and goodsType!= 3 ")
//            }
            def queryParams = new HashMap()

            if (params['rows'] && params['page']) {
                queryParams.max = params['rows'] ? params['rows'] : 20
                queryParams.offset = (Integer.parseInt(params['page']) - 1) * Integer.parseInt(queryParams['max'])
            }
            def namedParams = new HashMap()
            String sid=LightConstants.querySid();
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

            params.each { k, v ->
                if ('goodsCodeOrName'.equals(k) && v) {
                    query.append(' AND (t.barCode like :goodsName or t.goodsName like :goodsName) ')
                    queryCount.append(' AND (t.barCode like :goodsName or t.goodsName like :goodsName) ')
                    namedParams.goodsName = "%$v%"
                }
//                if ('branchId'.equals(k) && (v =~ /\d+/).matches()) {
//                    query.append(' AND t.branchId= :branchId ')
//                    queryCount.append(' AND t.branchId= :branchId ')
//                    namedParams.branchId = v.asType(BigInteger)
//                }
                if ('categoryIds'.equals(k) && v) {
                    query.append(' AND t.categoryId in( :categoryId )')
                    queryCount.append(' AND t.categoryId in( :categoryId ) ')
                    def categoryIds = []
                    v?.split(',') each {
                        categoryIds.add(it.asType(BigInteger))
                    }
                    namedParams.categoryId = categoryIds
                }
//                if ('isStore'.equals(k) && v) {
//                    query.append(' AND t.isStore = :isStore ')
//                    queryCount.append(' AND t.isStore = :isStore  ')
//                    namedParams.isStore = v.asType(boolean)
//                }
            }
            def count = Goods.executeQuery(queryCount.toString(), namedParams)
            def list = []
            if (count[0] > 0) {
                list = Goods.executeQuery(query.toString(), namedParams, queryParams)
            }

            def voList=[];
            list.each {
                it.teststr="11223344556677"
                voList.add(it)
            }
            map.put("total", count.size() > 0 ? count[0] : 0)
            map.put("rows", voList)
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


    /**
     * 新增 goods
     * flush==false
     * @param goods isFlush是否更新到数据库
     * @return
     */
    private def save(Goods goods, boolean isFlush = true) throws ServiceException {
        try {
            Validate.notNull(goods, 'goods不可为null')
            ResultJSON result = new ResultJSON()
            goods.id = null
            synchronized (this) {
//                def gc = getMaxGoodSCodeByTenantId(goods.categoryId)
//                def cat = categoryService.edit(goods.categoryId.toString()).object
//                if (!gc) {
//                    String code = cat.catCode;
//                    if (code && code.length() == 2) {
//                        gc = code + '000000'
//                    } else {
//                        gc = code + '0000'
//                    }
//                }
//                goods.barCode = SerialNumberGenerate.nextGoodsCode(gc)
//                if (cat.categoryType - 1 == 0) { //分类是原料 库存和原料true
                    goods.isStore = true
                    def tastes="";
                    def tastesIds="0";
                    tastesIds=goods.tastesIds;
                def temptastesIds="";
                    if(tastesIds){

                        def temparray=tastesIds.split(",")
                        temparray.each {
                            if(it){
                                def goodsSpec=GoodsSpec.findById(new BigInteger(it));
                                def specName=goodsSpec.specName;
                                def specName2=goodsSpec.specName2;
                                def price=goodsSpec.price;
                                if(price!=new BigDecimal("0.00")){
                                    tastes=tastes+specName+"|"+specName2+"|"+price+","
                                }else{
                                    tastes=tastes+specName+"|"+specName2+"|,"
                                }

                                temptastesIds=temptastesIds+it+","
                            }
                        }
                        tastes=tastes.substring(0,tastes.length()-1);
                        temptastesIds=temptastesIds.substring(0,temptastesIds.length()-1);
                    }else{
                        tastes="无"
                        temptastesIds="";
                    }
                goods.tastes=tastes;
//                goods.vipPrice1=goods.salePrice;
//                goods.vipPrice2=goods.salePrice;
                if(temptastesIds){
                    goods.tastesIds=temptastesIds;
                }
    //                    goods.goodsType = 3
//                }

                if (!goods.validate()) {
                    result.success = false
                    goods.errors.allErrors.each {
                        result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
                    }
                    result.object = goods
                } else {
                    def res = validGoodsNum(goods)
                    if (!res.isSuccess) {
                        return res
                    }
//                    if(checkCode(goods)){
                        LightConstants.setFiledValue(Goods.class,false,goods);
                        goods.isStore = true
                        goods.lastUpdateAt=new Date()
                        goods.lastUpdateBy=goods.createBy
                        goods.save flush: isFlush

                        //加入是否刷新库存计算表
                        if (goods.isStore ) {
//                        GoodsStoreList.setReload(1)
                            result.jsonMap.put("isReload","1")
                        }
                        result.success = true
                        result.setMsg("添加成功")
                        result.object = goods
//                    }else{
//                        result.success = false
//                        result.setMsg("商品条码重复")
//                        result.object = goods
//                    }
                }
            }
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 校验商品数量限制
     * @param goods
     * @return
     */
    private ResultJSON validGoodsNum(Goods goods) {
        def res = new ResultJSON(isSuccess: false)
        res.isSuccess = true
        return res
    }

    /**
     * 批量保存goods
     * @param goodsList
     * @return ResultJSON
     *  msg ：执行结果
     *  jsonMap ：错误goods集，jsonMap.size() 错误goods个数
     */
    def saveList(List<Goods> goodsList) throws ServiceException {
        try {
            Validate.notNull(goodsList, 'goodsList不可为null')
            ResultJSON result = new ResultJSON()
            result.jsonMap = [:]
            result.success = true
            int errorGoods = 0
            goodsList.eachWithIndex { Goods entry, int i ->
                if (i != 0 && i % 200 == 0) {
                    Goods.withSession {
                        it.flush()
                        it.clear()
                    }
                }
                def res = new ResultJSON()
                if (!entry.categoryId) {
                    res.success = false
                } else {
                    res = save(entry, true)
                    if (res.jsonMap.isReload == "1"){
                        //加入是否刷新库存计算表
                        result.jsonMap.isReload = "1"
                    }
                }
                if (res.success == 'false') {
                    result.jsonMap.put(entry, res.msg)
                    errorGoods++
                    Goods.withSession {
                        it.flush()
                        it.clear()
                    }
                }
            }
            result.msg = "保存成功个数:${goodsList.size() - errorGoods}"
            return result
        } catch (Exception e) {
            throw new ServiceException("1002", "保存数据失败", e.message)
        }
    }

    /**
     * 编辑Goods
     * @param id Goods主键id
     * @return
     */
    def getGoodsById(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Goods goods = Goods.findById(Integer.parseInt(id))
                StringBuilder sb = new StringBuilder('[')
                if (sb.length() > 1) {
                    sb.deleteCharAt(sb.length() - 1)
                }
                sb.append(']')
//                goods.tastesIds="0"
                if(!goods.tastesIds){ goods.tastesIds="0"}

                result.object = goods
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
     * 更新
     */
    def updateGoods(Goods goods) {
        Validate.notNull(goods, 'goods不能为null!')
        Validate.notNull(goods.id, 'goods.id不能为null!')
        ResultJSON result = new ResultJSON()
        result.success = false
        def saveGoods = Goods.findById(goods.id)
        LightConstants.setFiledValue(Goods.class,true,saveGoods);
        if (!saveGoods) {
            result.msg = '商品已删除或不存在'
            return result
        }
        //加入是否刷新库存计算表
        if (saveGoods.isStore != goods.isStore ) {
//            GoodsStoreList.setReload(1)
            result.jsonMap.put("isReload","1")
        }

        saveGoods.goodsName = goods.goodsName
        saveGoods.goodsName2 = goods.goodsName2
//        saveGoods.barCode = goods.barCode
        saveGoods.categoryId = goods.categoryId
        saveGoods.categoryName = goods.categoryName

//        saveGoods.mnemonic = goods.mnemonic
//        saveGoods.shortName = goods.shortName
        saveGoods.memo = goods.memo
        saveGoods.memo2 = goods.memo2

//        saveGoods.goodsUnitId = goods.goodsUnitId
        def tastes="";
        def tastesIds="0";
        tastesIds=goods.tastesIds;
        def temptastesIds="";
        if(tastesIds && tastesIds!="0"){

            def temparray=tastesIds.split(",")
            temparray.each {
                if(it && it!="0"){
                    def goodsSpec=GoodsSpec.findById(new BigInteger(it));
                    def specName=goodsSpec.specName;
                    def specName2=goodsSpec.specName2;
                    def price=goodsSpec.price;
                    if(price!=new BigDecimal("0.00")){
                        tastes=tastes+specName+"|"+specName2+"|"+price+","
                    }else{
                        tastes=tastes+specName+"|"+specName2+"|,"
                    }
                    temptastesIds=temptastesIds+it+","
                }
            }
            tastes=tastes.substring(0,tastes.length()-1);
            temptastesIds=temptastesIds.substring(0,temptastesIds.length()-1);
        }else{
            tastes="无"
            temptastesIds="0";
        }
        saveGoods.tastes=tastes;
        saveGoods.tastesIds=temptastesIds;

        saveGoods.salePrice = goods.salePrice
//        saveGoods.vipPrice1 = goods.vipPrice1
//        saveGoods.vipPrice2 = goods.vipPrice2
//        saveGoods.purchasingPrice = goods.purchasingPrice

        def cat = categoryService.edit(goods.categoryId.toString()).object
//        saveGoods.isStore = goods.isStore

//        saveGoods.priceType = goods.priceType

        saveGoods.goodsStatus = goods.goodsStatus
        saveGoods.photo = goods.photo
        saveGoods.lastUpdateAt=new Date()
        saveGoods.lastUpdateBy="admin"

        if (saveGoods.validate()) {
//            if(checkCode(saveGoods)){
                saveGoods.save()
                result.msg = '修改成功'
                result.success = true
//            }else {
//                result.msg = '商品条码重复'
//                result.success = false
//            }

        } else {
            saveGoods.errors.allErrors.each {
                result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
                result.object = goods
            }
            Validate.isTrue(false, result.msg)
        }
        return result
    }

    /**
     * 删除Goods，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            int num = 0
            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Goods goods = Goods.findById(id.asType(BigInteger))
                    def quantity = Store.findByGoodsId(goods.id)?.quantity
                    if ((quantity != null && quantity != 0) ){
                        continue
                    }
                    num++
                    goods.isDeleted = true
                    goods.save flush: true

                    //加入是否刷新库存计算表
                    if (goods.isStore ) {
//                        GoodsStoreList.setReload(1)
                        result.jsonMap.put("isReload","1")
                    }
                }
            }
            result.setMsg("成功删除${num}条")
            if (params.ids.split(",").size() > num){
                result.msg += ",未删除商品存在库存"
            }
            result.isSuccess = true
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1004", "删除数据失败", e.message)
            throw se
        }
    }

    /**
     * 获得最大商品号
     * TenantId是通过@TenantFilter
     * @return
     */
    public def getMaxGoodSCodeByTenantId(BigInteger categoryId) {
        if (!categoryId) {
            return null
        }
        def cat = Category.findById(categoryId)
        String sid=LightConstants.querySid();
        def hql = "SELECT MAX(b.barCode) FROM Goods AS b where  b.isDeleted = false  and b.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))} and b.barCode like '${cat.catCode}%'"
        String max
        Goods.withSession { s ->
            max = s.createQuery(hql).list().get(0)
        }
        return max
    }
    def checkCode(Goods goods) {
        String sid=LightConstants.querySid();
        def hql = "SELECT b.id FROM Goods AS b where  b.isDeleted = false and b.barCode='${goods.barCode}' " +
                " and b.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))}"
        List max
        Goods.withSession { s ->
            max = s.createQuery(hql).list()
        }
        ResultJSON result = new ResultJSON()
        if(max.size()==0 ||(max.size()==1&&goods.id==max.get(0))){
            return true
        }else{
            return false
        }
        return true
    }
//    public ResultJSON\
    def updateGoodsByCat(BigInteger cid, String cname, Integer goodsType) {
        try {
            ResultJSON result = new ResultJSON()
            String sql = "update goods set category_name=?  where category_id=? and tenant_id=?"
            int res = getSession().createSQLQuery(sql).setParameter(0, cname).setParameter(1, cid).setParameter(2, LightConstants.getTenantId()).executeUpdate()
            result.isSuccess = true
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("103", "更新数据失败", e.message)
            throw se
        }
    }

    def queryGoodsByCatId(def catId) {
        ResultJSON result = new ResultJSON()
        List<Goods> list = Goods.findAllByCategoryIdAndIsDeleted(catId,false)
        if (list.size() == 0) {
            result.isSuccess = true
        } else {
            result.isSuccess = false
            result.msg = "分类下已建立商品档案,不能增加下级分类!"
        }
        return result
    }
}