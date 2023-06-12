public class UnidadeServiceImpl implements IUnidadeService {

    private UnidadeDAO dao = new UnidadeDAO();
    
    public List<Unidade__c> getAll(){        
        List<Unidade__c> unidades = dao.getAll();
        return unidades;
    }
    
    
    public Unidade__c getUnidadeById(Id id){
        Unidade__c unidade = dao.getUnidadeById(id);
        return unidade;
    }
}