public class PlanificacionDiariaVentas
{
    private Opportunity opportunity;
    public List<ObjetivoClass> objetivos {get;set;}
    public List<ObjetivoClass> objetivosDiarios {get;set;}

    public List<SelectOption> sucursales {get;set;}
    public String selectedSucursal {get;set;}
    public List<String> sucursalesList {get;set;}    
    
    public List<String> tiposProducto {get;set;}
    public List<String> tiposProductoCENTRAL {get;set;}
    public List<String> tiposProductoBPS {get;set;}    
        
    public List<Auto_Demo__c> autosDemo {get;set;}
    public List<Senas_Apuesta__c> senasApuestas {get;set;}
    public List<Dias_Habiles_Transcurridos__c> diasHabilesYTranscurridos {get;set;}
    
    public String currentStrMonth {get; set;}
    public Integer currentIntMonth {get; set;}
    public Integer currentIntYear {get; set;}
    public Integer diasTranscurridos {get; set;}
    public Integer diasHabiles {get; set;}

    public Integer diasTranscurridosC {get; set;}
    public Integer diasHabilesC {get; set;}

    //periods
    public list<SelectOption> yearsPeriodOpts {get;set;}
    public String selectedYear {get;set;}
    public list<SelectOption> monthsPeriodOpts {get;set;}
    public String selectedMonth {get;set;}
    public Map<String, PerfectaPeriodo> mapYearsPeriods {get; set;}
    public list<SelectOption> periodOpts {get;set;}
    public String period {get;set;}
    private Date dateIni;
    private Date dateEnd;


    public static final String OPP_CERRADA_GANADA = 'Cerrada/Ganada';
    public static final String OPP_CALIFICADO = 'Calificado';
    public static final String OPP_TEST_DRIVE = 'Prueba de manejo';
    
    public static final String MENSUAL_E = 'Mensual Ejecutivo';
    public static final String DIARIO_E = 'Diario Ejecutivo';    
    public static final String USUARIO_VENTAS = 'Usuario de Ventas';
    
    public static final String GERENCIA_COMERCIAL = 'Gerencia Comercial';
    public static final String GERENCIA_CRM = 'Gerencia CRM';
    public static final String GERENCIA_0KM = 'Gerencia ventas 0KM';
    public static final String INSERT_VAL = 'insert';

    public static final String ALREADY_INIT = 'Los valores ya han sido actualizados, favor refresque la página';

    private Date fechaActual;
    
    private String updateInsertFlag = 'insert';
    private String updateInsertDailyFlag = 'insert';
    private String updateInsertAutoFlag = 'insert';
    private String updateInsertApuestasFlag = 'insert';
    private String updateInsertDiasCSFlag = 'insert';
    
    //Totales por tabla -------------------------------------------------------    
    public Integer totCumpLeadsEjecutivo {get; set;}
    public Integer totCumpProspectosEjecutivo {get; set;}
    public Integer totCumpTestDrivesEjecutivo {get; set;}
    public Integer totCumpVentasEjecutivo {get; set;}
    public Integer totCumpEntregasEjecutivo {get; set;}
    public Integer totCumpVOCEjecutivo {get; set;}

    public Integer totCumpLeads {get; set;}
    public Integer totCumpProspectos {get; set;}
    public Integer totCumpTestDrives {get; set;}
    public Integer totCumpVentas {get; set;}
    public Integer totCumpEntregas {get; set;}
    public Integer totCumpVOC {get; set;}        

    public Decimal totCumpLeadsPorc {get; set;}
    public Decimal totCumpProspectosPorc {get; set;}
    public Decimal totCumpTestDrivesPorc {get; set;}
    public Decimal totCumpVentasoPorc {get; set;}
    public Decimal totCumpEntregasPorc {get; set;}
    public Decimal totCumpVOCPorc {get; set;}        
    
    //---------------------------------------------------------
    
    public Integer totAvLeadsEjecutivo {get; set;}
    public Integer totAvProspectosEjecutivo {get; set;}
    public Integer totAvTestDrivesEjecutivo {get; set;}
    public Integer totAvVentasEjecutivo {get; set;}    
    public Integer totAvEntregasEjecutivo {get; set;}
    public Integer totAvVOCEjecutivo {get; set;}    

    public Integer totAvLeads {get; set;}
    public Integer totAvProspectos {get; set;}
    public Integer totAvTestDrives {get; set;}
    public Integer totAvVentas {get; set;}
    public Integer totAvEntregas {get; set;}
    public Integer totAvVOC {get; set;}

    public Decimal totAvLeadsPorc {get; set;}
    public Decimal totAvProspectosPorc {get; set;}
    public Decimal totAvTestDrivesPorc {get; set;}
    public Decimal totAvVentasPorc {get; set;}
    public Decimal totAvEntregasPorc {get; set;}
    public Decimal totAvVOCPorc {get; set;}    

    public Integer totAvDLeads {get; set;}
    public Integer totAvDProspectos {get; set;}
    public Integer totAvDTestDrives {get; set;}
    public Integer totAvDVentas {get; set;}
    public Integer totAvDEntregas {get; set;}
    public Integer totAvDVOC {get; set;}        
        
    //---------------------------------------------------------

    public Integer totPlanLeadsEjecutivo {get; set;}
    public Integer totPlanProspectosEjecutivo {get; set;}
    public Integer totPlanTestDrivesEjecutivo {get; set;}
    public Integer totPlanVentasEjecutivo {get; set;}
    public Integer totPlanEntregasEjecutivo {get; set;}
    public Integer totPlanVOCEjecutivo {get; set;}

    public Integer totPlanLeads {get; set;}
    public Integer totPlanProspectos {get; set;}
    public Integer totPlanTestDrives {get; set;}
    public Integer totPlanVentas {get; set;}
    public Integer totPlanEntregas {get; set;}
    public Integer totPlanVOC {get; set;}

    public Decimal totPlanLeadsPorc {get; set;}
    public Decimal totPlanProspectosPorc {get; set;}
    public Decimal totPlanTestDrivesPorc {get; set;}
    public Decimal totPlanVentasPorc {get; set;}
    public Decimal totPlanEntregasPorc {get; set;}
    public Decimal totPlanVOCPorc {get; set;}        
    
    //---------------------------------------------------------

    public Integer totSenas {get; set;}
    public Integer totApuestas {get; set;}
    
    
    //Totales por tabla -------------------------------------------------------
    
    private String userSucursal;
    private String profileName;
    public String userName {get; set;}
    
    public boolean canEdit {get;set;}
    public boolean canDisplay {get;set;}
    public boolean canDisplayPanel {get;set;}

    // URL reports --------------------------------------------------------------
    public Map<String, Report_Link__mdt> reportURL {get; set;}

    private static final String OP_M_PROSPECTOS = 'OP_M_Prospectos';
    private static final String OP_M_LEADS = 'OP_M_Leads';
    private static final String OP_M_TD = 'OP_M_TD';
    private static final String OP_M_VENTAS = 'OP_M_Ventas';
    private static final String OP_M_ENTREGAS = 'OP_M_Entregas';
    private static final String OP_M_VOC = 'OP_M_VOC';

    public PlanificacionDiariaVentas()
    {
       tiposProducto = new List<String>();
       tiposProductoCENTRAL = new List<String>();
       tiposProductoBPS = new List<String>();
       System.debug('-- Constructor --');
       fechaActual = Date.Today();
       currentIntMonth = fechaActual.month();
       currentIntYear = fechaActual.year();
       currentStrMonth = UtilFunctions.getMonth(currentIntMonth);

       periodOpts = initPeriodOpts();

       diasTranscurridosC = UtilFunctions.getBusinessDays(fechaActual.year(), currentIntMonth, fechaActual.day());
       diasHabilesC = UtilFunctions.getBusinessDays(fechaActual.year(), currentIntMonth, -1);
       canDisplay = false;
       canDisplayPanel = true;

       reportURL = PerfectaDAO.getCustomMetadata();
       setDateInterval();

       initUserInfo();
       initCustomSettings();
       initSucursales();
       initTiposProducto();
       initData();
       initDailyData();
       setURLReports();
       calcularPorcentajePlanificacion();
       initDataAutoDemo();
       initDataSenasApuestas();
       calcularTotales();
       canEdit = true; 
    }


    public PlanificacionDiariaVentas(ApexPages.StandardController stdController)
    {
        this.opportunity = (Opportunity)stdController.getRecord();
        initData();
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


    private void initUserInfo()
    {
       String roleName;
       User u = [SELECT Sucursal__c,
                        Name,
                        Profile.Name,
                        UserRole.Name
                   FROM User
                  WHERE Id = :UserInfo.getUserId()];

       userSucursal = u.Sucursal__c;
       profileName = u.Profile.Name;
       userName = u.Name;
       selectedSucursal = userSucursal;
       roleName = u.UserRole.Name;
       if(roleName == GERENCIA_0KM)
       {
           canDisplay = true;
       }
       if(u.Sucursal__c == selectedSucursal && u.Profile.Name == GERENCIA_COMERCIAL)
        {
            canEdit = true;
        }
    }
    
    private void initSucursales()
    {
       String sucursal;
       AggregateResult[] results = null;
       
       if(sucursales == null)
       {
         sucursales = new List<SelectOption>();
         results = [SELECT Sucursal__c sucursal From User GROUP BY Sucursal__c];
         for (AggregateResult ar : results) 
         {
           sucursal = (String)ar.get('sucursal');
           if(sucursal != null)
           {
              sucursales.add(new SelectOption(sucursal, sucursal));
           }
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
    
    private void initData()
    {
        Boolean isBPSFlag = false;
        sucursalesList = new List<String>();
        sucursalesList.add(selectedSucursal);
        if(selectedSucursal == 'BPS')
        {
            isBPSFlag = true;
            sucursalesList.add('CDE');
        }

        updateInsertFlag = 'insert';    
        List<String> idUsers = new List<String>();
        List<Objetivo__c> obj = [SELECT Id,
                                        Ejecutivo__c,
                                        Ejecutivo__r.Name,
                                        Prospectos__c,
                                        Leads_Calificados__c,                             
                                        Ventas__c,
                                        Test_Drives__c,
                                        Entregas__c,
                                        VoC__c
                                   FROM Objetivo__c
                                  WHERE Tipo__c = :MENSUAL_E
                                    AND Mes__c = :dateIni.month()
                                    AND Anio__c = :dateIni.year()
                                    AND Ejecutivo__r.Sucursal__c IN :sucursalesList
                                    AND isBPS__c = :isBPSFlag                                    
                               ORDER BY Ejecutivo__r.Name];

        System.debug('OBJET   [' + obj.size() + '] [' + MENSUAL_E + '] dIniMonth[' + dateIni.month() + '] dIniYear[' + dateIni.year() + ']');
        objetivos = new list<ObjetivoClass>(); 
        if(obj.isEmpty()){
            
            for(User e : [SELECT Id,
                                 Name
                            FROM User
                           WHERE Profile.Name = :USUARIO_VENTAS
                             AND Sucursal__c IN :sucursalesList
                             AND IsActive = true
                        ORDER BY Name]){

                idUsers.add(e.Id);
                objetivos.add(new ObjetivoClass
                                (new Objetivo__c(Ejecutivo__c = e.Id,
                                                 Ventas__c = 0,
                                                 Test_Drives__c = 0,
                                                 Leads_Calificados__c = 0,
                                                 Prospectos__c = 0,
                                                 Entregas__c = 0,
                                                 VoC__c = 0,
                                                 Anio__c = dateIni.year(),
                                                 Mes__c = dateIni.month(),
                                                 Tipo__c = MENSUAL_E,
                                                 isBPS__c = isBPSFlag,
                                                 Objetivo_Sucursal__c = selectedSucursal), e.Name, diasHabiles, diasTranscurridos));
            }
            
            updateInsertFlag = 'insert';
        }else{
            for(Objetivo__c o : obj){
                objetivos.add(new ObjetivoClass (o, o.Ejecutivo__r.Name, diasHabiles, diasTranscurridos));
                idUsers.add(o.Ejecutivo__r.Id);
            }
            updateInsertFlag = 'update';
         }
         
       getVentasPorEjcutivo(idUsers, objetivos);
       getLeadsPorEjecutivo(idUsers, objetivos);
       getTestDrivePorEjcutivo(idUsers, objetivos);
       getProspectosPorEjecutivo(idUsers, objetivos);
       getEntregasPorEjecutivo(idUsers, objetivos);
       getVOCPorEjecutivo(idUsers, objetivos);
    }


    private void initDailyData()
    {
        Boolean isBPSFlag = false;
        List<String> idUsers = new List<String>();

        sucursalesList = new List<String>();
        sucursalesList.add(selectedSucursal);
        if(selectedSucursal == 'BPS')
        {
            isBPSFlag = true;       
            sucursalesList.add('CDE');
        }

        List<Objetivo__c> obj = getDailyGoal();

        System.debug('OBJETD   [' + obj.size() + '] [' + DIARIO_E + '] [' + fechaActual + '] [' + selectedSucursal + ']');
        objetivosDiarios = new list<ObjetivoClass>();
        System.debug('OBJETD   [' + obj.isEmpty() + ']');
        if(obj.isEmpty()){
            
            for(User e : [SELECT Id,
                                 Name
                            FROM User
                           WHERE Profile.Name = :USUARIO_VENTAS
                             AND Sucursal__c IN :sucursalesList
                             AND IsActive = true
                        ORDER BY Name]){

                idUsers.add(e.Id);
                objetivosDiarios.add(new ObjetivoClass
                                (new Objetivo__c(Ejecutivo__c = e.Id,
                                                 Ventas__c = 0,
                                                 Test_Drives__c = 0,
                                                 Leads_Calificados__c = 0,
                                                 Prospectos__c = 0,
                                                 Entregas__c = 0,
                                                 VoC__c = 0,
                                                 Fecha_Planificacion__c = fechaActual,
                                                 Anio__c = dateIni.year(),
                                                 Mes__c = dateIni.month(),
                                                 Tipo__c = DIARIO_E,
                                                 isBPS__c = isBPSFlag,
                                                 Objetivo_Sucursal__c = selectedSucursal), e.Name, diasHabiles, diasTranscurridos));
            }
            
            updateInsertDailyFlag = 'insert';
        }else{
            for(Objetivo__c o : obj){
                objetivosDiarios.add(new ObjetivoClass (o, o.Ejecutivo__r.Name, diasHabiles, diasTranscurridos));
                idUsers.add(o.Ejecutivo__r.Id);
            }
            updateInsertDailyFlag = 'update';
         }
    }

    private list<Objetivo__c> getDailyGoal(){
        Boolean isBPSFlag = false;
        sucursalesList = new List<String>();
        sucursalesList.add(selectedSucursal);
        if(selectedSucursal == 'BPS')
        {
            isBPSFlag = true;
            sucursalesList.add('CDE');
        }

        System.debug('getDailyGoal bpsFlag[' + isBPSFlag + '] fecha[' + fechaActual + '] [' + sucursalesList + ']');

        return [SELECT Id,
                    Ejecutivo__c,
                    Ejecutivo__r.Name,
                    Prospectos__c,
                    Leads_Calificados__c,                                        
                    Ventas__c,
                    Test_Drives__c,
                    Entregas__c,
                    VoC__c
                    FROM Objetivo__c
                    WHERE Tipo__c = :DIARIO_E
                    AND Fecha_Planificacion__c = :fechaActual
                    AND Ejecutivo__r.Sucursal__c IN :sucursalesList
                    AND isBPS__c = :isBPSFlag
                    ORDER BY Ejecutivo__r.Name];
    }

    private void initDataAutoDemo()
    {
        sucursalesList = new List<String>();
        sucursalesList.add(selectedSucursal);
        if(selectedSucursal == 'BPS')
        {
            sucursalesList.add('CDE');
        }

        updateInsertAutoFlag = 'insert';
        List<String> idUsers = new List<String>();
        List<Auto_Demo__c> obj = [SELECT Id,
                                        Name,
                                        Estado__c
                                   FROM Auto_Demo__c
                                  WHERE Sucursal__c IN :sucursalesList
                               ORDER BY Name];

        System.debug('OBJET   [' + obj.size() + ']');
        autosDemo = new List<Auto_Demo__c>(); 
        for(Auto_Demo__c auto : obj)
        {
             autosDemo.add(auto);
        }
        updateInsertAutoFlag = 'update';
    }


    private void initDataSenasApuestas()
    {

        sucursalesList = new List<String>();
        sucursalesList.add(selectedSucursal);
        if(selectedSucursal == 'BPS')
        {
            sucursalesList.add('CDE');
        }

        updateInsertApuestasFlag = 'insert';    
        List<String> idUsers = new List<String>();
        List<Senas_Apuesta__c> obj = [SELECT Id,
                                             Ejecutivo__c,
                                             Ejecutivo__r.Name,                                             
                                             Apuesta__c,
                                             Senas__c
                                        FROM Senas_Apuesta__c
                                       WHERE Ejecutivo__r.Sucursal__c IN :sucursalesList
                                    ORDER BY Ejecutivo__r.Name];

        System.debug('OBJET   [' + obj.size() + ']');
        senasApuestas = new List<Senas_Apuesta__c>(); 
        if(obj.isEmpty()){
            
            for(User e : [SELECT Id,
                                 Name
                            FROM User
                           WHERE Profile.Name = :USUARIO_VENTAS
                             AND Sucursal__c IN :sucursalesList
                             AND IsActive = true
                        ORDER BY Name]){

                senasApuestas.add(new Senas_Apuesta__c(Ejecutivo__c = e.Id,
                                                       Apuesta__c = 0,
                                                       Senas__c = 0));
            }
            
            updateInsertApuestasFlag = 'insert';
        }else{
            for(Senas_Apuesta__c senaAp : obj){
                senasApuestas.add(senaAp);
            }
            updateInsertApuestasFlag = 'update';
         }
         
    }


    private void initCustomSettings()
    {
       updateInsertDiasCSFlag = 'insert';
       List<Dias_Habiles_Transcurridos__c> dht = [SELECT Name, 
                                                         Tipo__c, 
                                                         Dias__c 
                                                    FROM Dias_Habiles_Transcurridos__c ORDER BY Tipo__c];
       
       System.debug('DHH  [' + dht.size() + ']');
       diasHabilesYTranscurridos = new List<Dias_Habiles_Transcurridos__c>();
       if(dht.isEmpty())
       {
          diasHabilesYTranscurridos.add(new Dias_Habiles_Transcurridos__c(Name = 'DH', 
                                                                          Tipo__c = 'Dias Habiles', 
                                                                          Dias__c = diasHabilesC));
                                                                          
          diasHabilesYTranscurridos.add(new Dias_Habiles_Transcurridos__c(Name = 'DT', 
                                                                          Tipo__c = 'Dias Transcurridos', 
                                                                          Dias__c = diasTranscurridosC));
          diasHabiles = (Integer)diasHabilesYTranscurridos.get(0).Dias__c;
          diasTranscurridos = (Integer)diasHabilesYTranscurridos.get(1).Dias__c;
          updateInsertDiasCSFlag = 'insert';
       }
       else
       {
          for(Dias_Habiles_Transcurridos__c reg : dht)
          {
              diasHabilesYTranscurridos.add(reg);
          }
          diasHabiles = (Integer)diasHabilesYTranscurridos.get(0).Dias__c;
          diasTranscurridos = (Integer)diasHabilesYTranscurridos.get(1).Dias__c;
          
          updateInsertDiasCSFlag = 'update';
       }
       System.debug('InitCustomSettings  DH[' + diasHabiles + ']  DT[' + diasTranscurridos + ']');
    }


    // --------------------------------------------------------------- URL reports

    private void setURLReports()
    {
        for(ObjetivoClass objClsMonth : objetivos)
        {
            objClsMonth.urlProspectos = buildReportURL(OP_M_PROSPECTOS , objClsMonth.ejecutivoName);
            objClsMonth.urlLeads = buildReportURL(OP_M_LEADS , objClsMonth.ejecutivoName);
            objClsMonth.urlTestDrives = buildReportURL(OP_M_TD , objClsMonth.ejecutivoName);
            objClsMonth.urlVentas = buildReportURL(OP_M_VENTAS , objClsMonth.ejecutivoName);
            objClsMonth.urlEntregas = buildReportURL(OP_M_ENTREGAS , objClsMonth.ejecutivoName);
            objClsMonth.urlVOC = buildReportURL(OP_M_VOC , objClsMonth.ejecutivoName);
        }
    }


    private String buildReportURL(String report, String userName) 
    {
       Report_Link__mdt reportMetadata;
       String urlReport = '';
       reportMetadata = reportURL.get(report);

       Date fechaIni;
       Date fechaFin;

       fechaIni = dateIni;
       fechaFin = dateEnd;
       String tiposProd;

       String strFechaIni = fechaIni.month() + '/' + fechaIni.day() + '/' + fechaIni.year();
       String strFechaFin = fechaFin.month() + '/' + fechaFin.day() + '/' + fechaFin.year();

       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          tiposProd = '0KM';
       }
       if(selectedSucursal == 'BPS')
       {
          tiposProd = 'BPS';
       }


       if(reportMetadata != null)
       {
          if(report == OP_M_TD)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(userName,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + userSucursal;
          }
          if(report == OP_M_PROSPECTOS)
          {
            //Calificado (&lt; 3 meses), converted = false, central
             urlReport = reportMetadata.Link__c +'?pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + EncodingUtil.urlEncode(userName,'UTF-8');
             //urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + userName;
          }
          if(report == OP_M_LEADS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(userName,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + userSucursal;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + tiposProd;
          }
          if(report == OP_M_VENTAS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(userName,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + OPP_CERRADA_GANADA;              
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + userSucursal;
          }

          if(report == OP_M_ENTREGAS)
          {
             urlReport = reportMetadata.Link__c +'?pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;              
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' +tiposProd;
             urlReport = urlReport +'&pc5='+reportMetadata.pc5__c+'&pn5=' + reportMetadata.pn5__c + '&pv5=' + EncodingUtil.urlEncode(userName,'UTF-8');
          }
          if(report == OP_M_VOC)
          {
             urlReport = reportMetadata.Link__c +'?pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;              
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' +tiposProd;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + EncodingUtil.urlEncode(userName,'UTF-8');
          }

       }

       System.debug('URL Report [' + urlReport + ']');
       return urlReport;
    }


    public void saveAll()
    {
       System.debug('Save all');
       saveData();
       saveDataDaily();
       calcularPorcentajePlanificacion();
       saveDataAutoDemo();
       saveSenasApuestas();
       saveDiasCS();
    }
    

    public void saveCumplimiento()
    {
       System.debug('save cumplimiento');
       saveData();
       initCustomSettings();
       calcularPorcentajePlanificacion();
       calcularTotales();
    }


    public void saveDias()
    {
       saveDiasCS();
       System.debug('----- save dias CS DONE');       
       initCustomSettings();
       System.debug('----- init custom settings DONE');
       initData();
       System.debug('----- init data done DONE');
       initDailyData();
       System.debug('----- init daily data done DONE');
       calcularPorcentajePlanificacion();
       System.debug('----- calcular porc planificacion DONE');
       calcularTotales();
       System.debug('----- calcular totales DONE');
    }
    
    public void savePlanificacion()
    {
       System.debug('save planificacion------------');
       saveDataDaily();
       System.debug('save daily------------');
       initDailyData();
       System.debug('init data ------------');       
       calcularPorcentajePlanificacion();
       calcularTotales();       
    }
    
    public void saveDemoDisponible()
    {
       saveDataAutoDemo();
    }

    public void saveApuestas()
    {
       saveSenasApuestas();
    }

    public void saveSenas()
    {
       saveSenasApuestas();
    }

    public void saveData()
    {
        List<Objetivo__c> objetivosToSave = new List<Objetivo__c>();
        Objetivo__c objetivo;
        
        System.debug('save data [' + this.objetivos.size() + ']');
        
        for(ObjetivoClass objCls : this.objetivos)
        {
            objetivo = objCls.obj;
            //System.debug('NAME[' + objCls.ejecutivoName + '] leadsReg[' + objetivo.Leads_Calificados__c + '] ventas[' + objetivo.Ventas__c + '] testDrives[' + objetivo.Test_Drives__c + ']');
            objetivosToSave.add(objetivo);
        }
        
        upsert objetivosToSave;
    }
    
    public void saveDataDaily()
    {
        List<Objetivo__c> objetivosToSave = new List<Objetivo__c>();
        Objetivo__c objetivo;
        
        System.debug('save data Daily [' + this.objetivosDiarios.size() + ']');
        System.debug('save data Daily [' + updateInsertDailyFlag + ']');        
        
        if(updateInsertDailyFlag == INSERT_VAL && !getDailyGoal().isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ALREADY_INIT));
        }else{
            for(ObjetivoClass objCls : this.objetivosDiarios)
            {
                objetivo = objCls.obj;
                objetivo.Leads_Calificados__c = (objetivo.Leads_Calificados__c == null) ? 0: objetivo.Leads_Calificados__c;
                objetivo.Prospectos__c = (objetivo.Prospectos__c == null) ? 0 : objetivo.Prospectos__c;
                objetivo.Test_Drives__c = (objetivo.Test_Drives__c == null) ? 0 : objetivo.Test_Drives__c;
                objetivo.Ventas__c = (objetivo.Ventas__c == null) ? 0 : objetivo.Ventas__c;
                objetivo.Entregas__c = (objetivo.Entregas__c == null) ? 0 : objetivo.Entregas__c;
                objetivo.VoC__c = (objetivo.VoC__c == null) ? 0 : objetivo.VoC__c;                        
                
                //System.debug('D NAME [' + objetivo.id + '] [' + objCls.ejecutivoName + '] leadsReg[' + objetivo.Leads_Calificados__c + '] ventas[' + objetivo.Ventas__c + '] testDrives[' + objetivo.Test_Drives__c + ']');
                objetivosToSave.add(objetivo);
            }
            
            upsert objetivosToSave;
        }
        
    }

    public void saveDataAutoDemo()
    {
        List<Auto_Demo__c> autosDemoToSave = new List<Auto_Demo__c>();
        
        for(Auto_Demo__c autoDemo : this.autosDemo)
        {
            autosDemoToSave.add(autoDemo);
        }
        
        upsert autosDemoToSave;
        
    }


    public void saveSenasApuestas()
    {
        List<Senas_Apuesta__c> senasApuestasToSave = new List<Senas_Apuesta__c>();
        
        for(Senas_Apuesta__c senaAp : this.senasApuestas)
        {
            if(senaAp.Apuesta__c == null)
            {
              senaAp.Apuesta__c = 0;
            }
            if(senaAp.Senas__c == null)
            {
              senaAp.Senas__c = 0;
            }
            senasApuestasToSave.add(senaAp);
        }
        
        upsert senasApuestasToSave;
        
        calcularTotales();
        
    }


    public void saveDiasCS()
    {
        List<Dias_Habiles_Transcurridos__c> diasHTToSave = new List<Dias_Habiles_Transcurridos__c>();
        
        for(Dias_Habiles_Transcurridos__c dht : this.diasHabilesYTranscurridos)
        {
            if(dht.Dias__c == null)
            {
               dht.Dias__c = 0;
            }
            //System.debug('save dias [' + dht.Tipo__c + '] [' + dht.Dias__c + ']');            
            diasHTToSave.add(dht);
        }
        
        upsert diasHTToSave;
        
    }


    public void getLeadsPorEjecutivo(List<String> idEjecutivos, List<ObjetivoClass> objetivos)
    {
       Objetivo__c objetivo;
       Integer leadsEjecutivo;
       Map<String, Integer> leadsCalificados;

       System.debug('Leads SUC[' + selectedSucursal +']');       
       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          leadsCalificados = getOportunidadesPorEjecutivo(idEjecutivos, OPP_CALIFICADO, tiposProductoCENTRAL);
       }
       if(selectedSucursal == 'BPS')
       {
          leadsCalificados = getOportunidadesPorEjecutivo(idEjecutivos, OPP_CALIFICADO, tiposProductoBPS);
       }       

       for(ObjetivoClass objCls : objetivos)
       {
           objetivo = objCls.obj;
           leadsEjecutivo = leadsCalificados.get(objetivo.Ejecutivo__c);
           if(leadsEjecutivo != null)
           {
             objCls.leadsCalificadosPorEjecutivo = leadsEjecutivo;
           }
           else
           {
             objCls.leadsCalificadosPorEjecutivo = 0;
           }
           //System.debug('LE [' + leadsEjecutivo + '] [' + objetivo.Ejecutivo__c + '] [' + objCls.ejecutivoName + ']');
       }
    }

    public void getVentasPorEjcutivo(List<String> idEjecutivos, List<ObjetivoClass> objetivos)
    {
       Objetivo__c objetivo;
       Integer ventasEjecutivo;
       Map<String, Integer> ventas;
       System.debug(' Ventas SUC[' + selectedSucursal +']');

       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          ventas = getVentasPorEjecutivo(idEjecutivos, OPP_CERRADA_GANADA, tiposProductoCENTRAL);
       }
       if(selectedSucursal == 'BPS')
       {
          ventas = getVentasPorEjecutivo(idEjecutivos, OPP_CERRADA_GANADA, tiposProductoBPS);
       }
       
       for(ObjetivoClass objCls : objetivos)
       {
           objetivo = objCls.obj;
           ventasEjecutivo = ventas.get(objetivo.Ejecutivo__c);
           if(ventasEjecutivo != null)
           {
             objCls.ventasPorEjecutivo = ventasEjecutivo;
           }
           else
           {
             objCls.ventasPorEjecutivo = 0;
           }
           //System.debug('vE [' + ventasEjecutivo + '] [' + objetivo.Ejecutivo__c + '] [' + objCls.ejecutivoName + ']');
           
       }
    }

    public void getTestDrivePorEjcutivo(List<String> idEjecutivos, List<ObjetivoClass> objetivos)
    {
       Objetivo__c objetivo;
       Integer testDrivesEjecutivo;
       Map<String, Integer> testDrives;

       //Date fechaInicio = Date.newInstance(currentIntYear, currentIntMonth, 1);
       //Date fechaFin = Date.newInstance(currentIntYear, currentIntMonth + 1, 1).addDays(-1);
       Date fechaInicio = dateIni;
       Date fechaFin = dateEnd;

       System.debug('TD SUC[' + selectedSucursal +']');
       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          testDrives = PerfectaDAO.getTestDrives(fechaInicio, fechaFin, tiposProductoCENTRAL, idEjecutivos);
       }
       if(selectedSucursal == 'BPS')
       {
          testDrives = PerfectaDAO.getTestDrives(fechaInicio, fechaFin, tiposProductoBPS, idEjecutivos);
       }

       for(ObjetivoClass objCls : objetivos)
       {
           objetivo = objCls.obj;
           testDrivesEjecutivo = testDrives.get(objetivo.Ejecutivo__c);
           if(testDrivesEjecutivo != null)
           {
             objCls.testDrivesPorEjecutivo = testDrivesEjecutivo;
           }
           else
           {
             objCls.testDrivesPorEjecutivo = 0;
           }
           //System.debug('vE [' + ventasEjecutivo + '] [' + objetivo.Ejecutivo__c + '] [' + objCls.ejecutivoName + ']');
       }
    }


    private Map<String, Integer> getOportunidadesPorEjecutivo(List<String> idEjecutivos, String estadoOportunidad, List<String> tiposProducto)
    {
       Map<String, Integer> ventas = new Map<String, Integer>();
       AggregateResult[] results = null;
       Date fechaInicio = dateIni;
       Date fechaFin = dateEnd;

       System.debug('LDS PDV Fini [' + fechaInicio + ']  FFin[' + fechaFin + '] stage[' + estadoOportunidad + ']');
       for(String tp : tiposProducto)
       {
           System.debug('TP [' + tp + ']');
       }
       
       results = [SELECT Owner.id idus, 
                         Owner.Name nameus, 
                         COUNT(Id) countN 
                    FROM Opportunity  
                   WHERE Owner.Id IN :idEjecutivos
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) >= :fechaInicio
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) <= :fechaFin
                     //AND Stagename = :estadoOportunidad
                     AND Tipo_contacto__c IN :tiposProducto
                GROUP BY Owner.Id, Owner.Name];

       for (AggregateResult ar : results) 
       {
          System.debug('LDS owid[' + ar.get('idus') + '] -' + ar.get('nameus')+'-'+ar.get('countN'));
          ventas.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       return ventas;
    }
    
    
    private Map<String, Integer> getVentasPorEjecutivo(List<String> idEjecutivos, String estadoOportunidad, List<String> tiposProducto)
    {
       Map<String, Integer> ventas = new Map<String, Integer>();
       AggregateResult[] results = null;
       //Date fechaInicio = Date.newInstance(currentIntYear, currentIntMonth, 1);
       //Date fechaFin = Date.newInstance(currentIntYear, currentIntMonth + 1, 1);
       Date fechaInicio = dateIni;
       Date fechaFin = dateEnd;

       System.debug('getVentasPorEjecutivo [' + tiposProducto + ']');

       results = [SELECT Owner.Id idus, 
                         Owner.Name nameus, 
                         COUNT(id) countN 
                    FROM Opportunity  
                   WHERE Owner.Id = :idEjecutivos
                     AND stagename = :estadoOportunidad
                     AND Fecha_de_Venta__c >= :fechaInicio
                     AND Fecha_de_Venta__c <= :fechaFin
                     AND Tipo_contacto__c IN :tiposProducto
                GROUP BY Owner.Id, Owner.Name];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ventas.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       
       return ventas;
    }

    
    private void getEntregasPorEjecutivo(List<String> idEjecutivos, List<ObjetivoClass> objetivos)
    {
       Objetivo__c objetivo;    
       Integer entregasEjecutivo;
       Map<String, Integer> entregas;
       
       //Date fechaInicio = Date.newInstance(currentIntYear, currentIntMonth, 1);
       //Date fechaFin = Date.newInstance(currentIntYear, currentIntMonth + 1, 1).addDays(-1);
       Date fechaInicio = dateIni;
       Date fechaFin = dateEnd;

       System.debug('ENT SUC[' + selectedSucursal +']');
       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          entregas = PerfectaDAO.getEntregasPorEjecutivo(idEjecutivos, OPP_CERRADA_GANADA, fechaInicio, fechaFin, tiposProductoCENTRAL);
       }
       if(selectedSucursal == 'BPS')
       {
          entregas = PerfectaDAO.getEntregasPorEjecutivo(idEjecutivos, OPP_CERRADA_GANADA, fechaInicio, fechaFin, tiposProductoBPS);
       }

       for(ObjetivoClass objCls : objetivos)
       {
           objetivo = objCls.obj;
           entregasEjecutivo = entregas.get(objetivo.Ejecutivo__c);
           
           objCls.entregasPorEjecutivo = (entregasEjecutivo == null) ? 0 : entregasEjecutivo;
           //System.debug('vE [' + ventasEjecutivo + '] [' + objetivo.Ejecutivo__c + '] [' + objCls.ejecutivoName + ']');
       }
    }


    private void getVOCPorEjecutivo(List<String> idEjecutivos, List<ObjetivoClass> objetivos)
    {
       Objetivo__c objetivo;
       Integer vocEjecutivo;
       Map<String, Integer> vocs;
       
       //Date fechaInicio = Date.newInstance(currentIntYear, currentIntMonth, 1);
       //Date fechaFin = Date.newInstance(currentIntYear, currentIntMonth + 1, 1).addDays(-1);
       Date fechaInicio = dateIni;
       Date fechaFin = dateEnd;

       //vocs = PerfectaDAO.getVOCPorEjecutivo(fechaInicio, fechaFin, tiposProducto);
       System.debug('VOC SUC[' + selectedSucursal +']');
       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          vocs = PerfectaDAO.getVOCPorEjecutivo(fechaInicio, fechaFin, tiposProductoCENTRAL);
       }
       if(selectedSucursal == 'BPS')
       {
          vocs = PerfectaDAO.getVOCPorEjecutivo(fechaInicio, fechaFin, tiposProductoBPS);
       }

       for(ObjetivoClass objCls : objetivos)
       {
           objetivo = objCls.obj;
           vocEjecutivo= vocs.get(objetivo.Ejecutivo__c);
           
           objCls.vocPorEjecutivo = (vocEjecutivo == null) ? 0 : vocEjecutivo;
           //System.debug('vE [' + ventasEjecutivo + '] [' + objetivo.Ejecutivo__c + '] [' + objCls.ejecutivoName + ']');
       }
    }


    private Map<String, Integer> getProspectosPorEjecutivo(List<String> idEjecutivos, List<ObjetivoClass> objetivos)
    {
       Objetivo__c objetivo;
       Integer prospectosEjecutivo;

       Map<String, Integer> prospectos = new Map<String, Integer>();
       AggregateResult[] results = null;
       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       fechaIni = dateIni;
       fechaFin = dateEnd;

       if(selectedSucursal == 'CENTRAL' || selectedSucursal == 'CDE')
       {
          prospectos = PerfectaDAO.getProspectsByExec(idEjecutivos, 'Contacto de Prospección', tiposProductoCENTRAL, fechaIni, fechaFin);
       }
       if(selectedSucursal == 'BPS')
       {
          prospectos = PerfectaDAO.getProspectsByExec(idEjecutivos, 'Contacto de Prospección', tiposProductoBPS, fechaIni, fechaFin);          
       }

       for(ObjetivoClass objCls : objetivos)
       {
           objetivo = objCls.obj;
           prospectosEjecutivo = prospectos.get(objetivo.Ejecutivo__c);
           if(prospectosEjecutivo != null)
           {
             objCls.prospectosPorEjecutivo = prospectosEjecutivo;
           }
           else
           {
             objCls.prospectosPorEjecutivo = 0;
           }
       }
       return prospectos;
    }
    
    
    public void calcularPorcentajePlanificacion()
    {
        ObjetivoClass objetivoMensual;
        ObjetivoClass objetivoDiario;
        Map<String, ObjetivoClass> mapaObjetivos = new Map<String, ObjetivoClass>();

        for(ObjetivoClass objCls : objetivos)
        {
            mapaObjetivos.put(objCls.EjecutivoName, objCls);
        }

        //porcentaje
        for(ObjetivoClass objClsD : objetivosDiarios)
        {
            objetivoDiario = objClsD;
            objetivoMensual = mapaObjetivos.get(objClsD.EjecutivoName);
            if(objetivoMensual != null)
            {
               //System.debug('objMens[' + objetivoMensual.ejecutivoName + '] [' + objetivoDiario.obj.Prospectos__c + '] [' + objetivoMensual.prospectosPorEjecutivo + '] [' + objetivoMensual.getAvanceProspectosPorEjecutivo() + ']');
               objetivoMensual.planificacionProspectosPorcentaje = (objetivoMensual.getAvanceProspectosPorEjecutivo() == 0) ? 0 : ((objetivoDiario.obj.Prospectos__c + objetivoMensual.prospectosPorEjecutivo ) / objetivoMensual.getAvanceProspectosPorEjecutivo()) * 100;
               objetivoMensual.planificacionLeadsPorcentaje = (objetivoMensual.getAvanceLeadsPorEjecutivo() == 0) ? 0 : ((objetivoDiario.obj.Leads_Calificados__c + objetivoMensual.leadsCalificadosPorEjecutivo ) / objetivoMensual.getAvanceLeadsPorEjecutivo()) * 100;
               objetivoMensual.planificacionTestDrivesPorcentaje = (objetivoMensual.getAvanceTestDrivesPorEjecutivo() == 0) ? 0 : ((objetivoDiario.obj.Test_Drives__c + objetivoMensual.testDrivesPorEjecutivo ) / objetivoMensual.getAvanceTestDrivesPorEjecutivo()) * 100;
               objetivoMensual.planificacionVentasPorcentaje = (objetivoMensual.getAvanceVentasPorEjecutivo() == 0) ? 0 : ((objetivoDiario.obj.Ventas__c + objetivoMensual.ventasPorEjecutivo ) / objetivoMensual.getAvanceVentasPorEjecutivo()) * 100;
               objetivoMensual.planificacionEntregasPorcentaje = (objetivoMensual.getAvanceEntregasPorEjecutivo() == 0) ? 0 : ((objetivoDiario.obj.Entregas__c + objetivoMensual.entregasPorEjecutivo ) / objetivoMensual.getAvanceEntregasPorEjecutivo()) * 100;
               objetivoMensual.planificacionVOCPorcentaje = (objetivoMensual.getAvanceVoCPorEjecutivo() == 0) ? 0 : ((objetivoDiario.obj.VoC__c + objetivoMensual.vocPorEjecutivo ) / objetivoMensual.getAvanceVoCPorEjecutivo()) * 100;
            }
        }
        
        //planificacion diaria        
        for(ObjetivoClass objClsD : objetivosDiarios)
        {
            objetivoDiario = objClsD;
            objetivoMensual = mapaObjetivos.get(objClsD.EjecutivoName);
            if(objetivoMensual != null)
            {
               objetivoDiario.planificacionDiariaProspectos = objetivoDiario.obj.Prospectos__c + objetivoMensual.prospectosPorEjecutivo;
               objetivoDiario.planificacionDiariaLeads = objetivoDiario.obj.Leads_Calificados__c + objetivoMensual.leadsCalificadosPorEjecutivo;
               objetivoDiario.planificacionDiariaTestDrives = objetivoDiario.obj.Test_Drives__c + objetivoMensual.testDrivesPorEjecutivo;
               objetivoDiario.planificacionDiariaVentas = objetivoDiario.obj.Ventas__c + objetivoMensual.ventasPorEjecutivo;
               objetivoDiario.planificacionDiariaEntregas = objetivoDiario.obj.Entregas__c + objetivoMensual.entregasPorEjecutivo;
               objetivoDiario.planificacionDiariaVOC = objetivoDiario.obj.VOC__c + objetivoMensual.VOCPorEjecutivo;
            }
        }        
    }
    
    
    public Integer calcularTotales()
    {
        totCumpLeadsEjecutivo = 0;
        totCumpProspectosEjecutivo = 0;
        totCumpTestDrivesEjecutivo = 0;
        totCumpVentasEjecutivo = 0;
        totCumpEntregasEjecutivo = 0;
        totCumpVOCEjecutivo = 0;

        totCumpLeads = 0;
        totCumpProspectos = 0;
        totCumpTestDrives = 0;
        totCumpVentas = 0;
        totCumpEntregas = 0;
        totCumpVOC = 0;
        
        totAvProspectosEjecutivo = 0;
        totAvLeadsEjecutivo = 0;
        totAvTestDrivesEjecutivo = 0;
        totAvVentasEjecutivo = 0;
        totAvEntregasEjecutivo = 0;
        totAvVOCEjecutivo = 0;

        totPlanLeadsEjecutivo = 0;
        totPlanProspectosEjecutivo = 0;
        totPlanTestDrivesEjecutivo = 0;
        totPlanVentasEjecutivo = 0;
        totPlanEntregasEjecutivo = 0;
        totPlanVOCEjecutivo = 0;
        
        totPlanLeads = 0;
        totPlanProspectos = 0;
        totPlanTestDrives = 0;
        totPlanVentas = 0;
        totPlanEntregas = 0;
        totPlanVOC = 0;

        totAvDLeads = 0;
        totAvDProspectos = 0;
        totAvDTestDrives = 0;
        totAvDVentas = 0;
        totAvDEntregas = 0;
        totAvDVOC = 0;        
        
        totSenas = 0;
        totApuestas = 0;
        
        for(ObjetivoClass objCls : objetivos)
        {
            totCumpLeadsEjecutivo = totCumpLeadsEjecutivo + intVal(objCls.obj.Leads_Calificados__c);
            totCumpProspectosEjecutivo = totCumpProspectosEjecutivo + intVal(objCls.obj.Prospectos__c);
            totCumpTestDrivesEjecutivo = totCumpTestDrivesEjecutivo + intVal(objCls.obj.Test_Drives__c);
            totCumpVentasEjecutivo = totCumpVentasEjecutivo + intVal(objCls.obj.Ventas__c);
            totCumpEntregasEjecutivo = totCumpEntregasEjecutivo + intVal(objCls.obj.Entregas__c);
            totCumpVOCEjecutivo = totCumpVOCEjecutivo + intVal(objCls.obj.VoC__c);
            
            totCumpLeads = totCumpLeads + objCls.leadsCalificadosPorEjecutivo;
            totCumpProspectos = totCumpProspectos + objCls.prospectosPorEjecutivo;
            totCumpTestDrives = totCumpTestDrives + objCls.testDrivesPorEjecutivo;
            totCumpVentas = totCumpVentas + objCls.ventasPorEjecutivo;
            totCumpEntregas = totCumpEntregas + objCls.entregasPorEjecutivo;
            totCumpVOC = totCumpVOC + objCls.vocPorEjecutivo;
            
            totAvLeadsEjecutivo = totAvLeadsEjecutivo + objCls.getAvanceLeadsPorEjecutivo();
            totAvProspectosEjecutivo = totAvProspectosEjecutivo + objCls.getAvanceProspectosPorEjecutivo();
            totAvTestDrivesEjecutivo = totAvTestDrivesEjecutivo + objCls.getAvanceTestDrivesPorEjecutivo();
            totAvVentasEjecutivo = totAvVentasEjecutivo + objCls.getAvanceVentasPorEjecutivo();
            totAvEntregasEjecutivo = totAvEntregasEjecutivo + objCls.getAvanceEntregasPorEjecutivo();
            totAvVOCEjecutivo = totAvVOCEjecutivo + objCls.getAvanceVOCPorEjecutivo();

            totPlanLeadsEjecutivo = totPlanLeadsEjecutivo + objCls.getPlanificacionleadsPorEjecutivo();
            totPlanProspectosEjecutivo = totPlanProspectosEjecutivo + objCls.getPlanificacionProspectosPorEjecutivo();
            totPlanTestDrivesEjecutivo = totPlanTestDrivesEjecutivo + objCls.getPlanificacionTestDrivesPorEjecutivo();
            totPlanVentasEjecutivo = totPlanVentasEjecutivo + objCls.getPlanificacionVentasPorEjecutivo();
            totPlanEntregasEjecutivo = totPlanEntregasEjecutivo + objCls.getPlanificacionEntregasPorEjecutivo();
            totPlanVOCEjecutivo = totPlanVOCEjecutivo + objCls.getPlanificacionVOCPorEjecutivo();

        }
        
        totCumpLeadsPorc = calcularPorcentajeTotales(totCumpLeads, totCumpLeadsEjecutivo);
        totCumpProspectosPorc = calcularPorcentajeTotales(totCumpProspectos, totCumpProspectosEjecutivo);
        totCumpTestDrivesPorc = calcularPorcentajeTotales(totCumpTestDrives, totCumpTestDrivesEjecutivo);
        totCumpVentasoPorc = calcularPorcentajeTotales(totCumpVentas, totCumpVentasEjecutivo);
        totCumpEntregasPorc = calcularPorcentajeTotales(totCumpEntregas, totCumpEntregasEjecutivo);
        totCumpVOCPorc = calcularPorcentajeTotales(totCumpVOC, totCumpVOCEjecutivo);

        totAvLeads = totCumpLeads;
        totAvProspectos = totCumpProspectos;
        totAvTestDrives = totCumpTestDrives;
        totAvVentas = totCumpVentas;
        totAvEntregas = totCumpEntregas;
        totAvVOC = totCumpVOC;
        
        totAvLeadsPorc = calcularPorcentajeTotales(totAvLeads, totAvLeadsEjecutivo);
        totAvProspectosPorc = calcularPorcentajeTotales(totAvProspectos, totAvProspectosEjecutivo);
        totAvTestDrivesPorc = calcularPorcentajeTotales(totAvTestDrives, totAvTestDrivesEjecutivo);
        totAvVentasPorc = calcularPorcentajeTotales(totAvVentas, totAvVentasEjecutivo);
        totAvEntregasPorc = calcularPorcentajeTotales(totAvEntregas, totAvEntregasEjecutivo);
        totAvVOCPorc = calcularPorcentajeTotales(totAvVOC, totAvVOCEjecutivo);
        
        for(ObjetivoClass objCls : objetivosDiarios)
        {
          totPlanLeads = totPlanLeads + intVal(objCls.obj.Leads_Calificados__c);
          totPlanProspectos = totPlanProspectos + intVal(objCls.obj.Prospectos__c);
          totPlanTestDrives = totPlanTestDrives + intVal(objCls.obj.Test_Drives__c);
          totPlanVentas = totPlanVentas + intVal(objCls.obj.Ventas__c);
          totPlanEntregas = totPlanEntregas + intVal(objCls.obj.Entregas__c);
          totPlanVOC = totPlanVOC + intVal(objCls.obj.VOC__c);
          
          totAvDLeads = totAvDLeads + intVal(objCls.planificacionDiariaLeads);
          totAvDProspectos = totAvDProspectos + intVal(objCls.planificacionDiariaProspectos);
          totAvDTestDrives = totAvDTestDrives + intVal(objCls.planificacionDiariaTestDrives);
          totAvDVentas = totAvDVentas + intVal(objCls.planificacionDiariaVentas);
          totAvDEntregas = totAvDEntregas + intVal(objCls.planificacionDiariaEntregas);
          totAvDVOC = totAvDVOC + intVal(objCls.planificacionDiariaVOC);
          
        }        

        totPlanProspectosPorc = calcularPorcentajeTotales((totPlanProspectos + totAvProspectos), totAvProspectosEjecutivo);
        totPlanLeadsPorc = calcularPorcentajeTotales((totPlanLeads + totAvLeads), totAvLeadsEjecutivo);
        totPlanTestDrivesPorc = calcularPorcentajeTotales((totPlanTestDrives + totAvTestDrives), totAvTestDrivesEjecutivo);
        totPlanVentasPorc = calcularPorcentajeTotales((totPlanVentas + totAvVentas), totAvVentasEjecutivo);
        totPlanEntregasPorc = calcularPorcentajeTotales((totPlanEntregas + totAvEntregas), totAvEntregasEjecutivo);
        totPlanVOCPorc = calcularPorcentajeTotales((totPlanVOC + totAvVOC), totAvVOCEjecutivo);
        
        totSenas = 0;
        totApuestas = 0;
   
        System.debug('CT[' + senasApuestas + ']');
        
        for(Senas_Apuesta__c senAp : senasApuestas)
        {
            if(senAp.Senas__c == null)
            {
              senAp.Senas__c = 0;
            }
            totSenas = totSenas + intVal(senAp.Senas__c);
            //System.debug('CT[' + senAp + '] [' + senAp.Senas__c + ']');
            totApuestas = totApuestas + intVal(senAp.Apuesta__c);
        }        

        return 0;
    }

    private Decimal calcularPorcentajeTotales(Integer total1, Integer total2)
    {
       Decimal aux1;
       Decimal aux2;
       aux1 = total1;
       aux2 = total2;
       
       aux1 = (aux1 == null) ? 0: aux1;
       if(aux2 == 0)
       {
           return 0;
       }
       return (aux1 / aux2) * 100;
    }
    
    //------------------------------------------------- Clases
    public class ObjetivoClass
    {
        public Objetivo__c obj {get;set;}
        public String ejecutivoName {get;set;}
        public Integer ventasPorEjecutivo {get;set;}
        public Integer leadsCalificadosPorEjecutivo {get;set;}
        public Integer testDrivesPorEjecutivo {get;set;}
        public Integer prospectosPorEjecutivo {get;set;}
        public Integer entregasPorEjecutivo {get;set;}
        public Integer vocPorEjecutivo {get;set;}
        public Integer diasHabiles {get;set;}
        public Integer diasTranscurridos {get;set;}

        //------ URL reports -----------------------
        public String urlProspectos {get;set;}
        public String urlLeads {get;set;}
        public String urlTestDrives {get;set;}
        public String urlVentas {get;set;}
        public String urlEntregas {get;set;}
        public String urlVOC {get;set;}

        //------ % plaificacion--------------        
        public Decimal planificacionLeadsPorcentaje {get;set;}
        public Decimal planificacionVentasPorcentaje {get;set;}
        public Decimal planificacionTestDrivesPorcentaje {get;set;}
        public Decimal planificacionProspectosPorcentaje {get;set;}
        public Decimal planificacionEntregasPorcentaje {get;set;}
        public Decimal planificacionVOCPorcentaje {get;set;}
        
        //------ plaificacion diaria --------------
        public Decimal planificacionDiariaLeads {get;set;}
        public Decimal planificacionDiariaVentas {get;set;}
        public Decimal planificacionDiariaTestDrives {get;set;}
        public Decimal planificacionDiariaProspectos {get;set;}
        public Decimal planificacionDiariaEntregas {get;set;}
        public Decimal planificacionDiariaVOC {get;set;}
        
        public ObjetivoClass(Objetivo__c o, String n) {
            obj = o;
            ejecutivoName = n;
            prospectosPorEjecutivo = 0;
        }
        
        public ObjetivoClass(Objetivo__c o, String n, Integer dh, Integer dt) {
            obj = o;
            ejecutivoName = n;
            diasHabiles = dh;
            diasTranscurridos = dt;

            ventasPorEjecutivo = 0;
            leadsCalificadosPorEjecutivo = 0;
            testDrivesPorEjecutivo = 0;
            prospectosPorEjecutivo = 0;
            entregasPorEjecutivo = 0;
            vocPorEjecutivo = 0;

            planificacionLeadsPorcentaje = 0;
            planificacionVentasPorcentaje = 0;
            planificacionTestDrivesPorcentaje = 0;
            planificacionProspectosPorcentaje = 0;
            planificacionEntregasPorcentaje = 0;
            planificacionVOCPorcentaje = 0;
        }

        public Decimal getCumplimientoLeadPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(obj.Leads_Calificados__c, leadsCalificadosPorEjecutivo);
        }
        
        public Decimal getCumplimientoVentasPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(obj.Ventas__c, ventasPorEjecutivo);
        }

        public Decimal getCumplimientoTestDrivesPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(obj.Test_Drives__c, testDrivesPorEjecutivo);
        }

        public Decimal getCumplimientoProspectosPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(obj.Prospectos__c, prospectosPorEjecutivo);
        }

        public Decimal getCumplimientoEntregasPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(obj.Entregas__c, entregasPorEjecutivo);
        }

        public Decimal getCumplimientoVOCPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(obj.VoC__c, vocPorEjecutivo);
        }
        
        public Decimal getContactosDiarios()
        {
            Decimal resultado = 0;
            if(diasHabiles == 0)
            {
               return 0;
            }
            if(obj.Leads_Calificados__c == null)
            {
                resultado = 0;
            }
            else
            {
               resultado = obj.Leads_Calificados__c/diasHabiles;
            }
            resultado = resultado.round(System.RoundingMode.HALF_UP);
            return resultado;
        }
        

        //------------------------------- Avance -------------------------------------------------------
        public Integer getAvanceProspectosPorEjecutivo()
        {
            return calcularAvancePorEjecutivo(obj.Prospectos__c);
        }
                
        public Integer getAvanceLeadsPorEjecutivo()
        {
            return calcularAvancePorEjecutivo(obj.Leads_Calificados__c);
        }

        public Integer getAvanceTestDrivesPorEjecutivo()
        {
            return calcularAvancePorEjecutivo(obj.Test_Drives__c);
        }

        public Integer getAvanceVentasPorEjecutivo()
        {
            return calcularAvancePorEjecutivo(obj.Ventas__c);
        }
        
        public Integer getAvanceEntregasPorEjecutivo()
        {
            return calcularAvancePorEjecutivo(obj.Entregas__c);
        }

        public Integer getAvanceVOCPorEjecutivo()
        {
            return calcularAvancePorEjecutivo(obj.VoC__c);
        }
        
        private Integer calcularAvancePorEjecutivo(Decimal valor)
        {
           Integer result;        
           Decimal diasT = diasTranscurridos;
           Decimal diasH = diasHabiles;
           if(valor == null)
           {
              valor = 0;
           }
           if(diasH == 0)
           {
              return 0; 
           }
           //System.debug('diasT[' + diasT + '] diasH[' + diasH + '] valor[' + valor + ']');
           Decimal calculo = (diasT / diasH) * valor;
           result = (Integer)calculo.round(System.RoundingMode.HALF_UP);
           return result;
        }

        //-------------------------------% Avance -------------------------------------------------------        
        public Decimal getAvanceLeadPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(getAvanceLeadsPorEjecutivo(), leadsCalificadosPorEjecutivo);
        }
        
        public Decimal getAvanceVentasPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(getAvanceVentasPorEjecutivo(), ventasPorEjecutivo);
        }

        public Decimal getAvanceTestDrivesPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(getAvanceTestDrivesPorEjecutivo(), testDrivesPorEjecutivo);
        }

        public Decimal getAvanceProspectosPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(getAvanceProspectosPorEjecutivo(), prospectosPorEjecutivo);
        }

        public Decimal getAvanceEntregasPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(getAvanceEntregasPorEjecutivo(), entregasPorEjecutivo);
        }

        public Decimal getAvanceVOCPorcentaje()
        {
            return UtilFunctions.calcularPorcentaje(getAvanceVOCPorEjecutivo(), vocPorEjecutivo);
        }
        
        //-------------------------------Planificacion Ejecutivo -------------------------------------------------------  

        public Integer getPlanificacionProspectosPorEjecutivo()
        {
            return getAvanceProspectosPorEjecutivo() - prospectosPorEjecutivo;
        }

        public Integer getPlanificacionLeadsPorEjecutivo()
        {
            return getAvanceLeadsPorEjecutivo() - leadsCalificadosPorEjecutivo;
        }

        public Integer getPlanificacionTestDrivesPorEjecutivo()
        {
            return getAvanceTestDrivesPorEjecutivo() - testDrivesPorEjecutivo;
        }

        public Integer getPlanificacionVentasPorEjecutivo()
        {
            return getAvanceVentasPorEjecutivo() - ventasPorEjecutivo;
        }

        public Integer getPlanificacionEntregasPorEjecutivo()
        {
            return getAvanceEntregasPorEjecutivo() - entregasPorEjecutivo;
        }

        public Integer getPlanificacionVOCPorEjecutivo()
        {
            return getAvanceVOCPorEjecutivo() - vocPorEjecutivo;
        }

    }


   //------------------------------------------------- Clases

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

    public void changeSucursal()
    {
       System.debug('SUC[' + selectedSucursal +']');
       calculate();
    }


    public void calculate()
    {
       initData();
       initDailyData();
       setURLReports();
       calcularPorcentajePlanificacion();
       initDataAutoDemo();
       initDataSenasApuestas();
       calcularTotales();
       canEdit = initCanEdit();
       canDisplayPanel = true;
       if(dateIni.year() < currentIntYear)
       {
          canEdit = false;
          canDisplayPanel = false;
       }

       if(dateIni.year() == currentIntYear && dateIni.month() < currentIntMonth)
       {
          canEdit = false;
          canDisplayPanel = false;
       }
    }
    
   //------------------------------------------------- Clases    

    public boolean initCanEdit(){
        //return true;
        
        User u = [SELECT Sucursal__c,
                    Profile.Name
                    FROM User
                    WHERE Id = :UserInfo.getUserId()];
        system.debug('SUC: ' + u.Sucursal__c + ' Prof: ' + u.Profile.Name);
        system.debug('Selected SUC: ' + selectedSucursal + ' Prof: ' + GERENCIA_COMERCIAL);
        if(u.Profile.Name == GERENCIA_CRM)
        {
            return true;
        }        
        if(u.Sucursal__c == selectedSucursal && u.Profile.Name == GERENCIA_COMERCIAL)
        {
            return true;
        }
        return false;
    }
    
    public Integer intVal(Decimal d){
        if(d == null){
            return 0;
        }
        return Integer.valueOf(d);
    }


}