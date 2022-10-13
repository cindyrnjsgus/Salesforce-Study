({
    fnInit : function(component, event, helper) {
        helper.getInitData(component);
    },

    fnSave: function (component, event, helper) {
        var result = confirm('학급을 정말 이동하시겠습니까?');
        if(result) {
            helper.changeClass(component, event);
        }
        $A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();
    },

    fnCancel : function(component, event, helper) {
        //취소 (창닫기)
        $A.get("e.force:closeQuickAction").fire();
    }

});