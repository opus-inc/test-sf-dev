public class BarcodeGenerator {
    public String barcodeBase64 { get; set; }
    
    public void generateBarcode(String input) {
        // Carregar a biblioteca Barcode4J
        ClassLoader classLoader = ClassLoader.getSystemClassLoader();
        
        // Criar o gerador de códigos de barras
        Code128Bean barcodeBean = new Code128Bean();
        
        // Configurar as propriedades do gerador de códigos de barras
        barcodeBean.setModuleWidth(1);
        barcodeBean.setBarHeight(50);
        barcodeBean.setFontSize(10);
        
        // Gerar o código de barras
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        BitmapCanvasProvider canvasProvider = new BitmapCanvasProvider(outputStream, 'image/x-png', 300, BufferedImage.TYPE_BYTE_BINARY, false, 0);
        barcodeBean.generateBarcode(canvasProvider, input);
        canvasProvider.finish();
        
        // Converter o código de barras gerado para Base64
        Blob barcodeBlob = Blob.valueOf(outputStream.toByteArray());
        barcodeBase64 = EncodingUtil.base64Encode(barcodeBlob);
    }
}
