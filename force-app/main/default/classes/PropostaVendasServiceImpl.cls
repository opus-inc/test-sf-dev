public class PropostaVendasServiceImpl implements IPropostaVendasService {
    
    static private PropostaVendasDAO dao = new PropostaVendasDAO();
    
    public static Proposta_de_Vendas__c getPropostaVendas(Id propostaId){
		return dao.getPropostaVendas(propostaId);
    }
    
    public List<Proposta_de_Vendas__c> getAll(){
        return dao.getAll();
    }
    
    
    
}