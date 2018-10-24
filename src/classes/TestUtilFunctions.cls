@isTest
private class TestUtilFunctions {
    
    @isTest static void justCallFunctions() {
        system.assertEquals(UtilFunctions.getMonth(4), 'Abril');
        system.assertEquals(UtilFunctions.getBusinessDays(2001, 4, -1), 25);
        UtilFunctions.yearsBackFromCurrent(3, 2001, 'all');
        UtilFunctions.getInterval('2020', '1', '10');
        UtilFunctions.getInterval(2020, 1, 10);
        UtilFunctions.getInterval(2020, 1, 10);
        UtilFunctions.calcularPorcentaje(9, 6);

        UtilFunctions.isAccount('XYZ');
        UtilFunctions.isContact('XYZ');
        UtilFunctions.isOpp('XYZ');
        UtilFunctions.isLead('XYZ');
    }
}