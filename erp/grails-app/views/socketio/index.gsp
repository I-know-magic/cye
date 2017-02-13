<!DOCTYPE html>
<html>
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>socket demo</title>



    <style>
    body {
        padding:20px;
    }
    #console {
        height: 400px;
        overflow: auto;
    }
    .username-msg {color:orange;}
    .connect-msg {color:green;}
    .disconnect-msg {color:red;}
    .send-msg {color:#888}
    </style>
    <link rel="stylesheet" href="${resource(dir: 'bootstrap', file: 'dist/css/bootstrap.css', base: '..')}" type="text/css">
    <script type="text/javascript" src="${resource(dir:'js',file:'socket.io/socket.io.js',base: '..')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'socket.io/moment.min.js',base: '..')}"></script>
    <script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>

    %{--<asset:stylesheet src="bootstrap.css"/>--}%
    %{--<asset:stylesheet src="application.css"/>--}%

    %{--<asset:javascript src="application.js"/>--}%
    %{--<link href="bootstrap.css" rel="stylesheet">--}%
    %{--<asset:javascript src="socket.io/socket.io.js"/>--}%
    %{--<asset:javascript src="moment.min.js"/>--}%
    %{--<script src="socket.io/socket.io.js"></script>--}%
    %{--<script src="moment.min.js"></script>--}%

    <script>
        //    $(function(){
        //        $(".btn").click(function(){
        //            alert($(this).val());
        //        });
        //    })

        //debugger;
        var userName = 'user' + Math.floor((Math.random()*1000)+1);
        var socket =  io.connect('http://27.223.110.230:4020?username='+userName);
        //        var socket =  io.connect('http://192.168.2.102:4020');

        // 连接
        socket.on('connect', function() {
            output('<span class="connect-msg">Client has connected to the server!</span>');
        });
        //
        socket.on('chatevent', function(data) {
            output('<span class="username-msg">' + data.userName + ':</span> ' + data.message);
        });
        //发送数据
        socket.on('transData', function(data) {


            output('<span class="username-msg">' + data.userName + ':</span> ' + data.message);
        });
        //接受数据
        socket.on('retransData', function(data) {
            //debugger;

            var sscMessage=data.sscMessage;
            var msgType=sscMessage.msgType;
            var message=data.message;
            if(msgType==99){
                message="连接超时！"
            }
            output('<span class="username-msg">回复数据类型-' + msgType + ':</span> ' + '<span class="disconnect-msg">' +  message + ':</span> ');
        });
        socket.on('waring', function(data) {
            //debugger;
            var sscMessage=data.sscMessage;
            var msgType=sscMessage.msgType;
            var message=data.message;
            output('<span class="username-msg">回复数据类型-' + msgType + ':</span> ' + '<span class="disconnect-msg">' + message + ':</span> ');
        });
        //关闭连接
        socket.on('disconnect', function() {
            output('<span class="disconnect-msg">The client has disconnected!</span>');
        });

        function sendDisconnect() {
            socket.disconnect();
        }

        function sendMessage() {

            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            var tmzf_645 = $('#tmzf_645').val();
            var day_time=$('#day_time').val();
            if(!afn){
                afn="10";
//                removeElement
//                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="03";
            }
            if(!pn){
                pn="0";
            }
            if(!terminal){
                terminal="37020001"
            }
            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1

            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"0"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_pn={key:-6,value:pn};
            var ptlField_fn={key:-5,value:fn};

            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq];
            if(afn=="13"){
                var ptlField_key_password={key:-13,value:"0"};
                var ptlField_vn={key:-9,value:"1"};
                if(!day_time){
                    day_time="2016-04-11 00:00:00";
                }
                var ptlField_date={key:0,value:day_time};
                lst.push(ptlField_key_password);
                lst.push(ptlField_vn);
                lst.push(ptlField_pn);
                lst.push(ptlField_fn);
                lst.push(ptlField_date);
            }else {
                lst.push(ptlField_pn);
                lst.push(ptlField_fn);
            }
            if(tmzf_645){
                var ptlField_data0={key:0,value:"31"};
                var ptlField_data1={key:1,value:"3"};
                var ptlField_data2={key:2,value:"0"};
                var ptlField_data3={key:3,value:"1"};
                var ptlField_data4={key:4,value:"0"};
                var ptlField_data5={key:5,value:"3"};
                var ptlField_data6={key:6,value:"0"};
                var ptlField_data7={key:7,value:"0"};
                var ptlField_data8={key:8,value:"0"};
                var ptlField_data9={key:9,value:"0"};
                var ptlField_data10={key:10,value:Math.floor(tmzf_645.length/2)+""};
                var ptlField_data11={key:11,value:tmzf_645};
                lst.push(ptlField_data0);
                lst.push(ptlField_data1);
                lst.push(ptlField_data2);
                lst.push(ptlField_data3);
                lst.push(ptlField_data4);
                lst.push(ptlField_data5);
                lst.push(ptlField_data6);
                lst.push(ptlField_data7);
                lst.push(ptlField_data8);
                lst.push(ptlField_data9);
                lst.push(ptlField_data10);
                lst.push(ptlField_data11);
            }

            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
//            var jsonObject = {userName: userName,
//                message: message};
            socket.emit('transData', jsonObject);
        }
        function sendMessage1() {

            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            var tmzf_645 = $('#tmzf_645').val();
            var day_time=$('#day_time').val();
            var day_time_num=$('#day_time_num').val();
            if(!day_time_num){
                output('<span class="disconnect-msg">请填写打包数量!</span>');
                return false;
            }
            if(!afn){
                afn="13";
                //                removeElement
                //                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="262";
            }
            if(!pn){
                pn="1";
            }
            if(!terminal){
                terminal="37020001"
            }

            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1

            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"0"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_key_password={key:-13,value:"0"};
            var ptlField_vn={key:-9,value:"1"};

            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq,ptlField_key_password,ptlField_vn];
            for(var i=0;i<parseInt(day_time_num);i++){
                var ptlField_pn={key:-6,value:parseInt(pn)+i+""};
                var ptlField_fn={key:-5,value:fn};
                if(!day_time){
                    day_time="2016-04-11 00:00:00";
                }
                var ptlField_date={key:0,value:day_time};
                lst.push(ptlField_pn);
                lst.push(ptlField_fn);
                lst.push(ptlField_date);
            }


            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
            //            var jsonObject = {userName: userName,
            //                message: message};
            socket.emit('transData', jsonObject);
        }
        function output(message) {
            //debugger;
            var currentTime = "<span class='time'>" +  moment().format('HH:mm:ss.SSS') + "</span>";
            var element = $("<div>" + currentTime + " " + message + "</div>");
            $('#console').prepend(element);
        }

        $(document).keydown(function(e){
            if(e.keyCode == 13) {
                $('#send').click();
            }
        });
        function make_uuid() {
            var s = [];
            var hexDigits = "0123456789abcdef";
            for (var i = 0; i < 36; i++) {
                s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
            }
            s[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
            s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1); // bits 6-7 of the clock_seq_hi_and_reserved to 01
            s[8] = s[13] = s[18] = s[23] = "-";

            var uuid = s.join("");
            return uuid;
        }

        /**
         * 档案同步 -查询表数量
         **/
        function querymeternum() {
// -20=06,-18=37020001,-17=2,-16=12,-15=3,-14=3,-13=0,-9=1,-6=0,-5=11
            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            if(!afn){
                afn="12";
//                removeElement
//                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="11";
            }
            if(!pn){
                pn="0";
            }
            if(!terminal){
                terminal="37020001"
            }
            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1
            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"3"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_pn={key:-6,value:pn};
            var ptlField_fn={key:-5,value:fn};

            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq];

            var ptlField_key_password={key:-13,value:"0"};
            var ptlField_vn={key:-9,value:"1"};
            lst.push(ptlField_key_password);
            lst.push(ptlField_vn);
            lst.push(ptlField_pn);
            lst.push(ptlField_fn);
            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
//            var jsonObject = {userName: userName,
//                message: message};
            socket.emit('transData', jsonObject);
        }
        /**
         * 档案同步 -读取档案信息
         **/
        function querymeter() {

            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            if(!afn){
                afn="10";
//                removeElement
//                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="10";
            }
            if(!pn){
                pn="0";
            }
            if(!terminal){
                terminal="37020001"
            }
            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1
            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"3"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_key_password={key:-13,value:"0"};
            var ptlField_vn={key:-9,value:"1"};
            var ptlField_pn={key:-6,value:pn};
            var ptlField_fn={key:-5,value:fn};
            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq];
            lst.push(ptlField_key_password);
            lst.push(ptlField_vn);
            lst.push(ptlField_pn);
            lst.push(ptlField_fn);
            var ptlField_data0={key:0,value:"8"};
            lst.push(ptlField_data0);
            for(var i=1;i<=8;i++){
                var ptlField_datai={key:1,value:i+""};
                lst.push(ptlField_datai);

            }
            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
//            var jsonObject = {userName: userName,
//                message: message};
            socket.emit('transData', jsonObject);
        }

        /**
         * 档案同步 -增加单个表
         **/
        function addmeter() {

            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            var meterno = $('#meterno').val();
            var meteraddr = $('#meteraddr').val();
            if(!afn){
                afn="04";
//                removeElement
//                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="10";
            }
            if(!pn){
                pn="0";
            }
            if(!terminal){
                terminal="37020001"
            }
            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1
            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"3"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_pn={key:-6,value:pn};
            var ptlField_fn={key:-5,value:fn};
            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq];
            var ptlField_key_password={key:-13,value:"2"};
            var ptlField_vn={key:-9,value:"1"};
            lst.push(ptlField_key_password);
            lst.push(ptlField_vn);
            lst.push(ptlField_pn);
            lst.push(ptlField_fn);


            var ptlField_data0={key:0,value:"1"};

            var ptlField_data1={key:1,value:meterno};
            var ptlField_data2={key:2,value:meterno};
            var ptlField_data3={key:3,value:"31"};
            var ptlField_data4={key:4,value:"1"};
            var ptlField_data5={key:5,value:"30"};
            var ptlField_data6={key:6,value:meteraddr};//201511220909
            var ptlField_data7={key:7,value:"0"};
            var ptlField_data8={key:8,value:"0"};
            var ptlField_data9={key:9,value:"0"};
            var ptlField_data10={key:10,value:"0"};
            var ptlField_data11={key:11,value:"0"};
            var ptlField_data12={key:12,value:"1"};
            lst.push(ptlField_data0);
            lst.push(ptlField_data1);
            lst.push(ptlField_data2);
            lst.push(ptlField_data3);
            lst.push(ptlField_data4);
            lst.push(ptlField_data5);
            lst.push(ptlField_data6);
            lst.push(ptlField_data7);
            lst.push(ptlField_data8);
            lst.push(ptlField_data9);
            lst.push(ptlField_data10);
            lst.push(ptlField_data11);
            lst.push(ptlField_data12);


            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
//            var jsonObject = {userName: userName,
//                message: message};
            socket.emit('transData', jsonObject);
        }
        /**
         * 档案同步 -批量增加
         **/
        function addmeters() {

            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            var meterno = $('#meterno').val();
            var meteraddr = $('#meteraddr').val();
            var meternum = $('#meternum').val();
            if(!afn){
                afn="04";
//                removeElement
//                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="10";
            }
            if(!pn){
                pn="0";
            }
            if(!terminal){
                terminal="37020001"
            }
            if(!meternum){
                meternum="2"
            }
            if(!meterno){
                meterno=1;
            }
            if(!meteraddr){
                meteraddr="201511220909";
            }
            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1
            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"3"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_pn={key:-6,value:pn};
            var ptlField_fn={key:-5,value:fn};
            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq];
            var ptlField_key_password={key:-13,value:"2"};
            var ptlField_vn={key:-9,value:"1"};
            lst.push(ptlField_key_password);
            lst.push(ptlField_vn);
            lst.push(ptlField_pn);
            lst.push(ptlField_fn);


            var ptlField_data0={key:0,value:meternum};
            lst.push(ptlField_data0);
            for (var i = 0; i < parseInt(meternum); i++) {
                var ptlField_data1={key:1,value:parseInt(meterno)+i+""};
                var ptlField_data2={key:2,value:parseInt(meterno)+i+""};
                var ptlField_data3={key:3,value:"31"};
                var ptlField_data4={key:4,value:"1"};
                var ptlField_data5={key:5,value:"30"};
                var ptlField_data6={key:6,value:parseInt(meteraddr)+i+""};//201511220909
                var ptlField_data7={key:7,value:"0"};
                var ptlField_data8={key:8,value:"0"};
                var ptlField_data9={key:9,value:"0"};
                var ptlField_data10={key:10,value:"0"};
                var ptlField_data11={key:11,value:"0"};
                var ptlField_data12={key:12,value:"1"};
                lst.push(ptlField_data1);
                lst.push(ptlField_data2);
                lst.push(ptlField_data3);
                lst.push(ptlField_data4);
                lst.push(ptlField_data5);
                lst.push(ptlField_data6);
                lst.push(ptlField_data7);
                lst.push(ptlField_data8);
                lst.push(ptlField_data9);
                lst.push(ptlField_data10);
                lst.push(ptlField_data11);
                lst.push(ptlField_data12);
            };

            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
//            var jsonObject = {userName: userName,
//                message: message};
            socket.emit('transData', jsonObject);
        }
        /**
         * 档案同步 -删除全部表
         **/
        function delmeters() {

            var terminal=$('#terminal').val();
            var afn = $('#afn').val();
            var fn = $('#fn').val();
            var pn = $('#pn').val();
            if(!afn){
                afn="05";
//                removeElement
//                $("#warning-block").attr("class","alert alert-danger");
            }
            if(!fn){
                fn="053";
            }
            if(!pn){
                pn="0";
            }
            if(!terminal){
                terminal="37020001"
            }
            if(!meternum){
                meternum="2"
            }
            var username=userName;
            var terminalCode="37020001";

            //时间
            var mkTime=null;
            var data=null;
            var uuid=make_uuid();//请求报文生成的uuid
            var mas="2";//主站地址
            var seq="0";
            var msgType=1;//1--普通报文  2-－档案同步  3-－定时任务请求冻结  99--回复报文超时 100--主动上报
            var callbackType;// 回调web应用接口类型  根据afn来 并且配合msgType确定回调类型
            var maxWaitTime=1;//分钟
            var timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
            var writeTime = new Date();
            var ackinterval;
            var maxTrytimes=2;//最多重试次数
            var trytimes=1;//当前重试次数  默认为1
            var ptlField_code={key:-20,value:"06"};
            var ptlField_rta={key:-18,value:terminal};
            var ptlField_msa={key:-17,value:"2"};
            var ptlField_afn={key:-16,value:afn};
            var ptlField_fseq={key:-15,value:"3"};
            var ptlField_ifseq={key:-14,value:"3"};
            var ptlField_pn={key:-6,value:pn};
            var ptlField_fn={key:-5,value:fn};
            var lst=[ptlField_code,ptlField_rta,ptlField_msa,ptlField_afn,ptlField_fseq,ptlField_ifseq];
            var ptlField_key_password={key:-13,value:"0"};
            var ptlField_vn={key:-9,value:"1"};
            lst.push(ptlField_key_password);
            lst.push(ptlField_vn);
            lst.push(ptlField_pn);
            lst.push(ptlField_fn);


            var ptlField_data0={key:0,value:"31"};
            lst.push(ptlField_data0);

            var jsonObject = {'@class': 'com.shangsheng.communication.web.core.dto.SscMessage',
                userName: username,
                terminalCode: terminalCode,
                afn: afn,
                fn: fn,
                pn: pn,
                mkTime: mkTime,
                data: data,
                uuid: uuid,
                mas: mas,
                seq: seq,
                msgType: msgType,
                callbackType: callbackType,
                maxWaitTime: maxWaitTime,
                timeoutInterval: timeoutInterval,
                writeTime: writeTime,
                ackinterval: ackinterval,
                maxTrytimes: maxTrytimes,
                trytimes: trytimes,
                ptlFields: {lst:lst}
            };
//            var jsonObject = {userName: userName,
//                message: message};
            socket.emit('transData', jsonObject);
        }
    </script>
</head>

<body>

<h1>Netty-socketio Demo </h1>

<br/>

%{--<div class="alert alert-block hide" id="warning-block">--}%
%{--<button type="button" class="close" data-dismiss="alert">&times;</button>--}%
%{--<h4>Warning!</h4>Best check yo self, you're not...--}%
%{--</div>--}%

<div id="console" class="well">
</div>

<form class="well form-inline" onsubmit="return false;">
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> afn
    </button>
    %{--<div class="btn-group">--}%
    %{--<button type="button" class="btn btn-info">Action</button>--}%
    %{--<button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">--}%
    %{--<span class="caret"></span>--}%
    %{--<span class="sr-only">Toggle Dropdown</span>--}%
    %{--</button>--}%
    %{--<ul class="dropdown-menu">--}%
    %{--<li><a href="#">Action</a></li>--}%
    %{--<li><a href="#">Another action</a></li>--}%
    %{--<li><a href="#">Something else here</a></li>--}%
    %{--<li role="separator" class="divider"></li>--}%
    %{--<li><a href="#">Separated link</a></li>--}%
    %{--</ul>--}%
    %{--</div>--}%
    <input id="afn" class="input-xlarge" type="text" placeholder="example 04,10... "/>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> fn
    </button>
    <input id="fn" class="input-xlarge" type="text" placeholder="Type something..."/>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> pn
    </button>
    <input id="pn" class="input-xlarge" type="text" placeholder="Type something..."/>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> terminal
    </button>
    <input id="terminal" class="input-xlarge" type="text" placeholder="example 37020001 ..."/>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> 645
    </button>
    <input id="tmzf_645" class="input-xlarge" type="text" placeholder="example 645 ..."/>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> 抄读时间
    </button>
    <input id="day_time" class="input-xlarge" type="text" placeholder="example 2016-04-11 00:00:00 ..."/>
    <button type="button" onClick="sendMessage()" class="btn" id="send">Send</button>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> 打包数量
    </button>
    <input id="day_time_num" class="input-xlarge" type="text" placeholder="example 1,2,3..."/>
    <button type="button" onClick="sendMessage1()" class="btn" id="send">批量打包抄读日冻结</button>
    <button type="button" onClick="querymeternum()" class="btn" id="send1">查询载波表数量</button>
    <button type="button" onClick="querymeter()" class="btn" id="send2">读取档案信息</button>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> 测量点号
    </button>
    <input id="meterno" class="input-xlarge" type="text" placeholder="example 123 ..."/>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> 设备地址
    </button>
    <input id="meteraddr" class="input-xlarge" type="text" placeholder="example 201511220909 ..."/>
    <button type="button" onClick="addmeter()" class="btn" id="send3">增加单表</button>
    <button type="button" class="btn btn-default btn">
        <span class="glyphicon glyphicon-star" aria-hidden="true"></span> 加表数量
    </button>
    <input id="meternum" class="input-xlarge" type="text" placeholder="example 1，2，3 ..."/>

    <button type="button" onClick="addmeters()" class="btn" id="send4">增加多表(填写测量点号设备地址)</button>
    <button type="button" onClick="delmeters()" class="btn" id="send5">删除全部表</button>
    %{--<button type="button" onClick="sendMessage()" class="btn" id="send6">Send</button>--}%
    %{--<button type="button" onClick="sendMessage()" class="btn" id="send7">Send</button>--}%
    <button type="button" onClick="sendDisconnect()" class="btn">Disconnect</button>
</form>



</body>

</html>
