trigger UpdateCaseFileURL on ContentDocumentLink (after insert) {
        List<ContentDocumentLink> conlink =new  List<ContentDocumentLink>();
    for(ContentDocumentLink cv : trigger.new){  
   
                //docIds.add(cv.ContentDocumentId);
     conlink= [SELECT  LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Case ) and LinkedEntity.Type='Case'];
                S3Controller.UploadDocToS3Server(conlink[0].LinkedEntityId);
             system.debug('Test'+conlink[0].LinkedEntityId);
    } 
}