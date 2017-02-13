package smart.light.auth

import com.smart.common.Constants
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils
import api.RegisterApi
import api.common.ApiRest
import smart.light.saas.SysRole
import smart.light.saas.SysUser

@Transactional
class UserService {

    AuthService authService;

    public static final long limit = Long.valueOf(1000*60*5);

    public ApiRest register(Map sysUserMap) {
        ApiRest r = new ApiRest();
        try {
            if (sysUserMap != null) {
                if (StringUtils.isNotEmpty((String)sysUserMap["loginName"])) {
                    if (StringUtils.isNotEmpty((String)sysUserMap["userType"])) {
                        //商户员工
//                        if (sysUserMap["userType"].equals(Constants.USER_TYPE_TENANT_EMPLOYEE.toString())) {
//                            if (StringUtils.isNotEmpty((String)sysUserMap["tenantCode"])) {
//                                sysUserMap["loginName"] =  RegisterApi.tenantEmployeeLoginName((String)sysUserMap["loginName"], (String)sysUserMap["tenantCode"]);
//                            } else {
//                                LogUtil.logInfo("员工注册，商户号为空 ${sysUserMap.toString()}")
//                                r.setResult(Constants.REST_RESULT_FAILURE)
//                                r.setMessage("商户号无效");
//                                return r;
//                            }
//                        }
                        if (loginNameIsUnique((String)sysUserMap["loginName"], null)) {
                            if (authService.bindUnique(LightConstants.USER_BIND_TYPE_MOBILE, (String)sysUserMap["bindMobile"])) {
                                sysUserMap["loginPass"] = sysUserMap["loginPass"].encodeAsMD5();
                                sysUserMap["state"] = Constants.USER_STATE_ENABLED;
                                sysUserMap["loginCount"] = 0;
                                /*if (sysUserMap["userType"].equals(Constants.USER_TYPE_AGENT) || sysUserMap["userType"].equals(Constants.USER_TYPE_TENANT) || sysUserMap["userType"].equals(Constants.USER_TYPE_TENANT_EMPLOYEE)) {
                                    sysUserMap["loginCount"] = -1;
                                } else {
                                    sysUserMap["loginCount"] = 0;
                                }*/
                                SysUser sUser = new SysUser(sysUserMap);
                                Date now = new Date();
                                sUser.setCreateAt(now);
                                sUser.setLastUpdateAt(now);
                                //如果未指定用户名，则默认与登录名一致
                                if(sUser.name == null) sUser.name = sUser.loginName;//TODO 数据库中这两个字段长度不一致，name较短
                                if(sUser.save(flush:true)) {
                                    r.setResult(Constants.REST_RESULT_SUCCESS)
                                    r.setMessage("注册成功")
                                    r.setData(sUser.getId())
                                } else {
                                    StringBuffer error = new StringBuffer();
                                    sUser.getErrors().getAllErrors().each {
                                        error.append(it);
                                    }
                                    LogUtil.logError("用户保存失败 - ${sysUserMap.toString()} - ${error}");
                                    r.setResult(Constants.REST_RESULT_FAILURE)
                                    r.setMessage("注册失败")
                                    r.setError(error.toString())
                                }
                            } else {
                                LogUtil.logInfo("手机号 ${sysUserMap["bindMobile"]} 重复")
                                r.setResult(Constants.REST_RESULT_FAILURE)
                                r.setMessage("手机号已注册")
                            }
                        } else {
                            LogUtil.logInfo("用户名 ${sysUserMap["loginName"]} 重复")
                            r.setResult(Constants.REST_RESULT_FAILURE)
                            r.setMessage("已注册")
                            r.setError("用户名重复")
                        }
                    } else {
                        r.setResult(Constants.REST_RESULT_FAILURE)
                        r.setMessage("用户类型无效")
                    }
                } else {
                    LogUtil.logInfo("用户名 ${sysUserMap["loginName"]} 无效")
                    r.setResult(Constants.REST_RESULT_FAILURE)
                    r.setMessage("用户未注册")
                }
            } else {
                LogUtil.logInfo("无注册数据")
                r.setResult(Constants.REST_RESULT_FAILURE)
                r.setMessage("用户未注册")
            }
        } catch (Exception e) {
            LogUtil.logError("注册失败 - ${sysUserMap.toString()} - ${e.getMessage()}");
            r.setResult(Constants.REST_RESULT_FAILURE)
            r.setMessage("注册失败")
            r.setError(e.getMessage())
        }
        return r;
    }

    public boolean loginNameIsUnique(String loginName, String tenantCode) {
        if (StringUtils.isNotEmpty(tenantCode)) {
            loginName = RegisterApi.tenantEmployeeLoginName(loginName, tenantCode);
        }
        SysUser sUser = SysUser.findByLoginNameAndIsDeleted(loginName, false);
        if (StringUtils.isNotEmpty(loginName) && sUser == null) {
            return true;
        }
        if (sUser != null && sUser.getState().equals(Constants.USER_STATE_UNACTIVATED)) {
            if ((new Date().getTime() - sUser.getCreateAt().getTime()) > limit) {
                return true;
            }
        }
        return false;
    }

    public ApiRest activate(String userId) {
        ApiRest r = new ApiRest();
        if (StringUtils.isNotEmpty(userId)) {
            SysUser sUser = SysUser.get(userId);
            if (sUser != null) {
                if (sUser.getState() != null && sUser.getState().equals(Constants.USER_STATE_UNACTIVATED)) {
                    if ((new Date().getTime() - sUser.getCreateAt().getTime()) < limit) {
                        sUser.setState(Constants.USER_STATE_ENABLED);
                        if (sUser.save(flush:true)) {
                            r.setResult(Constants.REST_RESULT_SUCCESS)
                            r.setMessage("激活成功")
                        } else {
                            StringBuffer error = new StringBuffer();
                            sUser.getErrors().getAllErrors().each {
                                error.append(it);
                            }
                            LogUtil.logError("用户激活失败 - {userId:${userId}} - ${error}");
                            r.setResult(Constants.REST_RESULT_FAILURE)
                            r.setMessage("激活失败")
                            r.setError(error)
                        }
                    } else {
                        LogUtil.logInfo("用户 ${userId} 激活超时")
                        r.setResult(Constants.REST_RESULT_FAILURE)
                        r.setMessage("激活超时")
                    }
                } else {
                    LogUtil.logInfo("用户 ${userId} 已经激活过，请勿重复激活")
                    r.setResult(Constants.REST_RESULT_FAILURE)
                    r.setMessage("用户已经激活过，请勿重复激活")
                }
            } else {
                LogUtil.logInfo("激活用户 ${userId} 未查询到")
                r.setResult(Constants.REST_RESULT_FAILURE)
                r.setMessage("用户无效")
            }
        } else {
            LogUtil.logInfo("激活用户为Null")
            r.setResult(Constants.REST_RESULT_FAILURE)
            r.setMessage("用户无效")
        }
        return r;
    }

    /**
     * 根据id查询用户信息，支持批量查询
     * ids以英文逗号分隔，满足where id in (ids)的格式要求
     * @param ids
     * @return
     */
    public ApiRest list(String ids) {
        ApiRest r = new ApiRest()
        try {
            String filter = "id in (${ids})"
            List<SysUser> list = SysUser.executeQuery("from SysUser where ${filter} and state != ${Constants.USER_STATE_UNACTIVATED}")
            r.isSuccess = true
            r.message = ""
            r.data = list
            r.clazz = list.getClass()
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "查询用户信息失败"
            LogUtil.logError("{ids:${ids}} - ${e.message}");
        }
        return r
    }

    /**
     * 设置用户启用/禁用状态，未激活的用户不可进行此操作
     * @param userId
     * @param isEnabled
     * @return
     */
    public ApiRest setEnabled(BigInteger userId, Boolean isEnabled) {
        ApiRest r = new ApiRest()
        try {
            SysUser user = SysUser.findById(userId);
            if (user == null) {
                r.isSuccess = false
                r.message = "用户信息无效"
            } else if (user.state == Constants.USER_STATE_UNACTIVATED) {
                r.isSuccess = false
                r.message = "用户尚未激活，请先激活用户"
            } else {
                user.setState(isEnabled ? Constants.USER_STATE_ENABLED : Constants.USER_STATE_DISABLED)
                user.save flush: true
                r.isSuccess = true
                r.message = ""
            }
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "设置用户启用状态失败"
            LogUtil.logError("{userId:${userId}, isEnabled:${isEnabled}} - ${e.message}");
        }
        return r
    }

    public ApiRest delete(BigInteger userId) {
        ApiRest r = new ApiRest()
        try {
            SysUser user = SysUser.findById(userId);
            if (user == null) {
                r.isSuccess = false
                r.message = "用户信息无效"
            } else {
                user.isDeleted = true
                user.save flush: true
                r.isSuccess = true
                r.message = ""
            }
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "删除用户失败"
            LogUtil.logError("{userId:${userId}} - ${e.message}");
        }
        return r
    }

    public ApiRest setName(BigInteger userId, String name) {
        ApiRest r = new ApiRest()
        try {
            SysUser user = SysUser.findById(userId);
            if (user == null) {
                r.isSuccess = false
                r.message = "用户信息无效"
            } else {
                user.name = name
                user.save flush: true
                r.isSuccess = true
                r.message = ""
            }
        } catch (Exception e) {
            r.isSuccess = false
            r.message = "修改用户名失败"
            LogUtil.logError("{userId:${userId}, name:${name}} - ${e.message}");
        }
        return r
    }

    public ApiRest find(BigInteger tenantId, String branchIds, String roleCode, Integer offset, Integer rows) {
        ApiRest r = new ApiRest();
        try {
            StringBuffer hql = new StringBuffer("from SysUser su");
            if (tenantId != null) {
                hql.append(" left join su.sysRoles sr where sr.tenantId = ${tenantId}");
                if (StringUtils.isNotEmpty(branchIds)) {
                    hql.append(" and sr.branchId in (${branchIds})");
                }
                if (roleCode != null) {
                    hql.append(" and sr.roleCode = '${roleCode}'");
                }
            }
            List<SysUser> list = null;
            if (rows.intValue() == -1 && offset.intValue() == -1) {
                list = SysUser.executeQuery("select su " + hql.toString());
            } else {
                list = SysRole.executeQuery("select su " + hql.toString(), [max: rows, offset: offset]);
            }
            Integer total = -1;
            if(offset >= 0 && rows > 0) {
                List count = SysRole.executeQuery("select count(1) " + hql.toString());
                total = Integer.valueOf(count[0].toString());
            }
            r.isSuccess = true;
            r.message = total >= 0 ? total.toString() : "";
            r.data = list;
            r.clazz = list.getClass();
        } catch (Exception e) {
            r.isSuccess = false;
            r.message = "用户查询失败";
            r.error = e.getMessage();
            LogUtil.logError("{tenantId:${tenantId}, branchIds:${branchIds}, roleCode:${roleCode}} - ${e.message}");
        }

        return r;
    }

    public ApiRest findOne(String bindMobile) {
        ApiRest rest = new ApiRest();
        try {
            List<SysUser> list = SysUser.findAllByBindMobileAndStateAndIsDeleted(bindMobile, Constants.USER_STATE_ENABLED, false);
            if (list == null || list.size() == 0) {
                rest.isSuccess = false;
                rest.message = "无查询用户";
            } else if (list.size() > 1) {
                rest.isSuccess = false;
                rest.message = "查询用户数量为 ${list.size()}";
            } else {
                rest.isSuccess = true;
                rest.data = list.get(0);
                rest.clazz = SysUser.class;
            }
        } catch (Exception e) {
            rest.isSuccess = false;
            rest.message = "用户查询失败";
            rest.error = e.getMessage();
            LogUtil.logError("{bindMobile:${bindMobile}} - ${e.message}");
        }

        return rest;
    }


    /**
     * 验证用户密码是否匹配
     */
    def verifyPassBySysUserId(Map map){
        ApiRest result = new ApiRest();
        try {
            if(map.userId){
                SysUser sysUser = SysUser.find("from SysUser s where s.isDeleted = false and s.id = "+BigInteger.valueOf(Long.valueOf(map.userId)));
                if(sysUser){
                    if(map.password){
                        String passwordKey = map.password.encodeAsMD5();
                        if(sysUser.loginPass.equals(passwordKey)){
                            result.isSuccess = true;
                            result.message = "验证用户密码是否匹配接口方法调用成功并且匹配成功" ;
                        }
                        else{
                            result.isSuccess = false;
                            result.message = "验证用户密码是否匹配接口方法调用成功并且匹配失败" ;
                        }
                    }
                    else{
                        result.isSuccess = false;
                        result.message = "password参数为空";
                        LogUtil.logDebug("password参数为空");
                    }
                }
                else{
                    result.isSuccess = false;
                    result.message = "userId：" + map.userId+"，查询不到用户信息";
                    LogUtil.logDebug("userId：" + map.userId+"，查询不到用户信息");
                }
            }
            else{
                result.isSuccess = false;
                result.message = "userId参数为空";
                LogUtil.logDebug("userId参数为空，无法查询用户");
            }

        } catch (Exception e){
            LogUtil.logError("验证用户密码是否匹配接口方法调用失败"+e.message);
        }
        return result;
    }
}
