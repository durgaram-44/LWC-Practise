public with sharing class PicklistCaseCsv {
    public string uploadFileHandler{get;set;}
    public String csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    //public List<case> caselist{get;set;}
    @AuraEnabled
        public static Map<String,List<String>> csvFileRead(string base64){
             Map<String,List<String>> depValToContValue = new Map<String, List<String>>();
            List<Case> Caselist= new List<Case>();
            try{
                String csvAsString = EncodingUtil.base64Decode(base64).toString();
                 System.debug(' value1 '+ csvAsString  );
               //String csvAsString = uploadFileHandler.toString();
                String[] csvFileLines = csvAsString.split('\n');
                
                
                csvFileLines[0].split(',')[0].trim();
                csvFileLines.remove( 0 );
                
                String[] csvHeader = csvFileLines[1].split(',');
                string Category = csvHeader[0].trim();           
                string SubCategory = csvHeader[1].trim();
                
                System.debug(' Category '+ Category  );
                System.debug(' SubCategory '+ SubCategory );
                
                for(Integer i = 2; i < csvFileLines.size(); i++){
                    String[] csvRecordData = csvFileLines[i].split(',');
                    String dependentValue = csvRecordData[1].trim();
                    String controllingValue = csvRecordData[0].trim();
                    if(!depValToContValue.containsKey(dependentValue)){
                        depValToContValue.put(dependentValue, new List<String> {controllingValue});
                    }else{
                        depValToContValue.get(dependentValue).add(controllingValue);
                        //Caselist.put(depValToContValue);
                    }
                
                
    }
    } catch (Exception ex) {
                    throw new AuraHandledException(ex.getMessage());
    }
        return depValToContValue;
            //system.debug('values'+ depValToContValue);
        
    }
    }