package smart.light.web.vo

import smart.light.saas.SysRes


/**
 * Created by Administrator on 2015/7/8.
 */
class SysPrivilegeVo {
    BigInteger id=new BigInteger();
    /**
     * 资源List
     */
    List<SysRes> resList=new ArrayList<SysRes>()
    /**
     * 操作List
     */
    List<SysRes> opList=new ArrayList<SysRes>()

}
