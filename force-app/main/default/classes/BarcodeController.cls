/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Controller para a página ItauBoletoPDF
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Felipe Kuninory Akitaya   <felipe@ohanaconsultoria.com.br>
* @version      1.0
* @created      2023-04-28
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class BarcodeController {
    
    public String[] barCodeString {get; set;}
    public String parcelaMegaId {get; set;}
    public String pagamentoAvulsoId {get; set;}
    public String linhaDigitavelMega {get; set;}
    public String valor {get; set;}
    public String dataVencimento {get; set;}
    public String empresaOpusNome {get; set;}
    public String empresaOpusCNPJ {get; set;}
    public String empresaOpusEndereco {get; set;}
    public String clienteNome {get; set;}
    public String clienteCNPJ {get; set;}
    public String clienteEndereco {get; set;}
    public String instrucoes {get; set;}

    public String dataDocumento {get;set;}
    public String dataProcessamento {get;set;}
    public String beneficiario {get;set;}
    public String carteiraNumero {get;set;}
    public String nossoNumero {get;set;}
    public String numeroDocumento {get;set;}

    public Parcela_Mega__c parcela {get; set;}
    public Pagamento_Avulso_Boleto__c pagamentoAvulso {get; set;}

    public BarcodeController() {
        
        parcelaMegaId = ApexPages.currentPage().getParameters().get('parcelaMegaId');
        pagamentoAvulsoId = ApexPages.currentPage().getParameters().get('pagamentoAvulsoId');

        if (pagamentoAvulsoId == null && parcelaMegaId != null) {

            parcela = [SELECT Id, Name, Contrato__c, Linha_Digitavel_Mega__c, Codigo_de_Barras_Mega__c, 
            Valor__c, Data_Vencimento__c, Empresa_Opus__c, Empresa_Opus_CNPJ__c, Empresa_Opus_Endereco__c, 
            Cliente__c, Cliente_CPF_CNPJ__c, Cliente_Endereco__c, Instrucoes__c, Beneficiario__c, 
            Carteira_Numero__c, Data_Remessa__c, Nosso_Numero__c, Numero_Documento__c 
            FROM Parcela_Mega__c WHERE Id = :parcelaMegaId LIMIT 1];
        
            linhaDigitavelMega = parcela.Linha_Digitavel_Mega__c != null ? parcela.Linha_Digitavel_Mega__c : '';
            valor = parcela.Valor__c != null ? getValorTotalFormatado(parcela.Valor__c) : '0,00';
            dataVencimento = parcela.Data_Vencimento__c != null ? parcela.Data_Vencimento__c.format() : '';
            empresaOpusNome = parcela.Empresa_Opus__c != null ? parcela.Empresa_Opus__c : '';
            empresaOpusCNPJ = parcela.Empresa_Opus_CNPJ__c != null ? parcela.Empresa_Opus_CNPJ__c : '';
            empresaOpusEndereco = parcela.Empresa_Opus_Endereco__c != null ? parcela.Empresa_Opus_Endereco__c : '';
            clienteNome = parcela.Cliente__c != null ? parcela.Cliente__c : '';
            clienteCNPJ = parcela.Cliente_CPF_CNPJ__c != null ? parcela.Cliente_CPF_CNPJ__c : '';
            clienteEndereco = parcela.Cliente_Endereco__c != null ? parcela.Cliente_Endereco__c : '';
            instrucoes = parcela.Instrucoes__c != null ? parcela.Instrucoes__c : '';

            dataDocumento = parcela.Data_Remessa__c != null ? parcela.Data_Remessa__c.format() : '';
            dataProcessamento = date.today().format();
            beneficiario = parcela.Beneficiario__c != null ? parcela.Beneficiario__c : '';
            carteiraNumero = parcela.Carteira_Numero__c != null ? parcela.Carteira_Numero__c : '';
            nossoNumero = parcela.Nosso_Numero__c != null ? parcela.Nosso_Numero__c : '';
            numeroDocumento = parcela.Numero_Documento__c != null ? parcela.Numero_Documento__c : '';


            //if (String.isNotBlank(instrucoes)) {
            //    instrucoes = instrucoes.replaceAll('<br>', '\n');
            //}

            barCodeString = new List<String>();
            if(parcela.Codigo_de_Barras_Mega__c != null){
                barCodeString = GerarCodigoDeBarraInterleaved2of5(parcela.Codigo_de_Barras_Mega__c);
            }
        } else {
            pagamentoAvulso = [
                SELECT  
                    Id,
                    Name,
                    Valor__c,
                    Linha_Digitavel__c,
                    Codigo_de_Barras__c,
                    Data_de_vencimento__c,
                    Empresa_Opus_Razao_Social__c,
                    Empresa_Opus_CNPJ__c,
                    Empresa_Opus_Endereco__c,
                    Cliente__c, 
                    Cliente_CPF_CNPJ__c, 
                    Cliente_Endere_o__c,
                    Instrucoes__c
                FROM Pagamento_Avulso_Boleto__c
                WHERE Id = :pagamentoAvulsoId 
                LIMIT 1
            ];
        
            linhaDigitavelMega = pagamentoAvulso.Linha_Digitavel__c != null ? pagamentoAvulso.Linha_Digitavel__c : '';
            valor = pagamentoAvulso.Valor__c != null ? getValorTotalFormatado(pagamentoAvulso.Valor__c) : '0,00';
            dataVencimento = pagamentoAvulso.Data_de_vencimento__c != null ? pagamentoAvulso.Data_de_vencimento__c.format() : '';
            empresaOpusNome = pagamentoAvulso.Empresa_Opus_Razao_Social__c != null ? pagamentoAvulso.Empresa_Opus_Razao_Social__c : '';
            empresaOpusCNPJ = pagamentoAvulso.Empresa_Opus_CNPJ__c != null ? pagamentoAvulso.Empresa_Opus_CNPJ__c : '';
            empresaOpusEndereco = pagamentoAvulso.Empresa_Opus_Endereco__c != null ? pagamentoAvulso.Empresa_Opus_Endereco__c : '';
            clienteNome = pagamentoAvulso.Cliente__c != null ? pagamentoAvulso.Cliente__c : '';
            clienteCNPJ = pagamentoAvulso.Cliente_CPF_CNPJ__c != null ? pagamentoAvulso.Cliente_CPF_CNPJ__c : '';
            clienteEndereco = pagamentoAvulso.Cliente_Endere_o__c != null ? pagamentoAvulso.Cliente_Endere_o__c : '';
            instrucoes = pagamentoAvulso.Instrucoes__c != null ? pagamentoAvulso.Instrucoes__c : '';

            //if (String.isNotBlank(instrucoes)) {
            //    instrucoes = instrucoes.replaceAll('<br>', '<br />');
            //}

            barCodeString = new List<String>();
            if(pagamentoAvulso.Codigo_de_Barras__c != null){
                barCodeString = GerarCodigoDeBarraInterleaved2of5(pagamentoAvulso.Codigo_de_Barras__c);
            }
        }
    }

    public String getValorTotalFormatado(Decimal valorFormatar){
        String valorTotalFormatado;
        valorTotalFormatado = formatarValorMoeda(valorFormatar);

        if(valorTotalFormatado.substringAfter(',').length() == 1){
            valorTotalFormatado = valorTotalFormatado + '0';
        }

        return valorTotalFormatado;
    }
    
    public static String formatarValorMoeda(Decimal valorFormatar){
        valorFormatar.setScale(2);
        String centavos = ((valorFormatar - Math.floor(valorFormatar)) == 0) ? ',00' : '';
        List<String> args = new List<String>{'0','number','###.###.###.###.##0'};
        String valorFormatado = String.format(valorFormatar.format(), args);

        return valorFormatado + centavos;
    }

    public List<String> GerarCodigoDeBarraInterleaved2of5(String codigo) {
        //Mapeamento dos caracteres do código de barra
        String[] caracteres = new List<String>{'00110', '10001', '01001', '11000', '00101', '10100', '01100', '00011', '10010', '01010'};

        //Adicionar zero à esquerda, se necessário, para garantir um número par de caracteres
        if (math.mod(codigo.length(), 2) != 0) {
            codigo = '0' + codigo;
        }
        
        //Faz o código virar uma lista para percorrer cada caractere
        String[] charsCodigo = codigo.split('');

        //Inicializar a sequência do código de barra
        String codigoDeBarra = '1010';

        //Iterar sobre os pares de caracteres do código e adicionar os caracteres correspondentes do mapeamento
        for (Integer i = 0; i < codigo.length(); i += 2) {
            
            Integer primeiroCaractere = Integer.valueOf(charsCodigo[i]);
            Integer segundoCaractere = Integer.valueOf(charsCodigo[i + 1]);
            
            codigoDeBarra += JuntarBinarios(caracteres[primeiroCaractere].split(''), caracteres[segundoCaractere].split(''));
        }

        // Adicionar o caractere de término do código de barra
        codigoDeBarra += '1101';

        return codigoDeBarra.split('');
    }

    public String JuntarBinarios(List<String> primeiroCaractere, List<String> segundoCaractere){
        String codigoParCarcteres = '';

        //Se o valor do primeiro caractere for 0, ele deve ser uma barra fina, se for 1, deve ser uma barra larga
        codigoParCarcteres += primeiroCaractere[0] == '0' ? '1' : '11';
        //Se o valor do segundo caractere for 0, ele deve ser um espaço fino, se for 1, deve ser um espaço largo
        codigoParCarcteres += segundoCaractere[0] == '0' ? '0' : '00';

        codigoParCarcteres += primeiroCaractere[1] == '0' ? '1' : '11';
        codigoParCarcteres += segundoCaractere[1] == '0' ? '0' : '00';

        codigoParCarcteres += primeiroCaractere[2] == '0' ? '1' : '11';
        codigoParCarcteres += segundoCaractere[2] == '0' ? '0' : '00';

        codigoParCarcteres += primeiroCaractere[3] == '0' ? '1' : '11';
        codigoParCarcteres += segundoCaractere[3] == '0' ? '0' : '00';

        codigoParCarcteres += primeiroCaractere[4] == '0' ? '1' : '11';
        codigoParCarcteres += segundoCaractere[4] == '0' ? '0' : '00';

        return codigoParCarcteres;
    }
}