trigger updateamountonAccount on Opportunity (after delete, after insert, after undelete, after update) {
    
    Opportunity[] cons;
    if (Trigger.isDelete)
    { 
        cons = Trigger.old;
    }
    else{
        cons = Trigger.new;
    }
    Set<ID> acctIds = new Set<ID>();
    for (Opportunity con : cons) {
        acctIds.add(con.AccountId);
    }
    
    Map<ID, Opportunity> contactsForAccounts = new Map<ID, Opportunity>([SELECT Id ,AccountId, Amount FROM Opportunity WHERE AccountId IN :acctIds]);
    
    Map<ID, Account> acctsToUpdate = new Map<ID, Account>([SELECT Id, Amount__c FROM Account WHERE Id IN :acctIds]);
    
    for (Account acct : acctsToUpdate.values()) {
        Set<Id> conIds = new Set<Id>();
        Decimal totalValue = 0;
        for (Opportunity con : contactsForAccounts.values()) {
            if (con.AccountId == acct.Id && con.Amount != NULL) {
                totalValue += con.Amount; 
            }
        }
        acct.Amount__c = totalValue;
    }
    if(acctsToUpdate.values().size() > 0) {
        update acctsToUpdate.values();
    }
}