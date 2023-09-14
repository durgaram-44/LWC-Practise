public class AWSS3Service {
    
    public string awsKey {get;set;}
    public string awsSecret {get;set;}
    public string bucketName {get;set;}
    public string methodName {get;set;}
    public string hostName {get;set;}
    
    public AWSS3Service(string key, string secret, string bucket, string method, string host)
    {
        awsKey=key;
        awsSecret=secret;
        bucketName=bucket;
        methodName=method;
        hostName=host;
    }
    public string ContentType(string fileType)
    {
        switch on fileType.toLowerCase()
        {
            when 'docx'
            {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'csv'
            {
                return 'application/vnd.ms-excel';
            }
            when 'wav'
            {
                return 'audio/wav';
            }
            when 'wmv'
            {
                return 'video/x-ms-wmv';
            }
            when 'mp3'
            {
                return 'audio/mpeg';
            }
            when 'mp4'
            {
                return 'video/mp4';
            }
            when 'png'
            {
                return 'image/png';
                
            }
            when 'pdf'
            {
                return 'application/pdf';
                
            }
            when else {
                return 'image/jpeg';
            }
        }
    }    
    public string CreateGetAuthHeader(String contentType,
                                      String filename, String formattedDateString,string fileExtension){
                                          string auth;
                                          String stringToSign = this.methodName+'\n\n'+contentType+'\n'+formattedDateString+'\n/'+this.bucketName+'/'+filename;
                                          Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(this.awsSecret));
                                          String sig = EncodingUtil.base64Encode(mac);
                                          auth = 'AWS' + ' ' + this.awsKey + ':' + sig;
                                          return auth;
                                      }    
    
    public FileData GetDocumentUsingFileId(string recordId)
    {
        if(string.isBlank(this.awsSecret) || string.isBlank(this.awsKey) || string.isBlank(this.bucketName) || string.isBlank(this.hostName))
        {
            throw new BaseException('Set AWS credential');
        }
        
        List<Case> files=[SELECT  File_URL__c FROM Case where Id=:recordId];
         Case file=files[0];
        
        try
        {
           // string contentType=ContentType(file.ContentType);
            
            String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
            
            string fileUrl=file.File_URL__c;
            String fileName = fileUrl.substring(fileUrl.lastIndexOf('/') + 1);
            HttpRequest req = new HttpRequest();
            req.setMethod(this.methodName);
            req.setEndpoint(fileUrl);
            req.setHeader('Host', this.bucketName + '.' + this.hostName);
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-Disposition', 'attachment; filename=' + fileName);
            req.setHeader('Connection', 'keep-alive');
          //  req.setHeader('Content-type', contentType);
            req.setHeader('Date', formattedDateString);
            req.setHeader('ACL', 'public-read');
            
          //  req.setHeader('Authorization',CreateGetAuthHeader(contentType, fileName, formattedDateString,file.ContentType));
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            if (res.getStatusCode() == 200 || res.getStatusCode()==201) 
            {
                FileData data=new FileData();
                data.Content= EncodingUtil.Base64Encode(res.getBodyAsBlob());
            //    data.ContentType=contentType;
                system.debug(data);
                return data;
            }
        }
        catch(Exception ex)
        {
            throw new BaseException(ex);
        }
        return null;
    }
}