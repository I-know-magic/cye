//集中器规约
var _ter_procode;
var _afn;
var _fn;
var _pn;
var _vn;
var _fseq;
var _ifseq;
//集中器地址
var _terminal;
//主站地址
var _mas;
//报文类型
var _msgtype;
//集中器密码
var _ter_pass;
////超时时间
//var _timeout;
////重试次数
//var _trytime;
//表地址
var _driver_addr
//控制字
var _cmd;
//数据标示-- 645按照数据标示
var _dataflag;
//645控制的数据，如开灯 输入0100 加33，按照字节倒序，转换为 3334
var _datavalue;
//表密码 默认 3544444487867478 已加33并转换
var _driver_pass;
//是否有集中器密码和vn
var _flag_terpass=false;
//是否有vn
var _flag_vn=false;
//是否有数据域
var _flag_data=false;
var _ptlField_list=[];
var _data=[];
var _afn_645="16";
var _fn_645="001";
var _afn_04="04";
var _fn_111="111";
var _afn_10="10";
var _fn_10="10";
//错误信息
var _msg;
//是否出错
var _flag=true;
//循环次数
var _flag_loop=0;
//循环位置
var _op=0;
//循环长度
var _len;
//循环体的key是否发生变化
var _flag_index=false;

var _socket;
var _callbackType;
var _maxWaitTime=1;
var _timeoutInterval=1000*60;//毫秒  等待超时时间    如果为100 报警确认 timeoutInterval代表重发间隔时间
var _writeTime ;
var _ackinterval=0;
var _maxTrytimes=2;//最多重试次数
var _trytimes=1;//当前重试次数  默认为1
var _seq=0
var _mkTime=null;
var _socket_class;
var _username;
var _fsname="transData";
var _fname="retransData";
var _fcname="connect";
var _cmsg="已连接到服务端!";
var _fdname="disconnect";
var _dmsg="与服务器连接已断开";
var _fwname="waring";
var _socket_class="com.shangsheng.communication.web.core.dto.SscMessage";
var _data_pre="68";
var _data_end="16";
var _data_value_645="";
//增加String表达式  回调数据库更新数据 集中器分组控制、拉合闸控制，更新数据库
var _updateExpression="";
/**
 * 初始化必要数据
 * @param afn
 * @param fn
 * @param pn
 * @param terminal
 * @param mas
 * @param msgtype
 */
function init(afn, fn,pn,terminal,mas,msgtype,terpass,vn){

    _ptlField_list=[];
    _setTerProcode();
    _setAfn(afn);
    _setFn(fn);
    _setPn(pn);
    _setTerminal(terminal);
    _setMas(mas);
    _setMsgtype(msgtype);
    _setFseq();
    _setIFseq();
    setData();
    _setTerPass(terpass);
    _setVn(vn)
}
/**
 *
 * @param data
 */
function pack() {
    _pack_header();
    if(_getFlagData()){
        _pack_data();
    }
    send_data();
    return _getPtlFieldList();

}
function _pack_header(){
    var ptlField_code={key:-20,value:_getTerProcode()};
    var ptlField_rta={key:-18,value:_getTerminal()};
    var ptlField_mas={key:-17,value:_getMas()};
    var ptlField_afn={key:-16,value:_getAfn()};
    var ptlField_fseq={key:-15,value:_getFseq()};
    var ptlField_ifseq={key:-14,value:_getIFseq()};
    _addPtlFieldList(ptlField_code);
    _addPtlFieldList(ptlField_rta);
    _addPtlFieldList(ptlField_mas);
    _addPtlFieldList(ptlField_afn);
    _addPtlFieldList(ptlField_fseq);
    _addPtlFieldList(ptlField_ifseq);
    if(_getFlagterPaas()){
        var ptlField_key_password={key:-13,value:_getTerPass()};
        _addPtlFieldList(ptlField_key_password)
    }
    if(_getFlagVn()){
        var ptlField_vn={key:-9,value:_getVn()};
        _addPtlFieldList(ptlField_vn)
    }
    var ptlField_pn={key:-6,value:_getPn()};
    var ptlField_fn={key:-5,value:_getFn()};
    _addPtlFieldList(ptlField_pn);
    _addPtlFieldList(ptlField_fn);
}
function _pack_data(){
    //debugger;
    var afn=_getAfn();
    var fn=_getAfn();

    //数据
    var data=_getData();
    //是否循环
    var loop=_getFlagLoop();
    //循环位置
    var op=_getOp();
    //循环长度
    var len=_getLen();
    //循环次数
    var num=data[op];
    //var op_tmp=[];
    //var op_tmp_len=0;
    //var len_tmp=[];
    //var len_tmp_len=0;
    var flag_key=_getFlagIndex();
    if(afn==_afn_645 && fn==_fn_645){
        _pack_645();
        return true;
    }
    if(loop==0){
        _pack_unloop(data);
    }else{
        _pack_loop(data,num,len,flag_key,op);

    }


}
/**
 * 645按照数据标示来组织报文
 * @private
 */
function _pack_645(){
    var f=_check_data_645();
    if(f){
        $.each(data,function(key,value){
            var ptlField_value={key:key,value:value};
            _addPtlFieldList(ptlField_value);
        });
    }else{
        _setFlag(false);
        _setMsg("打包透明转发数据，参数不正确!")
    }

}
function _pack_unloop(data){
    $.each(data,function(key,value){
        var ptlField_value={key:key,value:value};
        if(_afn_10==_afn && _fn_10==_fn && key!=0){
            ptlField_value={key:"1",value:value};
        }
        _addPtlFieldList(ptlField_value);
    });
}
function _pack_loop(data,num,len,flag_key,op){
    var check_loop= _check_data_loop();
    if(check_loop) {
        $.each(data, function (key, value) {
            var ptlField_value = {key: key, value: value};
            if (key <= op) {
                _addPtlFieldList(ptlField_value);
                data.splice(0, 1);
            }
        });
        //循环次数和循环长度
        for (var i = 1; i <= num; i++) {
            //debugger;
            for (var j = 0; j < len; j++) {
                var obj = data[j];
                var ptlField_value = {key: 1, value: obj + ""};
                if (flag_key) {
                    ptlField_value = {key: j + 1, value: obj + ""};
                }
                _addPtlFieldList(ptlField_value);

            }
            data.splice(0, len);

        }
    }else{
        _setFlag(false);
        _setMsg("打包，参数不正确!")
    }
}
function _check_data_645(){
    return true;
}
function _check_data_loop(){
    return true;
}
/**
 * 计算校验位
 * @private
 */

function _check_bit(){

}
/**
 * 校验header数据
 * @private
 */
function _check_header_data(){

}

//========get=====set========//
function _getAfn(){
    return _afn;
}
function _setAfn(data){
    if(data==""||data==undefined||data==null){
        _afn=""
    }else{
        _afn=data;
    }
}

function _getTerProcode(){
    return _ter_procode;

}
function _setTerProcode(data){
    if(data==""||data==undefined||data==null){
        _ter_procode="06"
    }else{
        _ter_procode=data;
    }
}

function _getFn(){
    return _fn;
}
function _setFn(data){
    if(data==""||data==undefined||data==null){
        _fn=""
    }else{
        _fn=data;
    }

}

function _getPn(){
    return _pn;
}
function _setPn(data){
    if(data==""||data==undefined||data==null){
        _pn=""
    }else{
        _pn=data;
    }
}

function _getTerminal(){
    return _terminal;
}
function _setTerminal(data){
    if(data==""||data==undefined||data==null){
        _terminal=""
    }else{
        _terminal=data;
    }
}

function _getMas(){
    return _mas;
}
function _setMas(data){
    if(data==""||data==undefined||data==null){
        _mas=""
    }else{
        _mas=data;
    }

}

function _getMsgtype(){
    return _msgtype;
}
function _setMsgtype(data){
    if(data==""||data==undefined||data==null){
        _msgtype="1"
    }else{
        _msgtype=data;
    }
}

function _getTerPass(){
    return _ter_pass;
}
function _setTerPass(data){
    if(data==""||data==undefined||data==null){
        _setFlagterPaas(false);
        _ter_pass="0"
    }else{
        _setFlagterPaas(true);
        _ter_pass=data;
    }
}

function _getDriverAddr(){
    return _driver_addr;
}
function _setDriverAddr(data){
    if(data==""||data==undefined||data==null){
        _driver_addr=""
    }else{
        _driver_addr=data;
    }
}
function _getCmd(){
    return _cmd;
}
function _setCmd(data){
    if(data==""||data==undefined||data==null){
        _cmd=""
    }else{
        _cmd=data;
    }
}

function _getDataFlag(){
    return _dataflag
}
function _setDataFlag(data){
    if(data==""||data==undefined||data==null){
        _dataflag=""
    }else{
        _dataflag=data;
    }
}

function _getDataValue(){
    return _datavalue;
}
function _setDataValue(data){
    if(data==""||data==undefined||data==null){
        _datavalue=""
    }else{
        _datavalue=data;
    }
}

function _getDriverPass(){
    return _driver_pass;
}
function setDriverPass(data){
    if(data==""||data==undefined||data==null){
        _driver_pass="3544444487867478"
    }else{
        _driver_pass=data;
    }
}
function _getVn(){
    return _vn;
}
function _setVn(data){
    if(data==""||data==undefined||data==null){
        _setFlagVn(false);
        _vn="1"
    }else{
        _setFlagVn(true);
        _vn=data;
    }
}
function _getFseq(){
    return _fseq;
}
function _setFseq(data){
    if(data==""||data==undefined||data==null){
        _fseq="0"
    }else{
        _fseq=data;
    }
}

function _getIFseq(){
    return _ifseq;
}
function _setIFseq(data){
    if(data==""||data==undefined||data==null){
        _ifseq="3"
    }else{
        _ifseq=data;
    }
}
function _getFlagterPaas(){
    return _flag_terpass;
}
function _setFlagterPaas(data){
    if(data==""||data==undefined||data==null){
        _flag_terpass=false
    }else{
        _flag_terpass=data;
    }
}
function _getFlagVn(){
    return _flag_vn;
}
function _setFlagVn(data){
    if(data==""||data==undefined||data==null){
        _flag_vn=false
    }else{
        _flag_vn=data;
    }
}
function _getFlagData(){
    return _flag_data;
}
function _setFlagData(data){
    if(data==""||data==undefined||data==null){
        _flag_data=false
    }else{
        _flag_data=data;
    }
}

function _getPtlFieldList(){
    return _ptlField_list;
}
function _addPtlFieldList(data){
    if(data==""||data==undefined||data==null){
        return 0
    }else{
        return _ptlField_list.push(data);
    }
}
function _getData(){
    return _data;
}


function getMsg(){
    return _msg;
}
function _setMsg(data){
    _msg=data
}
function getFlag(){
    return _flag;
}
function _setFlag(data){
    _flag=data;
}
function _getFlagLoop(){
    return _flag_loop;
}
function _setFlagLoop(data){
    _flag_loop=data;

}
function _getOp(){
    return _op;
}
function _setOp(data){
    if(data==""||data==undefined||data==null){
        _op=0
    }else{
        _op=data;
    }
}
function _getLen(){
    return _len;
}
function _setLen(data){
    if(data==""||data==undefined||data==null){
        _len=""
    }else{
        _len=data;
    }
}
function _getFlagIndex(){
    return _flag_index;
}
function _setFlagIndex(data){
    if(data==""||data==undefined||data==null){
        _flag_index=false
    }else{
        _flag_index=data;
    }
}


/**
 *
 * @param data 数据
 * @param flag 是否循环 0不循环，1....n 多次循环
 * @param op 循环位置 0-第0位，1....n 多次循环 以-分割，例如，2次循环，1-6，第一位和第6位分别记录了循环的次数
 * @param len  循环体长度 多次循环 以-分割，例如，2次循环，5-4，第一次循环到第二次循环长度是5 第二次循环长度是4，总循环体长度是 (次数2*长度2)+长度1
 */
function setData(data,flag,op,len,flag_index){
    if(data==""||data==undefined||data==null){
        _setFlagData(false);
        _setFlagLoop(0)
        _data=[];
    }else{
        _setFlagData(true);
        _setFlagLoop(flag);
        _setOp(op);
        _setLen(len);
        _setFlagIndex(flag_index);
        //if(_getAfn()==_afn_645&&_getFn()==_fn_645){
        //    setData_645(data);
        //}
        _data=data;
    }
}
/**
 *
 * @param addr 表地址 正序
 * @param cmd 控制字  11或14
 * @param len 数据长度 04或0E
 * @param dataflag 数据标示 323333B4(查询) 333433B5(主灯) 343433B5(辅灯) 323433B5(全部) 已+33
 * @param pass 密码 固定 3544444487867478 已+33
 * @param datavalue 传入值需要倒序 +33
 */
function setData_645(callbackType,addr,cmd,len,dataflag,pass,datavalue,ackinterval){
    //debugger;
    _callbackType=callbackType;
    if(ackinterval){
        _ackinterval=ackinterval;

    }
    var countlen=_data_pre+_byte_desc(addr)+_data_pre+cmd+len+dataflag;
    if(pass&&datavalue){
        countlen=_data_pre+_byte_desc(addr)+_data_pre+cmd+len+dataflag+pass+_byte_add_33_desc(datavalue);
    }
    _data_value_645=countlen+_countlen(countlen)+_data_end;
    _data.push(_data_value_645);
}
function init_socket(url,fsname,fname,fcname,cmsg,fdname,dmsg,fwname,socket_class){

    _username='user' + make_uuid();
    _fname=fname;
    if(url){
        _socket =  io.connect(url+'?username='+_username);
    }else{
        return null;
    }
    if(fsname){
        _fsname=fsname;
    }
    if(fname){
        _fname=fname;
    }
    if(fdname){
        _fdname=fdname;
    }
    if(dmsg){
        _dmsg=dmsg;
    }
    if(fcname){
        _fcname=fcname;
    }
    if(cmsg){
        _cmsg=cmsg;
    }
    if(fwname){
        _fwname=fwname;
    }
    //连接
    socket_func(_fcname,_cmsg);
    //断开
    socket_func(_fdname,_dmsg);
    //发送
    socket_transData(_fsname);
    //回复
    socket_retransData(_fname);
    //报警
    socket_waring(_fwname);
    if(socket_class){
        _socket_class=socket_class;
    }
    return _socket;
}
function connect_socket(url,socket_class){
    if(socket_class){
        _socket_class=socket_class;
    }
    _username='user' + make_uuid();
    _socket = io.connect(url+'?username='+_username);
    //连接
    socket_func(_fcname,_cmsg);
    //断开
    socket_func(_fdname,_dmsg);
    //发送
    socket_transData(_fsname);
    //报警
    socket_waring(_fwname);
    return _socket;
}
function getSocket(){
    return _socket;
}
function socket_func(fname,msg){

    _socket.on(fname, function() {
        output('<span class="connect-msg">'+msg+'</span>');
    });
}
function socket_transData(fname){
    if(fname){
        _fsname=fname;
    }
    _socket.on(_fsname, function(data) {
        output('<span class="username-msg">' + data.userName + ':</span> ' + data.message);
    });
}
function socket_retransData(fname){
    if(fname){
        _fname=fname;
    }
    _socket.on(_fname, function(data) {
        var sscMessage=data.sscMessage;
        var msgType=sscMessage.msgType;
        var message=data.message;
        if(msgType==99){
            message="连接超时！"
        }
        output('<span class="username-msg">回复数据类型-' + msgType + ':</span> ' + '<span class="disconnect-msg">' +  message + ':</span> ');
    });
}
function socket_waring(fname,msg){
    if(fname){
        _fwname=fname;

    }
    _socket.on(_fwname, function(data) {

        var sscMessage=data.sscMessage;
        var msgType=sscMessage.msgType;
        var message=data.message;
        output('<span class="username-msg">回复数据类型-' + msgType + ':</span> ' + '<span class="disconnect-msg">' + message + ':</span> ');
    });}
function make_uuid() {
    var s = [];
    var hexDigits = "0123456789abcdefghijklmnopqrstuvwxyz";
    for (var i = 0; i < 36; i++) {
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
    }
    s[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1); // bits 6-7 of the clock_seq_hi_and_reserved to 01
    s[8] = s[13] = s[18] = s[23] = "-";

    var uuid = s.join("");
    return uuid;
}
function output(message) {
    var currentTime = "<span class='time'>" +  moment().format('HH:mm:ss.SSS') + "</span>";
    var element = $("<div>" + currentTime + " " + message + "</div>");
    $('#w_msg').prepend(element);
}

function send_data(){
    var jsonObject = {'@class': _socket_class,
        userName: _username,
        terminalCode: _terminal,
        afn: _afn,
        fn: _fn,
        pn: _pn,
        mkTime: _mkTime,
        data: null,
        uuid: make_uuid(),
        mas: _mas,
        seq: _seq,
        msgType: _msgtype,
        callbackType: _callbackType,
        maxWaitTime: _maxWaitTime,
        timeoutInterval: _timeoutInterval,
        writeTime: _writeTime,
        ackinterval: _ackinterval,
        maxTrytimes: _maxTrytimes,
        trytimes: _trytimes,
        updateExpression: _updateExpression,
        ptlFields: {lst:_getPtlFieldList()}
    };
    _socket.emit(_fsname, jsonObject);
}
function output_ptl(lst){
    output('<span class="username-msg">username:</span> ' + _username)
    for(var i=lst.length-1;i>=0;i--){
        var value=lst[i];
        output('<span class="username-msg">' + value.key + ':</span> ' + value.value)
    }
}
function check_msg_type(msgType){
    if(msgType==99){
        message="回复报文超时！"
    }else if(msgType==97){
        message="终端不在线！"
    }else if(msgType==98){
        message="发送超时！"
    }else{
        message="0"
    }
    return message;
}
/**
 *
 * @param data
 * @private
 */
function _countlen(data){
    var str=0;
    for(var i=0;i<data.length+1;i++){
        if(i!=0&&i%2==0){
            var tep='0x'+data.substring(i-2,i);
            str=str+parseInt(tep);
        }
    }
    var res=str.toString(16);
    return res.substring(res.length-2);
}
//字节倒序
function _byte_desc(data){
    var str="";
    for(var i=data.length;i>0;i--){
        if(i%2==0){
            str=str+data.substring(i-2,i);
        }
    }
    return str;
}
//字节倒序
function _byte_add_33_desc(data){
    var str="";
    for(var i=data.length;i>0;i--){
        if(i%2==0){
            var y=parseInt('0x'+data.substring(i-2,i))+parseInt('0x'+33);
            str=str+y.toString(16);
        }
    }
    return str;
}