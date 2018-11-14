public class PlanificacionPorEjecutivo
{
    public Integer prospectosDiarioAvance {get; set;}
    public Integer prospectosDiarioObjetivo {get; set;}    
    public Integer leadsDiarioAvance {get; set;}
    public Integer leadsDiarioObjetivo {get; set;}    
    public Integer testDrivesDiarioAvance {get; set;}
    public Integer testDrivesDiarioObjetivo {get; set;}    
    public Integer ventasDiarioAvance {get; set;}
    public Integer ventasDiarioObjetivo {get; set;}    

    public Integer prospectosMensualAvance {get; set;}
    public Integer prospectosMensualObjetivo {get; set;}    
    public Integer leadsMensualAvance {get; set;}
    public Integer leadsMensualObjetivo {get; set;}    
    public Integer testDrivesMensualAvance {get; set;}
    public Integer testDrivesMensualObjetivo {get; set;}
    public Integer ventasMensualAvance {get; set;}
    public Integer ventasMensualObjetivo {get; set;}
    
    private String userId;
    private String userName;
    private String userSucursal;
    public static final String MENSUAL_E = 'Mensual Ejecutivo';
    public static final String DIARIO_E = 'Diario Ejecutivo';
    public static final String OPP_CERRADA_GANADA = 'Cerrada/Ganada';
    public static final String OPP_CALIFICADO = 'Calificado';
    public static final String OPP_TEST_DRIVE = 'Prueba de manejo';
    
    public List<String> tiposProducto {get;set;}
    public List<String> tiposProductoCENTRAL {get;set;}
    public List<String> tiposProductoBPS {get;set;}    
    
    private Date fechaActual;
    public Integer currentIntMonth {get; set;}
    public Integer currentIntYear {get; set;}

    public Map<String, Report_Link__mdt> reportURL {get; set;}

    private static final String OP_M_PROSPECTOS = 'OP_M_Prospectos';
    private static final String OP_M_LEADS = 'OP_M_Leads';
    private static final String OP_M_TD = 'OP_M_TD';
    private static final String OP_M_VENTAS = 'OP_M_Ventas';

    public String OP_M_Prospectos_url {get; set;}
    public String OP_M_Leads_url {get; set;}
    public String OP_M_TD_url {get; set;}
    public String OP_M_Ventas_url {get; set;}

    public String OP_D_Prospectos_url {get; set;}
    public String OP_D_Leads_url {get; set;}
    public String OP_D_TD_url {get; set;}
    public String OP_D_Ventas_url {get; set;}

    public PlanificacionPorEjecutivo()
    {
       tiposProducto = new List<String>();
       tiposProductoCENTRAL = new List<String>();
       tiposProductoBPS = new List<String>();
    
       fechaActual =  Date.Today();//Date.newInstance(2018, 10, 19); 
       currentIntMonth = fechaActual.month();
       currentIntYear = fechaActual.year();
       reportURL = PerfectaDAO.getCustomMetadata();
       initTiposProducto();
       initUserInfo();
       loadURLs();       
       loadMonthData();
       loadDailyData();
    }
    
    private void initUserInfo()
    {
       User u = [SELECT Id,
                        Sucursal__c,
                        Name,
                        Profile.Name
                   FROM User
                   WHERE Id = :UserInfo.getUserId()];
       System.debug('U [' + u.id + '] N [' + u.Name + ']');
       userId = u.Id;
       userName = u.Name;
       userSucursal = u.Sucursal__c;
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


    private void loadURLs()
    {
      OP_M_Prospectos_url = buildReportURL(OP_M_PROSPECTOS, false);
      OP_M_Leads_url = buildReportURL(OP_M_LEADS, false);
      OP_M_TD_url = buildReportURL(OP_M_TD, false);
      OP_M_Ventas_url = buildReportURL(OP_M_VENTAS, false);

      OP_D_Prospectos_url = buildReportURL(OP_M_PROSPECTOS, true);
      OP_D_Leads_url = buildReportURL(OP_M_LEADS, true);
      OP_D_TD_url = buildReportURL(OP_M_TD, true);
      OP_D_Ventas_url = buildReportURL(OP_M_VENTAS, true);
    }

    private String buildReportURL(String report, Boolean diario)
    {
        Report_Link__mdt reportMetadata;
        String urlReport = '';
        reportMetadata = reportURL.get(report);

       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       if(diario)
       {
          fechaIni = fechaActual;
          fechaFin = fechaActual;
       }
       else
       {
          fechas = UtilFunctions.getInterval(currentIntYear, currentIntMonth, currentIntMonth);
          fechaIni = fechas.get(0);
          fechaFin = fechas.get(1);
       }

      String strFechaIni = fechaIni.month() + '/' + fechaIni.day() + '/' + fechaIni.year();
      String strFechaFin = fechaFin.month() + '/' + fechaFin.day() + '/' + fechaFin.year();      

        if(reportMetadata != null)
        {
           if(report == OP_M_TD)
           {
              urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + userName;
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
           }
           if(report == OP_M_LEADS)
           {
              urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + userName;
              urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
              urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
              urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + userSucursal;
           }
           if(report == OP_M_VENTAS)
           {
              urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + userName;
              urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + OPP_CERRADA_GANADA;              
              urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
              urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;
              urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + userSucursal;
           }
        }

        System.debug('URL Report [' + urlReport + ']');
        return urlReport;
    }

    private void loadMonthData()
    {
    
       List<AggregateResult> resultQuery;
        
       String baseQuery = 'SELECT SUM(Prospectos__c) sumProspectos, ' + 
                                 'SUM(Leads_Calificados__c) sumLeads, ' +
                                 'SUM(Ventas__c) sumVentas, ' +
                                 'SUM(Test_Drives__c) sumTD, ' +
                                 'SUM(Ofertas__c) sumOfertas, ' +
                                 'SUM(Entregas__c) sumEntregas, ' +
                                 'SUM(VoC__c) sumVOC ' +
                             'FROM Objetivo__c ' +
                           'WHERE Tipo__c  = :MENSUAL_E ' +
                             'AND Anio__c = :currentIntYear ' +
                             'AND Mes__c = :currentIntMonth ' + 
                             'AND Ejecutivo__r.Id = :userId';
                              
        resultQuery = Database.query(baseQuery);
        System.debug('query[' + baseQuery + '] res.size[' + resultQuery.size() + '] [' + currentIntMonth+ ']');
        
        Decimal value;
        for (AggregateResult ar : resultQuery)
        {
            value = (Decimal)ar.get('sumProspectos');
            prospectosMensualObjetivo = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumTD');
            testDrivesMensualObjetivo = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumLeads');
            leadsMensualObjetivo = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumVentas');
            ventasMensualObjetivo = value == null ? 0 : value.intValue();
        }                              
    
      //-------- Objetivos mensuales 
    
        

      //-------- Avance mensual
      prospectosMensualAvance = getProspectosPorEjecutivo(userId, false);
      prospectosMensualAvance = (prospectosMensualAvance == null) ? 0 : prospectosMensualAvance;
      leadsMensualAvance = getLeadsPorEjecutivo(userId, OPP_CALIFICADO, false);
      leadsMensualAvance = (leadsMensualAvance == null) ? 0 : leadsMensualAvance;
      testDrivesMensualAvance = getTestDrivesPorEjecutivo(userId, OPP_TEST_DRIVE, false);
      testDrivesMensualAvance = (testDrivesMensualAvance == null) ? 0 : testDrivesMensualAvance;
      ventasMensualAvance = getVentasPorEjecutivo(userId, OPP_CERRADA_GANADA, false);
      ventasMensualAvance = (ventasMensualAvance == null) ? 0 : ventasMensualAvance;
    }
 
 
    private Integer getProspectosPorEjecutivo(String idEjecutivo, Boolean diario)
    {
       Integer prospectosEjecutivo;

       AggregateResult[] results = null;
       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       if(diario)
       {
          fechaIni = fechaActual;
          fechaFin = fechaActual;
       }
       else
       {
          fechas = UtilFunctions.getInterval(currentIntYear, currentIntMonth, currentIntMonth);
          fechaIni = fechas.get(0);
          fechaFin = fechas.get(1);
       }
       
       System.debug('prospectos por ejecutivo id[' + idEjecutivo + ']  fechaCierre[' + fechaIni + ']');
       /*
       results = [SELECT Owner.id idus, 
                         COUNT(Id) countP 
                    FROM Task 
                   WHERE Subject = 'Contacto de Prospección' 
                     AND Owner.id = :idEjecutivo 
                     AND ActivityDate >= :fechaIni
                     AND ActivityDate <= :fechaFin 
                   GROUP BY Owner.id];

       for (AggregateResult ar : results) 
       {
          prospectosEjecutivo = (Integer)ar.get('countP');
       }
       prospectosEjecutivo = (prospectosEjecutivo == null) ? 0 : prospectosEjecutivo;*/
       List<Id> idsEjecutivos = new List<Id>();
       idsEjecutivos.add(idEjecutivo);
       Map<String, Integer> mapEjNumProspectos = PerfectaDAO.getProspectsByExec(idsEjecutivos, 'Contacto de Prospección', tiposProducto, fechaIni, fechaFin);
       prospectosEjecutivo = mapEjNumProspectos.get(idEjecutivo);
       return prospectosEjecutivo;
    }
    
    private Integer getOportunidadPorEjecutivo(String idEjecutivo, String estadoOportunidad, Boolean diario)
    {
       Integer result;
       AggregateResult[] results = null;
       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       if(diario)
       {
          fechaIni = fechaActual;
          fechaFin = fechaActual;
       }
       else
       {
          fechas = UtilFunctions.getInterval(currentIntYear, currentIntMonth, currentIntMonth);
          fechaIni = fechas.get(0);
          fechaFin = fechas.get(1);
       }
       
       results = [SELECT Owner.id idus, 
                         Owner.Name nameus, 
                         count(id) countN 
                    FROM Opportunity  
                   WHERE Owner.Id = :idEjecutivo
                     AND Stagename = :estadoOportunidad
                     AND Closedate >= :fechaIni
                     AND Closedate <= :fechaFin
                GROUP BY Owner.id, Owner.name];

       for (AggregateResult ar : results) 
       {
          result = (Integer)ar.get('countN');
       }
       result = result == null ? 0 : result;
       System.debug('OP EJ  id[' + idEjecutivo + '] st[' + estadoOportunidad + '] fi[' + fechaIni + '] ff[' + fechaFin + '] RES[' + result + ']');
       return result;
    }


    private Integer getVentasPorEjecutivo(String idEjecutivo, String estadoOportunidad, Boolean diario)
    {
       Integer ventas;
       AggregateResult[] results = null;
       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       if(diario)
       {
          fechaIni = fechaActual;
          fechaFin = fechaActual;
       }
       else
       {
          fechas = UtilFunctions.getInterval(currentIntYear, currentIntMonth, currentIntMonth);
          fechaIni = fechas.get(0);
          fechaFin = fechas.get(1);
       }

       results = [select Owner.id idus, 
                         Owner.Name nameus, 
                         count(id) countN 
                    from Opportunity  
                   where Owner.Id = :idEjecutivo
                     and stagename = :estadoOportunidad
                     and Fecha_de_Venta__c >= :fechaIni
                     and Fecha_de_Venta__c < :fechaFin                    
                group by owner.id, owner.name];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ventas = (Integer)ar.get('countN');
       }
       return ventas;
    }

    private Integer getLeadsPorEjecutivo(String idEjecutivo, String estadoOportunidad, Boolean diario)
    {
       Integer leads;
       AggregateResult[] results = null;
       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       if(diario)
       {
          fechaIni = fechaActual;
          fechaFin = fechaActual;
       }
       else
       {
          fechas = UtilFunctions.getInterval(currentIntYear, currentIntMonth, currentIntMonth);
          fechaIni = fechas.get(0);
          fechaFin = fechas.get(1);
       }

       System.debug('LEADS PE fini[' + fechaIni + '] ffin[' + fechaFin + '] stage[' + estadoOportunidad + ']');
       
       results = [select Owner.id idus, 
                         Owner.Name nameus, 
                         count(id) countN 
                    from Opportunity  
                   where Owner.Id = :idEjecutivo
                     //and stagename = :estadoOportunidad
                     and DAY_ONLY(convertTimeZone(CreatedDate)) >= :fechaIni
                     and DAY_ONLY(convertTimeZone(CreatedDate)) <= :fechaFin
                group by owner.id, owner.name];

       for (AggregateResult ar : results) 
       {
          //System.debug('LDS owid[' + ar.get('idus') + '] -' + ar.get('nameus')+'-'+ar.get('countN'));
          leads = (Integer)ar.get('countN');
       }
       
       return leads;
    }


    private Integer getTestDrivesPorEjecutivo(String idEjecutivo, String estadoOportunidad, Boolean diario)
    {
       Integer testDrives;
       AggregateResult[] results = null;
       Date fechaIni;
       Date fechaFin;
       List<Date> fechas;

       if(diario)
       {
          fechaIni = fechaActual;
          fechaFin = fechaActual;
       }
       else
       {
          fechas = UtilFunctions.getInterval(currentIntYear, currentIntMonth, currentIntMonth);
          fechaIni = fechas.get(0);
          fechaFin = fechas.get(1);
       }

       
       results = [select COUNT(Id) countN, 
                         CreatedById idEj
                    FROM Prueba_de_manejo__c  
                   WHERE DAY_ONLY(convertTimeZone(Createddate)) >= :fechaIni
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) < :fechaFin
                     AND CreatedById = :idEjecutivo
                GROUP BY CreatedById];

       for (AggregateResult ar : results) 
       {
          //System.debug('TD owid[' + ar.get('idEj') + '] -' + ar.get('nameus')+'-'+ar.get('countN'));
          testDrives = (Integer)ar.get('countN');
       }
       return testDrives;
    }

    private void loadDailyData()
    {
       Objetivo__c objetivoPorEjecutivo;    
       List<Objetivo__c> objetivosDiarios = 
                               [SELECT Id,
                                       Ejecutivo__c,
                                       Ejecutivo__r.Name,
                                       Prospectos__c,
                                       Leads_Calificados__c,                                        
                                       Ventas__c,
                                       Test_Drives__c
                                  FROM Objetivo__c
                                 WHERE Tipo__c = :DIARIO_E
                                   AND Fecha_Planificacion__c = :fechaActual
                                   AND Ejecutivo__r.Id = :userId
                              ORDER BY Ejecutivo__r.Name];

        System.debug('OBJETDDX [' + objetivosDiarios.size() + '] [' + userId + '] [' + DIARIO_E + '] [' + fechaActual + ']');

       ventasDiarioObjetivo = 0;
       testDrivesDiarioObjetivo = 0;
       leadsDiarioObjetivo = 0;
       prospectosDiarioObjetivo = 0;
       
       if(!objetivosDiarios.isEmpty())
       {
          objetivoPorEjecutivo = objetivosDiarios.get(0);
 
          prospectosDiarioObjetivo = objetivoPorEjecutivo.Prospectos__c == null ? 0 : (Integer)objetivoPorEjecutivo.Prospectos__c;
          leadsDiarioObjetivo = objetivoPorEjecutivo.Leads_Calificados__c == null ? 0 : (Integer)objetivoPorEjecutivo.Leads_Calificados__c;
          testDrivesDiarioObjetivo = objetivoPorEjecutivo.Test_Drives__c == null ? 0 : (Integer)objetivoPorEjecutivo.Test_Drives__c;
          ventasDiarioObjetivo = objetivoPorEjecutivo.Ventas__c == null ? 0 : (Integer)objetivoPorEjecutivo.Ventas__c;
          System.debug('OBJ Diario  ventas[' + ventasDiarioObjetivo + '] td[' + testDrivesDiarioObjetivo + '] lc[' + leadsDiarioObjetivo + '] pr[' + prospectosDiarioObjetivo + ']');
       }
       
      //-------- Avance mensual
      prospectosDiarioAvance = getProspectosPorEjecutivo(userId, true);
      prospectosDiarioAvance = (prospectosDiarioAvance == null) ? 0 : prospectosDiarioAvance;
      leadsDiarioAvance = getLeadsPorEjecutivo(userId, OPP_CALIFICADO, true);
      leadsDiarioAvance = (leadsDiarioAvance == null) ? 0 : leadsDiarioAvance;
      testDrivesDiarioAvance = getTestDrivesPorEjecutivo(userId, OPP_TEST_DRIVE, true);
      testDrivesDiarioAvance = (testDrivesDiarioAvance == null) ? 0 : testDrivesDiarioAvance;
      ventasDiarioAvance = getVentasPorEjecutivo(userId, OPP_CERRADA_GANADA, true);
      ventasDiarioAvance = (ventasDiarioAvance == null) ? 0 : ventasDiarioAvance;
 
    }

}