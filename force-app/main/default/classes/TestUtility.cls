/*
* @Desc 			: This class will contains all Test Data that need to create. We have to pull the method in to test class to run it. 
*
* @Dated 			: August, 15 2020
*
* @Modifications 	: 
*/

public class TestUtility {
    
    
    public static Account createAccount(String accountNameSuffix, Boolean insertAccount) {
        Account aAccount = new Account();
        aAccount.Name = 'Test Customer ' + accountNameSuffix;
        if(insertAccount)
            insert aAccount;
        return aAccount;
    }
    
    public static Contact createContact(String contactNameSuffix, String accountId, Boolean insertContact){
        Contact aContact = new Contact();
        aContact.FirstName = 'Test';
        aContact.LastName = 'Contact ' + contactNameSuffix;
        aContact.phone = '1231231234';
        aContact.email = '123@anablock.com';
        aContact.AccountId = accountId;
        aContact.MailingCity ='Testcity';
        aContact.MailingCountry = 'United States';
        aContact.MailingState = 'California';
        if(insertContact)
            insert aContact;
        return aContact;
    }
    
    public static Opportunity createOpportunity(String accountId, String opportunityNameSuffix, Boolean insertOpportunity) {
        Opportunity aOpportunity = new Opportunity();
        aOpportunity.Name = 'Test Opportiunity ' + opportunityNameSuffix;
        aOpportunity.AccountId = accountId;
        aOpportunity.CloseDate = System.today();
        aOpportunity.StageName = 'Qualified';
        aOpportunity.LeadSource = 'Web';
        aOpportunity.Type = 'Prospect';
        if(insertOpportunity) {
            insert aOpportunity;
        }
        return aOpportunity;
    }
    
    public static Lead createLead(String leadNameSuffix, Boolean insertLead){
        Lead aLead = new Lead();
		aLead.Company = 'Test Company';
        aLead.Email = 'developer@anablock.com';
        aLead.FirstName = 'Test';
        aLead.LastName = 'Lead' + leadNameSuffix;
        aLead.Status = 'New';
        if(insertLead)
            insert aLead;
        return aLead;
    }
    
    public static Case createCase(Boolean insertCase){
        Case aCase = new Case();
        aCase.Subject = 'This is a test';
        aCase.Status = 'Not Started';
        aCase.Priority = 'Low';
        if(insertCase)
            insert aCase;
        return aCase;
    }
    
    public static Case createCaseWithAccount(String accountId, Boolean insertCase) {
        Case aCase = new Case();
        aCase.AccountId = accountId;
        aCase.Status = 'Not Started';
        aCase.Priority = 'High';
        if(insertCase) {
            insert aCase;
        }
        return aCase;
    }

    public static void sendMail(String targetObjectId){
        
        messaging.SingleEmailMessage emailMsg = new messaging.SingleEmailMessage();
        string[] toAdd	=	new string[]{'developer@anablock.com'};
        emailMsg.setToAddresses(toAdd);
        emailMsg.setTargetObjectId(targetObjectId);
        emailMsg.setSubject('Test Subject');
        emailMsg.setPlainTextBody('Test Subject Mail From Anablock');
        emailMsg.setSenderDisplayName('Anablock');
		emailMsg.setSaveAsActivity(true);
        messaging.Email[] emails = new messaging.Email[]{ emailMsg };
        messaging.sendEmail(emails);
    }
    
    public static EmailMessage createEmailMessage(String parentId, boolean insertEmailMessage) {
        EmailMessage aEmailMsg = new EmailMessage();
        
        aEmailMsg.Subject = 'Anablock Systems';
        aEmailMsg.FromName = 'Anablock';
        aEmailMsg.status = '3';
        aEmailMsg.htmlBody = '<html><body><b>Test Mail</b></body></html>';
        String[] toIds = new String[]{ parentId };   
            aEmailMsg.toIds = toIds;  
        
        if(String.isNotBlank(parentId) && insertEmailMessage){
            insert aEmailMsg;
            
            EmailMessageRelation emr = new EmailMessageRelation();  
            emr.emailMessageId = aEmailMsg.Id;  
            emr.relationId = parentId; 
            emr.relationType = 'FromAddress';
            insert emr;  
        }
        
        return aEmailMsg;
    }
    
    public static Task createTask(String whoId, String whatId, Boolean insertTask){
        Task aTask = new Task();
        if(String.isNotBlank(whatId))
        	aTask.WhatId = whatId;
        
        if(String.isNotBlank(whoId))
        	aTask.WhoId = whoId;
		
        Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        System.debug('devRecordTypeId : '+ devRecordTypeId);
        aTask.Subject = 'Other';
        aTask.RecordTypeId = devRecordTypeId;
        aTask.priority= 'Normal';
        aTask.status = 'Not Started';
        aTask.description = 'New  Work';
        if(insertTask)
        	insert aTask;
        return aTask;
    }
    
    public static Profile getSystemAdminProfile(){
        Profile prf = [Select Id from profile where Name = 'System Administrator' limit 1];
        return prf; 
    }
    
    public static Profile getProfileInfoByName(String profileName){
        System.debug(profileName);
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName Limit 1];
        return p;
    }
    
    public static User createAUser(String userNameSuffix, Profile prf, Boolean insertUser){
        User aUser = new User();
        aUser.LastName = 'thisisatestuser ' + userNameSuffix;
        aUser.alias = userNameSuffix;
        if( aUser.alias.length() > 8 ) {
            aUser.alias = aUser.alias.substring(0,7);
        }
        aUser.email = 'Testuser'+userNameSuffix+'@anablock.com';
        aUser.UserName = 'Testuser'+userNameSuffix+system.now().getTime()+'@anablock.com';
        aUser.CommunityNickName = 'thisisatestuser'+userNameSuffix;
        aUser.TimeZoneSidKey = 'America/Los_Angeles';
        aUser.LocaleSidKey = 'en_US';
        aUser.EmailEncodingKey = 'ISO-8859-1';
        aUser.LanguageLocaleKey = 'en_US';
        aUser.ProfileId = prf.id;
        if(insertUser)
            insert aUser;
        return aUser;
    }
    
    /*public static UserRole getRole(String roleName){
        UserRole role = [SELECT Id FROM UserRole WHERE Name =: roleName LIMIT 1];
        return role; 
    }
    
    public static User createPortalUser(String userNameSuffix,String roleName, Profile prf, Boolean insertUser){
        User aUser = new User();
        // for portal user creation
        UserRole role = TestUtility.getRole(roleName);
        Account aAccount = TestUtility.CreateAccount('AnablockTest', true);
        Contact aContact = TestUtility.CreateContact('AnablockTest', aAccount.Id, true);
        User currentUser=[Select Id From User WHERE Id=:UserInfo.getUserId()];
        system.runAs(currentUser){
            aUser.ContactId = aContact.Id;
            // end (for portal user creation)
            aUser.LastName = 'thisisatestuser ' + userNameSuffix;
            aUser.alias = userNameSuffix;
            if( aUser.alias.length() > 8 ) {
                aUser.alias = aUser.alias.substring(0,7);
            }
            aUser.email = 'Testuser'+userNameSuffix+'@anablock.com';
            aUser.UserName = 'Testuser'+userNameSuffix+system.now().getTime()+'@anablock.com';
            aUser.CommunityNickName = 'thisisatestuser'+userNameSuffix;
            aUser.TimeZoneSidKey = 'America/Los_Angeles';
            aUser.LocaleSidKey = 'en_US';
            aUser.EmailEncodingKey = 'ISO-8859-1';
            aUser.LanguageLocaleKey = 'en_US';
            aUser.ProfileId = prf.id;
            aUser.isActive = true;
            if(insertUser)
                insert aUser;
        }
        return aUser;
    }*/
    
}