@isTest
private class TestPerfectaPeriodo {
	
	@isTest static void testPastYear() {
		PerfectaPeriodo pp = new PerfectaPeriodo(2001, true, false);
		system.assertEquals(pp.year, String.valueOf(2001));
		system.assertEquals(pp.isCurrent, false);
		system.assertEquals(pp.months.size(), 12 + 4 + 1);
		system.assertEquals(pp.months[3].getLabel(), 'Abril - 2001');
		system.assertEquals(pp.monthsInterval.get('4')[0], Date.newInstance(2001,4,1));
	}

	@isTest static void testCurrentYear() {
		PerfectaPeriodo pp = new PerfectaPeriodo(Date.today().year(), false, true);
		system.assertEquals(pp.year, String.valueOf(Date.today().year()));
		system.assertEquals(pp.isCurrent, true);
		system.assertEquals(pp.months.size(), Date.today().month());
		system.assertEquals(pp.months[0].getLabel(), 'Enero - ' + String.valueOf(Date.today().year()));
		system.assertEquals(pp.monthsInterval.get('1')[0], Date.newInstance(Date.today().year(),1,1));
	}
	

}