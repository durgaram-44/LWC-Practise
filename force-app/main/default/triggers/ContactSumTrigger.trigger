trigger ContactSumTrigger on Contact (after delete, after insert, after undelete, after update) {
    
    Contact[] cons;
    if (Trigger.isDelete)
    { 
        cons = Trigger.old;
    }
    else{
        cons = Trigger.new;
    }
    Set<ID> acctIds = new Set<ID>();
    for (Contact con : cons) {
        acctIds.add(con.AccountId);
    }
    
    Map<ID, Contact> contactsForAccounts = new Map<ID, Contact>([SELECT Id ,AccountId, Amount__c FROM Contact WHERE AccountId IN :acctIds]);
    
    Map<ID, Account> acctsToUpdate = new Map<ID, Account>([SELECT Id, Amount__c FROM Account WHERE Id IN :acctIds]);
    
    for (Account acct : acctsToUpdate.values()) {
        Set<Id> conIds = new Set<Id>();
        Decimal totalValue = 0;
        for (Contact con : contactsForAccounts.values()) {
            if (con.AccountId == acct.Id && con.Amount__c != NULL) {
                totalValue += con.Amount__c; 
            }
        }
        acct.Amount__c = totalValue;
    }
    if(acctsToUpdate.values().size() > 0) {
        update acctsToUpdate.values();
    }
}