@IsTest
public class TestUtilityTest {
    
    @isTest static void CreateEmailMessageTest() {
        Test.startTest();
        Lead aLead = TestUtility.createLead('Testlead', true);
        TestUtility.sendMail(aLead.Id);
        EmailMessage testEmail = TestUtility.CreateEmailMessage(aLead.Id, true);
        Test.stopTest();
    }
    
    @isTest static void CreateTaskTest() { 
        Test.startTest();
        Lead aLead = TestUtility.createLead('Testlead', true);
        TestUtility.sendMail(aLead.Id);
        Task testtask = TestUtility.createTask(aLead.Id, '', true);
        Test.stopTest();
    }
    
    @isTest static void CreateAccountTest() {
        Test.startTest();
        Account testAccount = TestUtility.CreateAccount('Test', true);
        TestUtility.getProfileInfoByName('System Administrator');
        TestUtility.getSystemAdminProfile();
        Test.stopTest();
    }
    
    @isTest static void CreateContactTest(){
        Test.startTest();
        Account testAccount = TestUtility.CreateAccount('Test', true);
        Contact testContact = TestUtility.CreateContact('test', testAccount.Id, true); 
        Test.stopTest();
    }
    
    @isTest static void CreateCaseTest(){
        Test.startTest();
        Case testCase = TestUtility.CreateCase(true);
        Test.stopTest();
    }
    
    @isTest static void CreateOpportunityTest(){
        Test.startTest();
        Account testAccount = TestUtility.CreateAccount('Test', true);
        Opportunity testOpportunity = TestUtility.CreateOpportunity(testAccount.Id, 'test', true);
        Test.stopTest();
    }
    
    @isTest static void GetSystemAdminProfileTest(){
        Test.startTest();
        Profile testProfile = TestUtility.GetSystemAdminProfile();
        Test.stopTest();
    }
    
    @isTest static void CreateAUserTest(){
        Test.startTest();
        Profile testProfile = TestUtility.GetSystemAdminProfile();
        User testUser = TestUtility.CreateAUser('testcreate', testProfile, true);
        Test.stopTest();
    }
     
    @isTest static void createCaseWithAccountTest() {
        Test.startTest();
        Account testAccount = TestUtility.CreateAccount('Test', true);
        Case testCase = TestUtility.createCaseWithAccount(testAccount.Id, true); 
        Test.stopTest();
    }
    
    /*
      @isTest static void createPortalUserTest(){
        Test.startTest();
        Profile testProfile = TestUtility.getCommunityProfile();
        User testUse2 = TestUtility.createPortalUser('testcre7', testProfile, false);  
        Test.stopTest();
    }
	*/
    
    
}