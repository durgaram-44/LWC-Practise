public class Trg_email2case2contact_Account {
    
    //Check whether record is belong to Case Object or Not
    public static Boolean IsCaseObject(ID RecordID){
        Boolean IsCaseObject=false;
        string sObjName = RecordID.getSObjectType().getDescribe().getName();        
        if(sObjName.toLowerCase()=='case')
        {
            IsCaseObject=true; 
        }
        return IsCaseObject;
    }
    //Email to case---Origin Type as Email 
    public Static Void EmailToCase(EmailMessage EmlObj){
        try{            
            
            String ToEmailAddress;
            if(EmlObj.ToAddress!=Null){
                ToEmailAddress= EmlObj.ToAddress;
            } 
            //CC Email ids 
            if(EmlObj.CcAddress!=Null){
                ToEmailAddress=ToEmailAddress+';'+EmlObj.CcAddress;
            }              
            ToEmailAddress=ToEmailAddress.deleteWhitespace();
            List<String> CaseEmailToIDsLst = ToEmailAddress.split(';'); 
            //Duplicate email eliminiation
            Set<String> UniqueCaseEmailToIDsLst = new Set<String>();        
            for(String EmailID:CaseEmailToIDsLst)
            {
                //Add Unique Email ID/IDs
                UniqueCaseEmailToIDsLst.add(EmailID);
            } 
            
            //to get generic email ID's. to ignore to map against account
            List<String> GenericEmailIDs = (Label.GenericEmailIDs).split(';');  
            //Generic Email IDs eliminiation
            UniqueCaseEmailToIDsLst.removeall(GenericEmailIDs);
            
            //Check whether To emailid is Correct or not
            for(String EmailID:UniqueCaseEmailToIDsLst){
                boolean ToEmailIDFound=false;
                EmailID=EmailID.deleteWhitespace();
                String strEmailID = '%' + EmailID + '%';
                strEmailID=strEmailID.deleteWhitespace();
                
                List<Account> AccEmailidsLst=[select id,Case_Email__c from Account where Case_Email__c 
                                              LIKE:strEmailID];
                if(AccEmailidsLst!=null && AccEmailidsLst.size()>0 ){
                    for(Account AcctObj:AccEmailidsLst){                         
                        String CaseEmailIDs='#'+AcctObj.Case_Email__c+'#';
                        CaseEmailIDs=CaseEmailIDs.replace(';', '##');
                        CaseEmailIDs=CaseEmailIDs.deleteWhitespace();
                        EmailID=EmailID.deleteWhitespace();
                        //Exact Match
                        if(CaseEmailIDs.containsIgnoreCase('#'+EmailID+'#'))
                        { ToEmailIDFound=true;
                         break;}
                    }
                    if(!ToEmailIDFound)
                    {
                        UniqueCaseEmailToIDsLst.remove(EmailID);                           
                    } 
                }
                else{
                    UniqueCaseEmailToIDsLst.remove(EmailID);
                }
            }
            
            //If account specific to email 
            if(UniqueCaseEmailToIDsLst!=null && UniqueCaseEmailToIDsLst.Size()>0){
                // Is Exact EmailID Exist (Predict Not Exist)
                Boolean IsEmailIDExist=false;
                //Get First account specific email
                string toemailid = ((new list<string>(UniqueCaseEmailToIDsLst))[0]) ;
                //To Email ID for Accurate match
                String ToemailIDForMatch='#'+toemailid+'#';
                //Email ID for wild search
                //toemailid=toemailid.deleteWhitespace();
                toemailid ='%'+toemailid+'%';   
                toemailid= toemailid.deleteWhitespace();
                //Get Account List 
                List<Account> AccLst=[Select ID,Case_Email__c from Account where Case_Email__c LIKE: toemailid ];
                //If Account Found
                if(AccLst!=null && AccLst.size()>0){
                    for(Account AcctObj:AccLst){
                        String CaseEmailIDs='#'+AcctObj.Case_Email__c+'#';
                        CaseEmailIDs=CaseEmailIDs.replace(';', '##');
                        CaseEmailIDs=CaseEmailIDs.deleteWhitespace();
                        ToemailIDForMatch= ToemailIDForMatch.deleteWhitespace();
                        //Exact Match
                        if(CaseEmailIDs.containsIgnoreCase(ToemailIDForMatch))
                        {                            
                            IsEmailIDExist=true;
                            //Search Contact 
                            ContactSearch(AcctObj.id,EmlObj);                       
                            break;
                        }
                    }
                    if(!IsEmailIDExist)
                    {
                        //search for contact without Account and create/update
                        ContactSearchWithoutAccountID(EmlObj);                           
                    }                
                }
                //If Account Not Found
                else{
                    //search for contact without Account and create/update 
                    ContactSearchWithoutAccountID(EmlObj);  
                }
            }
            //IF ToAddress did not contains any Account Specific Email IDs 
            else{
                ContactSearchWithoutAccountID(EmlObj);
                //search for contact without Account and create/update since it is  Generic Account
            }
            
        }    
        catch(exception ex){
            //ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','EmailToCase');
        }
    }
    
    
    
    // End Modified By Durga rambabu 05/12/2018  
    Public static Void ContactSearch(ID AccountID,EmailMessage EmlObj){
        Try{ 
            // Modified By Durga Rambabu 10/6/2019. 
            Contact[] Obj;
            //fetching the LastName......
            string   LastNames=GetLastName(EmlObj); 
            // fetching the FirstName.........           
            string  FirstNames=GetFirstName(EmlObj);
            If(FirstNames!=Null){            
                Obj =[select ID from Contact where AccountID=:AccountID and Email =: EmlObj.FromAddress and LastName=:LastNames and FirstName=:FirstNames limit 1];      
            }
            else{
                Obj =[select ID from Contact where AccountID=:AccountID and Email =: EmlObj.FromAddress and LastName=:LastNames limit 1];      
            }
            if(Obj!=null && obj.size()>0){
                //Update Contact                       
                UpdateCaseWithAccountContact(AccountID,Obj[0].id, EmlObj);
            }
            else{
                //create contact without AccountID and update case with NewContactID
                //Create New Contact with Account
                ID newContactID= CreateContact(AccountID,EmlObj);
                //Update case with NewContactID
                if(newContactID!=null){             
                    UpdateCaseWithAccountContact(AccountID,newContactID, EmlObj);
                }            
            }
        }catch(exception ex){
            // ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','ContactSearch');
        }
    }
    Public static Void ContactSearchWithoutAccountID(EmailMessage EmlObj){ 
        Try{  
            // Modified By Durga Rambabu 10/6/2019. 
            Contact[] Obj;
            //fetching the LastName......
            string   LastNames=GetLastName(EmlObj); 
            // fetching the FirstName.........           
            string  FirstNames=GetFirstName(EmlObj);
            If(FirstNames!=Null){              
                Obj =[select ID,AccountID from Contact where Email =: EmlObj.FromAddress and LastName=:LastNames and FirstName=:FirstNames limit 1];           
            }
            else{
                Obj =[select ID,AccountID from Contact where Email =: EmlObj.FromAddress and LastName=:LastNames limit 1];           
            }
            if(Obj!=null && obj.size()>0){
                UpdateCaseWithAccountContact(Obj[0].AccountID,Obj[0].id, EmlObj); 
            }
        }
        catch(exception ex){
            //   ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','ContactSearchWithoutAccountID');
        }
    }
    
    
    
    Public static Void UpdateCaseWithContact(ID ContactID,EmailMessage EmlObj){ 
        Try{       
            Case CaseObj=New Case();
            CaseObj=[Select Id,ContactID from case where id=:EmlObj.ParentId];
            CaseObj.ContactId=ContactID;        
            //Update UpdateCaseWithContact
            Database.SaveResult sr =  database.update(CaseObj,false);
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                string ErrorMessage='Error: '+sr.getErrors()[0].getMessage()+'.Fields that affected this error: '+sr.getErrors()[0].getFields();
                //ExceptionLog.createCustomLogs(ErrorMessage,'Trg_email2case2contact_Account','UpdateCaseWithContact');
            }
        }catch(exception ex){
            // ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','UpdateCaseWithContact');
        }
    }
    // update the case with Comapny Name & Contact Name....
    Public static Void UpdateCaseWithAccountContact(ID AccountID,ID ContactID,EmailMessage EmlObj){ 
        Try{       
            Case CaseObj=New Case();
            CaseObj=[Select Id,ContactID,AccountID from case where id=:EmlObj.ParentId];
            System.debug('case created: '+ CaseObj);
            CaseObj.ContactId=ContactID;
            CaseObj.AccountID=AccountID;     
            Database.SaveResult sr =  database.update(CaseObj,false);
            System.debug('case  saving: '+ sr);
            
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                string ErrorMessage='Error: '+sr.getErrors()[0].getMessage()+'.Fields that affected this error: '+sr.getErrors()[0].getFields();
                //ExceptionLog.createCustomLogs(ErrorMessage,'Trg_email2case2contact_Account','UpdateCaseWithAccountContact1');
            }
        }catch(exception ex){
            // ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','UpdateCaseWithAccountContact');
        }
    }
    //start *This method is created By @durga rambabu 6/2/2020 
    //when subject like 'You signed: "Electronic Proof of Claim' then fecth appcaseid based on appcaseid update Company Name..
    
    
    Public static ID CreateContact(ID AccountID,EmailMessage EmlObj){ 
        
        ID NewContactID;
        Try{ 
            Contact ConObj=New Contact();
            ConObj.FirstName=GetFirstName(EmlObj);
            ConObj.LastName=GetLastName(EmlObj); 
            ConObj.AccountID=AccountID;
            ConObj.email=EmlObj.FromAddress;
            //extract phone number from textbody
            String phone = getPhoneFromTextBody(EmlObj);
            if(phone!=null && phone.length()>0){
                ConObj.Phone = phone; 
            }
            //Case will created even on error
            Database.SaveResult sr = Database.insert(ConObj, false);
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed       
                NewContactID=sr.getId();
            }
            else { 
                // Operation failed, so get all errors   
                NewContactID=NULL;
            }         
            
        }        
        catch(exception ex){
            //  ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','CreateContact');
        }
        RETURN NewContactID;
    } 
    
    /**
* @description This method extract the phone number from textbody of emailmessage
* @param EmlObj the EmailMessage object
* @return the String which contains the phone number
*/
    Public static String getPhoneFromTextBody(EmailMessage EmlObj){ 
        String description = EmlObj.TextBody;
        String phone='';
        if(description!=null && description.indexOf('[Phone Number]')>0 ){
            phone = description.mid(description.indexOf('[Phone Number]')+15, 10);
        }
        else {
            phone ='';
        }
        
        return phone;
    }
    Public Static String GetLastName(EmailMessage EmlObj){
        String LastName;       
        //Check whether FromName is Blank or Not
        Try{
            if(EmlObj.FromName!=null){   
                //Check whether FromName contains any character
                // Only one word in From Name
                if(!(EmlObj.FromName).containsAny(', ')){
                    LastName= EmlObj.FromName;
                }
                else{
                    //Check whether FromName contains ',' character
                    if((EmlObj.FromName).containsAny(',')){                   
                        LastName=(EmlObj.FromName).substringBefore(',');
                        LastName=LastName.trim();
                    }
                    //FromName contains ' ' character
                    else{ 
                        //Remove multiple spaces
                        string FromName=(EmlObj.FromName).replaceAll('\\s+',' ');
                        LastName=(EmlObj.FromName).substringBefore(' ');               
                        //  LastName=LastName.trim();
                    }                
                }                 
                
            }
            else{
                LastName = (EmlObj.FromAddress).substringBefore('@');
            }
        }        
        catch(exception ex){
            // ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','GetLastName');
        }        
        Return LastName;        
    }
    Public Static String GetFirstName(EmailMessage EmlObj){
        String FirstName='';
        Try{
            //Check whether FromName is Blank or Not
            if(EmlObj.FromName!=null){   
                //Check whether FromName contains any character
                if(!(EmlObj.FromName).containsAny(', ')){
                    FirstName= '';
                }
                else{
                    //Check whether FromName contains ',' character
                    if((EmlObj.FromName).containsAny(',')){
                        FirstName=(EmlObj.FromName).substringAfter(',');
                        FirstName=FirstName.trim();
                    }
                    //FromName contains ' ' character
                    else{
                        //Remove multiple spaces
                        string FromName=(EmlObj.FromName).replaceAll('\\s+',' ');                   
                        FirstName=(EmlObj.FromName).substringAfter(' ');
                        FirstName=FirstName.trim();
                    }                
                }
                
            }
        }        
        catch(exception ex){
            // ExceptionLog.createCustomLogs(ex.getMessage(),'Trg_email2case2contact_Account','GetFirstName');
        }          
        Return FirstName;    
    }
    
    
}