package com.smart.common.util

import org.apache.commons.lang.time.DateFormatUtils
import org.hibernate.Session
import smart.light.bus.StoreOrder
import smart.light.saas.SysEmp

//import saas.domain.saas.Tenant

/**
 * 用户ID生成器
 * 员工ID前缀为：  6，从61010801开始
 * 其他ID前缀为：8，从82010801开始
 * 保留后四位同号的号码
 * Created by lvpeng on 2015/7/15.
 */
class IDCreator {
    private static BigInteger MIN_TENANT_ID = 61010801L
    private static BigInteger MIN_TENANT_HZG_ID = 71010801L
    private static BigInteger MIN_AGENT_ID = 82010801L
    private static BigInteger currentTenantID = -1L
    private static BigInteger currentTenantHZGID = -1L
    private static BigInteger currentAgentID = -1L
    private static String TenantPrefix = "tenant";
    private static String TenantHZGPrefix = "tenant_hzg";
    private static String AgentPrefix = "agent";
    private static String TenantTestPrefix = "tenant_test";
    private static String TenantHZGTestPrefix = "tenant_hzg_test";
    private static String AgentTestPrefix = "agent_test";

    private static BigInteger newValue(BigInteger value) {
        BigInteger newVal = value
        String str = newVal.toString()
        /*str = str.replaceAll('3', '5')
                .replaceAll('4', '5')
                .replaceAll('7', '8')*/
        //保留后四位同号的号码
        if(str[4] == str[5] && str[4] == str[6] && str[4] == str[7]) {
            return newValue(newVal)
        } else {
            newVal = BigInteger.valueOf(Long.valueOf(str))
            return newVal
        }
    }

    /**
     * 生成新的TenantID
     * @return
     */
    public static synchronized String newTenantID() {
        return newTenantID(0);
    }
    public static synchronized String newTenantID(Integer isTest) {
        SysEmp.withSession {Session session ->
            String prefix = 0.equals(isTest) ? TenantPrefix : TenantTestPrefix;
            currentTenantID = BigInteger.valueOf(Long.valueOf(SeqUtils.getSeqVal(session, prefix, 8)));
        }
        currentTenantID = newValue(currentTenantID)
        return currentTenantID.toString()
    }

    /**
     * 生成新的HZGID
     * @return
     */
    public static synchronized String newTenantHZGID() {
        return newTenantHZGID(0)
    }
    public static synchronized String newTenantHZGID(Integer isTest) {
        SysEmp.withSession {Session session ->
            String prefix = 0.equals(isTest) ? TenantHZGPrefix : TenantHZGTestPrefix;
            currentTenantHZGID = BigInteger.valueOf(Long.valueOf(SeqUtils.getSeqVal(session, prefix, 8)));
        }
        currentTenantHZGID = newValue(currentTenantHZGID)
        return currentTenantHZGID.toString()
    }

    /**
     * 生成新的AgentID
     * @return
     */
    public static synchronized String newAgentID() {
        return newAgentID(0)
    }
    public static synchronized String newAgentID(Integer isTest) {
        SysEmp.withSession {Session session ->
            String prefix = 0.equals(isTest) ? AgentPrefix : AgentTestPrefix;
            currentAgentID = BigInteger.valueOf(Long.valueOf(SeqUtils.getSeqVal(session, prefix, 8)));
        }
        currentAgentID = newValue(currentAgentID)
        return currentAgentID.toString()
    }
    public static String createStoreOrderCode(Integer orderType, String wd) {
        String code
        String type
        switch (orderType) {
            case 1: type = 'dd'
                break
            case 2: type = 'CK'
                break
            case 3: type = 'PD'
                break
            default: type = null
        }
        String no
        SysEmp.withSession { Session session ->
            no = SeqUtils.getSeqValToday(session, type + wd, 3)
        }
        code = String.format("%s%s", DateFormatUtils.format(new Date(), "yyMMdd"), no)
        return code
    }

    public static String createStoreOrderCode(Integer orderType, String wd, String branchCode) {
        String code
        String type
        switch (orderType) {
            case 1: type = 'RK'
                break
            case 2: type = 'CK'
                break
            case 3: type = 'PD'
                break
            default: type = null
        }
        String no
        StoreOrder.withSession { Session session ->
            no = SeqUtils.getSeqValToday(session, type + wd, 3)
        }
        code = String.format("${type}%s%s%s", DateFormatUtils.format(new Date(), "yyMMdd"), branchCode, no)
        return code
    }
}