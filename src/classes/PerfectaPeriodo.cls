public class PerfectaPeriodo
{
    public String year {set; get;}
    public Boolean isCurrent {set; get;}
    public Boolean isQuartersIncluded {set; get;}
    public List<SelectOption> months {set; get;}
    public Map<String, List<Date>> monthsInterval;
    
    private Date today;
    private Integer currMonth;    
    
    public PerfectaPeriodo(Integer pYear, Boolean pIsQuartersInclude, Boolean pIsCurrent)
    {
        today = Date.today();
        currMonth = today.month();
        year = String.valueOf(pYear);
        monthsInterval = new Map<String, List<Date>>();
        months = new List<SelectOption>();
        isCurrent = pIsCurrent;
        isQuartersIncluded = pIsQuartersInclude;
        addMonths();
        if(pIsQuartersInclude)
        {
            addQuartersYear();
        }
    }
    
    private void addMonths()
    {
        Integer currentMonth = 0;
        currentMonth = isCurrent ? currMonth : 12;
        
        for(Integer i = 1; i <= currentMonth; i++){
            months.add(new SelectOption(String.valueOf(i), genPOLabel(i, year)));
            monthsInterval.put(String.valueOf(i), UtilFunctions.getInterval(Integer.valueOf(year), i, i));
        }
    }
    
    private void addQuartersYear()
    {
        Integer currentMonth = 0;
        currentMonth = isCurrent ? currMonth : 12;
    
        for(Integer i = 1; i <= currentMonth/3; i++){
            months.add(new SelectOption('Q' + String.valueOf(i), 'Q' + String.valueOf(i)));
            
            monthsInterval.put('Q' + String.valueOf(i), UtilFunctions.getInterval(Integer.valueOf(year), (3 * i) - 2, 3 * i));
        }
        if(isCurrent)
        {
            if(Math.mod(currMonth, 3) > 0){
                String current = String.valueOf((currMonth/3) + 1);
                months.add(new SelectOption('Q' + current, 'Trimestre Actual (Q' + current +  ')'));
                monthsInterval.put('Q' + current, UtilFunctions.getInterval(Integer.valueOf(year), (3 * Integer.valueOf(current)) - 2, 3 * Integer.valueOf(current)));
            }
        }
        months.add(new SelectOption('AC', 'Año completo - ' + year));
        monthsInterval.put('AC', UtilFunctions.getInterval(Integer.valueOf(year), 1 , 12));
    }
    
    private String genPOLabel(Integer month, String year) {
        return UtilFunctions.getMonth(month) + ' - ' + year;
    }
    
}