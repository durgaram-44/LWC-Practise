trigger onlyoneaccountopportunitycreate on Opportunity (before insert,before update) {

    Set<id> accId = new Set<id>(); // Always try to use set
    for(opportunity opp : trigger.new)
    {
        if(opp.AccountId != null)
        {
            accId.add(opp.AccountId);    
        }
        }
    

    Map<Id,Account> mapAccount = new Map<Id,Account> ( [select id,(select id from opportunities) from account where id IN : accId ]) ;
    for(opportunity opp:trigger.new)
    {    
        
        if( opp.AccountId != null && mapAccount.containsKey(opp.AccountId) )
        {
            Account acc = mapAccount.get(opp.AccountId);
            if(acc.opportunities.size() > 0 && opp.StageName=='Prospecting' )
            {
                opp.addError('you can not add more then once opportunity for this account'); 
            }
            
        }
    }

}