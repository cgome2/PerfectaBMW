public class ComponetControllerTableEjecutivo
{
    public Integer numberColumns {set; get;}
    public ScorecardSetTable sorecardSetTables {set; get;}
    
    public ComponetControllerTableEjecutivo()
    {
    }
    
    public List<List<UITableEjecutivo>> getRowsTable()
    {
        List<UITableEjecutivo> individualTables = sorecardSetTables.setOfTables;
        List<UITableEjecutivo> row;
        Integer span = numberColumns;
        List<List<UITableEjecutivo>> rowsGrid = new List<List<UITableEjecutivo>>();
        Integer modulo = 0;
        Integer limite = 0;
        Integer division = 0;

        for(Integer i = 0; i < individualTables.size(); i+=span)
        {
            modulo = Math.mod((individualTables.size() - i), span);
            division = (individualTables.size() - i) / span;
            limite = division > 0 ? span : modulo;
            //System.debug('modulo[' + modulo + '] div[' + division + '] limite[' + limite + '] [' + i + ']');
            row = new List<UITableEjecutivo>();
            for(Integer j  = i; j < limite + i; j++)
            {
                row.add(individualTables.get(j));
            }
            rowsGrid.add(row);
        }
        //System.debug('L[' + rowsGrid.size() + ']');
        return rowsGrid;
    }
    
}