({

    openForgotPass : function (component, event, helper){
        component.set("v.errorMessage",null);
        component.set("v.showError",false);        
        document.getElementById("signIn").classList.add('slds-hide');  
        document.getElementById("forgotPass").classList.remove('slds-hide');     
        document.getElementById("username").value = null;
        document.getElementById("password").value = null;        
    },
    openSignin : function (component, event, helper){
        component.set("v.errorMessage",null);
        component.set("v.showError",false);
        document.getElementById("forgotPass").classList.add('slds-hide');  
        document.getElementById("forgotPassConfirm").classList.add('slds-hide');  
        document.getElementById("signIn").classList.remove('slds-hide');     
        document.getElementById("forgotUsername").value = null;    
    },  
    openPrivacy : function(component, event, helper){
      window.open("/s/edgeprivacy",'_blank');
    },
    
    /*initialize: function(component, event, helper) {
		        
         	
        
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();    
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap2}).fire();
        component.set('v.isUsernamePasswordEnabled', helper.getIsUsernamePasswordEnabled(component, event, helper));
        component.set("v.isSelfRegistrationEnabled", helper.getIsSelfRegistrationEnabled(component, event, helper));
        component.set("v.communityForgotPasswordUrl", helper.getCommunityForgotPasswordUrl(component, event, helper));
        component.set("v.communitySelfRegisterUrl", helper.getCommunitySelfRegisterUrl(component, event, helper));
        
        console.log('isUsernamePasswordEnabled' + component.get("v.isUsernamePasswordEnabled"));
        console.log(component.get("v.isSelfRegistrationEnabled"));
        console.log(component.get("v.communityForgotPasswordUrl"));
        console.log(component.get("v.communitySelfRegisterUrl"));        
        
    },*/
    
    handleLogin: function (component, event, helpler) {
        helpler.handleLogin(component, event, helpler);
    },    
    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    
    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },
    
   onKeyUp: function(component, event, helpler){
        if (event.keyCode === 13) {
            helpler.handleLogin(component, event, helpler);
        }
    },
   forgotOnKeyUp: function(component, event, helpler){
        if (event.keyCode === 13) {
            helpler.handleForgotPassword(component, event, helpler);
        }
    } ,
    handleForgotPassword: function (component, event, helpler) {
        helpler.handleForgotPassword(component, event, helpler);
    },
    checkBoxClicked: function (component, event, helper) {
        component.set("v.isComply",event.srcElement.checked);
    }
       
})