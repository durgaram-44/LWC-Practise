public class ReportController{ 
    
    public String filterId{get; set;}
    public String[] selectedreports {get; set;} 
    public String[] selectedfolder {get; set;} 
    List<selectOption> options {get; set;} 
    List<selectOption>  optionsfolder {get; set;} 
    List<Report> query  {get; set;} 
    
    public  ReportController(){
        
    }
  
    public   List<selectOption> getReports()
    {    
        
     
        options = new List<selectOption>();
   
        for (report rpt : [select id, Name from Report  where foldername = 'Test' order by name asc ]) {
            options.add(new selectOption(rpt.id, rpt.name));
        }  
        
        return options;
    }
    Public Void change()
    {
        getReports();
    }
  
    public String[] getSelectedValues() {
        return selectedreports;
    }
    
    public void setSelectedValues(String[] selectedreports) {     
        this.selectedreports =selectedreports;
    }
    //Generate report Based on parameter
    public void generateReport()
    {
        try
        {
            System.debug('Reports' +selectedreports);
           
        //    List<User> u1=[ SELECT Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE Group.Name ='Daily Audit Report')];
            if(selectedreports.size()>0)
            {
                for(String s :selectedreports)
                {
                    
                    String reportId = s;  
                                  
                    //get instance Url
                    String instanceName = URL.getSalesforceBaseUrl().toExternalForm();                
                    string url=instanceName+'/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+reportId;
                    system.debug(url);       
                    // ApexPages.PageReference objPage = new ApexPages.PageReference(url);
                   //  EncodingUtil.base64Decode(EncodingUtil.base64Encode(objPage.getContent())).toString();
                    Http binding = new Http();
                    HttpRequest req = new HttpRequest();
                    req.setMethod('GET');
                    req.setEndpoint(url);
                    req.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                    HttpResponse res = binding.send(req);
                    system.debug('response1:'+res);
                    while (res.getStatusCode() == 302) {
                        req.setEndpoint(res.getHeader('Location'));
                        res = new Http().send(req);
                    }
                    system.debug('response:'+res);
                    Blob b = res.getbodyasblob();               
                    Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();                
                    Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
                    system.debug('sendmail:data:'+b);   
                    objMsgEmailAttach.setBody(b);
                    objMsgEmailAttach.setFileName('Test.xlsx');
                    objMsgEmailAttach.setContentType('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                    email.setSubject('Test');
                    system.debug('code working');
                    
                    List<Messaging.EmailFileAttachment> attach=new List<Messaging.EmailFileAttachment>();
                    attach.add(objMsgEmailAttach);
                    email.setFileAttachments(attach);                    
                    
                    EmailService service=new EmailService(email);
                    service.body='Hello, <br/><br/> Please find the attached report<br/><br/>Thank You.<br/>Admin';
                    service.isHtml=true;
                    service.toAddresses=new List<string>();
                  //  for(User u12:u1){
                  //      service.toAddresses.add(u12.Email);  
                  //  }
                    service.toAddresses.add('rambabu.unoscm@gmail.com');
                    service.toAddresses.add('dvattikakula@galaxe.com');
                    service.subject='test';
                    system.debug('sendmail');   
                    service.sendMail();
                    system.debug('sendmail:complete'); 
                    
                }
            }
        }
        catch(Exception ex)
        {
           // ExceptionLog.createCustomLogs(ex.getMessage(),'ReportController ','generateReport');   
        }
    }
    
}