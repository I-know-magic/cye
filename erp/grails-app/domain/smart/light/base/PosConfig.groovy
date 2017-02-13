package smart.light.base

import com.smart.common.annotation.TenantFilter

/**
 * pos参数设置
 */
//@TenantFilter(column = "tenant_id")
class PosConfig {

    static constraints = {

    }
    static mapping = {

    }

    /**
     * 
     */
    BigInteger posId
    /**
     * POS配置参数
配置参数可以分组，每组作为一个参数包，具有不同的用途
     */
    String packageName
    /**
     * 版本

程序升级后，如果设置参数的结构发生变化，需要同时改变设置参数的版本标识，原则上与第一个使用的程序版本一致
     */
    String posConfgVersion
    /**
     * 各设置参数以json格式文本保存在字段中，完成支持json语法

空设置
{}

基本结构
{
    "key1": {
        “key1-1": 'value', 
        "key1-2": 3000 ,
        desc:'说明1'
    },
        "key2-1": {
        "ip": "localhost",
        "port": 8000
        desc:'说明2'
  },
}
     */
    String config
    /**
     * 数据在本地被修改0否1是
     */
    Integer lsDirty

    BigInteger id
    BigInteger tenantId
    String createBy
    Date createAt
    String lastUpdateBy
    Date lastUpdateAt
    boolean isDeleted

}
