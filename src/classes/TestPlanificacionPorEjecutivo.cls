@isTest
private class TestPlanificacionPorEjecutivo {
	
	@isTest static void testPlanEjecutivo() {
		PlanificacionPorEjecutivo ppe;
		TestUtil tu = new TestUtil();
		tu.initPruebaEjecutivos();
		System.runAs(tu.usuarios[0]){
			ppe = new PlanificacionPorEjecutivo();
		}
		//system.assertEquals(ppe.prospectosDiarioAvance, 1);
		system.assertEquals(ppe.prospectosDiarioObjetivo, 2);
		//system.assertEquals(ppe.leadsDiarioAvance, 1);
		system.assertEquals(ppe.leadsDiarioObjetivo, 1);    
		//system.assertEquals(ppe.testDrivesDiarioAvance, 1);
		system.assertEquals(ppe.testDrivesDiarioObjetivo, 1);    
		//system.assertEquals(ppe.ventasDiarioAvance, 1);
		system.assertEquals(ppe.ventasDiarioObjetivo, 1);    

		//system.assertEquals(ppe.prospectosMensualAvance, 1);
		system.assertEquals(ppe.prospectosMensualObjetivo, 50);    
		//system.assertEquals(ppe.leadsMensualAvance, 1);
		system.assertEquals(ppe.leadsMensualObjetivo, 20);    
		//system.assertEquals(ppe.testDrivesMensualAvance, 1);
		system.assertEquals(ppe.testDrivesMensualObjetivo, 12);    
		//system.assertEquals(ppe.ventasMensualAvance, 1);
		system.assertEquals(ppe.ventasMensualObjetivo, 6);
	}
	
}