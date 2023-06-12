/**
*	@author Felipe Kuninory Akitaya
*	Controller para a página que é invocada pelo PABX quando o atendente recebe um telefonema
*/
public class CriarChamadaController {
    
    private String interlocutor;
    private PageReference pageRef;
    private Task taskChamada;
    private Account contaEncontrada;
    
    public CriarChamadaController() {
        
        //Busca o telefone do interlocutor enviado pelo PABX
        interlocutor = ApexPages.CurrentPage().getParameters().get('interlocutor');
        
        if(!String.isBlank(interlocutor)){
            
            ConfigPABX__c configPABX = ConfigPABX__c.getOrgDefaults();
            
            //Se tiver telefone informado, busca a Conta com o telefone correspondente
            List<String> telefones = Util.getListaTelefonesParaBusca(interlocutor);
            contaEncontrada = AccountDAO.getInstance().getAccountByPhone(telefones);
            
            //Se nenhuma conta for encontrada, o idConta será o da conta genérica
            String idConta = '';
            idConta = contaEncontrada == null ? configPABX.ID_Usuario_Padrao__c : contaEncontrada.Id;
            
            //Instancia a Task para ser inserida depois.
            taskChamada = new Task();
            taskChamada.Subject = 'Chamada';
            taskChamada.OwnerId = UserInfo.getUserId();
            taskChamada.WhatId = idConta;
            taskChamada.Status = 'Não iniciado';
            taskChamada.Priority = 'Normal';
            
        }
    }
    
    public PageReference insereTaskChamadaERedirecUsuario(){
        
        if(taskChamada != null){
            insert taskChamada;
            pageRef = new PageReference('/' + taskChamada.Id);
        }
        
        return redirecionaUsuario();
    }
    
    public PageReference redirecionaUsuario(){
        if(pageRef == null){
            pageRef = new PageReference('/');
        }
        
        return pageRef.setRedirect(true);
    }
    
}