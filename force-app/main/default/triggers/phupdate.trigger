trigger phupdate on Contact (after insert,after update) {
    List<account> li=new list<Account>();
    List<Id> ids = new List<Id>();
    for(Contact c: trigger.new)
        ids.add(c.AccountId);
    Map<Id, Account> accountMap = new Map<Id, Account>([Select Id, Phone From Account Where Id In :ids]);
    for(Contact c: trigger.new)
    {
        Account a = accountMap.get(c.AccountId);
        if(a != null)
        {
            a.Phone= c.MobilePhone;
            li.add(a);
        }
    }
    update li;
}