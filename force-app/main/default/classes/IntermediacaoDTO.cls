public class IntermediacaoDTO {
    
    public String creci{get;set;}
    public String nomeIntermediador{get;set;}
    public String valorDosHonorarios{get; set;}
    public String telefone{get; set;}
    public String observacoes{get; set;}
    
    //Para teste de sistema, para unitários, descomentar.
    /*
public IntermediacaoDTO (Intermediacao__c intermediacao){
creci = '03589GO';
nomeIntermediador = 'intermediacao.Name';
valorDosHonorarios = 'R$ ' + formatarValorMoeda(2700.1); 
telefone = '629999-8888';
observacoes = 'intermediacao.Observacoes__c';
}
*/
    
    public IntermediacaoDTO (){}
    
    public IntermediacaoDTO (Intermediacao__c intermediacao){
        creci = intermediacao.CRECI__c;
        nomeIntermediador = intermediacao.Name;
        valorDosHonorarios = 'R$ ' + formatarValorMoeda(intermediacao.Valor__c); 
        telefone = intermediacao.Telefone_para_Contato__c;
        observacoes = intermediacao.Observacoes__c;
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