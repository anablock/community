({
    doInit : function(component, event, helper) {
        // set text in the modal
        let proceedText = $A.get("$Label.c.PDLProceedText");
        component.set("v.proceedText", proceedText);
    },
    
    getLeadInfo: function(component, event, helper) {
      
        let closeModal = component.get('c.closeModal');
        
        let action = component.get("c.getLeadInformationQuickAction");
        action.setParams({
            leadId: component.get("v.recordId")
        });        
        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() === "SUCCESS"){
                let serverResponse = response.getReturnValue();
                console.log(serverResponse);
                if(serverResponse == ''){
                    helper.showSuccessToast(component, event, helper);
                }else{ 
                    helper.showErrorToast(component, event, helper, serverResponse); 
                }
            }else{
                console.log('serverResponse');
                console.log(serverResponse);
                helper.showErrorToast(component, event, helper, serverResponse); 
            }
            $A.enqueueAction(closeModal);
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    
    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    }
   
})