function saveFrom(op, url, dialog, initUrl) {
    $('#' + op).form('submit', {
        url: url,
        onSubmit: function () {
            return $(this).form('validate');
        },
        success: function (result) {
            var result = eval('(' + result + ')');
            if (result.success == "true") {
                $.messager.alert('系统提示', result.msg, 'info');
                doSearch();
                if (dialog) {
                    $('#' + dialog).dialog('close');
                }
                else {
                   //var branch_val = $('#pos_add_branch').combobox("getValue");
                    $('#' + op).form('reset');
                   // $('#pos_add_branch').combobox("select",branch_val);
                    $('#' + op).form('load', initUrl)
                }
            } else {
                $.messager.alert('系统提示', result.msg, 'error');
            }
        },
        onLoadError: function () {
            $.messager.alert('系统提示', "加载数据失败，请稍后再试！", 'error');
        }
    });
}
function closedDialog(dialog, status) {
    $('#' + dialog).dialog(status);
}


$.extend($validateRules, {
    validatePassword: {
        validator: function (value) {
            if (/^[0-9]*$/g.test(value) && value.length == 6) {
                return true;
            } else {
                return false;
            }
        },
        message: '请输入6位数字'
    },
    checkPw: {
        validator: function (value, param) {
            return value == $('' + param).val();
        },
        message: '输入错误'
    }
});

/**
 * 初始化门店
 */
function initBranch(){
    var h_branch_type = $('#h_branch_type').val();
    if (h_branch_type != 0) {
        $('.p_branch_').hide();
    }
    $("#branch").textbox({
        buttonText: '选择',
        editable: false,
        width: 200,
        onClickButton: function () {
            $("#select_dialog").dialog({
                href: h_branch_url + '?checkBranchId=' + $('#branchMenu_r').val(),
                width: "350px",
                height: "500px"
            }).dialog("open").dialog('setTitle', "选择门店");
        }
    });
}
function setSelectObj(id, name, isWhere) {
    if (isWhere === "2") {
        $("#branchMenu_r").val(id);
        $("#branch").textbox("setValue", name);
    }
    $("#select_dialog").dialog("close");
}