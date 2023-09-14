public class S3ControllerDownload {
 @AuraEnabled
    public static FileData GetS3FileUsingFileId(string recordId)
    {
        String key = 'AKIAURBF7EJMUNB6MI7W'; 
        String secret = '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';
        String bucket = 'sfdcfileupload1'; 
        String host = 's3.us-east-1.amazonaws.com';
        String method = 'GET';
        AWSS3Service service=new AWSS3Service(key,secret,bucket,method,host);
       	FileData data=service.GetDocumentUsingFileId(recordId);
        return data;
    }
}