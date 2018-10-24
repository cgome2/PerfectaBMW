public class UIRecordTableScorecard
{
    public String labelObjetivo {get; set;}
    public String labelLogrado {get; set;}
    public String labelConquista {get; set;}
    public String labelLealtad {get; set;}
    public String labelTarea {get; set;}    
    public String valueObjetivo {get; set;}
    public String valueLogrado {get; set;}
    public String valueConquista {get; set;}
    public String valueLealtad {get; set;}
    public String valueTarea {get; set;}    
    public Decimal valuePorcentajeObjetivo {get; set;}
    public Decimal valuePorcentajeLogrado {get; set;}
    public Decimal valuePorcentajeConquista {get; set;}
    public Decimal valuePorcentajeLealtad {get; set;}
    
    public UIRecordTableScorecard(String pLabelObjetivo, String pLabelLogrado, String pLabelConquista, String pLabelLealtad, String pLabelTarea, 
                                  String pValueObjetivo, String pValueLogrado, String pValueConquista, String pValueLealtad, String pValueTarea, 
                                  Decimal pValuePorcentajeObjetivo, Decimal pValuePorcentajeLogrado, Decimal pValuePorcentajeConquista, Decimal pValuePorcentajeLealtad)
    {
       labelObjetivo = pLabelObjetivo;
       labelLogrado = pLabelLogrado;
       labelConquista = pLabelConquista;
       labelLealtad = pLabelLealtad;
       labelTarea = pLabelTarea;       
       valueObjetivo = pValueObjetivo;
       valueLogrado = pValueLogrado;
       valueConquista = pValueConquista;
       valueLealtad = pValueLealtad;
       valueTarea = pValueTarea;       
       valuePorcentajeObjetivo = pValuePorcentajeObjetivo;
       valuePorcentajeLogrado = pValuePorcentajeLogrado;
       valuePorcentajeConquista = pValuePorcentajeConquista;
       valuePorcentajeLealtad = pValuePorcentajeLealtad;
    }    
    
}