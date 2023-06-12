/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Helper para geração de PDF de boletos
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Felipe Kuninory Akitaya   <felipe@ohanaconsultoria.com.br>
* @version      1.0
* @created      2023-04-28
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class PDFHelper {

    public static final Integer MAX_NUMBER_PARCELAS = 100;
    public static PageReference pg;

    private static PDFHelper instance = new PDFHelper();

    private PDFHelper() {
    }

    public static PDFHelper getInstance(){
        return instance;
    }

    /**
     * Método para gerar os Jobs que serão executados assincronamente para criar e salvar os PDFs nas Parcelas.
     */
    public void buildEnqueueJobs(Boolean isInsert, List<Parcela_Mega__c> listNew, Map<Id, Parcela_Mega__c> mapOldValues){

        List<Id> recordIds = new List<Id>();

        for (Parcela_Mega__c loopParcela : listNew) {
            
            if (loopParcela.Status__c == 'Aberto' && String.isNotBlank(loopParcela.Codigo_de_Barras_Mega__c)) {
    
                if (isInsert) {
                    recordIds.add(loopParcela.Id);
                } else if (mapOldValues != null && loopParcela.Codigo_de_Barras_Mega__c != mapOldValues.get(loopParcela.Id).Codigo_de_Barras_Mega__c) {
                    recordIds.add(loopParcela.Id);
                }
            }
    
            if (recordIds.size() == MAX_NUMBER_PARCELAS) {
                System.debug('recordIds.size()= ' + recordIds.size());
                System.enqueueJob(new PDFQueueable(recordIds, 'Parcela_Mega__c'));
                recordIds.clear();
            }
        }
    
        if (!recordIds.isEmpty()) {
            System.enqueueJob(new PDFQueueable(recordIds, 'Parcela_Mega__c'));
        }
    }

    public void generateAndSavePDF(List<Id> recordIds) {

        Set<Id> setContVersionIds = new Set<Id>();
        List<ContentVersion> listContVersion = new List<ContentVersion>();
        List<ContentDocumentLink> listContDocumentLink = new List<ContentDocumentLink>();
        Map<Id, ContentVersion> mapContentVersion;
        Map<String, ContentVersion> mapParcelaContVersion = new Map<String, ContentVersion>();

        Set<Id> setContentDistribution = new Set<Id>();
        Map<String, Parcela_Mega__c> mapParcelas = new Map<String, Parcela_Mega__c>();
        List<ContentDistribution> listContDist = new List<ContentDistribution>();
        //Map<String, String> mapParcCpf = new Map<String, String>();
        Map<String, String> mapContVersionParcela = new Map<String, String>();
        
        List<Parcela_Mega__c> listParcelas = [SELECT Id, Name, Contrato__c, Linha_Digitavel_Mega__c, Cliente_CPF_CNPJ__c FROM Parcela_Mega__c WHERE Id = :recordIds];

        for (Parcela_Mega__c loopParcelas : listParcelas) {

            pg = Page.ItauBoletoPDF;
            pg.getParameters().put('parcelaMegaId', loopParcelas.Id);
    
            Blob pdf1;
            try {
                pdf1 = pg.getContentAsPDF();
            }
            catch (Exception e) {
                System.debug('generateAndSavePDF>>> Erro ao gerar Blob da página.');
                pdf1 = Blob.valueOf(e.getMessage());
            }

            //Insere o arquivo na lista a ser inserida
            ContentVersion cv = new ContentVersion();
            cv.Title = loopParcelas.Contrato__c + '_' + loopParcelas.Name + '.pdf';
            cv.PathOnClient = loopParcelas.Contrato__c + '_' + loopParcelas.Name + '.pdf';
            cv.VersionData = pdf1;
            listContVersion.add(cv);
            mapParcelaContVersion.put(loopParcelas.Id, cv);

            mapParcelas.put(loopParcelas.Id, loopParcelas);
            //mapParcCpf.put(loopParcelas.Id, loopParcelas.Cliente_CPF_CNPJ__c.substring(0,4));
        }
        
        insert listContVersion;

        //Agrupa os Ids das ContentVersion inseridas
        for (ContentVersion loopContVersion : listContVersion) {
            setContVersionIds.add(loopContVersion.Id);
        }

        //Busca as ContentVersion com o campo "ContentDocumentId"
        mapContentVersion = new Map<Id, ContentVersion>([SELECT Id, ContentDocumentId, Title FROM ContentVersion WHERE Id IN :setContVersionIds]);

        for (String loopIdParcelas : mapParcelaContVersion.keySet()) {

            ContentDocumentLink cdl = new ContentDocumentLink();
            //Busca ContentDocumentId do ContentVersion cujo ID é o mesmo que o ContentVersion no mapeamento mapParcelaContVersion na chave Parcela corrente(loopIdParcelas).
            cdl.ContentDocumentId = mapContentVersion.get(mapParcelaContVersion.get(loopIdParcelas).Id).ContentDocumentId;
            cdl.LinkedEntityId = loopIdParcelas;
            cdl.ShareType = 'V';
            listContDocumentLink.add(cdl);

            mapContVersionParcela.put(mapParcelaContVersion.get(loopIdParcelas).Id, loopIdParcelas);

            ContentDistribution conDis = new ContentDistribution();
            conDis.Name = mapContentVersion.get(mapParcelaContVersion.get(loopIdParcelas).Id).Title;
            conDis.ContentVersionId = mapParcelaContVersion.get(loopIdParcelas).Id;
            conDis.PreferencesAllowViewInBrowser = true;
            conDis.PreferencesAllowPDFDownload = true;
            conDis.PreferencesPasswordRequired = false;
            //conDis.Password = mapParcCpf.get(loopIdParcelas);
            listContDist.add(conDis);
        }

        //Insere o vinculo entre Parcela e PDF
        insert listContDocumentLink;
        insert listContDist;

        for(ContentDistribution contentDis : listContDist) {
            setContentDistribution.add(contentDis.Id);
        }

        Map<Id, ContentDistribution> mapContentDistribution = new Map<Id, ContentDistribution>([SELECT Id, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE Id IN :setContentDistribution]);

        listParcelas = new List<Parcela_Mega__c>();

        for (String loopIdContentDist : mapContentDistribution.keySet()) {
            
            Parcela_Mega__c parc = mapParcelas.get(mapContVersionParcela.get(mapContentDistribution.get(loopIdContentDist).ContentVersionId));
            parc.Link_do_Boleto__c = mapContentDistribution.get(loopIdContentDist).DistributionPublicUrl;
            listParcelas.add(parc);
        }

        update listParcelas;
    }
}