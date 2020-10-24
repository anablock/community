global class PDLApiControllerBatchable implements Database.AllowsCallouts, Schedulable, Database.Batchable<sObject>{
    
    
   global Database.QueryLocator start(Database.BatchableContext BC) {
        
         // get only records that are not refreshed in last 30 days and use it in query below
        List<PDL_Person__c> pdlPeople = [SELECT Id, Lead_Ref__c, Last_Sync_Date__c FROM PDL_Person__c WHERE Last_Sync_Date__C < LAST_N_DAYS:30];
        Set<Id> leadIds = new Set<Id>();
        for(PDL_Person__c pdlPerson : pdlPeople){
            leadIds.add(pdlPerson.Lead_Ref__c);
        }
        String leadSource = Label.PDLQueryLeadSource;
        String emptyString = '';
        String query = 'SELECT ID, Name, LeadSource, LinkedIn__c, Email, FirstName, LastName, Company FROM Lead WHERE LeadSource = :leadSource AND Id IN :leadIds';
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        
        List<PDLApiController.PDLResponse> responseList = new List<PDLApiController.PDLResponse>();
        
        try{
            responseList = PDLApiController.getLeadInformation(scope);
        
        }catch(System.JSONException ex) {
            System.debug('Batchable:Unable to parse JSON response= '+ ex.getMessage() + ' ' + ex.getLineNumber());
            
        }catch(System.NullPointerException e) {
            System.debug('Batchable:NullPointer= '+ e.getMessage() + ' ' + e.getLineNumber());
        }


        // TO-DO
        // store response somewhere
    }   
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new PDLApiControllerBatchable(), 1);
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}