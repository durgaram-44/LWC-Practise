public class S3FileController {
    @AuraEnabled
    public static string getFileUrl(string record)
    {
        try
        {
            List<Case> files=[SELECT  File_URL__c FROM Case where Id=:record];
           Case file=files[0];
            return file.File_URL__c;
        }
        catch(Exception ex)
        {
            system.debug('ex:'+ex.getMessage());
            return '';
        }
    }
}