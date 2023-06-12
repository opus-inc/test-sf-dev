public with sharing class NumberToWord {  
  static String[] hundreds = new string[]{ '', 'cento', 'duzentos', 'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos', 'novecentos' };  

  static String[] to_19 = new string[]{ 'zero', 'um',  'dois', 'três', 'quatro',  'cinco',  'seis',  
    'sete', 'oito', 'nove', 'dez',  'onze', 'doze', 'treze',  
    'quatorze', 'quinze', 'dezesseis', 'dezessete', 'dezoito', 'dezenove' };  
  static String[] tens = new string[]{ 'vinte', 'trinta', 'quarenta', 'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa'};  
  static String[] denom = new string[]{ '',  
    'mil',   'milhão',     'bilhão',    'trilhão',    'quadrilhão',  
    'quintilhão', 'sextilhão',   'septilhão',  'octilhão',   'nonilhão',  
    'decilhão',  'undecilhão',   'duodecilhão', 'tredecilhão',  'quatuordecilhão', 'quindecilhão',  
     'sexdecilhão', 'septendecilhão', 'octodecilhão', 'novemdecilhão', 'vigintilhão' };  
   // convert a value < 100 to Portuguese.    
  public static String convert_nn(integer val) {  
     if (val < 20)  
       return to_19[val];  
     if(val == 100)  
         return 'Cem';  
     for (integer v = 0; v < tens.size(); v++) {  
       String dcap = tens[v];  
       integer dval = 20 + 10 * v;  
       if (dval + 10 > val) {  
         if (Math.Mod(val,10) != 0)  
           return dcap + ' ' + to_19[Math.Mod(val,10)];  
         return dcap;  
       }      
     }  
     return 'Nunca deve chegar aqui, menos de 100 falha';  
   }  
   // convert a value < 1000 to portuguese, special cased because it is the level that kicks   
   // off the < 100 special case. The rest are more general. This also allows you to  
   // get strings in the form of "forty-five hundred" if called directly.  
   public static String convert_nnn(integer val) {  
     String word = '';  
     integer rem = val / 100;  
     integer mod = Math.mod(val,100);  
     if (rem > 0) {  
       word = hundreds[rem];  
       if (mod > 0) {  
         word += ' e ';  
       }  
     }  
     if (mod > 0) {  
       word += convert_nn(mod);  
     }  
     return word;  
   }

   public static String portuguese_number(long val) {  
     if (val < 100) {  
       return convert_nn(val.intValue());  
     }  
     if (val < 1000) {  
       return convert_nnn(val.intValue());  
     }  
     for (integer v = 0; v < denom.size(); v++) {  
       integer didx = v - 1;  
       integer dval = (integer)Math.pow(1000, v);  
       if (dval > val) {  
         integer mod = (integer)Math.pow(1000, didx);  
         integer l = (integer) val / mod;  
         integer r = (integer) val - (l * mod);  
         String ret = convert_nnn(l) + ' ' + denom[didx];  
         if (r > 999) {  
           ret += ', ' + portuguese_number(r);  
         }  else {
          if (Math.mod(r,100) == 0) {
            ret += ' e ' + portuguese_number(r);  
          } else {
            ret += ' ' + portuguese_number(r);  
          }

         }
         return ret;  
       }  
     }  
     return 'Should never get here, bottomed out in portuguese_number';  
   }
   
  @InvocableMethod(label='Número por extenso' description='Retorna o número por extenso')  
  public static List<String> portuguese_number(List<RequestPayload> requests) {
    List<String> responsePayload = new List<String>();
    for (RequestPayload request : requests) {
      responsePayload.add(NumberToWord.portuguese_number(request.valor.longValue()));
    }

    return responsePayload;
  } 

  public class RequestPayload {
    @InvocableVariable(label='Valor' required=true)
    public Decimal valor;
  }
 }