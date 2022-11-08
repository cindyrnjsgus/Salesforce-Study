/**
 * Created by samsung on 2022-11-07.
 */

({
    getAllData: function (component) {
        var action = component.get("c.fetchContacts");
        action.setCallback(this, function(response) {

            var state = response.getState();

            if(state === "SUCCESS") {
                var rows = response.getReturnValue();
                for(var i=0; i<rows.length; i++){
                    var row = rows[i];
                    row.rowNumber = i+1;
                    if(row.Class__r){
                        row.Grade = row.Class__r.Grade__c;
                        row.Class = row.Class__r.ClassNumber__c;
                    }
                }
                component.set('v.data', response.getReturnValue());
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                 if(errors) {
                     if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
                 }
                 else {
                     this.showToast("error", "Unknown error");
                 }
            }
        });
        $A.enqueueAction(action);
    }
});