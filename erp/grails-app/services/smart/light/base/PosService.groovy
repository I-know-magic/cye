package smart.light.base

import api.common.ApiRest
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional
import org.apache.commons.lang.Validate
import smart.light.auth.BranchService
import smart.light.saas.Branch

//TODO 修改类注释
/**
 * PosService
 * @author CodeGen
 * @generate at 2016-06-12 15:40:24
 */
@Transactional
class PosService {

    BranchService branchService
    /**
     * 查询Pos列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryPosList(Map<String,String> params) throws ServiceException {
        try {

            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from Pos t where t.isDeleted = false  and tenantId= :tenantId ")
            StringBuffer queryCount = new StringBuffer("select count(t.id) from Pos t where t.isDeleted = false and  tenantId= :tenantId ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            String sid=LightConstants.querySid();
            namedParams.tenantId = new BigInteger(LightConstants.getFromSession(sid, SessionConstants.KEY_TENANT_ID));

            params.each { k, v ->
                if ('posCode'.equals(k) && v) {
                    query.append(' AND t.posCode like :posCode ')
                    queryCount.append(' AND t.posCode like :posCode ')
                    namedParams.posCode = "%$v%"
                }
                if ('tenantId'.equals(k) && (v =~ /\d+/).matches()) {
                    query.append(' AND t.tenantId= :tenantId ')
                    queryCount.append(' AND t.tenantId= :tenantId ')
                    namedParams.tenantId = v.asType(BigInteger)
                }
                if ('branchId'.equals(k) && (v =~ /\d+/).matches()) {
                    query.append('AND t.branchId= :branchId')
                    queryCount.append('AND t.branchId= :branchId')
                    namedParams.branchId = v.asType(BigInteger)
                }
            }
            def list = Pos.executeQuery(query.toString(), namedParams, queryParams)
            def count = Pos.executeQuery(queryCount.toString(), namedParams)
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
     * 新增
     * @param pos
     * @return
     * @update:hxh
     * 总部只能维护自己门店的pos，分店同上
     */
    def save(Pos pos) throws ServiceException {
        Validate.notNull(pos,'pos is not null')
        try {
            ResultJSON result = new ResultJSON()
            pos.posCode = SerialNumberGenerate.nextSerialNumber(3,getMaxPosCode(pos.tenantId))
            pos.branchId = LightConstants.getBranchId()
            def branch = Branch.findById(pos.branchId)
            pos.branchName = branch.name
            pos.branchCode = branch.code
            pos.id = null
//            pos.password = pos.password.encodeAsMD5() //加密
            if(pos.validate()){
                LightConstants.setFiledValue(Pos.class,true,pos);

                pos.save flush: true
                result.success = true
                result.msg = '保存成功'
                result.object = pos
            }else {
                result.success = false
                pos.errors.allErrors.each {
                    result.msg = result.msg + "${it.field } = ${it.rejectedValue};"
                }
                result.object = pos
            }
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 更新状态
     * @param id
     * @param status
     * @return
     * @update:hxh
     * 总部只能更新自己门店的pos状态，分店同上
     */
    def updateStatus(BigInteger id,Integer status,String newPw){
        Validate.notNull(id,'id is not null')
        Validate.notNull(status,'status is not null')
        ResultJSON result = new ResultJSON()
        try {
            def pos = Pos.findById(id)
            if(pos){
                pos.status = status > 0 ? 1 : 0
                pos.password=newPw
                LightConstants.setFiledValue(Pos.class,true,pos);
                pos.save flush: true
                result.success = true
                result.msg = '修改成功'
            } else {
                result.success = false
                result.msg = '修改失败，不存在'
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "修改失败", e.message)
            throw se
        }
        return result
    }

    /**
     * 更新密码
     * @param id
     * @param newPw
     * @return
     */
    def updatePassword(BigInteger id,String newPw){
        Validate.notNull(id,'id is not null')
        ResultJSON result = new ResultJSON()
        try {
            def pos = Pos.findByIdAndBranchId(id,LightConstants.getBranchId())
            if(pos){
                pos.password = newPw
                LightConstants.setFiledValue(Pos.class,true,pos);
                pos.save flush: true
                result.success = true
                result.msg = '修改成功'
            } else {
                result.success = false
                result.msg = '修改失败，不存在'
            }
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "修改失败", e.message)
            throw se
        }
        return result
    }

    /**
     * 重置门店 设备码置为空
     * @param id
     * @return
     */
    def resetBranch(BigInteger id){
        Validate.notNull(id,'id is not null')
        ResultJSON result = new ResultJSON()
        def pos = Pos.findByIdAndBranchId(id,LightConstants.getBranchId())
        if(pos){
            pos.deviceCode = ''
            pos.status = 0
            pos.accessToken = ''
            pos.save()
            result.success = true
            result.msg = '注销成功'
        } else {
            result.success = false
            result.msg = ''
        }
        return result
    }

    /**
     * 编辑Pos
     * @param id Pos主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Pos pos = Pos.findById(Integer.parseInt(id))
                result.object = pos
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
     * 查找find
     * @param id Pos主键id
     * @return
     */
    @Transactional(readOnly = true)
    def find(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Pos pos = Pos.findById(Integer.parseInt(id))
                result.object = pos
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
     * 删除Pos，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Pos pos = Pos.findByIdAndBranchId(Integer.parseInt(id),LightConstants.getBranchId())
                    LightConstants.setFiledValue(Pos.class,true,pos);
                    pos.isDeleted = true
                    pos.save flush: true
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }

    /**
     * 获取最大posCode
     */
    def getMaxPosCode(BigInteger tenantId){
        def hql = "select max(p.posCode) from Pos as p where p.tenantId = ${tenantId.toString()}"
        String max
        Pos.withSession { s ->
            max = s.createQuery(hql).list()?.get(0)
        }
        return max
    }

    /**
     * 根据查询条件获得状态启用的pos
     * @param tenantId
     * @param posCode
     * @param branchCode
     * @param pass
     * @return Pos or null
     */
    public Pos queryPosStatusIsTrue(BigInteger tenantId, String posCode, String branchCode, String pass) throws ServiceException {
        try {
            Validate.notNull(tenantId, 'tenantId is not null')
            Validate.notNull(posCode, 'posCode is not null')
            Validate.notNull(pass, 'pass is not null')
            Validate.notNull(branchCode, 'branchCode is not null')
            return Pos.findByTenantIdAndBranchCodeAndPasswordAndPosCode(tenantId, branchCode, pass, posCode)
        } catch (Exception e) {
            throw new ServiceException("1001", "查询失败", e.message)
        }
    }

    /**
     * 根据id更新deviceCode
     * @param id not null
     * @param deviceCode not null and not empty
     * @return
     */
    public ResultJSON updatePosDeviceCodeById(BigInteger id,String deviceCode){
        ResultJSON json = new ResultJSON()
        json.isSuccess = false
        try {
            Validate.notNull(id, 'id is not null')
            Validate.notNull(deviceCode, 'deviceCode is not null')
            Validate.notEmpty(deviceCode, 'deviceCode is not empty')
            def p = Pos.findByDeviceCode(deviceCode)
            if (p){
                json.msg = "POS已初始化，对应的门店:${p.branchName},请解除与门店的关系"
                return json
            }
            def pos = Pos.get(id)
            if (!pos){
                json.msg = "id=${id},不存在"
                return json
            }
            pos.deviceCode = deviceCode
            if (pos.validate()){
                pos.save flush: true
                json.isSuccess = true
                json.msg = '更新成功'
            }
            else{
                pos.errors.allErrors.each {
                    json.msg = json.msg + "${it.field }=${it.rejectedValue},长度不能大于45个字符;"
                }
            }
            return json
        } catch (Exception e) {
            throw new ServiceException("1001", "查询失败", e.message)
        }
    }
    /**
     * 根据id更新门店名称字段
     * @param id not null
     * @param deviceCode not null and not empty
     * @return
     */
    public ResultJSON updatePosBranchNameById(BigInteger id,String branchName){
        ResultJSON json = new ResultJSON()
        json.isSuccess = true
        try {
            Validate.notNull(id, 'id is not null')
            Validate.notNull(branchName, 'branchName is not null')
            Validate.notEmpty(branchName, 'branchName is not empty')
            List<Pos> poses = Pos.findAllByBranchId(id)
            for(int i=0;i<poses.size();i++){
                def pos= poses.get(i)
                pos.branchName = branchName
                if (pos.validate()){
                    pos.save flush: true
                    json.isSuccess = true
                    json.msg = '更新成功'
                }
                else{
                    json.isSuccess=false
                    pos.errors.allErrors.each {
                        json.msg = json.msg + "${it.field }=${it.rejectedValue},长度不能大于45个字符;"
                    }
                }
            }
            return json
        } catch (Exception e) {
            throw new ServiceException("1001", "更新门店名称失败", e.message)
        }
    }

    /**
     * 启用POS
     */
    def disableOrEnablePos(BigInteger posId, Integer status) {
        ApiRest apiRest = new ApiRest()
        try {
            Pos pos = Pos.get(posId)
            Validate.notNull(pos, "ID为${posId}的POS不存在")
            pos.status = status
            pos.save flush: true
            apiRest.isSuccess = true
            apiRest.message = status == 0 ? "停用成功" : "启用成功"
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", status == 0 ? "停用失败" : "启用失败")
            throw se
        }
        return apiRest
    }

    /**
     * 初始化POS
     *
     */
    def initPos(BigInteger id, String deviceCode, String accessToken) {
        ApiRest apiRest = new ApiRest()
        try {
            Validate.notNull(id, "id is not null")
            Validate.notNull(deviceCode, "deviceCode is not null")
            Validate.notNull(accessToken, "accessToken is not null")
            Pos p = Pos.findByDeviceCode(deviceCode)
            if (p) {
                apiRest.isSuccess = false
                apiRest.error = "POS已初始化，对应的门店:${p.branchName}，请解除与门店的关系"
                return apiRest
            }
            Pos pos = Pos.get(id)
            if (!pos) {
                apiRest.isSuccess = false
                apiRest.error = "id=${id}的POS不存在"
                return apiRest
            }
            pos.deviceCode = deviceCode
            pos.accessToken = accessToken
            pos.save flush: true
            apiRest.isSuccess = true
            apiRest.message = "初始化成功"
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "初始化POS失败：" + e.message)
            throw se
        }
        return apiRest
    }
}
