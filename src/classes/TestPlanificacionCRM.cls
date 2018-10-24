@isTest
private class TestPlanificacionCRM {
    
    static void initTestObjetivos(PlanificacionCRM pCRM){
        String key1, key2;
        for(String s : pCRM.objetivos.keySet()){
            if(key1 == null){
                key1 = s;
            }else if(key2 == null){
                key2 = s;
            }else{
                break;
            }
        }
        pCRM.objetivos.get(key1).Prospectos__c = 1000;
        pCRM.objetivos.get(key2).Prospectos__c = 1000;
        pCRM.objetivos.get(key1).Leads_Calificados__c = 200;
        pCRM.objetivos.get(key2).Leads_Calificados__c = 200;
        pCRM.objetivos.get(key1).Test_Drives__c = 50;
        pCRM.objetivos.get(key2).Test_Drives__c = 50;
        pCRM.objetivos.get(key1).Ventas__c = 10;
        pCRM.objetivos.get(key2).Ventas__c = 10;
    }

    @isTest static void testCreateObjetivos() {
        PlanificacionCRM pCRM = new PlanificacionCRM();
        system.assertEquals(pCRM.sucursales.size(), 
                                    User.Sucursal__c.getDescribe().getPicklistValues().size());
        system.assertEquals(pCRM.objetivos.size(), 
                                Objetivo__c.Fuente_Origen__c.getDescribe().getPicklistValues().size());
        system.assertEquals(pCRM.leadsGoalSummary, 0);
        system.assertEquals(pCRM.qualifiedLeadsGoalSummary, 0);
        system.assertEquals(pCRM.testDrivesGoalSummary, 0);
        system.assertEquals(pCRM.salesGoalSummary, 0);

        initTestObjetivos(pCRM);
        
        //Refresh the page without saving
        pCRM = new PlanificacionCRM();

        //Goals are still null
        system.assertEquals(pCRM.leadsGoalSummary, 0);
        system.assertEquals(pCRM.qualifiedLeadsGoalSummary, 0);
        system.assertEquals(pCRM.testDrivesGoalSummary, 0);
        system.assertEquals(pCRM.salesGoalSummary, 0);
        
    }
    
    @isTest static void testEditObjetivos() {
        PlanificacionCRM pCRM = new PlanificacionCRM();
        
        initTestObjetivos(pCRM);

        //save goals
        pCRM.saveObjetivos();

        //Refresh the page after saving
        pCRM = new PlanificacionCRM();

        //Validate goals are fetched
        system.assertEquals(pCRM.leadsGoalSummary, 2000);
        system.assertEquals(pCRM.qualifiedLeadsGoalSummary, 400);
        system.assertEquals(pCRM.testDrivesGoalSummary, 100);
        system.assertEquals(pCRM.salesGoalSummary, 20);
    
    }

    @isTest static void testChangeSucursal() {
        PlanificacionCRM pCRM = new PlanificacionCRM();
        
        initTestObjetivos(pCRM);

        //save goals
        pCRM.saveObjetivos();

        //Refresh the page after saving
        pCRM = new PlanificacionCRM();

        //Validate goals are fetched
        system.assertEquals(pCRM.leadsGoalSummary, 2000);
        system.assertEquals(pCRM.qualifiedLeadsGoalSummary, 400);
        system.assertEquals(pCRM.testDrivesGoalSummary, 100);
        system.assertEquals(pCRM.salesGoalSummary, 20);
    
        system.assertEquals(pCRM.selectedSucursal, PlanificacionCRM.CENTRAL);
        //Change sucursal
        pCRM.selectedSucursal = PlanificacionCRM.CDE;
        pCRM.changeSucursal();

        //Goals are brand new
        system.assertEquals(pCRM.leadsGoalSummary, 0);
        system.assertEquals(pCRM.qualifiedLeadsGoalSummary, 0);
        system.assertEquals(pCRM.testDrivesGoalSummary, 0);
        system.assertEquals(pCRM.salesGoalSummary, 0);
    
    }
    
}