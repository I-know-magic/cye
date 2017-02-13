package smart.light.web.vo

/**
 * Created by Administrator on 2015/6/25.
 */
class BranchAreaVo {
    BigInteger parentId
    BigInteger childrenId
    String nodeName;
    /**
     * 是否区域 0否1是
     */
    String isArea;
}
