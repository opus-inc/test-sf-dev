public class IntermediacaoServiceImpl implements IIntermediacao{

    public static List<Intermediacao__c> getFromId(Id id){
        List<Intermediacao__c> inters;
        inters = IntermediacaoDAO.getFromId(id);
        return inters;
    }
    
    public static List<Intermediacao__c> getFromPropostaDeVendasId(Id propostaDeVendasid){
        List<Intermediacao__c> inters;
        inters = IntermediacaoDAO.getFromPropostaDeVendasId(propostaDeVendasid);
        return inters;
    }

    public static List<Intermediacao__c> getAll(){
        List<Intermediacao__c> inters; 
        inters = IntermediacaoDAO.getAll();
        return inters;
    }

    public static Double getTotalServiceIntermediacao(List<Intermediacao__c> inters){
        Double amount = 0;
        for(Intermediacao__c inter : inters){
            if(inter.Valor__c != null){
                amount += inter.Valor__c;
            }
        }
        return amount;
    }

    public static Intermediacao__c buildIntermediacao(
        String cpf_cnpj, String creci, String razaoSocial, Decimal porcentagem, String telefone, 
        String name, Id propostaVendasId, String tipoComissao, String observacoes, String tipo, String email
        ){
            Intermediacao__c prop = new Intermediacao__c(
            CPF_CNPJ__c = cpf_cnpj,
            CRECI__c = creci,
            Razao_Social__c = razaoSocial,
            Porcentagem__c = porcentagem,
            Telefone_para_Contato__c  = telefone,
            Name = name,
            Proposta_de_Vendas__c = propostaVendasId,
            Tipo_de_Comissao__c = tipoComissao,
            Observacoes__c = observacoes,
            Tipo__c = tipo,
            Email__c = email
        );
        insertIntermediacao(prop);
        return prop;
    }

    public static Intermediacao__c insertIntermediacao(Intermediacao__c inter){
        if (getAll().size() > 0){
            return getAll().get(0);
        } else {
        	return IntermediacaoDAO.insertIntermediacao(inter);    
        }
    }
}