package smart.light.web.chart

class ClsInfoSum {

    /**
     *
     */
    String m_id;
    /**
     *
     */
    String c_id;
    /**
     * 日期  用电量最大
     */
    String prt_date;
    /**
     * 名称类
     */
    String u_name;
    /**
     * 数值类
     */
    Integer i_count;
    /**
     * 金额类
     */
    Double c_total;
    /**
     * 占比 最大用电量
     */
    Double u_percent;
    /**
     * 保留
     */
    String prt_context;

    //抄度成功率

    Double light_success_p;
    Double pile_success_p;
    Double bill_success_p;

    //总用电量
    Double total_e;

    //分用电量
    Double light_part_e;
    Double pile_part_e;
    Double bill_part_e;

    //设备总数
    int light_total_d;
    int pile_total_d;
    int bill_total_d;

    //抄读成功数量
    int light_total_read
    int pile_total_read
    int bill_total_read

    //线损
    Double trep_loss;

    String btime;




}
