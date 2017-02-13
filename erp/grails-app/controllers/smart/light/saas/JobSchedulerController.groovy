package smart.light.saas

import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.DateUtils
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.PropertyUtils
import grails.converters.JSON
import smart.light.web.vo.ComboxVo

//TODO 修改类注释
/**
 * JobSchedulerController
 * @author CodeGen
 * @generate at 2016-04-18 09:53:57
 */
class JobSchedulerController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    JobSchedulerService jobSchedulerService

    /**
     * 显示功能页面
     */
    def index() {
        render(view: "/jobScheduler/view")
    }

    /**
     * 查询
     */
    def list() {
        ResultJSON result
        try {
            result = jobSchedulerService.queryJobSchedulerList(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 新增
     */
    def create() {
        ResultJSON result
        try {
            result = jobSchedulerService.create()
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 修改
     */
    def edit() {
        ResultJSON result
        try {
            String id = params.id;
            result = jobSchedulerService.edit(id)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存
     */
    def save() {
        ResultJSON result
        try {
            params["beginTime"]=DateUtils.StrToDate(params["beginTime"])
            JobScheduler jobScheduler = new JobScheduler(params)
            result = jobSchedulerService.save(jobScheduler)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 更新
     */
    def update() {
        ResultJSON result
        try {
            params["beginTime"]=DateUtils.StrToDate(params["beginTime"])
            JobScheduler jobScheduler = new JobScheduler(params)
            result = jobSchedulerService.save(jobScheduler)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 删除
     */
    def delete() {
        ResultJSON result
        try {
            result = jobSchedulerService.delete(params)
        } catch (ServiceException se) {
            result = new ResultJSON(se.getCodeMessage(), false)
            LogUtil.logError(se, params)
        } catch (Exception e){
            result = new ResultJSON(e)
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 查询员工分类
     */
    def queryJobTypeBox() {
        def list = [];
        ComboxVo comboxVo = new ComboxVo(id: null, text: '-- 请选择 --');
        list.add(0, comboxVo);
        String keyJobType=new String(PropertyUtils.getDefault(LightConstants.KEY_JOB_TYPE).getBytes("ISO-8859-1"), "utf-8");
        def keyValues=keyJobType.split(";");
        keyValues.each {String s->
            if(s&&s.split(",")&&s.split(",").length==2){
                ComboxVo cvo=new ComboxVo();
                cvo.id=Integer.parseInt(s.split(",")[0]);
                cvo.text=s.split(",")[1];
                list.add(cvo);
            }

        }
        render list as JSON
    }

}
