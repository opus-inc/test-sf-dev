public class CondicaoPagamentoDTO {
    
    public Integer quantidadeDeParcelas{get;set;}
    public String periodicidade{get;set;}
    public Date inicioDoVencimento{get; set;}
    public String valorTotalDasParcelasFormatado{get; set;}
    private Decimal valorTotalDasParcelas{get; set;}
    public String valorTotalDaSerieFormatado{get; set;}
    public Decimal valorTotalDaSerie{get; set;}
    public String correcao{get;set;}
    
    

    public CondicaoPagamentoDTO (Condi_o_de_Pagamento__c cond){
            quantidadeDeParcelas = Integer.valueOf(cond.Quantidade_de_parcelas__c);
            periodicidade = cond.Periodicidade_Condicao__c;
            inicioDoVencimento = cond.In_cio_do_Vencimento__c;
            valorTotalDasParcelasFormatado = 'R$ ' + formatarValorMoeda(cond.Valor_Total_das_Parcelas__c);
            valorTotalDasParcelas = cond.Valor_Total_das_Parcelas__c;
            valorTotalDaSerieFormatado = 'R$ '  + formatarValorMoeda(cond.Valor_Total_das_Parcelas__c * cond.Quantidade_de_parcelas__c);
            valorTotalDaSerie = cond.Valor_Total_das_Parcelas__c;
        	correcao = cond.Correcao__c;
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

}