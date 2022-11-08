/**
 * Created by samsung on 2022-10-20.
 */

({
    savePdf : function(component, event, helper){
        var dataUrl1 = component.get("v.vfPageUrl");

        var strDataURI1 = dataUrl1.replace(/^data:image\/(png|jpg);base64,/, "");
        var action = component.get("c.GenerateCustomPDFAndEmail");
        action.setParams({"recordId":component.get("v.recordId"),
                          "assetBody" : strDataURI1

        });
        $A.enqueueAction(action);
    }
});