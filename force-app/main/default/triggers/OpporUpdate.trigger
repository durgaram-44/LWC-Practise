trigger OpporUpdate on Opportunity (before Update) {
    
    Map<Id,Opportunity> oppOld = Trigger.oldMap;
    
    Map<Id,Opportunity> oppNew = Trigger.newMap;
    
    Set<Id> keys =oppOld.keySet();
    
    for(Id rid :keys){
        
        Opportunity oldOpportunity = oppOld.get(rid);
        
        Opportunity newOpportunity = oppNew.get(rid);
        
        if(oldOpportunity.stagename!='Closed Won' && newOpportunity.stagename=='Closed Won'){
            
            newOpportunity.closeDate=System.today();
            
            newOpportunity.type='New Customer';
            
        }
        
        
    }
}