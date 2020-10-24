/*
 * @Author 		: 
 * 
 * @Dated On 	: August, 14, 2020
 * 
 * @Desc 		: This class contains the logic to update lead Status by TaskTriggerHandler & Scheduling Job which will check for mass email process.
 * 
*/
public class LeadStatusUpdate {

	private static final String leadIdVariable = '00Q';
    private static final String leadStatusToSet = 'Contacted';
    private static final String ObjectName = 'Lead';
    
    /*
     * @Desc : Get Lead Id from list Email Recipient to pass into updateLead Method
     * 
    */ 
    
    public static void getLeadIdFromListEmailRecipient() {
        
		set<Id> setOfLeadIdToUpdate = new set<Id>();
        for(ListEmailIndividualRecipient listEmailRecipientObj : [SELECT Id,ListEmailId,Name,RecipientId FROM ListEmailIndividualRecipient WHERE RecipientId != NULL ORDER BY LastModifiedDate DESC limit 100]){
         	
          	if(listEmailRecipientObj.RecipientId != null && String.isNotEmpty(listEmailRecipientObj.RecipientId) && String.valueOf(listEmailRecipientObj.RecipientId).StartsWith(leadIdVariable)){     
                setOfLeadIdToUpdate.add(listEmailRecipientObj.RecipientId);
            }
                                                                      
         }
        system.debug('LeadStatusUpdateHandler.getTaskLeadId setOfLeadIdToUpdate : '+ setOfLeadIdToUpdate);
        
        if(setOfLeadIdToUpdate != null && !setOfLeadIdToUpdate.isEmpty()){
            updateLeadStatus(setOfLeadIdToUpdate);
        }
    }
    
    /*
     * @Desc : Get Lead Id from Task to pass into updateLead Method
     * 
    */ 
    
    public static void getLeadIdFromTask(list<task> triggerNew){
        set<Id> setOfLeadIdToUpdate = new set<Id>();
        
        for(Task taskObj : triggerNew){
            if(taskObj.WhoId != null && String.isNotBlank(taskObj.WhoId) 
               && String.valueOf(taskObj.WhoId).StartsWith(leadIdVariable)){
                   
                   setOfLeadIdToUpdate.add(taskObj.WhoId);
                   
               }
        }
        
        for(EmailMessageRelation emailmsg : [SELECT id,RelationId FROM  EmailMessageRelation 
                                             WHERE RelationObjectType =: ObjectName AND RelationId IN: setOfLeadIdToUpdate]){
                                                 setOfLeadIdToUpdate.add(emailmsg.RelationId);
            
        } 
        
        system.debug('LeadStatusUpdateHandler.getTaskLeadId setOfLeadIdToUpdate : '+ setOfLeadIdToUpdate);
        
        if(setOfLeadIdToUpdate != null && !setOfLeadIdToUpdate.isEmpty()){
            updateLeadStatus(setOfLeadIdToUpdate);
        }
    }
    
    /*
     * @Desc : Update Lead from set of id we passed
     * 
    */
    
    public static void updateLeadStatus(set<Id> setOfLeadIdToUpdate) {
        
        list<lead> listOfLeadToUpdate = new list<lead>();
        for(Lead le : [SELECT Id,Status FROM Lead WHERE Id IN : setOfLeadIdToUpdate]){
            if(le.Status != 'Nurturing' && le.Status != 'Engaged' && le.Status != 'Rejected' 
               && le.Status != 'Qualified' && le.Status != 'Meeting Scheduled' && le.Status != 'Contacted'){
                lead leObj 		= new lead();
                leObj.Id 		= le.Id;
                leObj.Status 	= leadStatusToSet;
                listOfLeadToUpdate.add(leObj);
            }
        }
        if(listOfLeadToUpdate != null && !listOfLeadToUpdate.isEmpty()){
            system.debug('LeadStatusUpdate.updateLeadStatus listOfLeadToUpdate : '+ listOfLeadToUpdate);
            update listOfLeadToUpdate;
        }
    }
}