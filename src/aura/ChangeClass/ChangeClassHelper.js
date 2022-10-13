({
    getInitData : function(component) {
        var action = component.get("c.getInitData");
        action.setParams({
            classes : component.get("v.classes")
        });

        action.setCallback(this, function(response) {
                                                        var state = response.getState();
                                                        if(state === "SUCCESS") {
                                                            var returnValue = response.getReturnValue();
                                                            component.set("v.classes", returnValue);
                                                        } else if(state === "ERROR") {
                                                            var errors = response.getError();
                                                             if(errors) {
                                                                 if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
                                                             }
                                                             else {
                                                                 this.showToast("error", "Unknown error");
                                                             }
                                                        }
                                                    }
                            );
        $A.enqueueAction(action);
    },

    changeClass : function(component, event) {
        var action = component.get("c.changeClass");
        action.setParams({
            className : component.get("v.selectedClass"),
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnValue = response.getReturnValue();

                if(!returnValue){
                    this.showToast("Error", "타 학년으로 이동 불가");
                }
                else {
                    this.showToast("Success", "반 이동 성공");
                }
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
    },

    showToast : function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key : "info_alt"
            , type : type
            , message : message
        });
        evt.fire();
    }

});