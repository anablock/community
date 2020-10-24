/*
* This class will cover the test cases for various events and scenarios for Lead
*/
@IsTest
public class LeadStatusUpdateTest {
    
    @IsTest
    static void taskTriggerTestRun(){
        
        Test.startTest();
        
        Lead aLead = TestUtility.createLead('TaskLead', true);
        
        //EmailMessage aEmailMessage = TestUtility.createEmailMessage(aLead.Id, true);
        TestUtility.sendMail(aLead.Id);
        
        Task aTask  = TestUtility.createTask(aLead.Id,'', true);
        
        Test.stopTest();
        
        //System.assertEquals('Contacted', aLead.Status); 
    }
    
    @IsTest
    static void scheduleJobTestRun(){ 
        
        Test.startTest();
        
        System.schedule('Schedule Job to check List Email Sent', '0 01 * * * ?', new LeadStatusUpdateScheduleJob());
                
        Test.stopTest();
        
    }
}