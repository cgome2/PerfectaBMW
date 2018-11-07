/**
*   Controller for Scorecards.page
*
*/
public with sharing class Scorecards {

    List<User> users;
    public list<SelectOption> yearsPeriodOpts {get;set;}
    public String selectedYear {get;set;}
    public String selectedSucursales {get;set;}
    public list<SelectOption> monthsPeriodOpts {get;set;}
    public String selectedMonth {get;set;}
    public String selectedMonthLabel {get;set;}
    
    public Map<String, PerfectaPeriodo> mapYearsPeriods {get; set;}

    public List<Map<String, ProspectoInformacion>> prospectosInfoList;
        
    public list<SelectOption> periodOpts {get;set;}
    public String period {get;set;}
    public List<UIFigure> conosEjecutivo {get;set;}
    public List<UIFigure> conosVentasFuenteOrigen {get;set;}
    public List<UIFigure> conosGeneralVentas {get;set;}

    public List<UITableEjecutivo> tablasEjecutivo {get;set;}
    public List<UITableScorecard> tablasVentasFuente {get;set;}
    public List<UITableScorecard> tablasCampanias {get;set;}    
    
    public ScorecardSetTable conjuntoTablas{get;set;}
    public ScorecardSingleSetTable conjuntoTablasVentasFuente{get;set;}
    public ScorecardSingleSetTable conjuntoTablasCampanias{get;set;}    
        
    public ScorecardTotalesObjetivo totalesObjetivo {get;set;}
    public Integer totalProspectosLogrados {get;set;}
    public Integer totalVentasLogradas {get;set;}
    public Integer totalTDLogrados {get;set;}
    public Integer totalLeadsLogrados {get;set;}
    public Integer totalOfertasLogrados {get;set;}
    public Integer totalEntregadosLogrados {get;set;}
    public Integer totalVOCLogrados {get;set;}    
    public Integer totalObjetivoProspectos {get;set;}
    public Decimal prospectosObjetivoPorcentaje {get;set;}
    public Decimal prospectosLogradosPorcentaje {get;set;}    
    
    public Integer totalVentasConquista {get;set;}
    public Integer totalVentasLealtad {get;set;}
    public Decimal totalVentasConquistaPorcentaje {get;set;}
    public Decimal totalVentasLealtadPorcentaje {get;set;}

    public Integer totalVentasCash {get;set;}
    public Integer totalVentasFS {get;set;}
    public Decimal totalVentasCashPorcentaje {get;set;}
    public Decimal totalVentasFSPorcentaje {get;set;}

    public Integer totalVentasRetail {get;set;}
    public Integer totalVentasWholesale {get;set;}
    public Decimal totalVentasRetailPorcentaje {get;set;}
    public Decimal totalVentasWholesalePorcentaje {get;set;}
    
    public Integer totalVentasEntrega {get;set;}
    public Decimal totalVentasEntregaPorcentaje {get;set;}
      
    public String selectedSucursal {get;set;}        
    
    public List<String> typesProductStr {get;set;}
    public String selectedTypeProduct {get;set;}
    public String selectedTiposProducto {get;set;}
    
    public static final String USUARIO_VENTAS = 'Usuario de Ventas';
    public static final String MENSUAL_E = 'Mensual Ejecutivo';
    public static final String MENSUAL_FUENTE = 'Mensual Origen';
    public static final String OPP_CERRADA_GANADA = 'Cerrada/Ganada';
    public static final String OPP_CALIFICADO = 'Calificado';
    public static final String OPP_TEST_DRIVE = 'Prueba de manejo';
    
    public static final String CRM_CAMP_RT = 'CRM_Satisf';

    private Date fechaActual;
    public Integer currentIntMonth {get; set;}
    public Integer currentIntYear {get; set;} 
    
    private Date dateIni;
    private Date dateEnd;

    //ventas perdidas
    public Map<String, String> razonesVentasPerdidas;
    public List<VentaPerdida> listVentasPerdidas {get; set;}
    public Integer totalVentasPerdidas {get; set;}
    
    // URL reports --------------------------------------------------------------
    public Map<String, Report_Link__mdt> reportURL {get; set;}

    private Map<String, String> fuenteOrigenMap {get; set;}

    public String urlTotalVentasLogradas {get;set;}
    public String urlTotalVentasRetail {get;set;}
    public String urlTotalVentasWholesale {get;set;}
    public String urlTotalVentasEntregas {get;set;}
    public String urlTotalVentasCash {get;set;}
    public String urlTotalVentasTerminacionesFS {get;set;}

    private static final String OP_M_PROSPECTOS = 'OP_M_Prospectos';
    private static final String OP_M_LEADS = 'OP_M_Leads';
    private static final String OP_M_TD = 'OP_M_TD';
    private static final String OP_M_VENTAS = 'OP_M_Ventas';
    private static final String OP_M_ENTREGAS = 'OP_M_Entregas';
    private static final String OP_M_VOC = 'OP_M_VOC';

    private static final String OP_FO_M_PROSPECTOS = 'OP_FO_M_Prospectos';
    private static final String OP_FO_M_LEADS = 'OP_FO_M_Leads';
    private static final String SC_FO_TD = 'SC_FO_TD';
    private static final String OP_FO_M_VENTAS = 'OP_FO_M_Ventas';
    private static final String OP_FO_M_ENTREGAS = 'OP_FO_M_Entregas';
    private static final String OP_FO_M_VOC = 'OP_FO_M_VOC';


    public Scorecards() {
        
        totalProspectosLogrados = 0;
        fechaActual = Date.Today();
        currentIntMonth = fechaActual.month();
        currentIntYear = fechaActual.year();    
        periodOpts = initPeriodOpts();
        period = String.valueOf(currentIntMonth);

        fuenteOrigenMap = PerfectaDAO.getFuentesOrigenLabel();

        initSucursalesCheckbox();
        initTypesProductCheckbox();        
        setDateInterval();
        this.reportURL = PerfectaDAO.getCustomMetadata();        
        setUrlReports();
        users = PerfectaDAO.getUsers(selectedSucursal, USUARIO_VENTAS);
        loadRazonesVentasPerdidas();
        System.debug('SCorecards--------');
        calculate();
    }

/********************** Action Handlers ***********************/


/********** Initializers / Data Fetching Methods / Utilities ***********/

    private list<SelectOption> initPeriodOpts() {
    
        list<SelectOption> opts = new list<SelectOption>();
        List<PerfectaPeriodo> yearsPeriodos = new List<PerfectaPeriodo>(); 
        
        mapYearsPeriods = new Map<String, PerfectaPeriodo>();
        yearsPeriodOpts = new list<SelectOption>();
        
        System.debug('initP cy[' + currentIntYear + ']');
        yearsPeriodos = UtilFunctions.yearsBackFromCurrent(5, currentIntYear, 'all');
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
        //System.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
        //opts.add(new SelectOption('AC', 'Año completo - 2018')); 
        return opts;
    }
    
    private String genPOLabel(Integer month, Integer year){
        return UtilFunctions.getMonth(month) + ' - ' + String.valueOf(year);
    }

   public class picklistClass{
        public boolean selected{get;set;}
        public string picklistString{get;set;}
    }    
    
    public list<picklistClass> sucursalesss{get;set;}
    public list<picklistClass> tiposproducto{get;set;}
    
    public void initSucursalesCheckbox(){
        if(sucursalesss == null){
            sucursalesss = new list<picklistClass>();
            Schema.DescribeFieldResult sucurList = User.Sucursal__c.getDescribe();
            List<Schema.PicklistEntry> plv = sucurList.getPicklistValues();
            picklistClass tempPicklist;
            selectedSucursal='';
            for( Schema.PicklistEntry pickListVal : plv){
                tempPicklist = new picklistClass();
                tempPicklist.picklistString = pickListVal.getLabel();
                tempPicklist.selected = true;
                sucursalesss.add(tempPicklist);
                if(selectedSucursal == ''){
                    selectedSucursal = selectedSucursal + tempPicklist.picklistString;
                } else {
                    selectedSucursal = selectedSucursal + '+' + tempPicklist.picklistString;
                }
            }
            selectedSucursales = selectedSucursal.replaceAll('\\+',',');
            System.debug('changeCheckSucursal selectedSucursales: ' + selectedSucursales);
        }
    }

    public void initTypesProductCheckbox(){
        typesProductStr = new List<String>();
        if(tiposproducto == null){
            tiposproducto = new list<picklistClass>();
            Schema.DescribeFieldResult tpList = Opportunity.Tipo_contacto__c.getDescribe();
            List<Schema.PicklistEntry> ple = tpList.getPicklistValues();
            picklistClass tmpPicklist;
            selectedTypeProduct='';
            for( Schema.PicklistEntry pickListValue : ple){
                tmpPicklist = new picklistClass();
                tmpPicklist.picklistString = pickListValue.getLabel();
                tmpPicklist.selected = true;
                tiposproducto.add(tmpPicklist);
                if(selectedTypeProduct == ''){
                    selectedTypeProduct = selectedTypeProduct + tmpPicklist.picklistString;
                } else {
                    selectedTypeProduct = selectedTypeProduct + '+' + tmpPicklist.picklistString;
                }
                typesProductStr.add(tmpPicklist.picklistString);
            }
        }
        selectedTiposProducto = selectedTypeProduct.replaceAll('\\+',',');
        System.debug('initTypesProductCheckbox initTypesProductCheckbox: ' + selectedTiposProducto);
    }

    private void loadRazonesVentasPerdidas()
    {
        razonesVentasPerdidas = new Map<String, String>();
        Schema.DescribeFieldResult razonesList = Schema.Opportunity.Razon_Perdida__c.getDescribe();
        List<Schema.PicklistEntry> ple = razonesList.getPicklistValues();
        for( Schema.PicklistEntry pickListValue : ple)
        {
           razonesVentasPerdidas.put(pickListValue.getValue(), pickListValue.getLabel());
        }
    }

    private void loadVentasPerdidas()
    {
        Integer sum = 0;
        VentaPerdida ventaPerdida;
        listVentasPerdidas = new List<VentaPerdida>();
        Map<String, Integer> ventasPerdidas;

        List<String> idUsers = new List<String>();
        for(User us : users)
        {
            idUsers.add(us.id);
        }

        //List<String> idEjecutivos, String estadoOportunidad, String profileName, Date fechaInicio, Date fechaFin, List<String> tiposProducto
        ventasPerdidas = PerfectaDAO.getOportunidadesPerdidas(idUsers, 'Cerrada/Perdida', USUARIO_VENTAS, dateIni, dateEnd, typesProductStr); 
        for(String rzv : razonesVentasPerdidas.keySet())
        {
            ventaPerdida = new VentaPerdida(razonesVentasPerdidas.get(rzv));
            ventaPerdida.cantidad = ventasPerdidas.get(rzv) == null ? 0 : ventasPerdidas.get(rzv);
            sum += ventaPerdida.cantidad;
            listVentasPerdidas.add(ventaPerdida);
        }

        for(VentaPerdida vp : listVentasPerdidas)
        {
            vp.porcentaje = UtilFunctions.caclularPorcentaje(vp.cantidad, sum);
        }
        totalVentasPerdidas = sum;
    }

    private void initTotalesObjetivo()
    {
       List<String> idUsers = new List<String>();
       totalesObjetivo = new ScorecardTotalesObjetivo();

       //Usuarios por sucursal
       system.debug('Usuarios?? ' + users.size());
       PerfectaDAO.getTotalesObjetivo(selectedSucursal, dateIni.year(), dateIni.month(), dateEnd.month(), MENSUAL_E, totalesObjetivo);

       for(User us : users)
       {
          idUsers.add(us.id);
       }

       List<Integer> resultsConquistaLealtad = PerfectaDAO.getNumeroVentasConquistaLealtad(idUsers, typesProductStr, OPP_CERRADA_GANADA, USUARIO_VENTAS, dateIni, dateEnd);
       //ventas lealtad basadas en las cuentas asociadas a oportunidades cerradas/ganadas
       totalVentasLealtad = resultsConquistaLealtad.get(0);
       //ventas conquista basadas en las cuentas asociadas a oportunidades cerradas/ganadas
       totalVentasConquista = resultsConquistaLealtad.get(1);
       
       totalVentasConquistaPorcentaje = getPorcentajeTotalesVentas(totalVentasConquista, totalVentasLealtad);
       totalVentasLealtadPorcentaje = getPorcentajeTotalesVentas(totalVentasLealtad, totalVentasConquista);
       
       List<Integer> resultsCashFS = PerfectaDAO.getVentasCash(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, typesProductStr);
       totalVentasCash = resultsCashFS.get(0);
       totalVentasFS = resultsCashFS.get(1);

       totalVentasCashPorcentaje = getPorcentajeTotalesVentas(totalVentasCash, totalVentasFS);
       totalVentasFSPorcentaje = getPorcentajeTotalesVentas(totalVentasFS, totalVentasCash);

       totalVentasRetail = PerfectaDAO.getVentasRetailOrWholesale(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, 'Retail', typesProductStr);
       totalVentasRetail = totalVentasRetail == null ? 0 : totalVentasRetail;
       totalVentasWholesale = PerfectaDAO.getVentasRetailOrWholesale(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, 'Wholesale', typesProductStr);
       totalVentasWholesale = totalVentasWholesale == null ? 0 : totalVentasWholesale;
       totalVentasRetailPorcentaje = getPorcentajeTotalesVentas(totalVentasRetail, totalVentasWholesale);
       totalVentasWholesalePorcentaje = getPorcentajeTotalesVentas(totalVentasWholesale, totalVentasRetail);
       
       totalObjetivoProspectos = PerfectaDAO.getObjetivosProspectosTotales(MENSUAL_E, dateIni, dateEnd, selectedSucursal);
       totalObjetivoProspectos = totalObjetivoProspectos == null ? 0 : totalObjetivoProspectos;

    }
    
    private void buildConoVentasEjecutivo()
    {
       Integer numValue = 0;
       Map<String, Integer> ejecutivoProspectos;
       Map<String, Integer> ejecutivoVentas;
       
       Map<String, Integer> ejecutivoTestDrives;
              
       List<String> idUsers = new List<String>();
       List<RegistroVentas> ejecutivos = new List<RegistroVentas>();
       
       System.debug('selsuc [' + selectedSucursal + ']');
       
       RegistroVentas ejecutivo;
       conosEjecutivo = new List<UIFigure>();
       tablasEjecutivo = new List<UITableEjecutivo>();       
       
       for(User us : users)
       {
          ejecutivo = new RegistroVentas();
          ejecutivo.id = us.id;
          ejecutivo.registroName = us.Name;
          ejecutivo.ventas = 0;
          ejecutivo.leadsCalificados = 0;
          ejecutivo.testDrives = 0;
          ejecutivo.prospectos = 0;
          ejecutivo.ofertas = 0;
          ejecutivo.entregados = 0;
          
          idUsers.add(ejecutivo.id);
          ejecutivos.add(ejecutivo);
       }
       
       //populate values
       Integer numProspectos = 0;
       totalProspectosLogrados = 0;


       Map<String, ProspectoInformacion> ejecutivosProspectosMap = prospectosInfoList.get(0);
       ProspectoInformacion pInfo;
       //ejecutivoProspectos = getProspectsByExec(idUsers, 'Contacto de Prospección');
       if(ejecutivosProspectosMap.size() > 0)
       {
          //System.debug('EP [' + ejecutivosProspectosMap + ']');
          for(RegistroVentas r : ejecutivos)
          {
              System.debug('r [' + r.registroName + '] [' + r.Id + ']');
              pInfo = ejecutivosProspectosMap.get(r.id);
              if(pInfo != null)
              {
                 numProspectos = (pInfo.numeroProspectos == null) ? 0 : pInfo.numeroProspectos;
                 r.prospectos = numProspectos;
                 //System.debug('r [' + r.id + '] [' + r.prospectos + ']'); 
                 r.prospectosConquista = pInfo.numeroConquista;
                 r.prospectosLealtad = pInfo.numeroLealtad;
                 //totalProspectosLogrados = totalProspectosLogrados + numProspectos;
              }
          }
       }
       totalProspectosLogrados = prospectosSummary.generatedRaw;

       //-------------------------------------- Seguimiento -------------------------------------------------
       numProspectos = 0;
       ejecutivoProspectos = getProspectsByExec(idUsers, 'Contacto de Prospección');
       if(ejecutivoProspectos.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numProspectos = ejecutivoProspectos.get(r.id);
              if(numProspectos == null)
              {
                 numProspectos = 0;
              }
              r.seguimientoProspectos = numProspectos;
          }
       }

       numProspectos = 0;
       ejecutivoProspectos = getProspectsByExec(idUsers, 'Seguimiento a Lead Calificado');
       System.debug('SEGUIMIENTO LEADS[' + ejecutivoProspectos.size() + ']');
       if(ejecutivoProspectos.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numProspectos = ejecutivoProspectos.get(r.id);
              if(numProspectos == null)
              {
                 numProspectos = 0;
              }
              r.seguimientoLeads = numProspectos;
          }
       }
       
       numProspectos = 0;
       ejecutivoProspectos = getProspectsByExec(idUsers, 'Seguimiento a Test Drive');
       if(ejecutivoProspectos.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numProspectos = ejecutivoProspectos.get(r.id);
              if(numProspectos == null)
              {
                 numProspectos = 0;
              }
              r.seguimientoTestDrives = numProspectos;
          }
       }


       numProspectos = 0;
       ejecutivoProspectos = getProspectsByExec(idUsers, 'Seguimiento a Presupuesto');
       if(ejecutivoProspectos.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numProspectos = ejecutivoProspectos.get(r.id);
              if(numProspectos == null)
              {
                 numProspectos = 0;
              }
              r.seguimientoOfertas = numProspectos;
          }
       }
       
       
       //-------------------------------------- Seguimiento -------------------------------------------------
       
              
       totalProspectosLogrados = totalProspectosLogrados == null ? 0 : totalProspectosLogrados;
       prospectosObjetivoPorcentaje = getPorcentaje(totalObjetivoProspectos, totalProspectosLogrados);
       prospectosLogradosPorcentaje = 100;
       
       numValue = 0;
       totalVentasLogradas = 0;
       ejecutivoVentas = getOportunidadesPorEjecutivo(idUsers, OPP_CERRADA_GANADA);
       if(ejecutivoVentas.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numValue = ejecutivoVentas.get(r.id);
              if(numValue == null)
              {
                 numValue = 0;
              }
              r.ventas = numValue;
              totalVentasLogradas = totalVentasLogradas + numValue;
          }
       }


       numValue = 0;
       totalLeadsLogrados = 0;
       Map<String, Integer> leadsCalificados = getOportunidadesCreadasPorEjecutivo(idUsers);
       if(leadsCalificados.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numValue = leadsCalificados.get(r.id);
              if(numValue == null)
              {
                 numValue = 0;
              }
              r.leadsCalificados = numValue;
              totalLeadsLogrados = totalLeadsLogrados + numValue;
          }
       }

       numValue = 0;
       totalTDLogrados = 0;
       Map<String, Integer> testDrives = PerfectaDAO.getTestDrives(dateIni, dateEnd, typesProductStr, idUsers);
       if(testDrives.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numValue = testDrives.get(r.id);
              if(numValue == null)
              {
                 numValue = 0;
              }
              r.testDrives = numValue;
              totalTDLogrados = totalTDLogrados + numValue;
          }
       }

       numValue = 0;
       totalOfertasLogrados = 0;
       Map<String, Integer> ofertasEjecutivo = PerfectaDAO.getOfertasEjecutivo(dateIni, dateEnd, typesProductStr);
       if(ofertasEjecutivo.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numValue = ofertasEjecutivo.get(r.id);
              if(numValue == null)
              {
                 numValue = 0;
              }
              r.ofertas = numValue;
              totalOfertasLogrados = totalOfertasLogrados + numValue;              
          }
       }       
       
       numValue = 0;
       totalEntregadosLogrados = 0;      
       Map<String, Integer> entregasEjecutivo = PerfectaDAO.getEntregasPorEjecutivo(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, typesProductStr);
       if(entregasEjecutivo.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numValue = entregasEjecutivo.get(r.id);
              if(numValue == null)
              {
                 numValue = 0;
              }
              r.entregados = numValue;
              totalEntregadosLogrados = totalEntregadosLogrados + numValue;
          }
       }

       numValue = 0;
       totalVOCLogrados = 0;
       Map<String, Integer> vocEjecutivo = PerfectaDAO.getVOCPorEjecutivo(dateIni, dateEnd, typesProductStr); 
       if(vocEjecutivo.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              numValue = vocEjecutivo.get(r.id);
              if(numValue == null)
              {
                 numValue = 0;
              }
              r.voice = numValue;
              totalVOCLogrados = totalVOCLogrados + numValue;              
          }
       }       


       List<Integer> conqLealtadValues; 
       Map<String, List<Integer>> tdConqLealtad = PerfectaDAO.getTestDrivesConquistaLealtadEjecutivo(idUsers, dateIni, dateEnd, typesProductStr);
       if(tdConqLealtad.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
             conqLealtadValues = tdConqLealtad.get(r.id);
             if(conqLealtadValues == null)
             {
                r.testDrivesConquista = 0;
                r.testDrivesLealtad = 0;
             }
             else
             {
                r.testDrivesConquista = conqLealtadValues.get(0);
                r.testDrivesLealtad = conqLealtadValues.get(1);
             }
          }       
       }
       
       Map<String, List<Integer>> leadsConqLealtad = PerfectaDAO.getLeadsConquistaLealtadEjecutivo(idUsers, dateIni, dateEnd, 'Calificado', typesProductStr);
       if(leadsConqLealtad.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
             conqLealtadValues = leadsConqLealtad.get(r.id);
             if(conqLealtadValues == null)
             {
                r.leadsCalificadosConquista = 0;
                r.leadsCalificadosLealtad = 0;
             }
             else
             {
                r.leadsCalificadosConquista = conqLealtadValues.get(0);
                r.leadsCalificadosLealtad = conqLealtadValues.get(1);
             }
          }
       }

       Map<String, List<Integer>> ofertasConqLealtad = PerfectaDAO.getOfertasConquistaLealtadEjecutivo(dateIni, dateEnd, typesProductStr);
       if(ofertasConqLealtad.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
             conqLealtadValues = ofertasConqLealtad.get(r.id);
             if(conqLealtadValues == null)
             {
                r.ofertasConquista = 0;
                r.ofertasLealtad = 0;
             }
             else
             {
                r.ofertasConquista = conqLealtadValues.get(0);
                r.ofertasLealtad = conqLealtadValues.get(1);
             }
          }       
       }
       
       Map<String, List<Integer>> ventasConqLealtad = PerfectaDAO.getVentasConquistaLealtadEjecutivo(idUsers, dateIni, dateEnd, OPP_CERRADA_GANADA, typesProductStr);
       if(ventasConqLealtad.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
             conqLealtadValues = ventasConqLealtad.get(r.id);
             if(conqLealtadValues == null)
             {
                r.ventasConquista = 0;
                r.ventasLealtad = 0;
             }
             else
             {
                r.ventasConquista = conqLealtadValues.get(0);
                r.ventasLealtad = conqLealtadValues.get(1);
             }
          }       
       }
       
       
       Map<String, List<Integer>> entregasConqLealtad = PerfectaDAO.getEntregasConquistaLealtadEjecutivo(idUsers, dateIni, dateEnd, OPP_CERRADA_GANADA, typesProductStr);
       if(entregasConqLealtad.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
             conqLealtadValues = entregasConqLealtad.get(r.id);
             if(conqLealtadValues == null)
             {
                r.entregadosConquista = 0;
                r.entregadosLealtad = 0;
             }
             else
             {
                r.entregadosConquista = conqLealtadValues.get(0);
                r.entregadosLealtad = conqLealtadValues.get(1);
             }
          }
       }
       
       Map<String, List<Integer>> vocConqLealtad = PerfectaDAO.getVOCConquistaLealtadEjecutivo(idUsers, dateIni, dateEnd, typesProductStr);
       if(vocConqLealtad.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
             conqLealtadValues = vocConqLealtad.get(r.id);
             if(conqLealtadValues == null)
             {
                r.voiceConquista = 0;
                r.voiceLealtad = 0;
             }
             else
             {
                r.voiceConquista = conqLealtadValues.get(0);
                r.voiceLealtad = conqLealtadValues.get(1);
             }
          }
       }
           

       Objetivo__c objetivo;
       Map<String, Objetivo__c> objetivosEjecutivos = PerfectaDAO.getObjetivosEjecutivos(MENSUAL_E, dateIni, dateEnd, selectedSucursal);
       if(objetivosEjecutivos.size() > 0)
       {
          for(RegistroVentas r : ejecutivos)
          {
              objetivo = objetivosEjecutivos.get(r.id);
              if(objetivo != null)
              {
                r.ventasLogrado = objetivo.Ventas__c == null ? 0 : (Integer)objetivo.Ventas__c;
                r.leadsCalificadosLogrado = objetivo.Leads_Calificados__c == null ? 0 : (Integer)objetivo.Leads_Calificados__c;
                r.testDrivesLogrado = objetivo.Test_Drives__c == null ? 0 : (Integer)objetivo.Test_Drives__c;
                r.prospectosLogrado = objetivo.Prospectos__c == null ? 0 : (Integer)objetivo.Prospectos__c;
                r.ofertasLogrado = objetivo.Ofertas__c == null ? 0 : (Integer)objetivo.Ofertas__c;
                r.entregadosLogrado = objetivo.Entregas__c == null ? 0 : (Integer)objetivo.Entregas__c;
                r.voiceLogrado = objetivo.VoC__c == null ? 0 : (Integer)objetivo.VoC__c;
                
                r.ventasPorcentaje = getPorcentaje(r.ventas, r.ventasLogrado);
                r.leadsCalificadosPorcentaje = getPorcentaje(r.leadsCalificados, r.leadsCalificadosLogrado);
                r.testDrivesPorcentaje = getPorcentaje(r.testDrivesLogrado, r.testDrives);
                r.prospectosPorcentaje = getPorcentaje(r.prospectos, r.prospectosLogrado);
                r.ofertasPorcentaje = getPorcentaje(r.ofertasLogrado, r.ofertas);
                r.entregadosPorcentaje = getPorcentaje(r.entregadosLogrado, r.entregados);
                r.voicePorcentaje = getPorcentaje(r.voiceLogrado, r.voice);
                
                r.ventasLogradoPorcentaje = getPorcentaje(r.ventas, r.leadsCalificados);
                r.leadsCalificadosLogradoPorcentaje = getPorcentaje(r.ventas, r.leadsCalificados);
                r.testDrivesLogradoPorcentaje = getPorcentaje(r.ventas, r.testDrives);
                r.prospectosLogradoPorcentaje = getPorcentaje(r.leadsCalificados,r.prospectos);
                r.ofertasLogradoPorcentaje = getPorcentaje(r.ventas, r.ofertas);
                r.entregadosLogradoPorcentaje = getPorcentaje(r.entregados, r.ventas);
                r.voiceLogradoPorcentaje = getPorcentaje(r.voice, r.entregados);
                //System.debug(' R [' + r.registroName  + '] [' + r.ventasLogrado + '] [' + r.leadsCalificadosLogrado + '] [' + r.testDrivesLogrado + '] [' + r.prospectosLogrado + '] [' + r.ofertasLogrado + '] [' + r.entregadosLogrado + '] [' + r.voiceLogrado + ']');
                //System.debug(' R [' + r.registroName  + '] [' + getPorcentaje(r.leadsCalificados,r.leadsCalificadosLogrado) + '] [' + r.leadsCalificados + '] [' + r.leadsCalificadosLogrado + '] [' + r.leadsCalificadosLogradoPorcentaje + ']');

                r.calculatePercentage();
              }
          }
       }       


       System.debug('tot prospectos [' + totalProspectosLogrados + ']');
       
       Integer ve;
       ve = PerfectaDAO.getVentasEntrega(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, typesProductStr);
       totalVentasEntrega = ve == null ? 0 : ve;
       totalVentasEntregaPorcentaje = getPorcentaje(totalVentasEntrega, totalVentasLogradas);

       Integer index = 0;
       //UITable
       UITableEjecutivo uiTablaEjecutivo;
       index = 1;
       for(RegistroVentas e : ejecutivos)
       {
          uiTablaEjecutivo = new UITableEjecutivo(e.registroName, index);
          uiTablaEjecutivo.addRecord('Prospectos','Prospectos', 'CONQ','Lealtad', 'Seguimiento', String.valueOf(e.prospectosLogrado), String.valueOf(e.prospectos),String.valueOf(e.prospectosConquista),String.valueOf(e.prospectosLealtad),String.valueOf(e.seguimientoProspectos), e.prospectosPorcentaje,e.prospectosLogradoPorcentaje,e.prospectosConquistaPorcentaje ,e.prospectosLealtadPorcentaje, buildReportURLEjecutivos(OP_M_PROSPECTOS, e.registroName));
          uiTablaEjecutivo.addRecord('Leads','Leads', '','', '', String.valueOf(e.leadsCalificadosLogrado), String.valueOf(e.leadsCalificados), String.valueOf(e.leadsCalificadosConquista), String.valueOf(e.leadsCalificadosLealtad),String.valueOf(e.seguimientoLeads),e.leadsCalificadosPorcentaje,e.leadsCalificadosLogradoPorcentaje,e.leadsCalificadosConquistaPorcentaje,e.leadsCalificadosLealtadPorcentaje, buildReportURLEjecutivos(OP_M_LEADS, e.registroName));
          uiTablaEjecutivo.addRecord('TD','TD', '','', '', String.valueOf(e.testDrivesLogrado),String.valueOf(e.testDrives), String.valueOf(e.testDrivesConquista), String.valueOf(e.testDrivesLealtad),String.valueOf(e.seguimientoTestDrives),e.testDrivesPorcentaje,e.testDrivesLogradoPorcentaje,e.testDrivesConquistaPorcentaje,e.testDrivesLealtadPorcentaje, buildReportURLEjecutivos(OP_M_TD, e.registroName));
          uiTablaEjecutivo.addRecord('Ofertas','Ofertas', '','', '', String.valueOf(e.ofertasLogrado), String.valueOf(e.ofertas), String.valueOf(e.ofertasConquista), String.valueOf(e.ofertasLealtad),String.valueOf(e.seguimientoOfertas),e.ofertasPorcentaje,e.ofertasLogradoPorcentaje,e.ofertasConquistaPorcentaje,e.ofertasLealtadPorcentaje, buildReportURLEjecutivos(OP_M_TD, e.registroName));
          uiTablaEjecutivo.addRecord('ventas','Ventas', '','', '', String.valueOf(e.ventasLogrado), String.valueOf(e.ventas), String.valueOf(e.ventasConquista), String.valueOf(e.ventasLealtad), '0',e.ventasPorcentaje,e.ventasLogradoPorcentaje,e.ventasConquistaPorcentaje,e.ventasLealtadPorcentaje, buildReportURLEjecutivos(OP_M_VENTAS, e.registroName));
          uiTablaEjecutivo.addRecord('Entregados','Entregados', '','', '', String.valueOf(e.entregadosLogrado), String.valueOf(e.entregados), String.valueOf(e.entregadosConquista), String.valueOf(e.entregadosLealtad),'0',e.entregadosPorcentaje,e.entregadosLogradoPorcentaje,e.entregadosConquistaPorcentaje,e.entregadosLealtadPorcentaje, buildReportURLEjecutivos(OP_M_ENTREGAS, e.registroName));
          uiTablaEjecutivo.addRecord('VOICE','VOICE', '','', '', String.valueOf(e.voiceLogrado),String.valueOf(e.voice), String.valueOf(e.voiceConquista), String.valueOf(e.voiceLealtad), '0',e.voicePorcentaje,e.voiceLogradoPorcentaje,e.voiceConquistaPorcentaje,e.voiceLealtadPorcentaje, buildReportURLEjecutivos(OP_M_VOC, e.registroName));
          
          tablasEjecutivo.add(uiTablaEjecutivo);
          index++;
       }       

       System.debug('CONO EJE[' + tablasEjecutivo.size() + ']');
       conjuntoTablas = new ScorecardSetTable(tablasEjecutivo);
       
    }

    private void buildConoFuenteOrigen()
    {
       Map<String, Integer> leadSourceProspectos;    
       Integer numValue;
       tablasVentasFuente = new List<UITableScorecard>();
       conosVentasFuenteOrigen = new List<UIFigure>();    
       List<RegistroVentas> fuenteOrigenVentas = new List<RegistroVentas>();
 
       RegistroVentas fuenteOrigen;
       
       List<String> idUsers = new List<String>();
       for(User us : users)
       {
          idUsers.add(us.id);
       }

       List<String> fuenteList = PerfectaDAO.getFuentesOrigen();
       
       for(String fo : fuenteList)
       {
          fuenteOrigen = new RegistroVentas();
          fuenteOrigen.registroName = fo;
          fuenteOrigenVentas.add(fuenteOrigen);
       }
       
       //populate values
       numValue = 0;       
       Map<String, Integer> tdFuenteOrigen = PerfectaDAO.getTestDrivesFuenteOrigen(idUsers, dateIni, dateEnd, typesProductStr);
       if(tdFuenteOrigen.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numValue = tdFuenteOrigen.get(r.registroName);
              numValue = numValue == null ? 0 : numValue;
              r.testDrives = numValue;
          }       
       }

       numValue = 0;
       Map<String, Integer> ofertasFuenteOrigen = PerfectaDAO.getOfertasFuenteOrigen(idUsers, dateIni, dateEnd, typesProductStr);
       System.debug('OFERTS F ORIG [' + ofertasFuenteOrigen + ']');
       if(ofertasFuenteOrigen.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numValue = ofertasFuenteOrigen.get(r.registroName);
              numValue = numValue == null ? 0 : numValue;
              r.ofertas = numValue;
          }       
       }

       numValue = 0;
       Map<String, Integer> leadsFuenteOrigen = PerfectaDAO.getOportunidadesPorFuenteOrigen(idUsers, OPP_CALIFICADO, dateIni, dateEnd, typesProductStr);
       if(leadsFuenteOrigen.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numValue = leadsFuenteOrigen.get(r.registroName);
              numValue = numValue == null ? 0 : numValue;
              r.leadsCalificados = numValue;
          }       
       }
       

       numValue = 0;
       Map<String, Integer> ventasFuenteOrigen = PerfectaDAO.getVentasPorFuenteOrigen(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, typesProductStr);
       if(ventasFuenteOrigen.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numValue = ventasFuenteOrigen.get(r.registroName);
              numValue = numValue == null ? 0 : numValue;
              r.ventas = numValue;
          }       
       }
       
       Integer numProspectos = 0;
       PSummary psumm = new PSummary();
       prospectosInfoList =  PerfectaDAO.getProspectosEjecutivoLeadSource(idUsers, typesProductStr, dateIni, dateEnd, psumm);
       prospectosSummary.generatedRaw = psumm.generatedRaw;
       prospectosSummary.retailConq = psumm.retailConq;
       prospectosSummary.wholesaleConq = psumm.wholesaleConq;

       prospectosSummary.retailConqPerc = ((Decimal)prospectosSummary.retailConq / ((Decimal)prospectosSummary.retailConq + (Decimal)prospectosSummary.wholesaleConq)) * 100;
       prospectosSummary.wholesaleConqPerc = ((Decimal)prospectosSummary.wholesaleConq / ((Decimal)prospectosSummary.retailConq + (Decimal)prospectosSummary.wholesaleConq)) * 100;

       Map<String, ProspectoInformacion> fuenteOrigenProspectos = prospectosInfoList.get(1);
       ProspectoInformacion pInfo;
       if(fuenteOrigenProspectos.size() > 0)
       {
          //System.debug('LSP [' + leadSourceProspectos + ']');
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              pInfo = fuenteOrigenProspectos.get(r.registroName);
              if(pInfo != null)
              {
                 numProspectos = (pInfo.numeroProspectos == null) ? 0 : pInfo.numeroProspectos;
                 r.prospectos = numprospectos;
                 r.prospectosConquista = pInfo.numeroConquista;
                 r.prospectosLealtad = pInfo.numeroLealtad;
              }
          }
       }

       numProspectos = 0;     
       //-------------------------------------- Seguimiento -------------------------------------------------
       leadSourceProspectos = getProspectsByLeadSource(idUsers, fuenteList, 'Contacto de Prospección', typesProductStr);
       if(leadSourceProspectos.size() > 0)
       {
          //System.debug('LSP [' + leadSourceProspectos + ']');
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numProspectos = leadSourceProspectos.get(r.registroName);
              numProspectos = (numProspectos == null) ? 0 : numProspectos;
              r.seguimientoProspectos = numProspectos;
              //r.prospectos = numprospectos;
          }
       }

       leadSourceProspectos = getProspectsByLeadSource(idUsers, fuenteList, 'Seguimiento a Lead Calificado', typesProductStr);
       if(leadSourceProspectos.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numProspectos = leadSourceProspectos.get(r.registroName);
              numProspectos = (numProspectos == null) ? 0 : numProspectos;
              r.seguimientoLeads = numProspectos;
          }
       }

       leadSourceProspectos = getProspectsByLeadSource(idUsers, fuenteList, 'Seguimiento a Test Drive', typesProductStr);
       if(leadSourceProspectos.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numProspectos = leadSourceProspectos.get(r.registroName);
              numProspectos = (numProspectos == null) ? 0 : numProspectos;
              r.seguimientoTestDrives = numProspectos;
          }
       }

       leadSourceProspectos = getProspectsByLeadSource(idUsers, fuenteList, 'Seguimiento a Presupuesto', typesProductStr);
       if(leadSourceProspectos.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              numProspectos = leadSourceProspectos.get(r.registroName);
              numProspectos = (numProspectos == null) ? 0 : numProspectos;
              r.seguimientoOfertas = numProspectos;
          }
       }


       //-------------------------------------- Seguimiento -------------------------------------------------


       
       List<Integer> conqLealtadValues; 
       Map<String, List<Integer>> tdConqLealtadFO = PerfectaDAO.getTDConquistaLealtadFuenteOrigen(idUsers, dateIni, dateEnd, typesProductStr);
       if(tdConqLealtadFO.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
             conqLealtadValues = tdConqLealtadFO.get(r.registroName);
             if(conqLealtadValues == null)
             {
                r.testDrivesConquista = 0;
                r.testDrivesLealtad = 0;
             }
             else
             {
                r.testDrivesConquista = conqLealtadValues.get(0);
                r.testDrivesLealtad = conqLealtadValues.get(1);
             }
          }       
       }


       Map<String, List<Integer>> leadsConqLealtadFO = PerfectaDAO.getOportunidadConquistaLealtadFuenteOrigen(idUsers, OPP_CALIFICADO, dateIni, dateEnd, typesProductStr);       
       if(leadsConqLealtadFO.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
             conqLealtadValues = leadsConqLealtadFO.get(r.registroName);
             if(conqLealtadValues == null)
             {
                r.leadsCalificadosConquista = 0;
                r.leadsCalificadosLealtad = 0;
             }
             else
             {
                r.leadsCalificadosConquista = conqLealtadValues.get(0);
                r.leadsCalificadosLealtad = conqLealtadValues.get(1);
             }
          }
       }


       Map<String, List<Integer>> ventasConqLealtadFO = PerfectaDAO.getVentasConquistaLealtadFuenteOrigen(idUsers, OPP_CERRADA_GANADA, dateIni, dateEnd, typesProductStr);
       if(ventasConqLealtadFO.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
             conqLealtadValues = ventasConqLealtadFO.get(r.registroName);
             if(conqLealtadValues == null)
             {
                r.ventasConquista = 0;
                r.ventasLealtad = 0;
             }
             else
             {
                r.ventasConquista = conqLealtadValues.get(0);
                r.ventasLealtad = conqLealtadValues.get(1);
             }
          }
       }

       Map<String, List<Integer>> ofertasConqLealtadFO = PerfectaDAO.getOfertasConquistaLealtadFO(idUsers, dateIni, dateEnd, typesProductStr);
       if(ofertasConqLealtadFO.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
             conqLealtadValues = ofertasConqLealtadFO.get(r.registroName);
             if(conqLealtadValues == null)
             {
                r.ofertasConquista = 0;
                r.ofertasLealtad = 0;
             }
             else
             {
                r.ofertasConquista = conqLealtadValues.get(0);
                r.ofertasLealtad = conqLealtadValues.get(1);
             }
          }
       }


       
       ScorecardTotalesObjetivo scto;
       Map<String, ScorecardTotalesObjetivo> objetivosFuenteOrigen = PerfectaDAO.getObjetivosFuenteOrigen(selectedSucursal, dateIni, dateEnd);
       if(objetivosFuenteOrigen.size() > 0)
       {
          for(RegistroVentas r : fuenteOrigenVentas)
          {
              scto = objetivosFuenteOrigen.get(r.registroName);
              if(scto != null)
              {
                r.prospectosLogrado = scto.prospectos;
                r.leadsCalificadosLogrado = scto.leads;
                r.testDrivesLogrado = scto.testDrive;
                r.ofertasLogrado = scto.ofertas;
                r.ventasLogrado = scto.ventas;
                
                r.ventasPorcentaje = getPorcentaje(r.ventas, r.ventasLogrado);
                r.leadsCalificadosPorcentaje = getPorcentaje(r.leadsCalificados,r.leadsCalificadosLogrado);
                r.testDrivesPorcentaje = getPorcentaje(r.testDrives,r.testDrivesLogrado);
                r.prospectosPorcentaje = getPorcentaje(r.prospectos,r.prospectosLogrado);
                r.ofertasPorcentaje = getPorcentaje(r.ofertas,r.ofertasLogrado);
                r.entregadosPorcentaje = getPorcentaje(r.entregados,r.entregadosLogrado);
                r.voicePorcentaje = getPorcentaje(r.voice,r.voiceLogrado);
                
                r.ventasLogradoPorcentaje = getPorcentaje(r.ventas, r.leadsCalificados);
                r.leadsCalificadosLogradoPorcentaje = getPorcentaje(r.ventas, r.leadsCalificados);
                r.testDrivesLogradoPorcentaje = getPorcentaje(r.ventas, r.testDrives);
                r.prospectosLogradoPorcentaje = getPorcentaje(r.leadsCalificados, r.prospectos);
                r.ofertasLogradoPorcentaje = getPorcentaje(r.ventas, r.ofertas);
                r.entregadosLogradoPorcentaje = getPorcentaje(r.entregados, r.ventas);
                r.voiceLogradoPorcentaje = getPorcentaje(r.voice, r.entregados);

                r.calculatePercentage();                
              }
          }       
       }
       

       // UI
       Integer index;
       UITableScorecard uiTableScore;
       index = 1;
       for(RegistroVentas r : fuenteOrigenVentas) //buildReportURLFuenteOrigen(String report, String fuenteOrigen) 
       {
           uiTableScore = new UITableScorecard(r.registroName, index); 
           uiTableScore.addRecord('Prospectos','Prospectos', 'CONQ','Lealtad', 'Seguimiento', String.valueOf(r.prospectosLogrado), String.valueOf(r.prospectos),String.valueOf(r.prospectosConquista),String.valueOf(r.prospectosLealtad),String.valueOf(r.seguimientoProspectos), r.prospectosPorcentaje,r.prospectosLogradoPorcentaje,r.prospectosConquistaPorcentaje,r.prospectosLealtadPorcentaje, buildReportURLFuenteOrigen(SC_FO_TD, r.registroName));
           uiTableScore.addRecord('Leads','Leads', '','', '', String.valueOf(r.leadsCalificadosLogrado), String.valueOf(r.leadsCalificados), String.valueOf(r.leadsCalificadosConquista), String.valueOf(r.leadsCalificadosLealtad), String.valueOf(r.seguimientoLeads),r.leadsCalificadosPorcentaje,r.leadsCalificadosLogradoPorcentaje,r.leadsCalificadosConquistaPorcentaje,r.leadsCalificadosLealtadPorcentaje, buildReportURLFuenteOrigen(SC_FO_TD, r.registroName));
           uiTableScore.addRecord('TD','TD', '','', '', String.valueOf(r.testDrivesLogrado),String.valueOf(r.testDrives), String.valueOf(r.testDrivesConquista), String.valueOf(r.testDrivesLealtad), String.valueOf(r.seguimientoTestDrives),r.testDrivesPorcentaje,r.testDrivesLogradoPorcentaje,r.testDrivesConquistaPorcentaje,r.testDrivesLealtadPorcentaje, buildReportURLFuenteOrigen(SC_FO_TD, r.registroName));
           uiTableScore.addRecord('Ofertas','Ofertas', '','', '', String.valueOf(r.ofertasLogrado), String.valueOf(r.ofertas), String.valueOf(r.ofertasConquista), String.valueOf(r.ofertasLealtad),String.valueOf(r.seguimientoOfertas),r.ofertasPorcentaje,r.ofertasLogradoPorcentaje,r.ofertasConquistaPorcentaje,r.ofertasLealtadPorcentaje, buildReportURLFuenteOrigen(SC_FO_TD, r.registroName));
           uiTableScore.addRecord('ventas','Ventas', '','', '', String.valueOf(r.ventasLogrado), String.valueOf(r.ventas), String.valueOf(r.ventasConquista), String.valueOf(r.ventasLealtad),'0',r.ventasPorcentaje,r.ventasLogradoPorcentaje,r.ventasConquistaPorcentaje,r.ventasLealtadPorcentaje, buildReportURLFuenteOrigen(SC_FO_TD, r.registroName));
           
           tablasVentasFuente.add(uiTableScore);
           index++;
       }
       
       conjuntoTablasVentasFuente = new ScorecardSingleSetTable(tablasVentasFuente); 
              
    }



    private void buildConoGeneralVentas()
    {
       conosGeneralVentas = new List<UIFigure>();    
       List<RegistroVentas> fuenteOrigenVentas = new List<RegistroVentas>();
            
       RegistroVentas fuenteOrigen;
       
       fuenteOrigen = new RegistroVentas();
       fuenteOrigen.registroName = 'General';
       fuenteOrigenVentas.add(fuenteOrigen);
       
       // UI
       UIFigure uiFigure;
       Integer index = 1;
       for(RegistroVentas r : fuenteOrigenVentas)
       {
           uiFigure = new UIFigure(r.registroName, index);
           
           
           uiFigure.addRecord('Prospectos',String.valueOf(totalProspectosLogrados) + '/' + String.valueOf(totalObjetivoProspectos));
           uiFigure.addRecord('Leads',String.valueOf(totalLeadsLogrados) + '/' + String.valueOf(totalesObjetivo.leads));
           uiFigure.addRecord('TD',String.valueOf(totalTDLogrados) + '/' + String.valueOf(totalesObjetivo.testDrive));
           uiFigure.addRecord('Ofertas',String.valueOf(totalOfertasLogrados) + '/' + String.valueOf(totalesObjetivo.ofertas));
           uiFigure.addRecord('Ventas',String.valueOf(totalVentasLogradas) + '/' + String.valueOf(totalesObjetivo.ventas));
           uiFigure.addRecord('Entrega',String.valueOf(totalVentasEntrega) + '/' + String.valueOf(totalesObjetivo.entregas));
           uiFigure.addRecord('VoC',String.valueOf(totalVOCLogrados) + '/' + String.valueOf(totalesObjetivo.voc));
           
           conosGeneralVentas.add(uiFigure);
           index++;
       }
    }
    
    
    private void buildCampanias()
    {
       List<RegistroVentas> campaniasRegsitros = new List<RegistroVentas>();
       tablasCampanias = new List<UITableScorecard>();  
       List<Campaign> campanias;
       RegistroVentas regCampania;
       Integer sum = 0;
       
       List<String> idUsers = new List<String>();
       //List<User> users = PerfectaDAO.getUsers(selectedSucursal, USUARIO_VENTAS);       
       for(User us : users)
       {
          idUsers.add(us.id);
       }
       
        
       campanias = PerfectaDAO.getCampanias(selectedSucursal, dateIni, dateEnd);

       for(Campaign camp : campanias)
       {
          regCampania = new RegistroVentas();
          regCampania.registroName = camp.Name;
          regCampania.id = camp.id;
          regCampania.prospectos = (Integer)camp.Objetivo_Invitados__c == null ? 0 : (Integer)camp.Objetivo_Invitados__c;
          regCampania.leadsCalificados = (Integer)camp.Objetivo_Leads_Calificados__c == null ? 0 : (Integer)camp.Objetivo_Leads_Calificados__c;
          regCampania.voice = (Integer)camp.Objetivo_de_Asistentes__c == null ? 0 : (Integer)camp.Objetivo_de_Asistentes__c;
          regCampania.testDrives = (Integer)camp.Objetivo_Test_Drive__c == null ? 0 : (Integer)camp.Objetivo_Test_Drive__c;
          regCampania.ofertas = (Integer)camp.Objetivo_Ofertas__c == null ? 0 : (Integer)camp.Objetivo_Ofertas__c;
          regCampania.ventas = (Integer)camp.Objetivo_Ventas__c == null ? 0 : (Integer)camp.Objetivo_Ventas__c;
          
          regCampania.voiceLogrado = (Integer)camp.Asistentes__c == null ? 0 : (Integer)camp.Asistentes__c;
          regCampania.leadsCalificadosLogrado = (Integer)camp.Confirmados__c == null ? 0 : (Integer)camp.Confirmados__c;
          regCampania.prospectosLogrado = ((Integer)camp.NumberOfLeads == null ? 0 : (Integer)camp.NumberOfLeads) + ((Integer)camp.NumberOfContacts == null ? 0 : (Integer)camp.NumberOfContacts);
          campaniasRegsitros.add(regCampania);
       }

       Integer numValue = 0;
       Map<String, Integer> tsCampanias = PerfectaDAO.getTestDriveCampania(idUsers, dateIni, dateEnd, typesProductStr);
       if(tsCampanias.size() > 0)
       {
          for(RegistroVentas r : campaniasRegsitros)
          {
              numValue = tsCampanias.get(r.id);
              numValue = (numValue == null) ? 0 : numValue;
              r.testDrivesLogrado = numValue;
          }
       }

       numValue = 0;
       Map<String, Integer> ventasCampanias = PerfectaDAO.getVentasCampania(idUsers, dateIni, dateEnd, typesProductStr);
       if(ventasCampanias.size() > 0)
       {
          for(RegistroVentas r : campaniasRegsitros)
          {
              numValue = ventasCampanias.get(r.id);
              numValue = (numValue == null) ? 0 : numValue;
              r.ventasLogrado = numValue;
          }
       }

       numValue = 0;
       Map<String, Integer> ofertasCampanias = PerfectaDAO.getOfertasCampania(idUsers, dateIni, dateEnd, typesProductStr);
       if(ofertasCampanias.size() > 0)
       {
          for(RegistroVentas r : campaniasRegsitros)
          {
              numValue = ofertasCampanias.get(r.id);
              numValue = (numValue == null) ? 0 : numValue;
              r.ofertasLogrado = numValue;
          }
       }

       List<Integer> conqLealtadValues;
       Map<String, List<Integer>> tdConquistaLealtadCampania = PerfectaDAO.getTestDriveCampaniaConquistaLealtad(idUsers, dateIni, dateEnd, typesProductStr);
       if(tdConquistaLealtadCampania.size() > 0)
       {
          for(RegistroVentas r : campaniasRegsitros)
          {
             conqLealtadValues = tdConquistaLealtadCampania.get(r.id);
             if(conqLealtadValues == null)
             {
                r.testDrivesConquista = 0;
                r.testDrivesLealtad = 0;
             }
             else
             {
                r.testDrivesConquista = conqLealtadValues.get(0);
                r.testDrivesLealtad = conqLealtadValues.get(1);
             }
          }
       }


       Map<String, List<Integer>> ofertasConquistaLealtadCampania = PerfectaDAO.getOfertasCampaniaConquistaLealtad(idUsers, dateIni, dateEnd, typesProductStr);
       if(ofertasConquistaLealtadCampania.size() > 0)
       {
          for(RegistroVentas r : campaniasRegsitros)
          {
             conqLealtadValues = ofertasConquistaLealtadCampania.get(r.id);
             if(conqLealtadValues == null)
             {
                r.ofertasConquista = 0;
                r.ofertasLealtad = 0;
             }
             else
             {
                r.ofertasConquista = conqLealtadValues.get(0);
                r.ofertasLealtad = conqLealtadValues.get(1);
             }
          }
       }


       Map<String, List<Integer>> ventasConquistaLealtadCampania = PerfectaDAO.getVentasCampaniaConquistaLealtad(idUsers, dateIni, dateEnd, typesProductStr);
       if(ventasConquistaLealtadCampania.size() > 0)
       {
          for(RegistroVentas r : campaniasRegsitros)
          {
             conqLealtadValues = ventasConquistaLealtadCampania.get(r.id);
             if(conqLealtadValues == null)
             {
                r.ventasConquista = 0;
                r.ventasLealtad = 0;
             }
             else
             {
                r.ventasConquista = conqLealtadValues.get(0);
                r.ventasLealtad = conqLealtadValues.get(1);
             }
          }
       }

         
       
       for(RegistroVentas r : campaniasRegsitros)
       {
          r.prospectosPorcentaje = getPorcentaje(r.prospectos, r.prospectosLogrado);
          r.leadsCalificadosPorcentaje = getPorcentaje(r.leadsCalificados, r.leadsCalificadosLogrado);
          r.voicePorcentaje = getPorcentaje(r.voiceLogrado, r.voiceConquista);
          r.testDrivesPorcentaje = getPorcentaje(r.testDrives, r.testDrivesLogrado);
          r.ofertasPorcentaje = getPorcentaje(r.ofertas, r.ofertasLogrado);
          r.ventasPorcentaje = getPorcentaje(r.ventas, r.ventasLogrado);
       }
       

       Integer index;
       UITableScorecard uiTableScore;
       index = 1;
       for(RegistroVentas r : campaniasRegsitros)
       {
           uiTableScore = new UITableScorecard(r.registroName, index);
           uiTableScore.addRecord('Invitados','Invitados', 'Conquista','Lealtad', '', String.valueOf(r.prospectos), String.valueOf(r.prospectosLogrado), String.valueOf(r.prospectosConquista),String.valueOf(r.prospectosLealtad),'0', r.prospectosPorcentaje, 0 , 0, 0, '');
           uiTableScore.addRecord('Confirmados','', '','', '', String.valueOf(r.leadsCalificados), String.valueOf(r.leadsCalificadosLogrado), String.valueOf(r.leadsCalificadosConquista), String.valueOf(r.leadsCalificadosLealtad), '0', r.leadsCalificadosPorcentaje, 0, 0, 0, '');
           uiTableScore.addRecord('Asistentes','', '','', '', String.valueOf(r.voice), String.valueOf(r.voiceLogrado), String.valueOf(r.voiceConquista), String.valueOf(r.voiceLealtad), '0', r.voicePorcentaje, 0, 0, 0, '');
           uiTableScore.addRecord('Test Drive','', '','', '', String.valueOf(r.testDrives), String.valueOf(r.testDrivesLogrado), String.valueOf(r.testDrivesConquista), String.valueOf(r.testDrivesLealtad), '0', r.testDrivesPorcentaje, 0, 0, 0, '');
           uiTableScore.addRecord('Ofertas','', '','', '', String.valueOf(r.ofertas), String.valueOf(r.ofertasLogrado), String.valueOf(r.ofertasConquista), String.valueOf(r.ofertasLealtad), '0', r.ofertasPorcentaje, 0, 0, 0, '');
           uiTableScore.addRecord('Ventas','', '','', '', String.valueOf(r.ventas), String.valueOf(r.ventasLogrado), String.valueOf(r.ventasConquista), String.valueOf(r.ventasLealtad), '0', r.ventasPorcentaje, 0, 0, 0, '');
           
           tablasCampanias.add(uiTableScore);
           index++;
       }
       
       conjuntoTablasCampanias = new ScorecardSingleSetTable(tablasCampanias);

    }
    
    
    /**
    *   Returns the Prospects count (Tasks with type 'Contacto de Prospección') grouped by OwnerId 
    *   
    *   We only count tasks linked to either: Account, Contact, Opportunity or Lead
    *   Dedup rule: Tasks linked to any linked Contact, Account, Opportunity only count once
    */
    private Map<String, Integer> getProspectsByExec(List<Id> idEjecutivos, String subjectTask){
        Map<String, Integer> prospectos = new Map<String, Integer>();

        Map<Id, set<Id>> ejToAccIds = new Map<Id, set<Id>>();
        Map<Id, set<Id>> ejToLeadIds = new Map<Id, set<Id>>();
        Map<Id, set<Id>> oppIdToEj = new Map<Id, set<Id>>();
        Map<Id, set<Id>> cntIdToEj = new Map<Id, set<Id>>();
        
        
        for(Task t : [SELECT OwnerId,
                            WhatId,
                            WhoId
                            FROM Task
                            WHERE Subject = :subjectTask
                            AND Owner.id IN :idEjecutivos 
                            AND ActivityDate >= :dateIni
                            AND ActivityDate <= :dateEnd]){
                            
            if(t.whatId != null && isAccount(t.whatId)){
                if(!ejToAccIds.containsKey(t.OwnerId)){
                    ejToAccIds.put(t.OwnerId, new set<Id>());
                }
                ejToAccIds.get(t.OwnerId).add(t.whatId);
            }else if(t.whoId != null && isContact(t.whoId)){
                if(!cntIdToEj.containsKey(t.whoId)){
                    cntIdToEj.put(t.whoId, new set<Id>());
                }
                cntIdToEj.get(t.whoId).add(t.OwnerId);
            }else if(t.whatId != null && isOpp(t.whatId)){
                if(!oppIdToEj.containsKey(t.whatId)){
                    oppIdToEj.put(t.whatId, new set<Id>());
                }
                oppIdToEj.get(t.whatId).add(t.OwnerId);
            }else if(t.whoId != null && isLead(t.whoId)){
                if(!ejToLeadIds.containsKey(t.OwnerId)){
                    ejToLeadIds.put(t.OwnerId, new set<Id>());
                }
                ejToLeadIds.get(t.OwnerId).add(t.whoId);
            }
        }
        //Group whatIds by related Account <-> Opportunity <-> Contact together
        for(Opportunity o : [SELECT Id,
                                    AccountId
                                    FROM Opportunity
                                    WHERE Id in :oppIdToEj.keyset()
                                    AND Tipo_contacto__c IN :typesProductStr]){
            for(Id ejecutivo : oppIdToEj.get(o.Id)){
                if(!ejToAccIds.containsKey(ejecutivo)){
                    ejToAccIds.put(ejecutivo, new set<Id>());
                }
                ejToAccIds.get(ejecutivo).add(o.AccountId);
            }
        }
        for(Contact c : [SELECT Id,
                                AccountId
                                FROM Contact
                                WHERE Id in :cntIdToEj.keyset()]){
            for(Id ejecutivo : cntIdToEj.get(c.Id)){
                if(!ejToAccIds.containsKey(ejecutivo)){
                    ejToAccIds.put(ejecutivo, new set<Id>());
                }
                ejToAccIds.get(ejecutivo).add(c.AccountId);
            }
        }
        //Build the Map adding the Count for Accounts and the count for Leads
        for(Id ejId : ejToAccIds.keyset()){
            prospectos.put(ejId, ejToAccIds.get(ejId).size());
        }
        for(Id ejId : ejToLeadIds.keyset()){
            if(!prospectos.containsKey(ejId)){
                prospectos.put(ejId, 0);
            }    
            prospectos.put(ejId, prospectos.get(ejId) + ejToLeadIds.get(ejId).size());
        }
        return prospectos;
    }
    
        


    /**
    *   Returns the Prospects count (Tasks with type 'Contacto de Prospección') grouped by LeadSource 
    *   
    *   We only count tasks linked to either: Account, Contact, Opportunity or Lead
    *   Dedup rule: Tasks linked to any linked Contact, Account, Opportunity only count once
    */
    private Map<String, Integer> getProspectsByLeadSource(List<Id> idEjecutivos, List<String> LeadSource, String subjectTask, List<String> tiposProducto){
        Map<String, Integer> prospectos = new Map<String, Integer>();

        set<Id> accIds = new set<Id>();
        set<Id> oppIds = new set<Id>();
        set<Id> cntIds = new set<Id>();
        set<Id> leadIds = new set<Id>();
        
        for(String s : LeadSource){
            prospectos.put(s, 0);
        }

        for(Task t : [SELECT OwnerId,
                            WhatId,
                            WhoId
                            FROM Task
                            WHERE Subject = :subjectTask //'Contacto de Prospección'
                            AND WhatId != null
                            AND Owner.id in :idEjecutivos 
                            AND ActivityDate >= :dateIni
                            AND ActivityDate <= :dateEnd]){
            if(t.whatId != null && isAccount(t.whatId)){
                accIds.add(t.whatId);
            }else if(t.whoId != null && isContact(t.whoId)){
                cntIds.add(t.whoId);
            }else if(t.whatId != null && isOpp(t.whatId)){
                oppIds.add(t.whatId);
            }else if(t.whoId != null && isLead(t.whoId)){
                leadIds.add(t.whoId);
            }
        }
        set<Id> alreadyCountedAcc = new set<Id>();

        //Group whatIds by related Account <-> Opportunity <-> Contact together
        for(Opportunity o : [SELECT Id,
                                    AccountId,
                                    LeadSource
                                    FROM Opportunity
                                    WHERE Id in :oppIds
                                    AND Tipo_contacto__c IN :tiposProducto
                                    order by CreatedDate desc]){
            if(!alreadyCountedAcc.contains(o.AccountId)){
                alreadyCountedAcc.add(o.AccountId);
                prospectos.put(o.LeadSource, prospectos.get(o.LeadSource) + 1);
            }
        }
        for(Contact c : [SELECT Id,
                                AccountId,
                                LeadSource
                                FROM Contact
                                WHERE Id in :cntIds
                                order by CreatedDate desc]){
            if(!alreadyCountedAcc.contains(c.AccountId)){
                alreadyCountedAcc.add(c.AccountId);
                if(c.LeadSource != null)
                {
                  prospectos.put(c.LeadSource, prospectos.get(c.LeadSource) + 1);
                }
            }
        }
        for(Account a : [SELECT Id,
                                AccountSource
                                FROM Account
                                WHERE Id in :cntIds
                                order by CreatedDate desc]){
            if(!alreadyCountedAcc.contains(a.Id)){
                alreadyCountedAcc.add(a.Id);
                prospectos.put(a.AccountSource, prospectos.get(a.AccountSource) + 1);
            }
        }
        //Add the count for Leads
        for(Lead l : [SELECT LeadSource
                        FROM Lead
                        WHERE id in :leadIds]){
            prospectos.put(l.LeadSource, prospectos.get(l.LeadSource) + 1);
        }
        return prospectos;
    }

    private map<String, String> prefToObj;
    /**
    *   Prefix to Object API Name for Account, Opportunity and Contact
    */
    private map<String, String> getPrefixToObject(){
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
    private boolean isAccount(String sId){
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
    private boolean isContact(String sId){
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
    private boolean isOpp(String sId){
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
    private boolean isLead(String sId){
        if(sId == null)
        {
           return false;
        }
        if(getPrefixToObject().get(sId.substring(0,3)) != null){
            return getPrefixToObject().get(sId.substring(0,3)) == 'Lead';
        }
        return false;
    }


    /**
    * REFACTORING: Clave variable (Ejecutivo o Fuente)
    */
    private Map<String, Integer> getOportunidadesPorEjecutivo(List<String> idEjecutivos, String estadoOportunidad)
    {

       Map<String, Integer> ventas = new Map<String, Integer>();
       AggregateResult[] results = null;

       System.debug(' GOPE [' + typesProductStr + '] idEj[' + idEjecutivos + '] edoOp[' + estadoOportunidad + '] dini[' + dateIni + '] difn[' + dateEnd + ']');
          
       results = [SELECT Owner.id idus, 
                         Owner.Name nameus, 
                         COUNT(Name) countN 
                    FROM Opportunity  
                   WHERE Owner.Id IN :idEjecutivos
                     AND Stagename = :estadoOportunidad
                     AND Tipo_contacto__c IN :typesProductStr
                     AND Fecha_de_Venta__c >= :dateIni
                     AND Fecha_de_Venta__c <= :dateEnd
                GROUP BY Owner.Id, Owner.Name];

       for (AggregateResult ar : results)
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ventas.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       
       return ventas;
    }

    private Map<String, Integer> getOportunidadesCreadasPorEjecutivo(List<String> idEjecutivos)
    {

       Map<String, Integer> ops = new Map<String, Integer>();
       AggregateResult[] results = null;

       System.debug(' GOCPE [' + typesProductStr + '] idEj[' + idEjecutivos + '] dini[' + dateIni + '] difn[' + dateEnd + ']');
          
       results = [SELECT Owner.id idus, 
                         Owner.Name nameus, 
                         COUNT(Name) countN 
                    FROM Opportunity  
                   WHERE Owner.Id IN :idEjecutivos
                     AND Tipo_contacto__c IN :typesProductStr
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) >= :dateIni
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) <= :dateEnd
                GROUP BY Owner.Id, Owner.Name];

       for (AggregateResult ar : results)
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ops.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }

       return ops;
    }


    public Decimal getVentasObjetivoPorcentaje()
    {
       Decimal x = totalVentasLogradas;
       Decimal y = totalesObjetivo.ventas;
       if(y==0)
       {
           return 0;
       }
       Decimal division = (x/y) * 100;
       System.debug('[' + totalVentasLogradas + '] [' + totalesObjetivo.ventas + '] ventasObjPorc [' + totalVentasLogradas / totalesObjetivo.ventas + ']');
       System.debug('[' + x + '] [' + y + '] ventasObjPorc [' + division + ']');       
       return division;
    }

    public Decimal getPorcentajeTotalesVentas(Integer ventaa, Integer ventab)
    {
       Decimal x = ventaa;
       Decimal y = ventab;
       x = (x == null) ? 0 : x;
       y = (y == null) ? 0 : y;       
       if(y==0 && x==0)
       {
           return 0;
       }
       Decimal division = (x/(x+y)) * 100;
       return division;
    }

    public Decimal getPorcentaje(Integer ventaa, Integer ventab)
    {
       Decimal x = ventaa == null ? 0 : ventaa;
       Decimal y = ventab == null ? 0 : ventab;
       
       if(y==0)
       {
           return 0;
       }
       Decimal division = (x/y) * 100;
       return division;
    }
    
    //-------------------------------------------- Events ----------------------------------------------

    public void changeCheckSucursal()
    {
        System.debug('Init');
        selectedSucursal = '';
        for (picklistClass plc : sucursalesss){

            if(plc.selected && selectedSucursal == ''){
                selectedSucursal = selectedSucursal + plc.picklistString;
            } else if(plc.selected && selectedSucursal != ''){
                selectedSucursal = selectedSucursal + '+' + plc.picklistString;
            }

            
        }
        selectedSucursales = selectedSucursal.replaceAll('\\+',',');
        System.debug('changeCheckSucursal selectedSucursales: ' + selectedSucursales);
        users = PerfectaDAO.getUsers(selectedSucursal, USUARIO_VENTAS);        
        System.debug('changeCheckSucursal selectedSucursal: ' + selectedSucursal);
    }

    public void changeCheckTipoProducto()
    {
        typesProductStr.clear();
        selectedTypeProduct = '';
        for (picklistClass plc : tiposproducto){
            if(plc.selected && selectedTypeProduct == ''){
                selectedTypeProduct = selectedTypeProduct + plc.picklistString;
            } else if(plc.selected && selectedTypeProduct != ''){
                selectedTypeProduct = selectedTypeProduct + '+' + plc.picklistString;
            }
            if(plc.selected)
            {
               typesProductStr.add(plc.picklistString);
            }
        }
        selectedTiposProducto = selectedTypeProduct.replaceAll('\\+',',');
        System.debug('changeCheckTipoProducto: selectedTiposProducto' + selectedTiposProducto);
        
        System.debug('CHANGE TIPO PROD[' + typesProductStr + ']');
        System.debug('changeCheckTipoProducto selectedTypeProduct: ' + selectedTypeProduct);
    }

    public void changeCheckBoxes()
    {
        System.debug('CHANGING CHECK BOXES');
        System.debug('selected month [' + selectedMonth + ']');

        for(SelectOption so : periodOpts)
        {
           //System.debug('soL[' + so.getLabel() + '] soV[' + so.getValue() + ']');
           if(so.getValue() == selectedMonth)
           {
               selectedMonthLabel = so.getLabel();
           }
        }

        PageReference pdfPage = new PageReference('/apex/ScorecardsPDF');
        pdfPage.setRedirect(false);
        changeCheckSucursal();
        changeCheckTipoProducto();
        setDateInterval();
        setURLReports();
        if(!Test.isRunningTest()){
            calculate();
        }
        
    }

    public PageReference preparePDF(){
        System.debug('Preparing PDF');
        PageReference pdfPage = new PageReference('/apex/ScorecardsPDF');
        pdfPage.setRedirect(false);

        changeCheckBoxes();
        return pdfPage;
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
       
       //UtilFunctions.printMapYearPeriods(periodo.monthsInterval);
       setDateInterval();
       if(!Test.isRunningTest()){
           calculate();
       }
    }    


    public void changeMonth()
    {
       PerfectaPeriodo periodo = mapYearsPeriods.get(selectedYear);
       System.debug('CHM SELYEAR[' + selectedYear +'] PER[' + periodo +'] SELMONTH[' + selectedMonth +']');       
       
       //UtilFunctions.printMapYearPeriods(periodo.monthsInterval);
       setDateInterval();
       if(!Test.isRunningTest()){     
           calculate();
       }     
    }    

    //-------------------------------------------- Events ----------------------------------------------
    
    private void calculate()
    {
        System.debug('Calculate--------');
        buildProspectosSummary();        
        initTotalesObjetivo();
        buildConoFuenteOrigen();
        buildConoVentasEjecutivo();
        buildConoGeneralVentas();
        loadVentasPerdidas();
        buildCampanias();
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


/********************* Prospectos & Campañas Lau 27/8 ***********************/
    
    public static final String DESCALIFICADO = 'Descalificado';
    public static final String RETAIL = 'Retail';
    public static final String WHOLESALE = 'WholeSale';

    public static final String CM_NO_ASIST = 'No Asistirá';
    public static final String CM_NO_CONT = 'No Contesta';

    public static final String OKM = '0Km';
    public static final String BPS = 'BPS';

    public PSummary prospectosSummary {get;set;}

    /**
    *   Calculates summary indicators for specific sets of Leads (plus Contacts in active Campaigns).
    *   Namely: Retail Leads, Wholesale Leads, Generated during the period, accumulated (base on backtrack param)
    *   For the last two, also presents the numbers excluding Converted or Marked as "Unqualified"
    *
    *   Assumptions:
    *   A Lead is always a Conquer
    *   A Contact (Member of an active Campaign) is a Conquer if it does not have an Asset with type in assetTypes
    *   This last conquers are always marked as Retail.
    *   @deprecated If an Account has several Contacts and those are added to several active Campaings, this counts just 1.
    *   @new    Messured by Contact
    */
     private PSummary buildProspectosSummary(){
        Integer backtrack = 90; //number of days back for accummulated (replace with variable from page selector)
        prospectosSummary = new PSummary();

        Set<String> idUsers = new Set<String>();
        for(User us : users)
        {
            idUsers.add(us.id);
        }
        //Get all Leads created during the period and sort
        for(Lead pro : [SELECT Es_Retail_WholeSale__c,
                            IsConverted,
                            Status,
                            CreatedDate
                            FROM Lead
                            WHERE CreatedDate >= :dateIni.addDays( -backtrack)
                            AND CreatedDate <= :dateEnd
                            AND OwnerId IN :idUsers
                            AND Tipo_de_producto__c in :typesProductStr]){
            
            if(!pro.IsConverted && pro.Status != DESCALIFICADO){
                prospectosSummary.accumActive += 1;
                if(pro.CreatedDate >= dateIni){
                    prospectosSummary.generatedActive += 1;
                }
            }
            if(pro.CreatedDate >= dateIni){
                if(pro.Es_Retail_WholeSale__c == RETAIL){
                prospectosSummary.retailConq += 1;
                }else{
                    prospectosSummary.wholesaleConq += 1;
                }
                prospectosSummary.generatedRaw += 1;
            }
            prospectosSummary.accumRaw += 1;
        }

        System.debug('TOT LDS ACCRAW[' + prospectosSummary.accumRaw + ']');

        //Gat the latest Campaign Member for each Contact
        map<Id, CampaignMember> cntIdToMemberStatus = new map<Id, CampaignMember>();
        for(CampaignMember c : [SELECT ContactId,
                                    Status,
                                    Campaign.StartDate
                                    FROM CampaignMember
                                    WHERE Campaign.StartDate >= :dateIni.addDays( -backtrack)
                                    AND Campaign.EndDate <= :dateEnd
                                    AND Campaign.RecordType.DeveloperName != :CRM_CAMP_RT
                                    AND ContactId != null
                                    ORDER BY Campaign.StartDate]){
            cntIdToMemberStatus.put(c.ContactId, c);
        }
        //Aggregate Members count to pSummary
        map<Id, Integer> hasAsset = PerfectaDAO.getCountAccountAssets(cntIdToMemberStatus.keySet(), typesProductStr);
        for(CampaignMember cm : cntIdToMemberStatus.values()){
            if(cm.Status != CM_NO_ASIST && cm.Status != CM_NO_CONT){
                prospectosSummary.accumActive += 1;
                if(cm.Campaign.StartDate >= dateIni){
                    prospectosSummary.generatedActive += 1;
                }
            }
            if(cm.Campaign.StartDate >= dateIni){
                if(!hasAsset.containsKey(cm.ContactId)){
                    prospectosSummary.retailConq += 1;
                }
                prospectosSummary.generatedRaw += 1;
            }
            prospectosSummary.accumRaw += 1;
        }
    Integer sumConq = prospectosSummary.retailConq + prospectosSummary.wholesaleConq;
    if(sumConq != null && sumConq > 0){

        prospectosSummary.retailConqPerc = ((Decimal)prospectosSummary.retailConq / ((Decimal)prospectosSummary.retailConq + (Decimal)prospectosSummary.wholesaleConq)) * 100;
        prospectosSummary.wholesaleConqPerc = ((Decimal)prospectosSummary.wholesaleConq / ((Decimal)prospectosSummary.retailConq + (Decimal)prospectosSummary.wholesaleConq)) * 100;
    }
    return prospectosSummary;
    }
    

/**
* URL para reportes
*/
    private void setURLReports()
    {
        Report_Link__mdt reportMetadata;

       String strFechaIni = dateini.month() + '/' + dateIni.day() + '/' + dateIni.year();
       String strFechaFin = dateEnd.month() + '/' + dateEnd.day() + '/' + dateEnd.year();      

        reportMetadata = reportURL.get('SC_VE_Logradas');
        this.urlTotalVentasLogradas = reportMetadata.Link__c;
        this.urlTotalVentasLogradas += '?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursales;
        this.urlTotalVentasLogradas += '&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + selectedTiposProducto;
        this.urlTotalVentasLogradas += '&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
        this.urlTotalVentasLogradas += '&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;

        reportMetadata = reportURL.get('SC_VE_RetailWholesale');
        this.urlTotalVentasRetail = reportMetadata.Link__c;
        this.urlTotalVentasRetail += '?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursales;
        this.urlTotalVentasRetail += '&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + selectedTiposProducto;
        this.urlTotalVentasRetail += '&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
        this.urlTotalVentasRetail += '&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;
        this.urlTotalVentasRetail += '&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c;
        this.urlTotalVentasWholesale = this.urlTotalVentasRetail + '&pv4=' + 'Wholesale';
        this.urlTotalVentasRetail += '&pv4=' + 'Retail';

        reportMetadata = reportURL.get('SC_VE_Entregas');
        this.urlTotalVentasEntregas = reportMetadata.Link__c;
        this.urlTotalVentasEntregas += '?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursales;
        this.urlTotalVentasEntregas += '&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + selectedTiposProducto;
        this.urlTotalVentasEntregas += '&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
        this.urlTotalVentasEntregas += '&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;

        reportMetadata = reportURL.get('Ventas_Cash_Terminaciones_FS');
        this.urlTotalVentasCash = reportMetadata.Link__c;
        this.urlTotalVentasCash += '?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursales;
        this.urlTotalVentasCash += '&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + selectedTiposProducto;
        this.urlTotalVentasCash += '&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
        this.urlTotalVentasCash += '&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;
        this.urlTotalVentasTerminacionesFS = urlTotalVentasCash + '&pc4='+reportMetadata.pc4__c+'&pn4=' + 'ne' + '&pv4=' + 'Contado';
        this.urlTotalVentasCash += '&pc4='+reportMetadata.pc4__c+'&pn4=' + 'eq' + '&pv4=' + 'Contado';
    }

    private String buildReportURLFuenteOrigen(String report, String fuenteOrigen) 
    {
       Report_Link__mdt reportMetadata;
       String urlReport = '';
       reportMetadata = reportURL.get(report);

       String strFechaIni = dateini.month() + '/' + dateIni.day() + '/' + dateIni.year();
       String strFechaFin = dateEnd.month() + '/' + dateEnd.day() + '/' + dateEnd.year();

       if(reportMetadata != null)
       {
          if(report == SC_FO_TD)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursales;
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedTiposProducto;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + EncodingUtil.urlEncode(fuenteOrigenMap.get(fuenteOrigen),'UTF-8');
          }
          if(report == OP_FO_M_PROSPECTOS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + selectedSucursales;
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
          }
          if(report == OP_FO_M_LEADS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursales;
          }
          if(report == OP_FO_M_VENTAS)
          {
             urlReport = reportMetadata.Link__c +'?pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursales;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + EncodingUtil.urlEncode(fuenteOrigen,'UTF-8');
             //urlReport = urlReport +'&pc5='+reportMetadata.pc5__c+'&pn5=' + reportMetadata.pn5__c + '&pv5=' + tiposProducto;
          }

       }

       System.debug('URL Report [' + urlReport + ']');
       return urlReport;
    }


    private String buildReportURLEjecutivos(String report, String userName) 
    {
       Report_Link__mdt reportMetadata;
       String urlReport = '';
       reportMetadata = reportURL.get(report);

       String strFechaIni = dateini.month() + '/' + dateIni.day() + '/' + dateIni.year();
       String strFechaFin = dateEnd.month() + '/' + dateEnd.day() + '/' + dateEnd.year();

       if(reportMetadata != null)
       {
          if(report == OP_M_TD)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(userName,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursales;
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
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + selectedSucursales;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + selectedTiposProducto;
          }
          if(report == OP_M_VENTAS)
          {
             urlReport = reportMetadata.Link__c +'?pc0='+reportMetadata.pc0__c+'&pn0=' + reportMetadata.pn0__c + '&pv0=' + EncodingUtil.urlEncode(userName,'UTF-8');
             urlReport = urlReport +'&pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + OPP_CERRADA_GANADA;              
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + selectedSucursales;
          }

          if(report == OP_M_ENTREGAS)
          {
             urlReport = reportMetadata.Link__c +'?pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaIni;
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' + strFechaFin;              
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' +selectedTiposProducto;
             urlReport = urlReport +'&pc5='+reportMetadata.pc5__c+'&pn5=' + reportMetadata.pn5__c + '&pv5=' + EncodingUtil.urlEncode(userName,'UTF-8');
          }
          if(report == OP_M_VOC)
          {
             urlReport = reportMetadata.Link__c +'?pc1='+reportMetadata.pc1__c+'&pn1=' + reportMetadata.pn1__c + '&pv1=' + strFechaIni;
             urlReport = urlReport +'&pc2='+reportMetadata.pc2__c+'&pn2=' + reportMetadata.pn2__c + '&pv2=' + strFechaFin;              
             urlReport = urlReport +'&pc3='+reportMetadata.pc3__c+'&pn3=' + reportMetadata.pn3__c + '&pv3=' +selectedTiposProducto;
             urlReport = urlReport +'&pc4='+reportMetadata.pc4__c+'&pn4=' + reportMetadata.pn4__c + '&pv4=' + EncodingUtil.urlEncode(userName,'UTF-8');
          }

       }

       System.debug('URL Report Ejecutivo SC [' + urlReport + ']');
       return urlReport;
    }


}