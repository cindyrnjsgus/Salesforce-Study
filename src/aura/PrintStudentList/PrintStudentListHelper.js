({
    savePdf : function(component){
        var action = component.get("c.GenerateCustomPDFAndEmail");
        action.setParams({"recordId":component.get("v.recordId")});
        $A.enqueueAction(action);
    }

});