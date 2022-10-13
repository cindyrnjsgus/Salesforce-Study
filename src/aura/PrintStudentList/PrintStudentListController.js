
({
    fnInit : function(component, event, helper){
        //'vfPageUrl'에 url 셋팅
        component.set("v.vfPageUrl" , "/apex/PrintStudentList2?recordId=" + component.get("v.recordId"));
    },

    fnCancel : function(component, event, helper){
        //창닫기
        $A.get("e.force:closeQuickAction").fire();
    },

    fnSave : function(component, event, helper){
         //PDF -> note & attachment에 저장
         helper.savePdf(component);
         //창닫고, 새로고침
         $A.get("e.force:closeQuickAction").fire();
         $A.get("e.force:refreshView").fire();
    }

});