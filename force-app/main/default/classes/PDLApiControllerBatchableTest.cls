@isTest
global class PDLApiControllerBatchableTest {
    
    @testSetup
    public static void testData()
    {
        Lead testLead = new Lead();
        testLead.FirstName = 'John';
        testLead.LastName = 'Doe';
        testLead.Company = 'Anablock';
        testLead.LinkedIn__c = 'https://www.linkedin.com/in/johndoe';
        testLead.LeadSource = Label.PDLQueryLeadSource;
        insert testLead;
        
        
        PDL_Person__c testPDLPerson = new PDL_Person__c();
        testPDLPerson.PDL_Id_Unique_Ref__c = '56543524253';
        testPDLPerson.Lead_Ref__c = testLead.Id;
        Date dateToday = Date.today();
        testPDLPerson.Last_Sync_Date__C = dateToday.addDays(-31);
        
        insert testPDLPerson;
    }
    global class PDLApiControllerCalloutMock implements HttpCalloutMock {
        global HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('[{"status": 200, "likelihood": 10, "data": {"id": "dB-YE-UCma6HB3mtNgZsdw_0000", "skills": [{"name": "spring boot"}, {"name": "git"}, {"name": "linux"}, {"name": "rest"}, {"name": "maven"}, {"name": "jpa"}, {"name": "tomcat"}, {"name": "javaserver pages jsp"}, {"name": "microsoft sql server"}, {"name": "jira"}, {"name": "lightning"}, {"name": "agile methodologies"}, {"name": "html"}, {"name": "angularjs"}, {"name": "java"}, {"name": "bootstrap"}, {"name": "hibernate"}, {"name": "salesforce.com administration"}, {"name": "spring framework"}, {"name": "css"}, {"name": "junit"}, {"name": "ubuntu"}, {"name": "cascading style sheets css"}, {"name": "java enterprise edition"}, {"name": "salesforce.com development"}, {"name": "mysql"}, {"name": "apex programming"}], "industries": [{"name": "information technology and services", "is_primary": true}, {"name": "computer software", "is_primary": false}], "interests": [], "profiles": [{"network": "linkedin", "ids": [], "clean": "linkedin.com/in/naumovskin", "aliases": [], "username": "naumovskin", "is_primary": true, "url": "http://www.linkedin.com/in/naumovskin"}, {"network": "linkedin", "ids": [], "clean": "linkedin.com/in/naumovskinikola", "aliases": [], "username": "naumovskinikola", "is_primary": false, "url": "http://www.linkedin.com/in/naumovskinikola"}], "emails": [], "phone_numbers": [], "birth_date_fuzzy": null, "birth_date": null, "gender": null, "primary": {"job": {"company": {"name": "tamedia", "size": "1001-5000", "founded": "1893", "industry": "media production", "location": {"locality": "zurich", "region": "zurich", "country": "switzerland"}, "profiles": ["linkedin.com/company/43258", "linkedin.com/company/tamedia", "crunchbase.com/organization/tamedia", "facebook.com/tamediadigital", "twitter.com/tamedia"], "website": "tamedia.ch"}, "start_date": null, "end_date": null, "title": {"levels": [], "name": "salesforce developer", "functions": ["salesforce developer"]}, "locations": [], "last_updated": "2019-11-01"}, "location": {"name": "serbia", "locality": null, "region": null, "country": "serbia", "last_updated": "2019-11-01", "continent": "europe"}, "name": {"first_name": "nikola", "middle_name": null, "last_name": "naumovski", "clean": "nikola naumovski"}, "industry": "information technology and services", "work_emails": [], "personal_emails": [], "other_emails": [], "linkedin": "linkedin.com/in/naumovskin"}, "names": [{"first_name": "nikola", "last_name": "naumovski", "suffix": null, "middle_name": null, "middle_initial": null, "name": "nikola naumovski", "clean": "nikola naumovski", "is_primary": true}], "locations": [{"name": "serbia", "locality": null, "region": null, "subregion": null, "country": "serbia", "continent": "europe", "type": "country", "geo": null, "postal_code": null, "zip_plus_4": null, "street_address": null, "address_line_2": null, "most_recent": true, "is_primary": true, "last_updated": "2019-11-01"}], "experience": [{"company": {"name": "tamedia", "size": "1001-5000", "founded": "1893", "industry": "media production", "location": {"locality": "zurich", "region": "zurich", "country": "switzerland"}, "profiles": ["linkedin.com/company/43258", "linkedin.com/company/tamedia", "crunchbase.com/organization/tamedia", "facebook.com/tamediadigital", "twitter.com/tamedia"], "website": "tamedia.ch"}, "start_date": null, "end_date": null, "title": {"levels": [], "name": "salesforce developer", "functions": ["salesforce developer"]}, "locations": [], "type": "company", "is_primary": true, "most_recent": true, "last_updated": "2019-11-01"}, {"company": {"name": "dhl", "size": "10001+", "founded": "1969", "industry": "logistics and supply chain", "location": {"locality": "bonn", "region": "nordrhein-westfalen", "country": "germany"}, "profiles": ["linkedin.com/company/1355", "twitter.com/deutschepostdhl", "crunchbase.com/organization/j-robert-scott", "linkedin.com/company/dhl", "facebook.com/dhl"], "website": "dhl.com"}, "locations": [], "end_date": "2016-04", "start_date": "2015-07", "title": {"levels": [], "name": "courier", "functions": ["courier"]}, "type": "company", "is_primary": false, "most_recent": false, "last_updated": null}, {"company": {"name": "aikon group d.o.o.", "size": "1-10", "founded": "2005", "industry": "computer software", "location": {"locality": "novi sad", "region": "vojvodina", "country": "serbia"}, "profiles": ["crunchbase.com/organization/aikon-group", "linkedin.com/company/1086248", "linkedin.com/company/aikon-group-d.o.o.", "twitter.com/aikongroup"], "website": "aikongroup.com"}, "locations": [], "end_date": null, "start_date": "2017-03", "title": {"levels": [], "name": "salesforce developer", "functions": ["salesforce developer"]}, "type": "company", "is_primary": false, "most_recent": false, "last_updated": null}, {"company": {"name": "connect software solutions novi sad", "size": "11-50", "founded": "2001", "industry": "information technology and services", "location": {"locality": "novi sad", "region": "vojvodina", "country": "serbia"}, "profiles": ["linkedin.com/company/2393751", "linkedin.com/company/connect-software-solutions-novi-sad"], "website": "connectsoftware.rs"}, "locations": [], "end_date": "2017-01", "start_date": "2016-08", "title": {"levels": [], "name": "junior web developer", "functions": ["junior web developer"]}, "type": "company", "is_primary": false, "most_recent": false, "last_updated": null}], "education": [{"school": {"name": "technical school mileva maric ajnstajn in novi sad", "type": null, "location": null, "profiles": [], "website": null}, "degrees": [], "start_date": "2008", "end_date": "2012", "majors": [], "minors": [], "gpa": null, "locations": []}, {"school": {"name": "singidunum university", "type": "post-secondary institution", "location": "serbia", "profiles": ["linkedin.com/edu/singidunum-university-165105"], "website": "singidunum.ac.rs"}, "end_date": null, "start_date": "2016", "gpa": null, "degrees": [], "majors": ["software engineering"], "minors": [], "locations": []}]}, "dataset_version": "9.0", "metadata" : { "user_id" : "00100000000000000" , "name" : "John Doe"}]');
            return res;
        }
    }
    @isTest
    public static void testGetLeadInformation(){
        List<Lead> leadsList = [SELECT firstname, lastname, company, linkedin__c FROM Lead];
        System.debug(leadsList);
        PDLApiControllerBatchable batch = new PDLApiControllerBatchable();
        Test.setMock(HttpCalloutMock.class , new PDLApiControllerBatchableTest.PDLApiControllerCalloutMock());
        Datetime dt = Datetime.now();
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        Test.startTest();
        Database.QueryLocator ql = batch.start(null);
        batch.execute(null);
        Test.stopTest();
    }
}