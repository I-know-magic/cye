package smart.light.base

import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.LogUtil
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.springframework.web.context.request.RequestContextHolder

//TODO 修改类注释
/**
 * GoodsUnitService
 * @author CodeGen
 * @generate at 2016-06-12 15:40:06
 */
@Transactional
class GoodsUnitService extends BaseServiceImpl{

    def queryGoodsUnitList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            //TODO 判断是否存在isDelete
            // where 1 = 1
            StringBuffer query = new StringBuffer("from GoodsUnit t where t.isDeleted = false and tenantId= :tenantId ")
            StringBuffer queryCount = new StringBuffer("select count(t) from GoodsUnit t where t.isDeleted = false and tenantId= :tenantId ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            String sid=LightConstants.querySid();
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));
            params.each { k, v ->
                if('codeName'.equals(k)&&v){
                    query.append(' AND (t.unitCode like :unitCode or t.unitName like :unitName) ')
                    queryCount.append(' AND (t.unitCode like :unitCode or t.unitName like :unitName) ')
                    namedParams.unitCode = "%$v%"
                    namedParams.unitName = "%$v%"
                }
            }
            def list = GoodsUnit.executeQuery(query.toString(), namedParams, queryParams)
            def count = GoodsUnit.executeQuery(queryCount.toString(), namedParams)
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

    /**
     * 新增或更新GoodsUnit
     * @param goodsUnit
     * @return
     */
    def save(GoodsUnit goodsUnit) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (!goodsUnit.validate()) {
                result.success = false
                goodsUnit.errors.allErrors.each {
                    result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
                }
                result.object = goodsUnit
            }else if (goodsUnit.id) {
                if (goodsUnit.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oGoodsUnit = GoodsUnit.findById(goodsUnit.id)
                oGoodsUnit.unitCode=goodsUnit.unitCode
                oGoodsUnit.unitName=goodsUnit.unitName
                LightConstants.setFiledValue(GoodsUnit.class,true,oGoodsUnit);
                oGoodsUnit.save flush: true
                result.setMsg("修改成功")
            } else {
                LightConstants.setFiledValue(GoodsUnit.class,true,goodsUnit);
                goodsUnit.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增GoodsUnit
     * @param id GoodsUnit主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            GoodsUnit goodsUnit = new GoodsUnit()
            goodsUnit.unitCode = SerialNumberGenerate.getNextCode(2, goodsUnitService.getMaxGoodsUnitCode())
            result.object = goodsUnit

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑GoodsUnit
     * @param id GoodsUnit主键id
     * @return
     */
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                GoodsUnit goodsUnit = GoodsUnit.findById(Integer.parseInt(id))
                result.object = goodsUnit
            } else {
                throw new Exception("无效的id")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1004", "编辑失败", e.message)
            throw se
        }
    }
    /**
     * 检查菜品单位是否被使用
     * @param unitId
     * @return
     */
    def checkGoodsUnit(def unitId){
        def sql="select count(*) from v_goods_package_v060 where unitId="+unitId
        def sq = getSession().createSQLQuery(sql)
        def total = sq.list()[0]
        if(total>0){
            return false
        }else{
            return true
        }
    }

    /**
     * 删除GoodsUnit，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    GoodsUnit goodsUnit = GoodsUnit.findById(Integer.parseInt(id))
                    // 删除时判断是否有菜品使用
//                    def checkResult=checkGoodsUnit(new BigInteger(id))
//                    if(!checkResult){
//                        result.success="false"
//                        result.msg="菜品单位已被使用，不可删除！"
//                        break;
//                    }else{
                        goodsUnit.isDeleted = true
                        goodsUnit.save flush: true
                        result.success="true"
                        result.setMsg("删除成功!")
//                    }
                }
            }
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            LogUtil.logError(e.message)
            throw se
        }
    }
    /**
     * 验证菜品单位名称是否重复
     * @param catName
     * @param tenantId
     * @param categoryId
     * @return
     */
    def checkCode(String unitName,BigInteger goodsUnitId) {
        ResultJSON result = new ResultJSON()
        try {
            List<GoodsUnit> countList=GoodsUnit.findAllByUnitName(unitName)
            int count = countList.size()

            if (count == 0) {
                result.success = "true";
            } else if(count==1){
                if(goodsUnitId){
                    if(goodsUnitId.compareTo(countList[0].id)==0){
                        result.success = "true";
                    }else{
                        result.success = "false";
                    }
                }else{
                    result.success = "false";
                }

            }else{
                result.success = "false";
            }


        } catch (Exception e) {
            ServiceException se = new ServiceException("106", "商户内菜品单位名称唯一校验失败", e.message)
            throw se

        }
        return result;
    }

    /**
     * 获取GoodsUnit
     * @return
     */
    def List<GoodsUnit> getGoodsUnitList(){
        String sid=LightConstants.querySid();
        return GoodsUnit.executeQuery("from GoodsUnit t where t.isDeleted = false  and t.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))}")
    }

    /**
     * 获得最大菜品单位编码号
     * TenantId是通过@TenantFilter
     * @return
     */
    public def getMaxGoodsUnitCode() {
        String sid=LightConstants.querySid();

        def hql = "SELECT MAX(b.unitCode) FROM GoodsUnit AS b where b.isDeleted = false  and b.tenantId= ${new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID))} "
        String max
        GoodsUnit.withSession { s ->
            max = s.createQuery(hql).list().get(0)
        }
        return max
    }
}
