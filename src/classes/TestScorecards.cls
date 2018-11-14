@isTest
private class TestScorecards {
    
    /**
    *   Improve this (and TestUtil as needed) to make meaningful assertions and validate implementation
    */
    @isTest static void testInitScorecards() { 
        TestUtil tu = new TestUtil();
        tu.initPruebaEjecutivos();
        test.startTest();
        Scorecards score = new Scorecards();
        test.stopTest();
        score.getVentasObjetivoPorcentaje();
        score.changeCheckSucursal();
        score.changeCheckTipoProducto();
        score.changeYear();
        score.changeMonth();
        //score.thisNotCool();
    }
    
    @isTest static void testComponents(){
        List<UITableScorecard> tables = new List<UITableScorecard>();
        UITableScorecard uits = new UITableScorecard('Title', 0);
        uits.addRecord('1000', '500', '250', '125', '75',
                        '100%', '200%', '300%', '400%', '500%',
                        1000, 500, 250, 125, '');
        tables.add(uits);

        ScorecardSingleSetTable ssst = new ScorecardSingleSetTable(tables);
        ComponentControllerScorecard ccs = new ComponentControllerScorecard();
        ccs.sorecardSetTables = ssst;
        ccs.numberColumns = 4;
        ccs.getRowsTable();
        ComponetControllerTableEjecutivo ccte = new ComponetControllerTableEjecutivo();
        List<UITableEjecutivo> ejTables = new List<UITableEjecutivo>();
        UITableEjecutivo uite = new UITableEjecutivo('Title', 0);
        uite.addRecord('1000', '500', '250', '125', '75',
                        '100%', '200%', '300%', '400%', '500%',
                        1000, 500, 250, 125, '');
        ejTables.add(uite);

        ScorecardSetTable sst = new ScorecardSetTable(ejTables);
        ccte.sorecardSetTables = sst;
        ccte.numberColumns = 4;
        ccte.getRowsTable();

    }

}