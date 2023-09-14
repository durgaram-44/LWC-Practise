trigger Updateattachment on Attachment (after insert) {
  List<Attachment> conlink =new  List<Attachment>();
    for(Attachment cv : trigger.new){  
   system.debug('Test01'+cv);
                //docIds.add(cv.ContentDocumentId);
     conlink= [select id, ParentId,Name, Body from Attachment where ParentId =:cv.ParentId];
                S3Controller.UploadDocToS3Server(conlink[0].ParentId);
             system.debug('Test'+conlink[0].ParentId);
    } 
    
    
}