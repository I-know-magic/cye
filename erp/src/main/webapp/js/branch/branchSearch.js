/**
 * 门店搜索组件
 */

$.extend($.fn.validatebox.defaults.rules, {
    inputEquals: {
        validator: function (value,isValid) {
            if (isValid) {
                return validBranch(value);
            }
            return true;
        },
        message: '请选择门店'
    }
});
function validBranch(value) {
    return branchValid(value);
}

/**
 * 创建组件
 * @param obj
 * @param url
 * @param formatter
 * @param onSelect
 */
function initBranchSearch(obj, url, formatter, onSelect, onLoadSuccess, isValid) {
    obj.combobox({
        url: url,
        method: 'get',
        valueField: 'id',
        textField: 'name',
        panelHeight: 280,
        //panelWidth: 390,
        required: true,
        prompt: '请选择配货门店',
        invalidMessage: '请选择门店',
        formatter: function (row) {
            if (formatter) {
                return formatter(row);
            } else {
                return defaultFormatter(row);
            }
        },
        onSelect: function (record) {
            if (onSelect) {
                return onSelect(record);
            }
        },
        onLoadSuccess: function (data) {
            if (onLoadSuccess) {
                return onLoadSuccess(data);
            } else {
                return true;
            }
        },
        validType: isValid ? 'inputEquals[' + isValid + ']' : ''
    });
}
/**
 * 默认格式化
 * @param row
 */
function defaultFormatter(row) {
    var fm = "<span>编码:&nbsp;".fontsize(3) + row.code + "&nbsp;&nbsp;&nbsp;&nbsp;名称:&nbsp;".fontsize(3) + row.name + "<br/>" + "地址:&nbsp;".fontsize(3)
        + row.address + "</span>";
    return fm;
}
