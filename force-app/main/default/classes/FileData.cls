public class FileData
{
    @AuraEnabled
    public string Content{get;set;}
    @AuraEnabled
    public blob ContentBlob{get;set;}
    @AuraEnabled
    public string ContentType{get;set;}
}