public class PlanificacionCRM {
	public static final String MENSUAL_O = 'Mensual Origen';
	public static final String CENTRAL = 'CENTRAL';
	public static final String CDE = 'CDE';
	public static final String USUARIO_VENTAS = 'Usuario de Ventas';
	public static final String OPP_CERRADA_GANADA = 'Cerrada/Ganada';
    public static final String OPP_CALIFICADO = 'Calificado';
    
	public List<SelectOption> sucursales {get;set;}
    public String selectedSucursal {get;set;}    
    
	public Map<String, Objetivo__c> objetivos {get;set;}

	public String currentStrMonth {get; set;}

	public boolean canEdit {get;set;}

	public Integer leadsGoalSummary {get; set;}
    public Integer qualifiedLeadsGoalSummary {get; set;}
    public Integer testDrivesGoalSummary {get; set;}
    public Integer salesGoalSummary {get; set;}
	public Integer deliveryGoalSummary {get; set;}  
	public Integer voCGoalSummary {get; set;}

	public Integer leadsProgressSummary {get; set;}
    public Integer qualifiedLeadsProgressSummary {get; set;}
    public Integer testDrivesProgressSummary {get; set;}
    public Integer salesProgressSummary {get; set;}
	
	public Decimal leadsProgressPercAvg {get; set;}
    public Decimal qualifiedLeadsProgressPercAvg {get; set;}
    public Decimal testDrivesProgressPercAvg {get; set;}
    public Decimal salesProgressPercAvg {get; set;}

	private Integer currentIntMonth;
	private Integer currentIntYear;

	private RecordType objetivoFuenteRT;

	private list<Id> executiveIds;

	private Date dateIni, dateEnd;
	private list<String> typesProductStr;

	public list<String> sourceList{get;set;}

	public Map<String, Integer> leadsProgress {get;set;}
	public Map<String, Integer> qualifiedLeadsProgress {get;set;}
	public Map<String, Integer> testDrivesProgress {get;set;}
	public Map<String, Integer> salesProgress {get;set;}
	
	public Map<String, Decimal> leadsProgressPerc {get;set;}
	public Map<String, Decimal> qualifiedLeadsProgressPerc {get;set;}
	public Map<String, Decimal> testDrivesProgressPerc {get;set;}
	public Map<String, Decimal> salesProgressPerc {get;set;}

    //tipos de producto
    public List<String> tiposProducto {get;set;}
    public List<String> tiposProductoCENTRAL {get;set;}
    public List<String> tiposProductoBPS {get;set;}    


    //periods
    public list<SelectOption> yearsPeriodOpts {get;set;}
    public String selectedYear {get;set;}
    public list<SelectOption> monthsPeriodOpts {get;set;}
    public String selectedMonth {get;set;}
    public Map<String, PerfectaPeriodo> mapYearsPeriods {get; set;}
    public list<SelectOption> periodOpts {get;set;}
    public String period {get;set;}
    //private Date dateIni;
    //private Date dateEnd;

    // URL reports --------------------------------------------------------------
	public Map<String, ReportURLContainer> sourceLinkReports {get; set;}
    public Map<String, Report_Link__mdt> reportURL {get; set;}

    private static final String OP_FO_M_PROSPECTOS = 'OP_FO_M_Prospectos';
    private static final String OP_FO_M_LEADS = 'OP_FO_M_Leads';
    private static final String OP_FO_M_TD = 'OP_FO_M_TD';
    private static final String OP_FO_M_VENTAS = 'OP_FO_M_Ventas';
    private static final String OP_FO_M_ENTREGAS = 'OP_FO_M_Entregas';
    private static final String OP_FO_M_VOC = 'OP_FO_M_VOC';


	public PlanificacionCRM(){

        tiposProducto = new List<String>();
        tiposProductoCENTRAL = new List<String>();
        tiposProductoBPS = new List<String>();

		Date fechaActual = Date.Today();
		currentIntMonth = fechaActual.month();
		currentIntYear = fechaActual.year();
		currentStrMonth = UtilFunctions.getMonth(currentIntMonth);

		reportURL = PerfectaDAO.getCustomMetadata();
		//dateIni = Date.newInstance(currentIntYear, currentIntMonth, 1);
		//dateEnd = Date.newInstance(currentIntYear, currentIntMonth + 1, 1).addDays(-1);

        periodOpts = initPeriodOpts();

		canEdit = true;
		objetivoFuenteRT = [SELECT Id
								FROM RecordType
								WHERE sObjectType = 'Objetivo__c'
								AND RecordType.DeveloperName = 'FuentesOrigen'];

        setDateInterval();								

		initSucursales();
        initTiposProducto();
		selectedSucursal = CENTRAL;
		//executiveIds = getExecsSucursal(selectedSucursal);
		executiveIds = getUsersId(selectedSucursal, USUARIO_VENTAS);
		typesProductStr = getAllProductTypes();
		sourceList = PerfectaDAO.getFuentesOrigen();
		initObjetivos();
		initAvance();
		summaryCalc();
        setURLReports();
		system.debug('FUENTES >> ' + sourceList);
		system.debug('Test Drive Map >> ' + testDrivesProgress);
	}


    private List<Id> getUsersId(String sucursal, String profile)
	{
		List<Id> ids = new List<Id>();
		List<User> users = PerfectaDAO.getUsers(sucursal, profile);
        for(User u : users)
		{
            ids.add(u.Id);
		}
		return ids;
	}

    private list<SelectOption> initPeriodOpts() {
    
        list<SelectOption> opts = new list<SelectOption>();
        List<PerfectaPeriodo> yearsPeriodos = new List<PerfectaPeriodo>(); 
        
        mapYearsPeriods = new Map<String, PerfectaPeriodo>();
        yearsPeriodOpts = new list<SelectOption>();
        
        System.debug('initP cy[' + currentIntYear + ']');
        yearsPeriodos = UtilFunctions.yearsBackFromCurrent(5, currentIntYear, 'none');
        for(PerfectaPeriodo pp : yearsPeriodos)
        {
           yearsPeriodOpts.add(new SelectOption(String.valueOf(pp.year), String.valueOf(pp.year)));
           mapYearsPeriods.put(String.valueOf(pp.year), pp);
        }

        selectedYear = yearsPeriodos.get(yearsPeriodos.size() - 1).year;
        monthsPeriodOpts = yearsPeriodos.get(yearsPeriodos.size() - 1).months;
        selectedMonth = monthsPeriodOpts.get(monthsPeriodOpts.size() - 1).getValue();
        
        Date today = Date.today();
        Integer currMonth = today.month();
        for(Integer i = 1; i <= currMonth; i++){
            opts.add(new SelectOption(String.valueOf(i), genPOLabel(i, today.year())));
        }
        for(Integer i = 1; i <= currMonth/3; i++){
            opts.add(new SelectOption('Q' + String.valueOf(i), 'Q' + String.valueOf(i)));
        }
        if(Math.mod(currMonth, 3) > 0){
            String current = String.valueOf((currMonth/3) + 1);
            opts.add(new SelectOption('Q' + current, 'Trimestre Actual (Q' + current +  ')'));
        }
        opts.add(new SelectOption('AC', 'Año completo - 2018'));
        return opts;
    }

    private String genPOLabel(Integer month, Integer year)
    {
        return UtilFunctions.getMonth(month) + ' - ' + String.valueOf(year);
    }


	private void initSucursales(){
       String sucursal;
       AggregateResult[] results = null;

		if(sucursales == null){
			sucursales = new List<SelectOption>();
			Schema.DescribeFieldResult sucurList = User.Sucursal__c.getDescribe();
			List<Schema.PicklistEntry> plv = sucurList.getPicklistValues();
			for( Schema.PicklistEntry pickListVal : plv){
				sucursales.add(new SelectOption(pickListVal.getValue(), pickListVal.getLabel()));
			}
		}
	}

    private void initTiposProducto()
    {
        Schema.DescribeFieldResult tpList = Schema.Opportunity.Tipo_contacto__c.getDescribe();
        List<Schema.PicklistEntry> plValues = tpList.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : plValues)
        {
           tiposProducto.add(pickListVal.getValue());
           if(pickListVal.getValue() == '0KM')
           {
               tiposProductoCENTRAL.add(pickListVal.getValue());
           }
           if(pickListVal.getValue() == 'BPS')
           {
               tiposProductoBPS.add(pickListVal.getValue());
           }
        }
    }


	private void initObjetivos(){
		objetivos = new Map<String, Objetivo__c>();

        for(Objetivo__c o : [SELECT Id,
								Fuente_Origen__c,
								Prospectos__c,
								Leads_Calificados__c,                                        
								Test_Drives__c,
								Ventas__c
								FROM Objetivo__c
								WHERE Tipo__c = :MENSUAL_O
								AND Mes__c = :dateIni.month()
								AND Objetivo_Sucursal__c = :selectedSucursal
								AND RecordTypeId = :objetivoFuenteRT.Id
								ORDER BY Fuente_Origen__c]){
			objetivos.put(o.Fuente_Origen__c, o);
		}

        if(objetivos.isEmpty()){
            for(String source : sourceList){
				objetivos.put(source, new Objetivo__c(Fuente_Origen__c  = source,
                                                 Prospectos__c = 0,
                                                 Leads_Calificados__c = 0,
                                                 Test_Drives__c = 0,
                                                 Ventas__c = 0,
												 Anio__c = currentIntYear,
                                                 Mes__c = currentIntMonth,
                                                 Tipo__c = MENSUAL_O,
												 Objetivo_Sucursal__c = selectedSucursal,
												 RecordTypeId = objetivoFuenteRT.Id));
            }
        }
	}

	private void initAvance(){
		Integer numValue;
		testDrivesProgress = PerfectaDAO.getTestDrivesFuenteOrigen(executiveIds, dateIni, dateEnd, typesProductStr);
		fillInTheBlanks(sourceList, testDrivesProgress);

		qualifiedLeadsProgress = PerfectaDAO.getOportunidadesPorFuenteOrigen(executiveIds, OPP_CALIFICADO, dateIni, dateEnd, typesProductStr);
    	fillInTheBlanks(sourceList, qualifiedLeadsProgress);

		salesProgress = PerfectaDAO.getOportunidadesPorFuenteOrigen(executiveIds, OPP_CERRADA_GANADA, dateIni, dateEnd, typesProductStr);
    	fillInTheBlanks(sourceList, salesProgress);
		
		PSummary psum = new PSummary();
		Map<String, ProspectoInformacion> fuenteOrigenProspectos =  PerfectaDAO.getProspectosEjecutivoLeadSource(executiveIds, typesProductStr, dateIni, dateEnd, psum).get(1);
		leadsProgress = new Map<String, Integer>();
		for(String fuente: sourceList){
			leadsProgress.put(fuente, 0);
			if(fuenteOrigenProspectos.containsKey(fuente)){
				leadsProgress.put(fuente, fuenteOrigenProspectos.get(fuente).numeroProspectos);
			}
		}
		leadsProgressPerc = calcPercentage(sourceList, 'Prospectos__c', objetivos, leadsProgress);
		qualifiedLeadsProgressPerc = calcPercentage(sourceList, 'Leads_Calificados__c', objetivos, qualifiedLeadsProgress);
		testDrivesProgressPerc = calcPercentage(sourceList, 'Test_Drives__c', objetivos, testDrivesProgress);
		salesProgressPerc = calcPercentage(sourceList, 'Ventas__c', objetivos, salesProgress);
	}

	public void saveObjetivos(){
		upsert objetivos.values();
		initAvance();
		summaryCalc();
	}

	public void changeSucursal(){
		executiveIds = getExecsSucursal(selectedSucursal);
		initObjetivos();
		initAvance();
		summaryCalc();
	}

	public void summaryCalc(){
		leadsGoalSummary = 0;
		qualifiedLeadsGoalSummary = 0;
    	testDrivesGoalSummary = 0;
    	salesGoalSummary = 0;
		deliveryGoalSummary = 0;
		voCGoalSummary = 0;
		for(Objetivo__c o : objetivos.values()){
			leadsGoalSummary += o.Prospectos__c == null ? 0 : Integer.valueOf(o.Prospectos__c);
			qualifiedLeadsGoalSummary += o.Leads_Calificados__c == null ? 0 : Integer.valueOf(o.Leads_Calificados__c);
    		testDrivesGoalSummary += o.Test_Drives__c == null ? 0 : Integer.valueOf(o.Test_Drives__c);
    		salesGoalSummary += o.Ventas__c == null ? 0 : Integer.valueOf(o.Ventas__c);
		}

		leadsProgressSummary = 0;
		qualifiedLeadsProgressSummary = 0;
    	testDrivesProgressSummary = 0;
    	salesProgressSummary = 0;
		for(String s : sourceList){
			leadsProgressSummary += leadsProgress.get(s);
			qualifiedLeadsProgressSummary += qualifiedLeadsProgress.get(s);
			testDrivesProgressSummary += testDrivesProgress.get(s);
			salesProgressSummary += salesProgress.get(s);
		}
	    Decimal numLeads, numQLeads, numTDrives, numSales;
		numLeads = leadsGoalSummary == 0 ? 1 : leadsGoalSummary;
		numQLeads = qualifiedLeadsGoalSummary == 0 ? 1 : qualifiedLeadsGoalSummary;
		numTDrives = testDrivesGoalSummary == 0 ? 1 : testDrivesGoalSummary;
		numSales = salesGoalSummary == 0 ? 1 : salesGoalSummary;

		leadsProgressPercAvg = leadsProgressSummary * 100 / numLeads;
		qualifiedLeadsProgressPercAvg = qualifiedLeadsProgressSummary * 100 / numQLeads;
    	testDrivesProgressPercAvg = testDrivesProgressSummary * 100 / numTDrives;
    	salesProgressPercAvg = salesProgressSummary * 100 / numSales;


	}

	private list<Id> getExecsSucursal(String suc){
		list<Id> result = new list<Id>();
		for(User u : [SELECT Id
						FROM User
						WHERE Sucursal__c = :suc]){
			result.add(u.Id);
		}
		return result;
	}

	private list<String> getAllProductTypes(){
		List<String> typesProductStr = new List<String>();
        Schema.DescribeFieldResult tpList = Opportunity.Tipo_contacto__c.getDescribe();
        List<Schema.PicklistEntry> ple = tpList.getPicklistValues();
        for( Schema.PicklistEntry pickListValue : ple){
                typesProductStr.add(pickListValue.getValue());
		}
		return typesProductStr;
	}

	private void fillInTheBlanks(list<String> sources, Map<String, Integer> data){
		for(String s : sources){
			if(!data.containsKey(s)){
				data.put(s, 0);
			}
		}
	}

	private Map<String, Decimal> calcPercentage(list<String> sources,
														String metricField, 
														Map<String, Objetivo__c> goals, 
														Map<String, Integer> progress){
		Map<String, Decimal> percResult = new Map<String, Decimal>();
		for(String s : sources){
			Decimal denominator = (Decimal)goals.get(s).get(metricField);
			if(denominator == 0){
				denominator = 1;
			}
			Decimal perc = 100 * progress.get(s) / denominator;
			percResult.put(s, perc);
		}
		return percResult;
	}

    public void changeYear()
    {
       PerfectaPeriodo periodo = mapYearsPeriods.get(selectedYear);
       System.debug('CHY SELYEAR[' + selectedYear +'] PER[' + periodo +']');
              
       if(periodo != null)
       {
          monthsPeriodOpts = periodo.months;
          selectedMonth = monthsPeriodOpts.get(monthsPeriodOpts.size() - 1).getValue();
       }
       
       setDateInterval();
       if(!Test.isRunningTest()){
           calculate(); 
       }
    }


    public void changeMonth()
    {
       PerfectaPeriodo periodo = mapYearsPeriods.get(selectedYear);
       System.debug('CHM SELYEAR[' + selectedYear +'] PER[' + periodo +'] SELMONTH[' + selectedMonth +']');       

       setDateInterval();
        setURLReports();       
       if(!Test.isRunningTest()){
           calculate();
       }     
    }    

    private void setDateInterval()
    {
       List<Date> dates;
       Map<String, List<Date>> mapPeriodDates;    
       PerfectaPeriodo periodo = mapYearsPeriods.get(selectedYear);
       if(periodo != null)
       {
          mapPeriodDates = periodo.monthsInterval;
          dates = mapPeriodDates.get(selectedMonth);
          dateIni = dates.get(0);
          dateEnd = dates.get(1);
       }
       System.debug('Interval dateIni[' + dateIni +'] dateEnd[' + dateEnd + ']');       
    }

    public void calculate()
    {
       executiveIds = getExecsSucursal(selectedSucursal);
	   typesProductStr = getAllProductTypes();
	   sourceList = PerfectaDAO.getFuentesOrigen();
	   initObjetivos();
	   initAvance();
	   summaryCalc();

       canEdit = true;

       if(dateIni.year() < currentIntYear)
       {
          canEdit = false;
       }

       if(dateIni.year() == currentIntYear && dateIni.month() < currentIntMonth)
       {
          canEdit = false;
       }
    }

    // --------------------------------------------------------------- URL reports

    private void setURLReports()
    {
        ReportURLContainer urlContainer;
        sourceLinkReports = new Map<String, ReportURLContainer>();
        for(String src : sourceList)
        {
            urlContainer = new ReportURLContainer();
            urlContainer.urlProspectos = buildReportURL(OP_FO_M_PROSPECTOS , src);
            urlContainer.urlLeads = buildReportURL(OP_FO_M_LEADS , src);
            urlContainer.urlTestDrives = buildReportURL(OP_FO_M_TD , src);
            urlContainer.urlVentas = buildReportURL(OP_FO_M_VENTAS , src);
            sourceLinkReports.put(src, urlContainer);
        }
    }


    private String buildReportURL(String report, String fuenteOrigen) 
    {
       Report_Link__mdt reportMetadata;
       String urlReport = '';
       reportMetadata = reportURL.get(report);

       Date fechaIni;
       Date fechaFin;

       fechaIni = dateIni;
       fechaFin = dateEnd;

       String strFechaIni = fechaIni.month() + '/' + fechaIni.day() + '/' + fechaIni.year();
       String strFechaFin = fechaFin.month() + '/' + fechaFin.day() + '/' + fechaFin.year();

       //tiposProducto

       System.debug('TIPOS PROD REP [' + tiposProducto + ']');

       if(reportMetadata != null)
       {
          if(report == OP_FO_M_TD)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursal;
          }
          if(report == OP_FO_M_PROSPECTOS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursal;
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
          }
          if(report == OP_FO_M_LEADS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursal;
          }
          if(report == OP_FO_M_VENTAS)
          {
             urlReport = reportMetadata.Link__c +'?pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursal;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
             //urlReport = urlReport +'&pc5='+reportMetadata.pc5__c+'&pn5=' + reportMetadata.pn5__c + '&pv5=' + tiposProducto;
          }

       }

       System.debug('URL Report [' + urlReport + ']');
       return urlReport;
    }


    public class ReportURLContainer
    {
        //------ URL reports -----------------------
        public String urlProspectos {get;set;}
        public String urlLeads {get;set;}
        public String urlTestDrives {get;set;}
        public String urlVentas {get;set;}
    }

}