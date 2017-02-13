
/****************************** 扩展方法 *****************************************/

Date.prototype.format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,                 //月份
        "d+": this.getDate(),                    //日
        "h+": this.getHours(),                   //小时
        "m+": this.getMinutes(),                 //分
        "s+": this.getSeconds(),                 //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds()             //毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

Date.prototype.addDays = function (days) {
    var sdate = this.getTime();
    var edate = new Date(sdate + (days * 24 * 60 * 60 * 1000));
    return edate;
}

Date.prototype.getThisWeekStart = function () {
    //星期一为第一天
    var getDay = new Date().getDay();
    if (getDay == 0) {
        return new Date().addDays(-6);
    } else {
        return new Date().addDays(getDay * -1 + 1);
    }
}

Date.prototype.getThisWeekEnd = function () {
    var startDay = new Date().getThisWeekStart();
    return startDay.addDays(6);
}

Date.prototype.getLastWeekStart = function () {
    //星期一为第一天
    var getDay = new Date().getDay();
    if (getDay == 0) {
        return new Date().addDays(-13);
    } else {
        return new Date().addDays(getDay * -1 - 6);
    }
}

Date.prototype.getLastWeekEnd = function () {
    //星期一为第一天
    var getDay = new Date().getDay();
    if (getDay == 0) {
        return new Date().addDays(-7);
    } else {
        return new Date().addDays(getDay * -1);
    }
}

Date.prototype.getThisMonthStart = function () {
    var currentYear=new Date().getFullYear();
    var currentMonth = new Date().getMonth();
    return new Date(currentYear, currentMonth, 1);
}

Date.prototype.getThisMonthEnd = function () {
    var currentYear=new Date().getFullYear();
    var currentMonth = new Date().getMonth();
    return new Date(currentYear, currentMonth+1, 1).addDays(-1);
}


Date.prototype.getLastMonthStart = function () {
    var lastMonthEnd = this.getLastMonthEnd();
    var days = lastMonthEnd.getDate();
    return lastMonthEnd.addDays(days * -1 + 1);
}

Date.prototype.getLastMonthEnd = function () {
    var currentYear = new Date().getFullYear();
    var currentMonth = new Date().getMonth();
    return new Date(currentYear, currentMonth, 1).addDays(-1);
}

String.prototype.toDate = function () {
    return new Date(this.replace(/-/g, "/"));
}

String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

browser = function (type) {
    var userAgent = navigator.userAgent.toLowerCase();
    switch (type) {
        case "isSafari":
            return /webkit/.test(userAgent);
        case "isOpera":
            return /opera/.test(userAgent);
        case "isMsie":
            if (!!window.ActiveXObject || "ActiveXObject" in window)
                return true;
            else
                return false;
        case "isMozilla":
            return /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
        default:
            alert("无法识别检测的浏览器类型");
            break;
    }

}

getRandomNum = function (min,max){   
    var range = max - min;   
    var rand = Math.random();   
    return (min + Math.round(rand * range));
}

/*时间日期选择器*/
dateTimePicker = function (opts) {
    opts = opts || {};
    opts.type = opts.type || "range";
    opts.dateFormat = opts.dateFormat || (opts.type == "range" ? "yy-mm-dd" : "yy.mm.dd");
    opts.yearRange = opts.yearRange || (opts.type == "range" ? "2013:" : "1980:");
    if (opts.showTimepicker == null) opts.showTimepicker = (opts.type == "range" ? true : false);
    if (opts.showArrow == null) opts.showArrow = true;
    if (opts.showBtnClean == null) opts.showBtnClean = false;
    if (opts.type == "range" && opts.defaultDateTime == null) {
        opts.defaultDateTime =  [new Date().format("yyyy-MM-dd 00:00"), new Date().format("yyyy-MM-dd 23:59")]
    }
    this.opts = opts;

    this.dateTimePickerOpts = {};
    this.initDateTimePickerOpts();

    this.createUI();

    this.bindDateTimePicker();
    
}

dateTimePicker.prototype = {
    regional: function () {
        //日期部分
        $.datepicker.regional['zh-CN'] = {
            closeText: '关闭',
            prevText: '&#x3c;上月',
            nextText: '下月&#x3e;',
            currentText: '今天',
            monthNames: ['一月', '二月', '三月', '四月', '五月', '六月',
                    '七月', '八月', '九月', '十月', '十一月', '十二月'],
            monthNamesShort: ['01', '02', '03', '04', '05', '06',
                    '07', '08', '09', '10', '11', '12'],
            dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
            dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
            dayNamesMin: ['日', '一', '二', '三', '四', '五', '六'],
            weekHeader: '周',
            dateFormat: 'yy-mm-dd',
            firstDay: 1,
            isRTL: false,
            showMonthAfterYear: true,
            yearSuffix: '年'
        };
        $.datepicker.setDefaults($.datepicker.regional['zh-CN']);

        //时间部分
        $.timepicker.regional['zh-CN'] = {
            timeOnlyTitle: '选择时间',
            timeText: '时间',
            hourText: '小时',
            minuteText: '分钟',
            secondText: '秒钟',
            millisecText: '微秒',
            timezoneText: '时区',
            currentText: '现在时间',
            closeText: '关闭',
            timeFormat: 'HH:mm',
            amNames: ['AM', 'A'],
            pmNames: ['PM', 'P'],
            isRTL: false
        };
        $.timepicker.setDefaults($.timepicker.regional['zh-CN']);
    },

    createUI: function () {
        var _this = this;

        if (this.opts.type == "range") {
            var container = $(this.opts.container);
            if (!container.hasClass("dateTimeRangeBox")) container.addClass("dateTimeRangeBox");

            var beginId = getRandomNum(1, 999999);
            var endId = getRandomNum(1, 999999);

            var beginContainer = $("<input id='ui-timePicker-begin-" + beginId + "' type='text' class='timeInput' value='" + this.opts.defaultDateTime[0] + "' size='16' readonly='readonly'>");
            beginContainer.bind("click", function () {
                _this.setFocus(this);
            });
            beginContainer.appendTo(container);

            $("<span>-</span>").appendTo(container);

            var endContainer = $("<input id='ui-timePicker-end-" + endId + "' type='text' class='timeInput' value='" + this.opts.defaultDateTime[1] + "' size='16' readonly='readonly'>");
            endContainer.bind("click", function () {
                _this.setFocus(this);
            });
            endContainer.appendTo(container);

            this.dateTimePickerOpts.beginContainer = $("#ui-timePicker-begin-" + beginId);
            this.dateTimePickerOpts.endContainer = $("#ui-timePicker-end-" + endId);
            this.dateTimePickerOpts.onClose = function () { container.find("input").removeClass("on") }
        }
    },

    initDateTimePickerOpts: function () {
        this.dateTimePickerOpts = {
            timeFormat: "HH:mm",
            dateFormat: this.opts.dateFormat,
            changeYear: true,
            changeMonth: true,
            showTime: false,
            showArrow: this.opts.showArrow,
            showBtnClean: this.opts.showBtnClean,
            yearRange: this.opts.yearRange,
            showTimepicker: this.opts.showTimepicker,
            showDateRangeSelector: this.opts.type == "range" ? true : false,
            dateTimePickerWidth: this.opts.type == "range" ? 400 : 266,
            container: this.opts.container
        };
    },

    bindDateTimePicker: function () {
        var _this = this;
        
        this.regional();

        if (this.opts.type == "range")
            $(this.opts.container).find("input").datetimepicker(this.dateTimePickerOpts);
        else
            $(this.opts.container).datetimepicker(this.dateTimePickerOpts);
    },

    setFocus: function (e) {
        $(e).parent().find("input").removeClass("on");
        $(e).addClass("on");
    },

    getSelectedDatetime: function (withoutSecond) {
        if (this.opts.type == "range") {
            var arr = [2];
            if (typeof (withoutSecond) != "undefined" && withoutSecond) {
                arr[0] = $(this.dateTimePickerOpts.beginContainer).val();
                arr[1] = $(this.dateTimePickerOpts.endContainer).val();
            } else {
                arr[0] = $(this.dateTimePickerOpts.beginContainer).val() + ":00";
                arr[1] = $(this.dateTimePickerOpts.endContainer).val() + ":59";
            }
            return arr;
        } else {
            return $(this.opts.container).val();
        }

    }
}

/*时间选择器*/
$.fn.timeSlidePicker = function () {
    $.timepicker.regional['zh-CN'] = {
        timeOnlyTitle: '选择时间',
        timeText: '时间',
        hourText: '小时',
        minuteText: '分钟',
        secondText: '秒钟',
        millisecText: '微秒',
        timezoneText: '时区',
        currentText: '现在时间',
        closeText: '关闭',
        timeFormat: 'HH:mm',
        amNames: ['AM', 'A'],
        pmNames: ['PM', 'P'],
        isRTL: false
    };
    $.timepicker.setDefaults($.timepicker.regional['zh-CN']);

    var timeSlidePickerOptions = {
        timeFormat: "HH:mm:ss",
        showArrow: false,
        showTime: false,
        showTimepicker: true,
        timeOnly: true,
        showButtonPanel: false
    };

    $(this).datetimepicker(timeSlidePickerOptions);
}