trigger  DmlTriggerNotBulkopp on Opportunity (after insert) {

List<Opportunity> opplist1= new List<Opportunity>();
for(Opportunity op : Trigger.new) {
opplist1.add(op);
}

List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
WHERE Id IN :Trigger.new];
    system.debug('tesopp'+relatedOpps);
    If(relatedOpps.size()>0 && relatedOpps!=null){
List<Opportunity> opplist= new List<Opportunity>();
for(Opportunity opp : relatedOpps) {
if ((opp.Probability >= 50) && (opp.Probability < 100)) {
opp.Description = 'New description for opportunity.';
opplist.add(opp);

}
}
update opplist;
    }
}