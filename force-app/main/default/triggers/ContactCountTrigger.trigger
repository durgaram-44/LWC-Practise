Trigger ContactCountTrigger on Contact(After insert,After Delete,After Undelete)
{
  Set<Id> setAccountIds = new Set<Id>();
  
  //Whenever your working with After Undelete operation you can access data through 
  //Trigger.new or Trigger.newMap but not with Trigger.old or Trigger.oldmap variables
  if(Trigger.isInsert || Trigger.isUndelete)
  {
   for(Contact con : Trigger.new)
   {
    setAccountIds.add(con.AccountId);
   }
  }
  
  if(Trigger.isDelete)
  {
   //if you use Trigger.new below in place of Trigger.old you will end up with 
   //System.NullPointerException:Attempt to de-reference a null object
   for(Contact con : Trigger.old) 
   {
    setAccountIds.add(con.AccountId);
   }
  }
  
 List<Account> listAccs = [Select id,name,number_of_contacts__c ,(Select id from contacts) from Account where Id in : setAccountIds];
  for(Account acc :listAccs)
  {
   acc.number_of_contacts__c = acc.contacts.size();
  }
  update listAccs;
  
  If(listAccs.size()>0){
   List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  
  for (Contact myContact : Trigger.new) {
    if (myContact.Email != null && myContact.LastName != null) {
    
      // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
     
      List<String> sendTo = new List<String>();
      sendTo.add(myContact.Email);
      mail.setToAddresses(sendTo);

      mail.setSubject('Your contact detail are added'); //Subject of the mail and the body of the mail
      String body = 'Dear ' + myContact.LastName + ', '; 
      body += 'According to the ContactEmailTrigger trigger';
      body += 'your contact details were added successful';
      body += 'For more details you can visit ';
     
      mail.setHtmlBody(body);    
      // Step 4. Add your email to the master list
      mails.add(mail);
    }
  }
  // Step 5: Send all emails in the master list
  Messaging.sendEmail(mails);
  }
}