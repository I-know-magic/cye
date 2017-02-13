package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * pos信息
 */
//@TenantFilter(column = "tenant_id")
class Pos {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 所属门店，默认为0，代表总部
     */
    BigInteger branchId
    /**
     * 设备码
     */
    String deviceCode
    /**
     * pos机编码
     */
    String posCode
    /**
     * 门店编码
     */
    String branchCode
    /**
     * pos密码
     */
    String password
    /**
     * 0停用
1启用
     */
    Integer status
    /**
     * 备注
     */
    String memo
    /**
     * 冗余字段：门店名称
     */
    String branchName
    /**
     * 同步使用
     */
    String accessToken
    /**
     * 
     */
    String tenantCode
    /**
     * app名称
     */
    String appName
    /**
     * app版本
     */
    String appVersion

    BigInteger id
    BigInteger tenantId
    Date createAt
    String createBy
    Date lastUpdateAt
    String lastUpdateBy
    boolean isDeleted

}
