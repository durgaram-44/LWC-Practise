trigger updateAmount on Account (after update) {
    Set <Id> accountIdSet = new Set <Id>();
    Map <Id,Decimal> accountMap = new Map <Id,Decimal> ();
    for(Account acc:trigger.new) {    
        accountIdSet.add(acc.id);
     /*   if(acc.Amount__c != null) {
            accountMap.put(acc.id,acc.Amount__c);
        } */
    }
    List <contact> contactList = new List <Contact>();
    for(Contact con:[select id,accountId,Amount__c from contact where accountId in:accountIdSet]) {
        for(Account acc:trigger.new){
              if(con.AccountId==acc.id){
            con.Amount__c = acc.Amount__c;
            contactList.add(con);
        }
    }
    }
    if(contactList.size() >0) {
        update contactList;
    }
    
}