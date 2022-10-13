({
    fnInit : function(component, event, helper) {
        //recordId 로그를 찍어 확인해보기
        console.log('recordId : ',component.get("v.recordId"));
        //helper로 이동 시키기
        helper.getInitData(component);
    }
});