public class UtilFunctions
{
    public static final Map<Integer, String> MONTHS_TXT = new Map<Integer, String>
                                                    {1 => 'Enero', 
                                                     2 => 'Febrero',
                                                     3 => 'Marzo',
                                                     4 => 'Abril',
                                                     5 => 'Mayo',
                                                     6 => 'Junio',
                                                     7 => 'Julio',
                                                     8 => 'Agosto',
                                                     9 => 'Septiembre',
                                                     10 => 'Octubre',
                                                     11 => 'Noviembre',
                                                     12 => 'Diciembre'};
                                             
    /**
     * Return the month as a text string. 
     * Ej, month 1 = 'Enero'
     *
     */
    public static String getMonth(Integer mes)
    {
        if(mes < 13 && mes > 0)
        {
           return MONTHS_TXT.get(mes);
        }
        return '';
    }
    
    
    /**
     * This calculate business days in a month interval.
     * endDayPeriod = -1 . The end day period is the las day of the month
     * endDayPeriod != -1 . The end day period is the value setted
     */
    public static Integer getBusinessDays(Integer year, Integer month, Integer endDayPeriod)
    {
       Integer daysOfMonth;
       Integer daysIncrement;
       Datetime dateIncremental;
       Integer businessDays = 0;
       String dayOfWeek;

       if(endDayPeriod == -1)
       {
          daysIncrement = Date.daysInMonth(year, month);
       }
       else
       {
          daysIncrement = endDayPeriod;
       }
       
       dateIncremental = Datetime.newInstance(year, month, 1);
       businessDays = 0;
 
       for(Integer i = 1; i < daysIncrement + 1; i++)
       {
           dayOfWeek = dateIncremental.format('EEEE');
           dateIncremental = dateIncremental.addDays(1);
           if(!dayOfWeek.equals('Sunday'))
           {
             businessDays++;
           }
       }
       return businessDays;
    }
    
    /**
     * Por regla de tres se calcula el porcentaje
     */
    public static Double calcularPorcentaje(Decimal valorCien, Integer valorReal)
    {
        Double resultado;
        if(valorCien == null || valorCien == 0)
        {
            resultado = 0;
        }
        else
        {
            resultado = (valorreal * 100) / valorCien;
        }
        return resultado;
    }


    public static Decimal caclularPorcentaje(Integer dividendo, Integer divisor)
    {
       Decimal x = dividendo == null ? 0 : dividendo;
       Decimal y = divisor == null ? 0 : divisor;
       
       if(y==0)
       {
           return 0;
       }
       Decimal division = (x/y) * 100;
       return division;
    }

    
 
    /**
     * Return a map of years and months, quarters and full year
     * @yearsBack from current year, years back. if years = 5 and current year is 2000, the map will contain as key (2000, 1999, 1998, 1997, 1996, 1995)
     * @param flag. Values 'all', 'current', 'none'. The null parameter is 'none'. The flag specifies if the list of months include quarters and full year as periods
     *              all - all years include quarters and full year
     *              current - current year includes quarters and full year
     *              none - quarters and full year are not included
     */
    public static List<PerfectaPeriodo> yearsBackFromCurrent(Integer yearsBack, Integer currentYear, String flag)
    {
        List<PerfectaPeriodo> periodos = new List<PerfectaPeriodo>();
        PerfectaPeriodo periodo;
        Boolean isCurrentYear = false;
        Boolean quarters = false;
        
        if(flag.equals('all'))
        {
            quarters = true;
        }
        
        
        for(Integer i = yearsBack + 1; i > 0; i--)
        {
            periodo = new PerfectaPeriodo(currentYear - yearsBack, quarters, isCurrentYear);
            yearsBack --;
            if(i == 2)
            {
               isCurrentYear = true;
               if(flag.equals('current'))
               {
                  quarters = true;
               }
            }
            periodos.add(periodo);
        }
        return periodos;
    }
    
    
    public static List<Date> getInterval(String year, String monthIni, String monthEnd)
    {
       return  getInterval(Integer.valueOf(year), Integer.valueOf(monthIni), Integer.valueOf(monthEnd));
    }


    public static List<Date> getInterval(Integer year, Integer monthIni, Integer monthEnd)
    {
       List<Date> dates = new List<Date>();
        
       Date dateIni = Date.newInstance(year, monthIni, 1);
       Date dateEnd = Date.newInstance(year, monthEnd, Date.daysInMonth(year, monthEnd));
       
       dates.add(dateIni);
       dates.add(dateEnd);
       return dates;
    }
    

    //----------------------------- prospectos

    //private map<String, String> prefToObj;
    /**
    *   Prefix to Object API Name for Account, Opportunity and Contact
    */
    public static map<String, String> getPrefixToObject(){
        map<String, String> prefToObj;
        if(prefToObj == null){
            prefToObj = new map<String, String>();
            Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
            Schema.DescribeSObjectResult a = m.get('Account').getDescribe() ;
            prefToObj.put(a.getKeyPrefix(), a.getName());
            Schema.DescribeSObjectResult o = m.get('Opportunity').getDescribe() ;
            prefToObj.put(o.getKeyPrefix(), o.getName());
            Schema.DescribeSObjectResult c = m.get('Contact').getDescribe() ;
            prefToObj.put(c.getKeyPrefix(), c.getName());
            Schema.DescribeSObjectResult l = m.get('Lead').getDescribe() ;
            prefToObj.put(l.getKeyPrefix(), l.getName());
        }
        return prefToObj;
    }



    /**
    *   Prefix to Object API Name for Account, Opportunity and Contact
    */
    public static boolean isAccount(String sId){
        if(sId == null)
        {
            return false;
        }
        if(getPrefixToObject().get(sId.substring(0,3)) != null){
            return getPrefixToObject().get(sId.substring(0,3)) == 'Account';
        }
        return false;
    }

    /**
    *   Prefix to Object API Name for Account, Opportunity and Contact
    */
    public static boolean isContact(String sId){
        if(sId == null)
        {
            return false;
        }
        if(getPrefixToObject().get(sId.substring(0,3)) != null){
            return getPrefixToObject().get(sId.substring(0,3)) == 'Contact';
        }
        return false;
    }

    /**
    *   Prefix to Object API Name for Account, Opportunity and Contact
    */
    public static boolean isOpp(String sId){
        if(sId == null)
        {
           return false;
        }
        if(getPrefixToObject().get(sId.substring(0,3)) != null){
            return getPrefixToObject().get(sId.substring(0,3)) == 'Opportunity';
        }
        return false;
    }

    /**
    *   Prefix to Object API Name for Account, Opportunity and Contact
    */
    public static boolean isLead(String sId){
        if(sId == null)
        {
           return false;
        }
        if(getPrefixToObject().get(sId.substring(0,3)) != null){
            return getPrefixToObject().get(sId.substring(0,3)) == 'Lead';
        }
        return false;
    }

}