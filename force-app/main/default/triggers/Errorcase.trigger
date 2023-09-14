trigger Errorcase on Case(before update)
{
Set<Id> caseids=New Set<Id>();
For(Case c:Trigger.new){
caseids.add(c.Id);
}

List<Case> casval=[select Id, Status,Reason__c from Case where Id In:caseids  and Status ='Resloved'];
For(Case cc:Trigger.new){
If( cc.Reason__c==Null){
If(casval.size()>0){
cc.Reason__c.addError('Case is Resolved');
}
}
}

}