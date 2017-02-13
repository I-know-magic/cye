function loadBoxData(id, url, textField, update,index) {

    $('#' + id).combobox({
        editable: false,
        valueField: 'id',
        textField: textField,
        panelHeight: 230,
        url: url,
        onLoadSuccess: function (rec) {
            debugger;
            if (!update) {
                $('#' + id).combobox("select", rec[1].id);
            }else {
                $('#' + id).combobox("select", index);
            }
        }
    });
}
function loadBoxData_cus(id, url,valueField, textField, update,index) {

    $('#' + id).combobox({
        editable: false,
        valueField: 'id',
        textField: textField,
        panelHeight: 230,
        url: url,
        onLoadSuccess: function (rec) {
            debugger;
            if (!update) {
                $('#' + id).combobox("select", rec[0].id);
            }else {
                $('#' + id).combobox("select", index);
            }
        }
    });
}
function loadBoxDatas(ids, url, textField, update,indexs) {

    var str=ids.split(',');
    if(str){
        for(var i=0;i<str.length;i++){
            var id=str[i];
            debugger;
            $('#' + id).combobox({
                editable: false,
                valueField: 'id',
                textField: textField,
                panelHeight: 230,
                url: url+'&id='+id,
                loadData:function(data){
                    debugger;
                },
                onLoadSuccess: function (rec) {

                    if (!update) {
                        $('#' + id).combobox("select", rec[1].id);
                    }
                }
            });
        }
    }
}