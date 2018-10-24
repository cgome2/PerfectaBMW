public class UIFigure
{
    public String title {get; set;}
    public Integer index {get; set;}    
    public List<UIFigureRecord> records {get; set; }
    
    public UIFigure(String pTitle, Integer pIndex)
    {
       title = pTitle;
       index = pIndex;
       records = new List<UIFigureRecord>();
    }
    
    public void addRecord(String label, String value)
    {
        records.add(new UIFigureRecord(label, value));
    }
    
}