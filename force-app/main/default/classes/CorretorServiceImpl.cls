public class CorretorServiceImpl implements ICorretorService {
	
    public CorretorDAO dao = new CorretorDAO();
    public static List<Corretores__c> listCorretores;
    public static Corretores__c corretor;
    
    public List<Corretores__c> getAll(){
        listCorretores = null;
        return listCorretores = dao.getAll();
    }
    
    public Corretores__c getCorretorByCPF(String cpf){
        corretor = null;
        return corretor = dao.getCorretorByCPF(cpf);
    }
    
    public List<Corretores__c> getCorretoresByImobiliariaName(String imobiliaria){
        listCorretores = null;
        return listCorretores = dao.getCorretoresByImobiliariaName(imobiliaria);
    }
    
    public List<Corretores__c> getCorretoresByCRECI(String creciNumber){
        listCorretores = null;
        return listCorretores = dao.getCorretoresByCRECI(creciNumber);
    }
    
}