global class Batchupdatesample implements Database.Batchable<sObject>{
    Global string sample;
   global Batchupdatesample(String sample) {
    this.sample = sample;
 }
    global Database.querylocator start(Database.BatchableContext BC){
     String query='select id,Sample__c from user where isActive=true';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<User> scope){
        for(User u : scope){
            u.Sample__c=sample;
        }
        database.Update(scope,false);
    }
    global void finish(Database.BatchableContext BC){
    }
}