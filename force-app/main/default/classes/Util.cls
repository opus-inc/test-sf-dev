/**
*   @author Felipe Kuninory Akitaya
*   @class Classe de métodos utilitários
*/
public class Util {
    
    public static List<String> getListaTelefonesParaBusca(String strTelefone) { 
        
        List<String> telefones = new List<String>();
        
        //Busca apenas os números do telefone
        String regex = '[^0-9]';
        String numerosTelefone = strTelefone.replaceAll(regex, '');
        
        if(numerosTelefone.length()<8){
            return telefones;
        }else{
            
            //Últimos 8 dígitos
            numerosTelefone = numerosTelefone.right(8);
            //Últimos 8 dígitos com hífen
            String numerosTelefoneHifen = numerosTelefone.left(4) + '-' + numerosTelefone.right(4);
            //Últimos 8 dígitos com espaço
            String numerosTelefoneEspaco = numerosTelefone.left(4) + ' ' + numerosTelefone.right(4);
            
            telefones.add('%' + numerosTelefone + '%');
            telefones.add('%' + numerosTelefoneHifen + '%');
            telefones.add('%' + numerosTelefoneEspaco + '%');
            
            return telefones;
        }
    }
    
}