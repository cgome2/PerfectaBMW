public class ComponentControllerScorecard
{
    public Integer numberColumns {set; get;}
    public ScorecardSingleSetTable sorecardSetTables {set; get;}
    
    public ComponentControllerScorecard()
    {
    }
    
    public List<List<UITableScorecard>> getRowsTable()
    {
        List<UITableScorecard> individualTables = sorecardSetTables.setOfTables;
        List<UITableScorecard> row;
        Integer span = numberColumns;
        List<List<UITableScorecard>> rowsGrid = new List<List<UITableScorecard>>();
        Integer modulo = 0;
        Integer limite = 0;
        Integer division = 0;

        //System.debug('lencol[' + individualTables.size()+ ']');
        for(Integer i = 0; i < individualTables.size(); i+=span)
        {
            modulo = Math.mod((individualTables.size() - i), span);
            division = (individualTables.size() - i) / span;
            limite = division > 0 ? span : modulo;
            //System.debug('modulo[' + modulo + '] div[' + division + '] limite[' + limite + '] [' + i + ']');
            row = new List<UITableScorecard>();
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