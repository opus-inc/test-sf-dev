/**
* Classe responsável por oferecer dados para emissão da Proposta
* @Since 17/02/2021
* @author Douglas Eleutério | Ohana Consultoria
* @version 1.0
*/

public class CartaPropostaController {
    
    public String propostaId {get;set;}
    public List<Condi_o_de_Pagamento__c> financiamento {get; set;}
    public List<Proponentes__c> proponentesList {get; set;}
    public Proposta_de_Vendas__c propostaDeVendas {get;set;}
    public List<Condi_o_de_Pagamento__c> condicaoPagamento{get; set;}
    public Tabela_de_Vendas__c tabelaDaProposta{get; set;}
    public String valorTotalProposta{get; set;}
    public List<Intermediacao__c> intermediacoes {get; set;}
    public Double valorIntermediacoes{get; set;}
    public List<CondicaoPagamentoDTO> condDto {get; set;}
    public List<IntermediacaoDTO> intermediacoesDTO{get; set;}
    
    //Valores Formatados
    public String valorUnidade{get; set;}
    public String valorTotalParcelas{get; set;}
    public String totalProposta_servicosDeIntermediacao{get; set;}
    public String valorIntermediacoesString {get; set;}
    public String financiamentoUnitarioFormatado {get; set;}
    public String financiamentoSerieFormatado {get; set;}
    public Date financiamentoInicioVencimento {get; set;}

    private String nomeInc{
        get {return nomeInc = 'SPE INCORPORAÇÃO OPUS BUENO 1 LTDA';}
        set {nomeInc = 'SPE INCORPORAÇÃO OPUS BUENO 1 LTDA';}
    } 
    
    
    //Somente para testes de Sistema
    /*
	public List<Proponentes__c> proponentesList {
        get{
        	List<Proponentes__c> aux = new List<Proponentes__c>();
            aux.add(ProponentesUtil.buildProponente());
            aux.add(ProponentesUtil.buildProponente());
            return aux; 
        }
		set;}    
    */
    
    public CartaPropostaController(){
        propostaId = ApexPages.currentPage().getParameters().get('propostaId');
        proponentesList = getProponentes(propostaId);
        System.debug('Dentro do Controller valor do Parametro :' + propostaId);
        propostaDeVendas = PropostaVendasServiceImpl.getPropostaVendas(propostaId);
        tabelaDaProposta = TabelaDeVendasDAO.getTabelaDeVendasById(propostaDeVendas.Tabela_da_Proposta__c);
        condicaoPagamento = CondicaoPagamentoServiceImpl.getCondicaoPagamentoSemFinanciamento(tabelaDaProposta.Id);
        System.debug('OhanaCondicao: '+ condicaoPagamento);
        valorTotalParcelas = formatarValorMoeda(CartaPropostaServiceImpl.getTotalParcelamento(condicaoPagamento));
        valorUnidade = formatarValorMoeda(propostaDeVendas.Valor_Tabela__c);
        financiamento = CondicaoPagamentoServiceImpl.getCondicaoPagamentoFinanciamento(tabelaDaProposta.Id);
        System.debug('OhanaFinanciamento: '+ financiamento);
        //valorTotalProposta = formatarValorMoeda((CartaPropostaServiceImpl.getTotalParcelamento(condicaoPagamento) + financiamento.Valor_Total_das_Parcelas__c));
        valorTotalProposta = formatarValorMoeda(propostaDeVendas.Valor_da_Proposta__c);
        intermediacoes  = IntermediacaoServiceImpl.getFromPropostaDeVendasId(propostaDeVendas.Id);
        //intermediacoes = new List<Intermediacao__c>();
        //intermediacoes.add(IntermediacaoUtils.createIntermediacao(propostaDeVendas.Id));
        valorIntermediacoes = IntermediacaoServiceImpl.getTotalServiceIntermediacao(intermediacoes);
        valorIntermediacoesString = formatarValorMoeda(valorIntermediacoes);
        totalProposta_servicosDeIntermediacao = formatarValorMoeda(propostaDeVendas.Valor_da_Proposta__c +   valorIntermediacoes);
        condDto = new List<CondicaoPagamentoDTO>();
        for(Condi_o_de_Pagamento__c cond : condicaoPagamento){
        	CondicaoPagamentoDTO dto = new CondicaoPagamentoDTO(cond);
            condDto.add(dto);
        }
        intermediacoesDTO = new List<IntermediacaoDTO>();
        for(Intermediacao__c inter : intermediacoes){
            IntermediacaoDTO interDto = new IntermediacaoDTO(inter);
            intermediacoesDTO.add(interDto);
        }
        if(financiamento.size() > 0) {
            financiamentoUnitarioFormatado = formatarValorMoeda(financiamento.get(0).Valor_Total_das_Parcelas__c);
            financiamentoInicioVencimento = financiamento.get(0).In_cio_do_Vencimento__c;
        } 
      
    }

    public static String formatarValorMoeda(Decimal valorFormatar){
        if(String.valueOf(valorFormatar).contains(',')){
            valorFormatar.setScale(2);
        }
        String centavos = ((valorFormatar - Math.floor(valorFormatar)) == 0) ? ',00' : '';
        List<String> args = new List<String>{'0','number','###.###.###.###.##0'};
        String valorFormatado = String.format(valorFormatar.format(), args);

        if(String.valueOf(valorFormatado).contains(',')){
            List<String> aux = valorFormatado.split(',');
            if(aux.get(1).length() == 1){
                String temp = aux.get(1);
                aux.remove(1);
                aux.add(','+temp + '0');
                valorFormatado = aux.get(0)+aux.get(1);
            }
        }
        return valorFormatado + centavos;
    }

    public List<Proponentes__c> getProponentes(String propostaId){
        return ProponenteServiceImpl.getProponentesListByPropostaDeVendasId(propostaId);
    }
}