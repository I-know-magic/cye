package smart.light.web

import smart.light.bus.StoreAccountService

class MyjobJob {
    StoreAccountService storeAccountService
    static triggers = {
//        simple name: 'simpleTrigger', startDelay: 10000, repeatInterval: 30000, repeatCount: 10
//        cron name:   'cronTrigger',   startDelay: 10000, cronExpression: '0/30 * * * * ?'
//        custom name: 'customTrigger', triggerClass: MyTriggerClass, myParam: myValue, myAnotherParam: myAnotherValue
    }


    def execute() {
        // execute job
//        println "Job run!";
//        {"branchId":"1",
// "occurAt":"2016-07-25 21:36:21",
// "createBy":"POS",
// "goodsId":"1",
// "occurQuantity":"-1",
// "tenantId":"1",
// "occurType":"1",
// "orderCode":"11607250003",
// "goodsName":"鲤鱼",
// "barCode":"01001"}
//        Map params=new HashMap();
//        params['occurType']="1";
//        params['branchId']="1";
//        params['tenantId']="1";
//        params['orderCode']="11607250003";
//        params['barCode']="01001";
//        params['goodsName']="鲤鱼";
//        params['occurAt']="2016-07-25 21:36:21";
//        params['goodsId']="16";
//        params['occurQuantity']="-1";
//        params['createBy']="POS";
//        storeAccountService.save(params);

    }
}
