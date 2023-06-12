public class PDFHelperDefaultImpl implements IPDFHelper {
    //DELETE
    public PageReference getPageReference() {
        return new PageReference('/apex/ItauBoleto');
    }
}