public class GeneratePublicUrl {
 
    public static ContentDistribution generatePublicLink(Id contentDocumentId){
        /* Getting ContentVersion file using ContentDocument Id */
        ContentVersion cv = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId];
 
        /* Creating ContentDistribution record */
        ContentDistribution conDis = new ContentDistribution();
        conDis.Name = cv.Title;
        conDis.ContentVersionId = cv.Id;
        conDis.PreferencesAllowViewInBrowser= true;
        insert conDis;
        return conDis;
    }
}