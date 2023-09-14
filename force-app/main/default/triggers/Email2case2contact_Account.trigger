trigger Email2case2contact_Account on EmailMessage (before insert) {
    try{
        if(trigger.isAfter && trigger.IsInsert) {     
            EmailMessage EmlObj=new EmailMessage();        
            EmlObj=Trigger.new[0];    
            Boolean efilingflag = False;
            
            if(EmlObj.Incoming){              
                Case CaseObj=[select Status,Origin from case where ID=:EmlObj.ParentId]; 
                //Code If Origin is Email                
                if(CaseObj.Status=='New' && CaseObj.Origin=='Email')
                {
                   Trg_email2case2contact_Account.EmailToCase(EmlObj);
                        }
                    } 
        }             
    }
    catch(exception ex){
       system.debug(ex);
    }
}