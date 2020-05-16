public class GoogleDriveFolderCreationCtrl {
    public static void readFolderContents() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:GoogleAuthenticationNamedCredential');
        req.setHeader('content-type','application/json');
        req.setHeader('content-type','application/x-www-form-urlencoded');
        String messageBody = '';
        req.setHeader('Content-length','0');
        req.setTimeout(60*1000);
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug('---Response---'+ resp);
        List<String> FileLst = new List<String>();
        JSONParser parserD = JSON.createParser(resp);
        while (parserD.nextToken() != null) {
            if ((parserD.getCurrentToken() == JSONToken.FIELD_NAME) && (parserD.getText() == 'id')){
                parserD.nextToken();
                FileLst.add(parserD.getText());
            }
        }
        System.debug('---FileLst---'+FileLst);
        Map<String, FileProperties> fileWithFileProperties = FileProperties();
        List<String> fileIdList = new List<String>();
        List<Google_Folder_Content__c> contentListToInsert = new List<Google_Folder_Content__c>();
        for(Google_Folder_Content__c file : [SELECT Id, Name, File_Id__c, MIME_Type__c FROM Google_Folder_Content__c])
            fileIdList.add(file.File_Id__c);
        if(!FileLst.isEmpty()){
            for(String fileId : FileLst){
                if(!fileIdList.isEmpty()){
                    if(!fileIdList.contains(fileId)){
                        Google_Folder_Content__c fileToInsert = new Google_Folder_Content__c();
                        fileToInsert.Name = fileWithFileProperties.get(fileId).name;
                        fileToInsert.File_Id__c = fileId;
                        fileToinsert.MIME_Type__c = fileWithFileProperties.get(fileId).mimeType;
                        contentListToInsert.add(fileToInsert);
                    }
                }
                else{
                    Google_Folder_Content__c fileToInsert = new Google_Folder_Content__c();
                    fileToInsert.Name = fileWithFileProperties.get(fileId).name;
                    fileToInsert.File_Id__c = fileId;
                    fileToinsert.MIME_Type__c = fileWithFileProperties.get(fileId).mimeType;
                    System.debug('---fileToInsert---'+fileToInsert);
                    contentListToInsert.add(fileToInsert);
                }
            }
        }
        System.debug('---contentListToInsert---'+contentListToInsert);
        List<ContentVersion> contentVersionToInsert = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocLinkToInsert = new List<ContentDocumentLink>();
        List<fileContent> fileContentList = new List<fileContent>();
        if(!contentListToInsert.isEmpty()){
            for(Google_Folder_Content__c gcontent : contentListToInsert){
                HttpRequest gReq = new HttpRequest();
                gReq.setMethod('GET');
                //String url = 'https://www.googleapis.com/drive/v2/files/'+gcontent.File_Id__c+'?alt=media&source=downloadUrl';
                gReq.setEndpoint('callout:GoogleFileAuthentication/'+gcontent.File_Id__c+'?alt=media&source=downloadUrl');
                gReq.setTimeout(60*1000);
                Http h1 = new Http();
                HttpResponse gRes = h1.send(gReq);
                System.debug('---Response---'+gRes.getBody());
                System.debug('---encode---'+EncodingUtil.base64Encode(gRes.getBodyAsBlob()));
                fileContent fcontent = new fileContent();
                fcontent.fileBlob = gRes.getBodyAsBlob();
                fcontent.googleFolderContent = gcontent;
                fileContentList.add(fcontent);
            }
            insert contentListToInsert;
        }
        Map<String, String> fileIdWithRecIdMap = new Map<String, String>();
        for(Google_Folder_Content__c gcontent : contentListToInsert)
            fileIdWithRecIdMap.put(gcontent.File_Id__c, gcontent.Id);
        if(!fileContentList.isEmpty()){
            for(fileContent fcontent : fileContentList){
                if(fileIdWithRecIdMap.containsKey(fcontent.googleFolderContent.File_Id__c)){
                    ContentVersion cv = new ContentVersion();
                    cv.VersionData = fcontent.fileBlob;
                    cv.Title = fcontent.googleFolderContent.Name;
                    cv.PathOnClient = fcontent.googleFolderContent.Name;
                    cv.Description = fileIdWithRecIdMap.get(fcontent.googleFolderContent.File_Id__c);
                    contentVersionToInsert.add(cv);
                }
            }
            insert contentVersionToInsert;
            for(ContentVersion cv : contentVersionToInsert){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                cdl.LinkedEntityId = cv.Description;
                cdl.ShareType = 'V';
                contentDocLinkToInsert.add(cdl);
            }
            insert contentDocLinkToInsert;
        }
        List<String> googleFolderContentIdList = new List<String>();
        for(Google_Folder_Content__c gcontent : contentListToInsert)
            googleFolderContentIdList.add(gcontent.Id);
        //GoogleFolderContentCreation.callIRISProcessor(googleFolderContentIdList);
    }
    
    public static Map<String, FileProperties> FileProperties(){
        Map<String,String> FilePropertiesDetails=new Map<String,String>();
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setEndpoint('callout:GoogleFileAuthentication');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('Content-length', '0');
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        System.debug('---response---'+resls.getBody());
        JSONParser parserDr = JSON.createParser(resls.getBody());
        List<fileContentWrapper> fileContentWrapperList = new List<fileContentWrapper>();
        while(parserDr.nextToken() != null){
            String FileName = '';
            String FileId = '';
            String mimeType = '';
            fileContentWrapper fileWrap = new fileContentWrapper();
            if ((parserDr.getCurrentToken() == JSONToken.FIELD_NAME)){
                if((parserDr.getText() == 'id')){
                    parserDr.nextToken();               
                    Fileid = parserDr.getText();
                    System.debug('---Fileid---'+parserDr.getText());
                }
                parserDr.nextToken();
                if((parserDr.getText() == 'name')){
                    parserDr.nextToken();
                    Filename = parserDr.getText();
                    System.debug('---Filename---'+parserDr.getText());
                }
                FilePropertiesDetails.put(Fileid, Filename);
                if(!String.isEmpty(Filename))
                    fileWrap.fileName = Filename;
                if(!String.isEmpty(Fileid))
                    fileWrap.fileId = Fileid;
                if(!String.isEmpty(mimeType))
                    fileWrap.mimeType = mimeType;
            }
            if(fileWrap != null)
                fileContentWrapperList.add(fileWrap);
        }
        System.debug('---fileContentWrapperList---'+fileContentWrapperList);
        fileListParser fileParser = new fileListParser();
        fileListParser fileParserList = fileParser.parse(resls.getBody());
        System.debug('---fileParserList---'+fileParserList.files);
        Map<String, FileProperties> filePropertiesMap = new Map<String, FileProperties>();
        for(FileProperties fileProp : fileParserList.files){
            filePropertiesMap.put(fileProp.id, fileProp);
        }
        //return fileParserList.files;
        //return FilePropertiesDetails;
        return filePropertiesMap;
    }
    
    public class ParentRequestClass {
        public String id;
    }
    
    public class FolderRequestClass {
        public String title;
        public String mimeType;
        public List<ParentRequestClass> parents;
    }
    
    public class fileContentWrapper {
        public String fileName;
        public String fileId;
        public String mimeType;
    }
    
    public class fileListParser{
        public String kind;
        public String incompleteSearch;
        public List<FileProperties> files;
        public fileListParser parse(String json){
            fileListParser file = (fileListParser) System.JSON.deserialize(json, fileListParser.class);
            return (fileListParser) System.JSON.deserialize(json, fileListParser.class);
        }
    }
    
    public class fileContent{
        public Blob fileBlob;
        public Google_Folder_Content__c googleFolderContent;
    }
}