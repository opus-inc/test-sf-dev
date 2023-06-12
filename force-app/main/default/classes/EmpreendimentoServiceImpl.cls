public class EmpreendimentoServiceImpl implements IEmpreendimentoService {
	
   	private static EmpreendimentoDAO dao = new EmpreendimentoDAO();
    private static List<Empreendimento__c> empreendimentos;
    
   	public List<Empreendimento__c> getAll(){
        empreendimentos = null;
        empreendimentos = dao.getAll();
        return empreendimentos;
    }
    
    public List<Empreendimento__c> getEmpreendimentoByName(String name){
        empreendimentos = null;
        empreendimentos = dao.getEmpreendimentoByName(name);
        return empreendimentos;
    }
}