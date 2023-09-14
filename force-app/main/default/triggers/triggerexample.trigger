Trigger triggerexample on Account(before insert,before update)
{
/*
Set<Id> accid =new Set<Id>();
For(Account acc:Trigger.new)
{
accid.add(acc.id);
}
//flagvalue=false;
List<Account> acclist=[select Id, Industry,Type from Account where Id In:accid]; */
List<Account> acountlist =new List<Account>(); 
for(Account ac:Trigger.new)
{
if(ac.Type=='Technology Partner')
ac.Industry='Energy';
acountlist.add(ac);
}
/*If(acountlist.size()>0){
update acountlist;
} 
*/
}