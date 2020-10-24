({
    
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },

    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleLogin: function (component, event, helpler) {
        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;
        var action = component.get("c.login");
        var startUrl = component.get("v.startUrl");
        
        startUrl = decodeURIComponent(startUrl);
        
        action.setParams({username:username, password:password, startUrl:startUrl});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            var isIE_ = isIE() ; 
            
            if (rtnValue !== null) { 
                if(rtnValue.includes("Error")){
                    component.set("v.errorMessage",rtnValue.replace('Error','').replace('Email', 'Username'));
                    component.set("v.showError",true);                           
                }else{                
                    
                    if(isIE_.indexOf('IE') >= 0){                    	
                        var navEvt = $A.get('e.force:navigateToURL');
                        navEvt.setParams({url: rtnValue, target: "_self"});
                        navEvt.fire();
                    }else{
                        window.open(rtnValue,'_self');       
                    }
                }                                             
            }
            function isIE() { 
                var ua= navigator.userAgent, tem,
                    M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
                if(/trident/i.test(M[1])){
                    tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
                    return 'IE '+(tem[1] || '');
                }
                if(M[1]=== 'Chrome'){
                    tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
                    if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
                }
                M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
                if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
                return M.join(' '); 
            }
            helper.saveCookie({});
        });
        $A.enqueueAction(action);
    },  
    
    getIsUsernamePasswordEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsUsernamePasswordEnabled");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isUsernamePasswordEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getIsSelfRegistrationEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsSelfRegistrationEnabled");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isSelfRegistrationEnabled',rtnValue);
                //component.set('v.communitySelfRegisterUrl',rtnValue);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunitySelfRegisterUrl : function (component, event, helpler) {
        var action = component.get("c.getSelfRegistrationUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communitySelfRegisterUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    handleForgotPassword: function (component, event, helpler) {
        
        var username = document.getElementById("forgotUsername").value;
        
        var startUrl = component.get("v.startUrl");
        
        var action = component.get("c.forgotPassword");
        action.setParams({username:username});
        
        action.setCallback(this, function(a) {
            
            var rtnValue = a.getReturnValue();
            if (rtnValue != null) {
                component.set("v.errorMessage",rtnValue.replace('Email Address', 'Username'));
                component.set("v.showError",true);
            }
            else{                
        		document.getElementById("forgotPass").classList.add('slds-hide');                     
                document.getElementById("forgotPassConfirm").classList.remove('slds-hide'); 
            }
        });
        $A.enqueueAction(action);
    }     

})