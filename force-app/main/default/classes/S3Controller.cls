public class S3Controller {
	@AuraEnabled
    public static void UploadDocToS3Server(string recordId)
    {
        UploadDocument(recordId);
    }
    
    @future(callout=true)
    public static void UploadDocument(string recordId)
    {
        //S3 Key 
        String key = 'AKIAURBF7EJMUNB6MI7W'; 
        //S3 Secret Key 
        String secret = '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';
        String bucket = 'sfdcfileupload1'; 
        String host = 's3.us-east-1.amazonaws.com';
        String method = 'PUT';
        AWSService service=new AWSService(key,secret,bucket,method,host);
		    service.UploadDocuments(recordId);
    }
}