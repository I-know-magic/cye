package smart.light.base

import com.smart.common.ResultJSON
import com.smart.common.util.LightConstants
import com.smart.common.exception.ServiceException
import com.smart.common.util.SessionConstants
import grails.transaction.Transactional

//TODO 修改类注释
/**
 * PaymentService
 * @author CodeGen
 * @generate at 2016-06-12 15:40:15
 */
@Transactional
class PaymentService {

    /**
     * 查询Payment列表
     * @param params 参数Map，至少应包含rows,page两个参数
     */
    @Transactional(readOnly = true)
    def queryPaymentList(Map params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            def map = new HashMap<String, Object>()

            StringBuffer query = new StringBuffer("from Payment t where isDeleted=false ")
            StringBuffer queryCount = new StringBuffer("select count(t) from Payment t where isDeleted=false ")
            def queryParams = new HashMap()
            queryParams.max = params.rows
            queryParams.offset = (Integer.parseInt(params.page) - 1) * Integer.parseInt(params.rows)
            def namedParams = new HashMap()
            //TODO 处理查询条件

            def list = Payment.executeQuery(query.toString(), namedParams, queryParams)
            def count = Payment.executeQuery(queryCount.toString(), namedParams)
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
     * 新增或更新Payment
     * @param payment
     * @return
     */
    def save(Payment payment) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (payment.id) {
                if (payment.hasErrors()) {
                    throw new Exception("数据校验失败!")
                }
                def oPayment = Payment.findById(payment.id)
                //TODO 复制对象属性值
                LightConstants.setFiledValue({className}.class,true);
                oPayment.save flush: true
                result.setMsg("编辑成功")
            } else {
                LightConstants.setFiledValue({className}.class,false);
                payment.save flush: true
                result.setMsg("添加成功")
            }

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1002", "保存数据失败", e.message)
            throw se
        }
    }

    /**
     * 新增Payment
     * @param id Payment主键id
     * @return
     */
    @Transactional(readOnly = true)
    def create() throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            Payment payment = new Payment()
            result.object = payment

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1003", "添加失败", e.message)
            throw se
        }
    }

    /**
     * 编辑Payment
     * @param id Payment主键id
     * @return
     */
    @Transactional(readOnly = true)
    def edit(String id) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()
            if (id) {
                Payment payment = Payment.findById(Integer.parseInt(id))
                result.object = payment
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
     * 删除Payment，支持批量删除
     * @param params
     * @return
     */
    def delete(def params) throws ServiceException {
        try {
            ResultJSON result = new ResultJSON()

            if (params.ids) {
                for (String id : params.ids.split(",")) {
                    Payment payment = Payment.findById(Integer.parseInt(id))
                    payment.isDeleted = true
                    payment.save flush: true
                }
            }
            result.setMsg("删除成功!")

            return result
        } catch (Exception e) {
            ServiceException se = new ServiceException("1005", "删除数据失败", e.message)
            throw se
        }
    }
}
