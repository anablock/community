global class LeadStatusUpdateScheduleJob implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        list<listEmail> listEmail = [SELECT Id,IsTracked,Name,Status,Subject FROM ListEmail WHERE Status = 'Sent' ORDER BY LastModifiedDate DESC limit 1];
        
        if(test.isRunningTest()){ LeadStatusUpdate.getLeadIdFromListEmailRecipient(); }
        else if(listEmail != null && !listEmail.isEmpty()){ LeadStatusUpdate.getLeadIdFromListEmailRecipient(); } 
    }
}