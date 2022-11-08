/**
 * Created by samsung on 2022-10-20.
 */

({
    fnInit : function(component, event, helper){
        //'vfPageUrl'에 url 셋팅
        component.set("v.vfPageUrl" , "/apex/AssetContract?recordId=" + component.get("v.recordId"));
    },

    fnCancel : function(component, event, helper){
        //창닫기
        $A.get("e.force:closeQuickAction").fire();
    },

    fnSave : function(component, event, helper){
        helper.savePdf(component,  event, helper);
        $A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();
    }
});