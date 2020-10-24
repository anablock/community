public class PDLApiController {
    
    static final String API_KEY = Label.PDL_api_key;
    
    @AuraEnabled
    public static String getLeadInformationQuickAction(String leadId){
        
        List<PDLResponse> responseList = new List<PDLResponse>();
        
        String errorMessage = '';
        String query = 'SELECT ID, Name, LeadSource, LinkedIn__c, Email, FirstName, LastName, Company FROM Lead WHERE Id = :leadId';
        List<Lead> leadList = Database.query(query);
        if(leadList.size() > 0) {
            try{

                responseList = getLeadInformation(leadList);
          
            }catch(System.JSONException jex) {
                errorMessage = 'QuickAction:JSONException= '+ jex.getMessage() + ' LineNumber:' + jex.getLineNumber();
                
            }catch(System.ListException ex) {
                errorMessage = 'QuickAction:ListException= '+ ex.getMessage() + ' LineNumber:' + ex.getLineNumber();

            }catch(System.NullPointerException npe) {
                errorMessage = 'QuickAction:NullPointer= '+ npe.getMessage() + ' LineNumber:' + npe.getLineNumber();
            }
            catch(System.Exception e) {
                errorMessage = 'QuickAction:Exception= '+ e.getMessage() + ' LineNumber:' + e.getLineNumber();
             }
        
        }else{
            errorMessage = 'Invalid Lead Id.';
        }
        
        // if the person is not found in the system or something else ocurrs
        // we are handing back message to the UI
        PDLResponse response = new PDLResponse();
        if(responseList.size() > 0) response = responseList.get(0);
        if(response != null && response.status == false && errorMessage == '') errorMessage = response.errorMessage;
        
        return errorMessage;
    }
    
    public static List<PDLResponse> getLeadInformation(List<Lead> leadList) {
        System.debug('leadList');
        System.debug(leadList);
        List<Database.UpsertResult> upsertRes = new List<Database.UpsertResult>();
        List<PDLResponse> newPdlResponseList = new List<PDLResponse>();
        
        // creating a bulkified request body
        List<PDLApiRequestObject.Requests> requestList = new List<PDLApiRequestObject.Requests>();
        for(Lead forLead : leadList) {
            PDLApiRequestObject.Requests req = new PDLApiRequestObject.Requests();
            req = createRequestBodyWithLeadInformation(forLead);
            requestList.add(req);
        }
        
        PDLApiRequestObject.Top requestBody = new PDLApiRequestObject.Top();
        requestBody.requests = requestList;
        
        System.debug(JSON.serialize(requestBody));
        
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint('https://api.peopledatalabs.com/v4/person/bulk');
        request.setMethod('POST');
        request.setHeader('X-Api-Key', API_KEY);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(requestBody));
        
        HTTPResponse response = http.send(request);
        
        System.debug('response= ' + response.getStatus());
        System.debug('responseCode= ' + response.getStatusCode());
        System.debug(response.getBody());
        
        if (response.getStatusCode() == 200) {

            List<PDLApiWrapper> wrapperDataList = (List<PDLApiWrapper>) JSON.deserialize(response.getBody(), List<PDLApiWrapper>.class);
            newPdlResponseList = createLeadWithWrapperInformation(wrapperDataList);
            System.debug(newPdlResponseList);
          
        }
        return newPdlResponseList;
    }
    
    
    
    public static List<PDLResponse> upsertLeadsAndGetStatus(List<PDLResponse> newPdlResponseList, Map<String, String> pdlId2LeadId){
        
        Map<Id, PDL_Person__c> leadsForUpsertMap = new Map<Id, PDL_Person__c>();
        for(Integer i = 0; i < newPdlResponseList.size(); i++){
            if(newPdlResponseList.get(i).status == true){
                leadsForUpsertMap.put(newPdlResponseList.get(i).personId, newPdlResponseList.remove(i).pdlPerson);
            }
        }

        Schema.SObjectField PDLId = PDL_Person__c.Fields.PDL_Id_Unique_Ref__c;
        List<Database.UpsertResult> upsertRes = Database.upsert(leadsForUpsertMap.values(), PDLId, false);

        List<Lead> leads = [SELECT Id FROM Lead WHERE Id in :pdlId2LeadId.values()];  
        
        Map<String, String> leadId2PersonId = new Map<String, String>();
        for(Database.UpsertResult ups : upsertRes){
            
            if(ups.isSuccess()){
                List<PDL_Person__c> pdlPeople = [SELECT Id,Lead_Ref__c FROM
                                                 PDL_Person__c WHERE
                                                 Lead_Ref__c IN :leadsForUpsertMap.keySet()];
                Map<Id, PDL_Person__c> mapId2PDLPeople = new Map<Id,PDL_Person__c>(pdlPeople);
                PDL_Person__c pdlPerson = (PDL_Person__c) mapId2PDLPeople.get(ups.getId());
                leadId2PersonId.put(pdlPerson.Lead_Ref__c , pdlPerson.Id);
                
            }
            

            PDLResponse res = new PDLResponse();
            res.personId = ups.getId();
            res.status = ups.isSuccess();
            res.pdlPerson = leadsForUpsertMap.get(ups.getId());
            String msg = '';
            if(!ups.isSuccess()){
                for (Database.Error er : ups.getErrors()) {
                    msg += 'Error (' + er.getStatusCode() + '):' + er.getMessage() + '\n';
                }
            }
            res.errorMessage = msg;
            newPdlResponseList.add(res);
        }
        updateLeadsReference(leadId2PersonId);
        return newPdlResponseList;
    }
    
    
    public static PDLApiRequestObject.Requests createRequestBodyWithLeadInformation(Lead lead){
        PDLApiRequestObject.Requests req = new PDLApiRequestObject.Requests();
        List<PDLApiRequestObject.Params> paramsList = new List<PDLApiRequestObject.Params>();
        
        //using metadata object PDL provided to keep track of data in response
        PDLApiRequestObject.Metadata metadataObj = new PDLApiRequestObject.Metadata();
        metadataObj.user_id = lead.Id;
        metadataObj.name = lead.Name;
        
        PDLApiRequestObject.Params paramsObj = new PDLApiRequestObject.Params();
        
        List<String> profilesList = new List<String>();
        List<String> emailsList = new List<String>();
        List<String> firstNameList = new List<String>();
        List<String> lastNameList = new List<String>();
        List<String> companyList = new List<String>();
        
        // starting with linkedin highest priority
        if(lead.LinkedIn__c != null) {
            profilesList.add(lead.LinkedIn__c);
        }else if(lead.Email != null) {
            emailsList.add(lead.Email);
        }else if(lead.Lastname != null && lead.FirstName != null && lead.Company != null) {
            lastNameList.add(lead.LastName);
            firstNameList.add(lead.FirstName);
            companyList.add(lead.Company);
        }else{
            // no criteria to search for this Lead
            System.debug('Not enough information to do search for this lead!');
        }
        
        paramsObj.profile = profilesList;
        paramsObj.email = emailsList;
        paramsObj.last_name = lastNameList;
        paramsObj.first_name = firstNameList;
        paramsObj.company = companyList;
        
        req.params = paramsObj;
        req.metadata = metadataObj;
        
        return req;
        
    }
    
    
    public static List<PDLResponse> createLeadWithWrapperInformation(List<PDLApiWrapper> wrapperDataList){
       
        Map<String,String> pdlId2LeadId = new Map<String, String>();
        
        List<PDLResponse> pdlResponseList = new List<PDLResponse>();
       
        for(PDLApiWrapper wrapperData : wrapperDataList) {
            PDLResponse pdlResponse = new PDLResponse();
            
            String personId = '';
            String personName = '';
            
            if( wrapperData != null) {
                
                if(wrapperData.metadata != null) {
                    PDLApiWrapper.Metadata mtd = wrapperData.Metadata;
                    personId = mtd.user_id;
                    personName = mtd.name;
                }
                
                if(wrapperData.data != null) {
                    
                    String gender = '', companyName = '', companySize = '';
                    String firstName = '', middleName = '', lastName = '';
                    String locality = '', region = '', country = '', streetAddress = '';
                    String educationName = '', professionalExperience = '';
                    String skills = '', profiles = '';
                    String emailWork = '', emailPersonal = '', emailOther = '';
                    String phone1 = '', phone2 = '', phone3 = '';
                    String pdlId = '';
                    DateTime lastSyncDate;
                    
                    PDLApiWrapper.Data data = wrapperData.data;
                    
                    Education utilEdu = parseEducation(data);
                    educationName = utilEdu.educationName;
                    
                    Experience utilExp = parseExperience(data);
                    professionalExperience = utilExp.companyName;
                    
                    
                    skills = parseSkills(data);
                    profiles = parseProfiles(data);
                    
                    Email utilEmail = parseEmail(data);
                    emailWork = utilEmail.emailWork;
                    emailPersonal = utilEmail.emailPersonal;
                    emailOther = utilEmail.emailOther;
                    
                    Phone utilPhone = parsePhone(data);
                    phone1 = utilPhone.phone1;
                    phone2 = utilPhone.phone2;
                    phone3 = utilPhone.phone3;
                    
                    if(data.gender != null) gender = data.gender;
                    
                    Company utilCompany = parseCompany(data);
                    companyName = utilCompany.companyName;
                    companySize = utilCompany.companySize;
                    
                    Name utilName = parseName(data);
                    firstName = utilName.firstName;
                    middleName = utilName.middleName;
                    lastName = utilName.lastName;
                    
                    Location utilLocation = parseLocation(data);
                    locality = utilLocation.locality;
                    region = utilLocation.region;
                    country = utilLocation.country;
                    streetAddress = utilLocation.streetAddress;
                    
                    lastSyncDate = DateTime.now();
                    pdlId = data.id;
                    
                    // used to relate PDL Person to Lead
                    pdlId2LeadId.put(pdlId, personId);
                    
                    
                    PDL_Person__c newPdlPerson = new PDL_Person__c();
                    newPdlPerson.PDL_Id_Unique_Ref__c = pdlId;
                    newPdlPerson.Lead_Ref__c = personId;
                    newPdlPerson.Name = personName;
                    newPdlPerson.Address__c = streetAddress;
                    newPdlPerson.City__c = locality;
                    newPdlPerson.Region__c = region;
                    newPdlPerson.Country__c = country;
                    newPdlPerson.Education_name__c = educationName;
                    newPdlPerson.Professional_experience__c = professionalExperience;
                    newPdlPerson.current_company_name__c = companyName;
                    newPdlPerson.current_company_size__c = companySize;
                    newPdlPerson.Email_Work__c = emailWork;
                    newPdlPerson.Email_Personal__c = emailPersonal;
                    newPdlPerson.Email_Other__c = emailOther;
                    newPdlPerson.Firstname__c = firstName;
                    newPdlPerson.Gender__c = gender;
                    newPdlPerson.Last_sync_date__c = lastSyncDate;
                    newPdlPerson.Lastname__c = lastName;
                    newPdlPerson.Middlename__c = middleName;
                    newPdlPerson.Phone_1__c = phone1;
                    newPdlPerson.Phone_2__c = phone2;
                    newPdlPerson.Phone_3__c = phone3;
                    newPdlPerson.Profiles__c = profiles;
                    newPdlPerson.Skills__c = skills;
                    
                    pdlResponse.personId = personId;
                    pdlResponse.status = true;
                    pdlResponse.pdlPerson = newPdlPerson;
                    pdlResponse.errorMessage = '';
                    
                }else{
                                        
                    pdlResponse.personId = personId;
                    pdlResponse.status = false;
                    pdlResponse.pdlPerson = new PDL_Person__c();
                    PDLApiWrapper.Error errors = wrapperData.error;
                    if(errors != null){
                        pdlResponse.errorMessage = errors.message;
                    }
                }
                pdlResponseList.add(pdlResponse);
            }
            
            pdlResponseList = upsertLeadsAndGetStatus(pdlResponseList, pdlId2LeadId);
        }
        return pdlResponseList;
        
    }
    
    
    
    
    
    public static void updateLeadsReference(Map<String,String> leadId2pdlId){
        
        List<Lead> leads = [SELECT Id FROM Lead WHERE Id in :leadId2pdlId.keyset()]; 
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead ld : leads){
            if(leadId2pdlId.get(ld.Id) != null){
                ld.PDL_person_ref__C = leadId2pdlId.get(ld.Id);
                leadsToUpdate.add(ld);
            }
        }
        
        update leadsToUpdate;
    }
        
        
        
        
    public static String parseProfiles(PDLApiWrapper.data data){
        String profiles = '';
        List<String> profilesList = new List<String>();
        if(data.profiles != null) {
            for(PDLApiWrapper.Profiles profile : data.profiles) {
                if(profile.url == null) continue;
                String url = (String) profile.url;
                profilesList.add(url);
            }
        }
        profiles = string.join(profilesList,'\r\n');
        return profiles;
    }
    
    
    
    public static String parseSkills(PDLApiWrapper.data data){
        String skills = '';
        List<String> skillsList = new List<String>();
        if(data.skills != null) {
            skillsList = new List<String>();
            for(PDLApiWrapper.Skills skill : data.skills) {
                if(skill.name == null) continue;
                String name = (String) skill.name;
                skillsList.add(name.capitalize());
            }
        }
        skills = string.join(skillsList,';');
        return skills;
    }
    
    
    public static Education parseEducation(PDLApiWrapper.data data){
        Education utilEdu = new Education();
        
        String educationName = '';
        String[] educationNameList;
        if(data.education != null) {
            educationNameList = new List<String>();
            for(PDLApiWrapper.Education edu : data.education) {
                if(edu.school == null) continue;
                if(edu.school.name != null) educationNameList.add(edu.school.name.capitalize());
            }
            utilEdu.educationName = string.join(educationNameList,'\r\n');
        }
        return utilEdu; 
    }
    
    public static Experience parseExperience(PDLApiWrapper.data data){
        Experience utilExp = new Experience();
        
        String experienceName = '';
        String[] experienceNameList;
        if(data.experience != null) {
            experienceNameList = new List<String>();
            for(PDLApiWrapper.Experience exp : data.experience) {
                if(exp.company == null) continue;
                if(exp.company.name != null) experienceNameList.add(exp.company.name.capitalize());
            }
            utilExp.companyName = string.join(experienceNameList,'\r\n');
        }
        return utilExp; 
    }
    
    public static Email parseEmail(PDLApiWrapper.data data){
        String emailWork = '', emailPersonal = '', emailOther = '';
        Email utilEmail = new Email();
 
        if(data.primary != null) {
            PDLApiWrapper.Primary primary = data.primary;

            if(primary.work_emails != null && primary.work_emails.size() > 0)
            utilEmail.emailWork = primary.work_emails[0].capitalize();

            if(primary.personal_emails != null && primary.personal_emails.size() > 0)
            utilEmail.emailPersonal = primary.personal_emails[0].capitalize();

            if(primary.other_emails != null && primary.other_emails.size() > 0)
            utilEmail.emailOther = primary.other_emails[0].capitalize();
        }
        return utilEmail;
    }
    
    public static Phone parsePhone(PDLApiWrapper.data data){
        String phone1 = '', phone2 = '', phone3 = '';
        Phone utilPhone = new Phone();
        
        if(data.phone_numbers != null) {
            Integer counter = 0;
            for(PDLApiWrapper.phone_numbers phone : data.phone_numbers) {
                if(phone.number_Z == null) continue;
                String phoneNumber = (String) phone.number_Z;
                System.debug(phoneNumber);
                if(counter == 0) phone1 = phoneNumber;
                if(counter == 1) phone2 = phoneNumber;
                if(counter == 2) phone3 = phoneNumber;
                counter++;
            }
        }
        utilPhone.phone1 = phone1;
        utilPhone.phone2 = phone2;
        utilPhone.phone3 = phone3;
        return utilPhone;
    }
    
    
    public static Company parseCompany(PDLApiWrapper.data data){
        String companyName = '', companySize = '';
        Company utilCompany = new Company();
        
        if(data.primary.job != null && data.primary.job.company != null) {
            PDLApiWrapper.Company company = data.primary.job.company;
            if(company.name != null) companyName = company.name;
            if(company.size != null) companySize = company.size;
        }
        utilCompany.companyName = companyName.capitalize();
        utilCompany.companySize = companySize;
        return utilCompany;
    }
    
    
    public static Name parseName(PDLApiWrapper.data data){
        String firstName = '', middleName = '', lastName = '';
        Name utilName = new Name();
        if(data.names != null) {
            List<PDLApiWrapper.Names> names = data.names;
            for(PDLApiWrapper.Names name : names) {
                if(name.is_primary) {
                    if(name.first_name != null) firstName = name.first_name;
                    if(name.middle_name != null) middleName = name.middle_name;
                    if(name.last_name != null) lastName = name.last_name;
                }
            }
        }
        utilName.firstName = firstName.capitalize();
        utilName.middleName = middleName.capitalize();
        utilName.lastName = lastName.capitalize();
        return utilName;
    }
    
    public static Location parseLocation(PDLApiWrapper.data data){
        String locality = '', region = '', country = '', streetAddress = '';
        Location utilLocation = new Location();
        if(data.locations != null) {
            List<PDLApiWrapper.Locations_Z> locations = data.locations;
            for(PDLApiWrapper.Locations_Z location : locations) {
                if(location.is_primary) {
                    if(location.locality != null) locality = location.locality;
                    if(location.region != null) region = location.region;
                    if(location.country != null) country = location.country;
                    if(location.street_address != null) streetAddress = location.street_address;
                }
            }
        }
        utilLocation.locality = locality.capitalize();
        utilLocation.region = region.capitalize();
        utilLocation.country = country.capitalize();
        utilLocation.streetAddress = streetAddress.capitalize();
        
        return utilLocation;
    }
    
    
    public class PDLResponse{
        PDL_Person__c pdlPerson;
        Boolean status;
        String personId;
        String errorMessage;
    }
    
    public class Education {
        public String educationName;
    }
    
    public class Experience {
        public String companyName;
    }
    
    public class Email {
        public String emailWork;
        public String emailPersonal;
        public String emailOther;
    }
    
    public class Phone {
        public String phone1;
        public String phone2;
        public String phone3;
    }
    
    public class Company {
        public String companyName;
        public String companySize;
    }
    
    public class Name {
        public String firstName;
        public String middleName;
        public String lastName;
        
    }
    
    public class Location {
        public String locality;
        public String region;
        public String country;
        public String streetAddress;
        
    }
    
}