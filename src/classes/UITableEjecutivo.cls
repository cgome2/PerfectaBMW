public class UITableEjecutivo
{
    public String title {get; set;}
    public Integer index {get; set;}    
    public List<UIRecordTableEjecutivo> records {get; set; }
    
    public UITableEjecutivo(String pTitle, Integer pIndex)
    {
       title = pTitle;
       index = pIndex;
       records = new List<UIRecordTableEjecutivo>();
    }
    
    public void addRecord(String pLabelObjetivo, String pLabelLogrado, String pLabelConquista, String pLabelLealtad, String pLabelTarea,
                          String pValueObjetivo, String pValueLogrado, String pValueConquista, String pValueLealtad, String pValueTarea, 
                          Decimal pValuePorcentajeObjetivo, Decimal valuePorcentajeLogrado, Decimal valuePorcentajeConquista, Decimal valuePorcentajeLealtad,
                          String purlLogrado)
    {
        records.add(new UIRecordTableEjecutivo(pLabelObjetivo, pLabelLogrado, pLabelConquista, pLabelLealtad, pLabelTarea, 
                                               pValueObjetivo, pValueLogrado, pValueConquista, pValueLealtad, pValueTarea, 
                                               pValuePorcentajeObjetivo, valuePorcentajeLogrado, valuePorcentajeConquista, valuePorcentajeLealtad,
                                               purlLogrado));
    }
    
}