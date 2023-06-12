/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Data factory to help other apex test classes
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Felipe Kuninory Akitaya   <felipe@ohanaconsultoria.com.br>
* @version      1.0
* @created      2023-04-28
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class ObjectBuilderForTests {

    public static Parcela_Mega__c cacheParcelaMega;

    public static Parcela_Mega__c getNewParcelaMega(Boolean getFromCache){

		if(getFromCache == true && cacheParcelaMega != null){
			return cacheParcelaMega;
		}

		Parcela_Mega__c parcelaMega = new Parcela_Mega__c();
        parcelaMega.Name = 'Parcela Teste';
        parcelaMega.Data_Vencimento__c = Date.today();
        parcelaMega.Valor__c = 100;
        parcelaMega.Status__c = 'Aberto';
        parcelaMega.Linha_Digitavel_Mega__c = '34191.12390 32512.702930 85731.400009 3 93490000681436';
        parcelaMega.Codigo_de_Barras_Mega__c = '34193934900006814361123932512702938573140000';

        insert parcelaMega;
		cacheParcelaMega = parcelaMega;

        return parcelaMega;
	}
}