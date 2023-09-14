trigger DmlTriggerNotBulk on Account(after update) {
If(Trigger.isafter && Trigger.isUpdate){
// Get the related opportunities for the accounts in this trigger.
//List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
//WHERE AccountId IN :Trigger.old];
List<Opportunity> opplist=new List<Opportunity>();
// Iterate over the related opportunities
for(Opportunity opp : [SELECT Id,Name,Probability FROM Opportunity
WHERE AccountId IN :Trigger.old]) {
// Update the description when probability is greater
// than 50% but less than 100%
if ((opp.Probability >= 50) && (opp.Probability < 100)) {
opp.Description = 'New description for opportunity.';
opplist.add(opp);

}
}
update opplist;
}
}