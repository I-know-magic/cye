/**
 * 数据格式化
 */
function dateFormatter(val, row, index) {
    if (val != null) {
        return $.formatDate("yyyy-MM-dd", val.substr(0, 10));
    }
    return val;
}
/**
 * 精确到时分秒
 * @param val
 * @param row
 * @param index
 * @returns {*}
 */
function dateFormatterToHMS(val, row, index) {
    if (val != null) {
        return $.formatDate("yyyy-MM-dd HH:mm:ss", val.substr(0, 20));
    }
}
function dateFormatterToHM(val, row, index) {
    if (val != null) {
        return $.formatDate("yyyy-MM-dd HH:mm", val.substr(0, 20));
    }
}
function moneyFormatter2(val) {
    if (val != null) {
        return "￥" + parseFloat(val).toFixed(2);
    }
    return val
}
function moneyFormatter(val) {
    if (val) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === 0) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === undefined || val === "" || val == null) {
        return "￥" + parseFloat(0).toFixed(2);
    } else {
        return "￥" + parseFloat(0).toFixed(2);
    }
}
/**
 *针对报表的金额格式话
 * @param value
 * @param row
 * @param index
 * @returns {string}
 */
function reportMoneyFormatter(val) {
    if (val) {
        return "￥" + val;
    } else if (val === 0) {
        return "￥" + parseFloat(val).toFixed(2);
    } else if (val === undefined || val === "" || val == null) {
        return "￥" + parseFloat(0).toFixed(2);
    } else {
        return "￥" + parseFloat(0).toFixed(2);
    }
}
function timeFormatter(date) {
   return date?date.substring(0,date.length-2):""
}

function numberFormatter(value, row, index) {
    if (value) {
        return value;
    } else if (value === 0) {
        return parseFloat(0).toFixed(2);
    }
}
/**
 * 格式化数字为小数点后两位
 * @param value
 * @param row
 * @param index
 * @returns {string}
 */
function numberF(value, row, index) {
    if (value) {
        return parseFloat(value).toFixed(2);
    } else if (value === 0) {
        return parseFloat(0).toFixed(2);
    }
}
/**用于报表**/
function rep_money_Formatter(val) {
    if (val) {
        return "￥" + parseFloat(val).toFixed(2);
    }
}
function booleanFormatter(val) {
    if (val == true) {
        return "是";
    }
    if (val == false) {
        return "否";
    }
    return val;
}

