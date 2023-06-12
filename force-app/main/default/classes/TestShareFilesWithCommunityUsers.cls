@IsTest
Public class TestShareFilesWithCommunityUsers {
    
    @isTest static void testmethod1(){
        Test.startTest();
        Account accA =new Account(Name='Demo');
        
        insert accA ; 
        
        Opportunity opp = new Opportunity(Name='test opp',StageName='stage', AccountId = accA.Id ,Probability = 95, CloseDate=system.today());
        
        insert opp;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob;
        content.origin = 'H';
        
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=opp.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';        
        
        insert contentlink;
        Test.stopTest();
        
    }
}