public class UITableScorecard
{
    public String title {get; set;}
    public Integer index {get; set;}    
    public List<UIRecordTableScorecard> records {get; set; }
    
    public UITableScorecard(String pTitle, Integer pIndex)
    {
       title = pTitle;
       index = pIndex;
       records = new List<UIRecordTableScorecard>();
    }
    
    public void addRecord(String pLabelObjetivo, String pLabelLogrado, String pLabelConquista, String pLabelLealtad, String pLabelTarea,
                          String pValueObjetivo, String pValueLogrado, String pValueConquista, String pValueLealtad, String pValueTarea, 
                          Decimal pValuePorcentajeObjetivo, Decimal valuePorcentajeLogrado, Decimal valuePorcentajeConquista, Decimal valuePorcentajeLealtad)
    {
        records.add(new UIRecordTableScorecard(pLabelObjetivo, pLabelLogrado, pLabelConquista, pLabelLealtad, pLabelTarea, 
                                               pValueObjetivo, pValueLogrado, pValueConquista, pValueLealtad, pValueTarea, 
                                               pValuePorcentajeObjetivo, valuePorcentajeLogrado, valuePorcentajeConquista, valuePorcentajeLealtad));
    }
    
    
}