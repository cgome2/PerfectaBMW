public class RegistroVentas
{
    public String id {get;set;}
    public String registroName {get;set;}
    
    public Integer ventas {get;set;}
    public Integer leadsCalificados {get;set;}
    public Integer testDrives {get;set;}
    public Integer prospectos {get;set;}
    public Integer ofertas {get;set;}
    public Integer entregados {get;set;}
    public Integer voice {get;set;}
    
    public Integer seguimientoProspectos {get;set;}
    public Integer seguimientoLeads {get;set;}
    public Integer seguimientoTestDrives {get;set;}
    public Integer seguimientoOfertas {get;set;}

    public Integer ventasLogrado {get;set;}
    public Integer leadsCalificadosLogrado {get;set;}
    public Integer testDrivesLogrado {get;set;}
    public Integer prospectosLogrado {get;set;}
    public Integer ofertasLogrado {get;set;}
    public Integer entregadosLogrado {get;set;}
    public Integer voiceLogrado {get;set;}

    public Integer ventasConquista {get;set;}
    public Integer leadsCalificadosConquista {get;set;}
    public Integer testDrivesConquista {get;set;}
    public Integer prospectosConquista {get;set;}
    public Integer ofertasConquista {get;set;}
    public Integer entregadosConquista {get;set;}
    public Integer voiceConquista {get;set;}

    public Integer ventasLealtad {get;set;}
    public Integer leadsCalificadosLealtad {get;set;}
    public Integer testDrivesLealtad {get;set;}
    public Integer prospectosLealtad {get;set;}
    public Integer ofertasLealtad {get;set;}
    public Integer entregadosLealtad {get;set;}
    public Integer voiceLealtad {get;set;}

    public Decimal ventasConquistaPorcentaje {get;set;}
    public Decimal leadsCalificadosConquistaPorcentaje {get;set;}
    public Decimal testDrivesConquistaPorcentaje {get;set;}
    public Decimal prospectosConquistaPorcentaje {get;set;}
    public Decimal ofertasConquistaPorcentaje {get;set;}
    public Decimal entregadosConquistaPorcentaje {get;set;}
    public Decimal voiceConquistaPorcentaje {get;set;}

    public Decimal ventasLealtadPorcentaje {get;set;}
    public Decimal leadsCalificadosLealtadPorcentaje {get;set;}
    public Decimal testDrivesLealtadPorcentaje {get;set;}
    public Decimal prospectosLealtadPorcentaje {get;set;}
    public Decimal ofertasLealtadPorcentaje {get;set;}
    public Decimal entregadosLealtadPorcentaje {get;set;}
    public Decimal voiceLealtadPorcentaje {get;set;}

    public Decimal ventasPorcentaje {get;set;}
    public Decimal leadsCalificadosPorcentaje {get;set;}
    public Decimal testDrivesPorcentaje {get;set;}
    public Decimal prospectosPorcentaje {get;set;}
    public Decimal ofertasPorcentaje {get;set;}
    public Decimal entregadosPorcentaje {get;set;}
    public Decimal voicePorcentaje {get;set;}

    public Decimal ventasLogradoPorcentaje {get;set;}
    public Decimal leadsCalificadosLogradoPorcentaje {get;set;}
    public Decimal testDrivesLogradoPorcentaje {get;set;}
    public Decimal prospectosLogradoPorcentaje {get;set;}
    public Decimal ofertasLogradoPorcentaje {get;set;}
    public Decimal entregadosLogradoPorcentaje {get;set;}
    public Decimal voiceLogradoPorcentaje {get;set;}
    
    public RegistroVentas()
    {
       ventas = 0;
       leadsCalificados = 0;
       testDrives = 0;
       prospectos = 0;
       ofertas = 0;
       entregados = 0;
       voice = 0;

       seguimientoProspectos = 0;
       seguimientoLeads = 0;
       seguimientoTestDrives = 0;
       seguimientoOfertas = 0;

       ventasLogrado = 0;
       leadsCalificadosLogrado = 0;
       testDrivesLogrado = 0;
       prospectosLogrado = 0;
       ofertasLogrado = 0;
       entregadosLogrado = 0;
       voiceLogrado = 0;

       ventasConquista = 0;
       leadsCalificadosConquista = 0;
       testDrivesConquista = 0;
       prospectosConquista = 0;
       ofertasConquista = 0;
       entregadosConquista = 0;
       voiceConquista = 0;

       ventasLealtad = 0;
       leadsCalificadosLealtad = 0;
       testDrivesLealtad = 0;
       prospectosLealtad = 0;
       ofertasLealtad = 0;
       entregadosLealtad = 0;
       voiceLealtad = 0;

       ventasPorcentaje = 0;
       leadsCalificadosPorcentaje = 0;
       testDrivesPorcentaje = 0;
       prospectosPorcentaje = 0;
       ofertasPorcentaje = 0;
       entregadosPorcentaje = 0;
       voicePorcentaje = 0;

       ventasLogradoPorcentaje = 0;
       leadsCalificadosLogradoPorcentaje = 0;
       testDrivesLogradoPorcentaje = 0;
       prospectosLogradoPorcentaje = 0;
       ofertasLogradoPorcentaje = 0;
       entregadosLogradoPorcentaje = 0;
       voiceLogradoPorcentaje = 0;

    }


    public void calculatePercentage()
    {
        // porcentajes de conquista y lealtad
       ventasConquistaPorcentaje = UtilFunctions.calcularPorcentaje(ventas , ventasConquista);
       leadsCalificadosConquistaPorcentaje = UtilFunctions.calcularPorcentaje(leadsCalificados, leadsCalificadosConquista);
       testDrivesConquistaPorcentaje = UtilFunctions.calcularPorcentaje(testDrives, testDrivesConquista);
       prospectosConquistaPorcentaje = UtilFunctions.calcularPorcentaje(prospectos, prospectosConquista);
       ofertasConquistaPorcentaje = UtilFunctions.calcularPorcentaje(ofertas, ofertasConquista);
       entregadosConquistaPorcentaje = UtilFunctions.calcularPorcentaje(entregados, entregadosConquista);
       voiceConquistaPorcentaje = UtilFunctions.calcularPorcentaje(voice, voiceConquista);

       ventasLealtadPorcentaje = UtilFunctions.calcularPorcentaje(ventas, ventasLealtad);
       leadsCalificadosLealtadPorcentaje = UtilFunctions.calcularPorcentaje(leadsCalificados, leadsCalificadosLealtad);
       testDrivesLealtadPorcentaje = UtilFunctions.calcularPorcentaje(testDrives, testDrivesLealtad);
       prospectosLealtadPorcentaje = UtilFunctions.calcularPorcentaje(prospectos, prospectosLealtad);
       ofertasLealtadPorcentaje = UtilFunctions.calcularPorcentaje(ofertas, ofertasLealtad);
       entregadosLealtadPorcentaje = UtilFunctions.calcularPorcentaje(entregados, entregadosLealtad);
       voiceLealtadPorcentaje = UtilFunctions.calcularPorcentaje(voice, voiceLealtad);
    }


}