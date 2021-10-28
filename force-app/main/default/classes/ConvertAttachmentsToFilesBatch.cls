public class ConvertAttachmentsToFilesBatch implements Database.Batchable<sObject>,Database.Stateful{
    public string qString;
    String errorDetailsString = 'Parent Record Id, Attachment Id, Error deatils \n';
    String successRecordString = 'Parent Record Id, Attachment Id, ContentVersionId \n';
    long jobStartTime= 0;
    long jobEndTime= 0;
    
    public ConvertAttachmentsToFilesBatch(String qStr){
        qString = qStr;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        jobStartTime = system.now().getTime();
        return Database.getQueryLocator(qstring);
    }     
    public void execute(Database.batchableContext BC, List<sObject> scope){
        List<String> parentRecordIds= new List<String>();
        for(sObject sb:scope){
            parentRecordIds.add(string.valueof(sb.get('Id')));
        }
        if(parentRecordIds.size()>0){
            List<Attachment> attList = new List<Attachment>();
            for(Attachment att:[SELECT Id, Name, ParentId, Body, OwnerId, Description FROM Attachment WHERE ParentId IN:parentRecordIds]){
                attList.add(att);
            }
            uploadFile(attList);
        }
        
    }
    public void finish(Database.batchableContext BC){ 
        jobEndTime = system.now().getTime();
        long batchJobExecutionTimeInSeconds= (jobEndTime - jobStartTime)/1000;
        long batchJobExecutionTimeInMins= batchJobExecutionTimeInSeconds/60;
        long batchJobExecutionTimeInHours= batchJobExecutionTimeInMins/60;
        
        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        string jobConclusion='Your ConvertAttachmentsToFilesBatch batch job with id-'+BC.getJobId()+' to convert attachments to files is completed';
        jobConclusion = jobConclusion + ' This job took '+ string.valueof(batchJobExecutionTimeInMins)+' minutes to complete';
        jobConclusion = jobConclusion +' It executed ' + a.totalJobItems + ' batches.  Of which, ' + a.jobitemsprocessed + ' processed without any exceptions thrown and ' + a.numberOfErrors + ' batches threw unhandled exceptions.';
        system.debug('*******ConvertAttachmentsToFilesBatch jobConclusion:'+jobConclusion);
    }
    public static string uploadFile(List<Attachment> attList){
        String message = '';
        try {
            List<ContentVersion> conVersionList = new  List<ContentVersion>();
            List<ContentDocumentLink> conDocumentLinkList = new  List<ContentDocumentLink>();
            List<ContentVersion> updatedConVersionList = new  List<ContentVersion>();
            Map<Id, Id> conVerAttParentIdMap = new Map<Id, Id>();
            Map<Id, Id> conVerAttOwnerIdMap = new Map<Id, Id>();
            Map<Id,ContentVersion> conVersionMap = new Map<Id,ContentVersion> ();            
			Map<Id, Id> conVerDocIdMap = new Map<Id, Id>(); 
            Map<Id, String> conVerNameMap = new Map<Id, String>();
            
            for(ContentVersion conVer : [SELECT Id, Title, OwnerId FROM ContentVersion]) {
                conVerNameMap.put(conVer.Id, conVer.Title);
            }

            for(Attachment att: attList){
                if(att.body!=null && att.body.size()>0 && !conVerNameMap.values().contains(att.Name)){                    
                    ContentVersion cvtobeinserted =  createContentVersion(att);
                    conVersionList.add(cvtobeinserted);
                    conVersionMap.put(att.Id,cvtobeinserted);
                }
                conVerAttParentIdMap.put(att.Id , att.ParentId);
                conVerAttOwnerIdMap.put(att.Id, att.OwnerId);
            }
            
            if(conVersionMap.size() > 0){
                insert conVersionMap.values();
            }
            
            for(ContentVersion conVer : [SELECT Title, ContentDocumentId FROM ContentVersion]) {
                conVerDocIdMap.put(conVer.Id, conVer.ContentDocumentId);
            }            
            
            for(Id attId : conVersionMap.keySet()){
                ContentDocumentLink cdl = createContentDocumentLink(conVerDocIdMap.get(conVersionMap.get(attId).Id),conVerAttParentIdMap.get(attId));
                conDocumentLinkList.add(cdl);
            }
            
            if(conDocumentLinkList.size() > 0) {
                insert conDocumentLinkList;
            }
            
            for(Id attId : conVersionMap.keySet()){
                ContentVersion conVer = updateContentVersionOwner(conVersionMap.get(attId),conVerAttOwnerIdMap.get(attId));
                updatedConVersionList.add(conVer);
            }
            
            if(updatedConVersionList.size() > 0) {
                update updatedConVersionList;
            }            
            
            message = 'SUCCESS';            
            
        } catch(Exception e) {
            system.debug('***Exception while uploading attachment as files:'+e.getmessage());
            message ='ERROR:'+e.getmessage();            
        }
        return message;
    }
    
    public static  ContentVersion createContentVersion(Attachment att){
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = att.Name;
        conVer.Title = att.Name;
        conVer.VersionData = att.Body;
        conVer.Description = att.Description;
        
        return conVer;            
        
    }
    
    public static ContentDocumentLink createContentDocumentLink(Id conDoc, Id parentId){      
        
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = parentId; 
        cDe.ShareType = 'I';          
        
        return cDe;
    } 
    
    public static ContentVersion updateContentVersionOwner(ContentVersion conVer, Id ownerId) {
        conVer.OwnerId = ownerId;
        
        return conVer;
    }
    
}