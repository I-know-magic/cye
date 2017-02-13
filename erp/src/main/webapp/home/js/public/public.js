/**
 * 条形码校验校验器
 */
function barValidate(bar) {
    if (typeof bar !="string" || !bar.match(/\d+/g)) {
        return false;
    }
    var pBit = bar.substring(bar.length - 1, bar.length);
    var no = bar.substring(0, bar.length - 1);
    return pBit == barParityBitCreator(no);
}
/**
 * 条形码校验位生成器
 * @param sequence 序列位
 */
function barParityBitCreator(sequence){
    if (typeof sequence !="string" || !sequence.match(/\d+/g)) {
        return '';
    }
    var seqChars = sequence.match(/./g);
    //a、自右向左顺序
    var evenSum = 0
    //c、自右向左顺序
    var oddSum = 0

    for (var x = seqChars.length - 1; x >= 0; x -= 2) {
        evenSum += parseInt(seqChars[x]);
        if (x != 0) {
            oddSum += parseInt(seqChars[x - 1]);
        }
    }
    // b、d
    var sum = evenSum * 3 + oddSum;
    var zs = sum;
    while (true) {
        if (zs % 10 == 0) {
            break ;
        }
        zs++;
    }
    return zs - sum;
}
/**
 * 保留小数点后两位,如果不满两位则补零
 * @param number
 * @param decimals 小数点后几位
 * @returns {*}
 */
function roundNumber(number,decimals) {
    var newString;// The new rounded number
    //如果输入的值为负数，则置为最小值0.00
    if(parseFloat(number) < 0){
        newString = "0.00";
        return newString;
    }
    decimals = Number(decimals);
    if (decimals < 1) {
        newString = (Math.round(number)).toString();
    } else {
        var numString = number.toString();
        if (numString.lastIndexOf(".") == -1) {// If there is no decimal point
            numString += ".";// give it one at the end
        }
        var cutoff = numString.lastIndexOf(".") + decimals;// The point at which to truncate the number
        var d1 = Number(numString.substring(cutoff, cutoff + 1));// The value of the last decimal place that we'll end up with
        var d2 = Number(numString.substring(cutoff + 1, cutoff + 2));// The next decimal, after the last one we want
        if (d2 >= 5) {// Do we need to round up at all? If not, the string will just be truncated
            if (d1 == 9 && cutoff > 0) {// If the last digit is 9, find a new cutoff point
                while (cutoff > 0 && (d1 == 9 || isNaN(d1))) {
                    if (d1 != ".") {
                        cutoff -= 1;
                        d1 = Number(numString.substring(cutoff, cutoff + 1));
                    } else {
                        cutoff -= 1;
                    }
                }
            }
            d1 += 1;
        }
        if (d1 == 10) {
            numString = numString.substring(0, numString.lastIndexOf("."));
            var roundedNum = Number(numString) + 1;
            newString = roundedNum.toString() + '.';
        } else {
            newString = numString.substring(0, cutoff) + d1.toString();
        }
    }
    //如果小数点前面有多余的零则去掉
    var before = newString.substring(0,newString.lastIndexOf("."));
    var reg=/[1-9]/;
    if(reg.test(before)){
        var after = newString.substring(newString.lastIndexOf(".")+1,newString.length);
        newString = before.replace(/^0+/, '') + "." + after;
    }

    if (newString.lastIndexOf(".") == -1) {// Do this again, to the new string
        newString += ".";
    }
    var decs = (newString.substring(newString.lastIndexOf(".") + 1)).length;
    for (var i = 0; i < decimals - decs; i++) {
        newString += "0";
    }
    if(newString == '.00'){
        newString = "0.00"
    }
    if(parseFloat(newString) > 999999999999.99){
        newString = "999999999999.99";
    }
    return newString;
}
function keyPress(ob) {
    if (!ob.value.match(/^[\+\-]?\d*?\.?\d*?$/))
        ob.value = ob.t_value;
    else ob.t_value = ob.value;
    if (ob.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))
        ob.o_value = ob.value;
}
function keyUp(ob) {
    if (!ob.value.match(/^[\+\-]?\d*?\.?\d*?$/))
        ob.value = ob.t_value;
    else ob.t_value = ob.value;
    if (ob.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))
        ob.o_value = ob.value;
}
function onBlur(ob) {
    if(!ob.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?|\.\d*?)?$/))
        ob.value=ob.o_value;
    else{
        if(ob.value.match(/^\.\d+$/))
            ob.value=0+ob.value;
        if(ob.value.match(/^\.$/))
            ob.value=0;
        ob.o_value=ob.value};
}
/**
 * 只能输入数字和小数点
 * @param e
 * @constructor
 */
function IsNum(e) {
    var k = window.event ? e.keyCode : e.which;
    if (((k >= 48) && (k <= 57)) || k == 8 || k == 0 || k == 46 || (k <= 105 && k >= 96) || k == 110) {
    } else {
        if (window.event) {
            window.event.returnValue = false;
        }
        else {
            e.preventDefault(); //for firefox
        }
    }
}
/**
 * 只能输入输入数字
 * @param e
 */
function isNumber(e){
    var k = window.event ? e.keyCode : e.which;
    if (((k >= 48) && (k <= 57)) || k == 8 || k == 0) {
    } else {
        if (window.event) {
            window.event.returnValue = false;
        }
        else {
            e.preventDefault(); //for firefox
        }
    }
}