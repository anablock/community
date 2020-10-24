({
	 showSuccessToast : function(component, event, helper) {
        let successMessageText = $A.get("$Label.c.PDLSuccessMessageText");
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: successMessageText,
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showErrorToast : function(component, event, helper, serverResponse) {
        console.log('serverResponse ' + serverResponse);
        let errorMessageText = serverResponse == '' ? $A.get("$Label.c.PDLErrorMessageText") : serverResponse;
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: errorMessageText,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})