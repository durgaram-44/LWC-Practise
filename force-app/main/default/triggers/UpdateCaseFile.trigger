trigger UpdateCaseFile on ContentVersion (after insert) {

    Set<Id> docIds = new Set<Id>();
    
    for(ContentVersion cv : trigger.new){  
       
      if(cv.ContentDocumentId != null)
            {
                //docIds.add(cv.ContentDocumentId);
                S3Controller.UploadDocToS3Server(cv.ContentDocumentId);
        }  
    } 
}