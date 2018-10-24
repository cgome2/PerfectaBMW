@isTest
public class TestPlanificacionDiariaVentas
{

    @isTest static void testPlanificacionDiariaController()
    {
      PlanificacionDiariaVentas.ObjetivoClass objCls;
      Objetivo__c objetivo;
      TestUtil testUtil = new TestUtil();
      testUtil.initUsuarios();
      
      PlanificacionDiariaVentas pdvCtrl = new PlanificacionDiariaVentas();
      pdvCtrl.saveAll();
      
      objCls = pdvCtrl.objetivos.get(0);
      objetivo = objCls.obj;
      
      pdvCtrl.initCanEdit();
      objCls.getAvanceLeadPorcentaje();
      objCls.getAvanceVentasPorcentaje();
      objCls.getAvanceTestDrivesPorcentaje();
      objCls.getAvanceProspectosPorcentaje();
      
      objCls.getCumplimientoLeadPorcentaje();
      objCls.getCumplimientoVentasPorcentaje();
      objCls.getCumplimientoTestDrivesPorcentaje();
      objCls.getCumplimientoProspectosPorcentaje();
      objCls.getContactosDiarios();
      
    }
    
}