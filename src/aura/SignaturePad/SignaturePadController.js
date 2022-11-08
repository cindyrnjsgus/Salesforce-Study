({
    fnInit : function(component, event, helper) {
        var sObjectName = component.get("v.sObjectName");
        helper.doInit(component, event, helper);
    },

    fnErase : function(component, event, helper){
        helper.doErase(component, event, helper);
    },

    fnSave : function(component, event, helper){
        var canvas = component.find('installer').getElement();
        var isEmpCanvas = helper.isCanvasEmpty(canvas);

        if (isEmpCanvas){
            component.find("notifLib").showToast({
                                                   "variant":"warning",
                                                   "title": "서명란에 서명을 해주세요.",
                                                   "mode":"dismissable"
                                                });
        }
        else {
            helper.doSave(component, event, helper);
        }
    },
    
    fnCancel : function(component, event, helper){
        var isCommunity = component.get("v.isCommunity");
        if(!isCommunity) {
            $A.get("e.force:closeQuickAction").fire();
        } else {
            var evt = component.getEvent("CommunityButtonEvt");
            if(evt) {
                evt.fire();
            } else {
            }
        }
    }, 
});