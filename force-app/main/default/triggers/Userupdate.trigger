trigger Userupdate on Account (after insert, after update)
{
    Set<Id> accid=new Set<Id>();
    Map<ID,String> mapacc=New Map<Id,String>();
    For(Account acc:Trigger.New)
    {
        If(acc.Type=='Customer - Direct' && acc.Manager__c!=Null){
            accid.add(acc.Id);
        }
    }
    For(Account acc:Trigger.old)
    {
        If(acc.Type=='Customer - Direct' && acc.Manager__c!=Null){
            accid.add(acc.Id);
        }
    }
    
    
    List<user> userlist=new List<User>();
    List<User> u1 =[Select Id,UserName, ManagerChecked__c from User];
    List<Account> acc1=[select Id,Manager__c from Account where Id In:accid];
    for(User u22:u1){
        for(Account uu:acc1){
            If(uu.Manager__c==u22.Id ){
                u22.ManagerChecked__c=True;
                userlist.add(u22);
            }
            else {
                u22.ManagerChecked__c=False;
                userlist.add(u22);
            }
        }
    }
    if(userlist.size() >0) {
        update userlist;
    }
    
}