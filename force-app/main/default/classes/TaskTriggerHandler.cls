/*
* This class contains the business logic for various actions performed on various Task trigger events
*/
public with sharing class TaskTriggerHandler {
    
    /*
    * This method is called on BeforeInsert Task trigger event
    */
    //public void OnBeforeInsert(list<task> triggerNew) {
    //} 
    
    /*
    * This method is called on AfterInsert Task trigger event
    */
    public void OnAfterInsert(list<task> triggerNew) {
        LeadStatusUpdate.getLeadIdFromTask(triggerNew);
    } 
    
    /*
    * This method is called on BeforeUpdate Task trigger event
    */
    //public void OnBeforeUpdate(list<task> triggerNew) {
    //}
    
    /*
    * This method is called on AfterUpdate Task trigger event
    */
    //public void OnAfterUpdate(list<task> triggerNew) {  
     //} 


}