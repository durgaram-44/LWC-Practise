public class createAcc {
 
    @AuraEnabled
    public static Account createAccount(Account acc) {
        system.debug('acc'+acc);
        insert acc;
        return acc;
    }
}