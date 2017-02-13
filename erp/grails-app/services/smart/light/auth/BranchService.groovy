package smart.light.auth

import com.smart.common.ResultJSON
import com.smart.common.service.impl.BaseServiceImpl
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import grails.transaction.Transactional
import net.sf.json.JSONObject
import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.Validate
import org.hibernate.Query
import org.hibernate.Session
import org.hibernate.service.spi.ServiceException
import smart.light.base.PosService
import smart.light.saas.Branch
//import smart.light.web.base.Area
import smart.light.web.vo.BranchAreaVo
import smart.light.web.vo.BranchVo


//TODO 修改类注释
/**
 * BranchService
 * @author CodeGen
 * @generate at 2015-06-11 10:32:55
 */
@Transactional
class BranchService extends BaseServiceImpl {

    PosService posService;
    EmployeeService employeeService;
    /**
     * 查询Branch列表
     * @param params 参数Map，支持不分页查询
     * @update hxh :改用vo查询
     */

    @Transactional(readOnly = true)
    def queryBranchs(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            String areaId = params.get("areaId");
            def qyeryId = "";
            if (areaId) {
                def queryarea = getSession().createSQLQuery("select getAreaChildLst(" + areaId + ")");
                List list = queryarea.list();
                if (list.size() > 0) {
                    areaId = list.get(0)
                }
                qyeryId = areaId.substring(2)
            }

            //初始化参数
            StringBuilder sb = new StringBuilder()
            def queryParam = [:]
            def max = params['rows'] ? params['rows'] : 20
            def offset = params['page'] ? (Integer.parseInt(params['page']) - 1) * Integer.parseInt(max) : 0
            params.each { k, v ->
                if ('codeName'.equals(k) && v) {
                    sb.append(" AND (m.branch_code like :codeName or m.branch_name like :codeName) ")
                    queryParam.codeName = "%$v%"
                }
                if ('areaId'.equals(k) && (v =~ /\d+/).matches()) {

                    if (qyeryId) {
                        sb.append(" AND m.area_id in (" + qyeryId + ") ")
                    } else {
                        sb.append(" AND m.area_id=:areaId ")
                    }
                    if (!qyeryId) {
                        queryParam.areaId = "$v"
                    }

                }
            }
//            sb.append(" AND m.tenant_id = ${SystemHelper.getTenantId()} ")
            String sql = "SELECT * FROM v_branch_info m WHERE 1=1 " + sb.toString()
            String count = "SELECT COUNT(branch_id) FROM v_branch_info m WHERE 1=1 " + sb.toString()

            def sq = getSession().createSQLQuery(sql)
            def cq = getSession().createSQLQuery(count)

            if (params['rows'] && params['page']) {
                sq.setMaxResults(max?.asType(int))
                sq.setFirstResult(offset?.asType(int))
            }

            queryParam.eachWithIndex { Map.Entry<Object, Object> entry, int i ->
                sq.setParameter(entry.key, entry.value.toString())
                cq.setParameter(entry.key, entry.value.toString())
            }
            def total = cq.list()[0]
            def dataList = []
            List<BranchVo> branchVoList = []
            if (total > 0) {
                dataList = sq.list()
            }
            dataList.each { def it ->
                int c = 0
                def vo = new BranchVo()
                vo.id = it[0]
                vo.tenantId = it[1]
                vo.code = it[2]
                vo.name = it[3]
                vo.branchType = it[4]

                vo.phone = it[5]
                vo.contacts = it[6]
                vo.address = it[7]
                vo.geolocation = it[8]
                vo.areaId = it[9]

                vo.parentId = it[10]
                vo.status = it[11]
                vo.memo = it[12]
                vo.createAt = it[13]
                vo.type = it[14]

                vo.isTinyhall = it[15]
                vo.isTakeout = it[16]
                vo.amount = it[17]
                vo.takeoutRange = it[18]
                vo.takeoutAmount = it[19]

                vo.takeoutTime = it[20]
                vo.startTakeoutTime = it[21]
                vo.endTakeoutTime = it[22]
                vo.shippingPriceType = it[23]
                vo.isBuffet = it[24]

                vo.isInvite = it[25]
                vo.areaCode = it[26]
                vo.areaName = it[27]
                vo.areaParentId = it[28]

                branchVoList << vo
            }
            result.isSuccess = true
            result.jsonMap = ['rows': branchVoList, 'total': total]
            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }
    /**
     * 获得当前登录用户对应商户的所有门店
     */
    def queryBranchs() {
        try {
            def hql = " from Branch t where 1=1 "
            def list = Branch.executeQuery(hql.toString())
            return list
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询当前登录用户对应商户的所有门店失败", e.message)
            throw se
        }
    }

    /**
     * 新增或更新Branch
     * @param branch
     * @return
     */
    @Override
    int hashCode() {
        return super.hashCode()
    }

    def save(Branch branch) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (!branch.validate()) {
                result.success = false
                branch.errors.allErrors.each {
                    result.msg = result.msg + "${it.field} = ${it.rejectedValue};"
//                    if ("${it.field}" == "geolocation") {
//                        result.setMsg("请从地图选择门店位置！")
//                        return false
//                    }
                }
                return result
            } else if (branch.id != null) {
                def oBranch = Branch.findById(branch.id)
                oBranch.name = branch.name
                oBranch.phone = branch.phone
                oBranch.contacts = branch.contacts
                oBranch.address = branch.address
                oBranch.memo = branch.memo
                LightConstants.setFiledValue(Branch.class,true,branch);
                oBranch.save flush: true
//                def updatePosResult = posService.updatePosBranchNameById(oBranch.id, oBranch.name)
//                if (updatePosResult.isSuccess) {
                    result.setMsg("门店信息修改成功！")
                    result.isSuccess = true
//                } else {
//                    Validate.isTrue(false, 'POS门店名称未更新成功，门店信息修改失败！')
//                }
                return result
            } else {
                LightConstants.setFiledValue(Branch.class,false,branch);
                branch.save flush: true
            }


            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }
    /**
     * 添加门店调用接口初始化管理员、角色
     * @param branchId
     * @return
     * @author zhangfei
     */
    def initBranchInfo(BigInteger branchId) {
        try {
//            String tenantCode = SystemHelper.getTenantCode()
//            def tenantId = SystemHelper.getTenantId()
//            Integer discountAmount = 0
//            Integer discountRate = 100
//            String createBy = SystemHelper.getUserName()
//            def initResult = SaaSApi.initBranch(branchId, tenantId, tenantCode, discountAmount, discountRate, createBy)
            return null
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "调用接口初始化管理员、角色失败", e.message)
            LogUtil.logError(e.message)
            throw se
        }

    }

    /**
     * 新增Branch
     * @param id Branch主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            Branch branch = new Branch()
            result.object = branch

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑Branch
     * @param id Branch主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Branch branch = Branch.findById(Integer.parseInt(id))
                result.object = branch
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
     * 删除Branch，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Map<String, String> paramId = new HashMap<String, String>();
                    paramId.put("branchId", id)
                    paramId.put("rows", "20")
                    paramId.put("page", "1")
                    def posList = posService.queryPosList(paramId)
                    def empList = employeeService.queryEmpList(id?.asType(BigInteger))
                    if (empList.jsonMap.rows.size() > 0) {
                        result.setMsg("此门店下有用户不能被删除!");
                        result.isSuccess = false
                    } else if (posList.jsonMap.rows.size() > 0) {
                        result.isSuccess = false
                        result.setMsg("此门店下有pos不能被删除!");
                    } else {
                        Branch branch = Branch.findById(Integer.parseInt(id))
                        branch.isDeleted = true
                        branch.save flush: true
                    }

                }
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }

    /**
     * 获得最大门店编码号
     * TenantId是通过@TenantFilter
     * @return
     */
    public def getMaxBranchCode() {
        def hql = "SELECT MAX(b.code) FROM Branch AS b"
        String max
        Branch.withSession { s ->
            max = s.createQuery(hql).list().get(0)
        }
        return max
    }
    /**
     * 获取总部区域记录
     * @return
     */
    def getDefaultArea() {
//        def area = Area.findByParentId(new BigInteger("-1"))
        return null
    }

    /**
     * 获取list
     * @author hxh
     */
    def getBranchList(Map<String, String> param) {
        def namedParams = new HashMap()
        def query = new StringBuilder(' from Branch b where 1=1 ')
        param?.each { k, v ->
            if ('status'.equals(k) && (v =~ /\d+/).matches()) {
                namedParams.status = v.asType(Integer)
                query.append(' and b.status = :status ')
            }
        }
        return Branch.executeQuery(query.toString(), namedParams)
    }

    def getByCode(String code) {
        return Branch.findByCode(code)
    }

    /**
     * 加载区域门店
     * @param params
     * @throws ServiceException
     */
    def getBranchAreaList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def tenantId = params["tenantId"];
            def querySql = new StringBuffer("SELECT b. NAME AS nodeName,b.id, 1 as isArea," +
                    "b.area_id AS pId FROM branch b  left join area a on a.id=b.area_id where b.area_id is not NULL and b.tenant_id=" + tenantId + " and b.is_deleted=0 and b.status=1 UNION SELECT a.`name` AS nodeName," +
                    "a.id,0 as isArea, " +
                    "case when a.id=45 then 0  else 45  end AS pId FROM area a right join branch b on b.area_id=a.id where a.tenant_id=" + tenantId + " and a.is_deleted=0")
            Query query = getSession().createSQLQuery(querySql.toString());
            List<BranchAreaVo> branchAreaArrayList = new ArrayList<BranchAreaVo>();
            Iterator it = query.list().iterator();
            while (it.hasNext()) {
                BranchAreaVo branchAreaVo = new BranchAreaVo();
                Object[] ob = (Object[]) it.next();
                branchAreaVo.nodeName = (String) ob[0];
                branchAreaVo.childrenId = (BigInteger) ob[1];
                branchAreaVo.isArea = (String) ob[2]
                branchAreaVo.parentId = (BigInteger) ob[3];

                branchAreaArrayList.add(branchAreaVo);
            }
            BranchAreaVo branchAreaVo = new BranchAreaVo();
            branchAreaVo.nodeName = "全选"
            branchAreaVo.childrenId = 0
            branchAreaVo.isArea = "-1"
            branchAreaVo.parentId = -1
            branchAreaArrayList << branchAreaVo
            return branchAreaArrayList;
        } catch (Exception e) {
            ServiceException se = new ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

    @Transactional(readOnly = true)
    def findbyid(BigInteger id) {
        return Branch.findById(id)

    }

    @Transactional(readOnly = true)
    def findBranchByTenant(BigInteger tenantId) {
        List<Branch> branchList = Branch.findAll("from Branch as b where b.isDeleted = false and b.tenantId = " + tenantId);
        return branchList;
    }

    def getAreaNameById(BigInteger areaId) {
//        def areaName
//        if (areaId != null) {
//            Area area = Area.findById(areaId)
//            areaName = area.name
//        }
//        return areaName

    }



    /**
     * 查询Branch列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryBranchList(Map params) throws com.smart.common.exception.ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from Branch t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from Branch t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = Branch.executeQuery(query.toString(), namedParams, queryParams)
            def count = Branch.executeQuery(queryCount.toString(), namedParams)
            map.put("total", count.size() > 0 ? count[0] : 0)
            map.put("rows", list)
            if (list.size() == 0) {
                result.setMsg("无数据")
            }

            result.jsonMap = map
            return result
        } catch (Exception e) {
            com.smart.common.exception.ServiceException se = new com.smart.common.exception.ServiceException("1001", "查询失败", e.message)
            throw se
        }
    }

    /**
     * 新增或更新Branch
     * @param branch
     * @return
     */
//    def save(Branch branch) throws com.smart.common.exception.ServiceException {
//        try {
//            ResultJSON result = new ResultJSON()
//
//            if (branch.id) {
//                if (branch.hasErrors()) {
//                    throw new Exception("数据校验失败!")
//                }
//                def oBranch = Branch.findById(branch.id)
//                //TODO 复制对象属性值
//                LightConstants.setFiledValue({className}.class,true);
//                oBranch.save flush: true
//                result.setMsg("编辑成功")
//            } else {
//                LightConstants.setFiledValue({className}.class,false);
//                branch.save flush: true
//                result.setMsg("添加成功")
//            }
//
//            return result
//        } catch (Exception e) {
//            com.smart.common.exception.ServiceException se = new com.smart.common.exception.ServiceException("1002", "保存数据失败", e.message)
//            throw se
//        }
//    }

    /**
     * 新增Branch
     * @param id Branch主键id
     * @return
     */
//    @Transactional(readOnly = true)
//    def create() throws com.smart.common.exception.ServiceException {
//        try {
//            ResultJSON result = new ResultJSON()
//            Branch branch = new Branch()
//            result.object = branch
//
//            return result
//        } catch (Exception e) {
//            com.smart.common.exception.ServiceException se = new com.smart.common.exception.ServiceException("1003", "添加失败", e.message)
//            throw se
//        }
//    }

    /**
     * 编辑Branch
     * @param id Branch主键id
     * @return
     */
//    @Transactional(readOnly = true)
//    def edit(String id) throws com.smart.common.exception.ServiceException {
//        try {
//            ResultJSON result = new ResultJSON()
//            if (id) {
//                Branch branch = Branch.findById(Integer.parseInt(id))
//                result.object = branch
//            } else {
//                throw new Exception("无效的id")
//            }
//
//            return result
//        } catch (Exception e) {
//            com.smart.common.exception.ServiceException se = new com.smart.common.exception.ServiceException("1004", "编辑失败", e.message)
//            throw se
//        }
//    }

    /**
     * 删除Branch，支持批量删除
     * @param params
     * @return
     */
//    def delete(def params) throws com.smart.common.exception.ServiceException {
//        try {
//            ResultJSON result = new ResultJSON()
//
//            if (params.ids) {
//                for (String id : params.ids.split(",")) {
//                    Branch branch = Branch.findById(Integer.parseInt(id))
//                    branch.isDeleted = true
//                    branch.save flush: true
//                }
//            }
//            result.setMsg("删除成功!")
//
//            return result
//        } catch (Exception e) {
//            com.smart.common.exception.ServiceException se = new com.smart.common.exception.ServiceException("1005", "删除数据失败", e.message)
//            throw se
//        }
//    }

    /**
     * 获取tree数据
     * @return
     */
    def getZTreeJson() {
        StringBuffer query = new StringBuffer(" from Branch t where isDeleted=false order by t.code");
        def namedParams = new HashMap();
        def list = Branch.executeQuery(query.toString(), namedParams);
        Branch obj = new Branch();
        obj.id = -1;
        obj.name = "所有门店";
        list << obj;
        return list
    }
}
