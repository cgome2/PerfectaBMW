@isTest
private class TestPerfectaDAO {
  
  private static final String USUARIO_VENTAS = 'Usuario de Ventas';
  private static final String SUCURSAL = 'CENTRAL';
  private static final String MENSUAL_E = 'Mensual Ejecutivo';
  private static final String MENSUAL_FUENTE = 'Mensual Origen';
  private static final String OPP_CERRADA_GANADA = 'Cerrada/Ganada';
  private static final String OPP_CERRADA_PERDIDA = 'Cerrada/Perdida';
  private static final String OPP_CALIFICADO = 'Calificado';
  private static final String OPP_TEST_DRIVE = 'Prueba de manejo'; 
  
  /**
   *  Improve this (and TestUtil as needed) to make meaningful assertions and validate implementation 
   */
  @isTest static void testInitScorecards()  {
    List<Date> datesOfInterval;
    List<String> idUsers = new List<String>();
    List<String> tipoActivos = new List<String>();
    Set<Id> idCuentas;
    TestUtil tu = new TestUtil();
    tu.initPruebaEjecutivos();
    
    ScorecardTotalesObjetivo totalesObjetivo = new ScorecardTotalesObjetivo();
    
    datesOfInterval = UtilFunctions.getInterval(Date.today().year(), Date.today().month(), Date.today().month());
    Date dateIni = datesOfInterval.get(0);
    Date dateFin = datesOfInterval.get(1);
    
    List<User> users = PerfectaDAO.getUsers(SUCURSAL, USUARIO_VENTAS);
    for(User us : users)
    {
      idUsers.add(us.id);
    }
    tipoActivos.add('0Km');
    tipoActivos.add('BPS');
    
    
    PerfectaDAO.getTotalesObjetivo(SUCURSAL, dateIni.year(), dateIni.month(), dateFin.month(), MENSUAL_E, totalesObjetivo);

    Map<Id, Integer> accountsOpp = PerfectaDAO.getOportunidadesPorCuenta(idUsers, OPP_CERRADA_GANADA, USUARIO_VENTAS, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getNumeroVentasConquistaLealtad(idUsers, tipoActivos, OPP_CERRADA_GANADA, USUARIO_VENTAS, dateIni, dateFin);
    PerfectaDAO.getVentasCash(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVentasEntrega(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVentasRetailOrWholesale(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, 'Retail', tipoActivos);
    PerfectaDAO.getFuentesOrigen();
    PerfectaDAO.getTestDrives(dateIni, dateFin, tipoActivos, idUsers);
    PerfectaDAO.getTestDrivesConquistaLealtadEjecutivo(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getTestDrivesFuenteOrigen(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOfertasEjecutivo(dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOfertasFuenteOrigen(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getEntregasPorEjecutivo(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVOCPorEjecutivo(dateIni, dateFin, tipoActivos);
    PerfectaDAO.getObjetivosEjecutivos(MENSUAL_E, dateIni, dateFin, SUCURSAL);
    PerfectaDAO.getObjetivosProspectosTotales(MENSUAL_E, dateIni, dateFin, SUCURSAL);
    PerfectaDAO.getOportunidadesPorFuenteOrigen(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVentasPorFuenteOrigen(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getObjetivosFuenteOrigen(SUCURSAL, dateIni, dateFin);
    PerfectaDAO.getCampanias(SUCURSAL, dateIni, dateFin);
    PerfectaDAO.getTestDriveCampania(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVentasCampania(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOfertasCampania(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getCountAccountAssets(accountsOpp.keySet(), tipoActivos);
    PerfectaDAO.getLeadsConquistaLealtadEjecutivo(idUsers, dateIni, dateFin, OPP_CALIFICADO, tipoActivos);
    PerfectaDAO.getVentasConquistaLealtadEjecutivo(idUsers, dateIni, dateFin, OPP_CALIFICADO, tipoActivos);
    PerfectaDAO.getOfertasConquistaLealtadEjecutivo(dateIni, dateFin, tipoActivos);
    PerfectaDAO.getEntregasConquistaLealtadEjecutivo(idUsers, dateIni, dateFin, OPP_CERRADA_GANADA, tipoActivos);
    PerfectaDAO.getVOCConquistaLealtadEjecutivo(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOportunidadesPerdidas(idUsers, OPP_CERRADA_PERDIDA, USUARIO_VENTAS, dateIni, dateFin, tipoActivos);

    PSummary psumm = new Psummary();
    PerfectaDAO.getProspectosEjecutivoLeadSource(idUsers, tipoActivos, dateIni, dateFin, psumm);

    PerfectaDAO.getCustomMetadata();

//------------------------------------------------ Fuente Origen Conquista Lealtad---------------------------------------------------------------

    PerfectaDAO.getTDConquistaLealtadFuenteOrigen(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOportunidadConquistaLealtadFuenteOrigen(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVentasConquistaLealtadFuenteOrigen(idUsers, OPP_CERRADA_GANADA, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOfertasConquistaLealtadFO(idUsers, dateIni, dateFin, tipoActivos);
 
 //------------------------------------------------ Campanias Conquista Lealtad---------------------------------------------------------------
 
    PerfectaDAO.getTestDriveCampaniaConquistaLealtad(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getVentasCampaniaConquistaLealtad(idUsers, dateIni, dateFin, tipoActivos);
    PerfectaDAO.getOfertasCampaniaConquistaLealtad(idUsers, dateIni, dateFin, tipoActivos);

  }


  
}