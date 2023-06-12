@isTest(SeeAllData=true)
public class RHX_TEST_Fluxo_de_Pagamento {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Fluxo_de_Pagamento__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Fluxo_de_Pagamento__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}