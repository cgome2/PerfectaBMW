public class PerfectaDAO
{

    /**
     * Return the active users filtered by sucursal and profile.
     */
    public static List<User> getUsers(String sucursal, String profile)
    {
        List<User> users;
        String[] tokens;
        
        if(sucursal != null)
        {
          tokens = sucursal.split('\\+');
        }
        
        users = [SELECT Id, 
                        Name, 
                        Sucursal__c 
                   FROM User
                  WHERE Profile.Name = :profile
                    AND Sucursal__c IN :tokens
                    AND IsActive = true
                  ORDER BY Name];
        return users;
    }
 
    /**
     * Se obtienen los totales de los objetivos del mes
     */
    public static void getTotalesObjetivo(String sucursal, Integer anio, Integer mesInicio, Integer mesFin, String perfil, ScorecardTotalesObjetivo totalesObjetivo)
    {
        List<AggregateResult> resultQuery;
        
        String[] tokens;
        
        if(sucursal != null)
        {
          tokens = sucursal.split('\\+');
        }
        
        String baseQuery = 'SELECT SUM(Prospectos__c) sumProspectos, ' + 
                                  'SUM(Leads_Calificados__c) sumLeads, ' +
                                  'SUM(Ventas__c) sumVentas, ' +
                                  'SUM(Test_Drives__c) sumTD, ' +
                                  'SUM(Ofertas__c) sumOfertas, ' +
                                  'SUM(Entregas__c) sumEntregas, ' +
                                  'SUM(VoC__c) sumVOC ' +
                             'FROM Objetivo__c ' +
                            'WHERE Tipo__c  = :perfil ' +
                              'AND Anio__c = :anio ' +
                              'AND Mes__c >= :mesInicio ' + 
                              'AND Mes__c <= :mesFin ' +                               
                              'AND Ejecutivo__r.Sucursal__c IN :tokens';

        resultQuery = Database.query(baseQuery);
        //System.debug('query[' + baseQuery + '] res.size[' + resultQuery.size() + '] [' + mesInicio + '] [' + perfil + '] [' + sucursal + ']');
        
        Decimal value;
        for (AggregateResult ar : resultQuery)
        {
            value = (Decimal)ar.get('sumProspectos');
            totalesObjetivo.prospectos = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumTD');
            totalesObjetivo.testDrive = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumLeads');
            totalesObjetivo.leads = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumVentas');
            totalesObjetivo.ventas = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumOfertas');
            totalesObjetivo.ofertas = value == null ? 0 : value.intValue();
            value = (Decimal)ar.get('sumEntregas');
            totalesObjetivo.entregas = value == null ? 0 : value.intValue();            
            value = (Decimal)ar.get('sumVOC');
            totalesObjetivo.voc = value == null ? 0 : value.intValue();            
        }
    }
    
    
    public static List<Integer> getNumeroVentasConquistaLealtad(List<String> idEjecutivos, List<String> tipoActivos, String estadoOportunidad, String profileName, Date fechaInicio, Date fechaFin)    
    {
       String accId;
       Integer numAssets = 0;
       Integer numLealtad = 0;
       Integer numConq = 0;
       List<Integer> conquistaLealtadResults = new List<Integer>();

       List<Opportunity> opps = null;

       opps = [SELECT Owner.Id, 
                      Owner.Name,
                      SyncedQuote.Contact.Activos__c,
                      SyncedQuoteId
                 FROM Opportunity  
                WHERE Owner.Id IN :idEjecutivos
                  AND Stagename = :estadoOportunidad
                  AND Tipo_contacto__c IN :tipoActivos
                  AND Fecha_de_Venta__c >= :fechaInicio 
                  AND Fecha_de_Venta__c <= :fechaFin
                  AND SyncedQuoteId != null];

       
      for (Opportunity op : opps) 
      {
        numAssets = (Integer)op.SyncedQuote.Contact.Activos__c;
        if(numAssets == null || numAssets == 0 || numAssets == 1)
        {
           numConq += 1;
        }
        else
        {
           numLealtad += 1;
        }
      }

       conquistaLealtadResults.add(numConq);
       conquistaLealtadResults.add(numLealtad);
       return conquistaLealtadResults;
    }

/*
    public static Map<Id, Integer> getOportunidadesPorContacto(List<String> idEjecutivos, String estadoOportunidad, String profileName, Date fechaInicio, Date fechaFin)
    {
      Integer numOp;
      String cntId;
      AggregateResult[] results = null;
      //select count(id), accountid, account.name from opportunity where stagename = 'Cerrada/Ganada' and closedate >= 2018-01-01 and closedate <= 2018-12-31 and owner.isactive= true and owner.profile.name = 'Usuario de Ventas' group by accountid, account.name
      Map<Id, Integer> contactsOpp = new Map<Id, Integer>();

      results = [SELECT COUNT(Id) numOp, 
                        SyncedQuote.ContactId contid, 
                        SyncedQuote.Contact.Name contname
                   FROM Opportunity 
                  WHERE Stagename = :estadoOportunidad 
                    AND Closedate >= :fechaInicio
                    AND Closedate <= :fechaFin
                    AND Owner.id IN :idEjecutivos 
                    AND Owner.IsActive = true 
                    AND Owner.Profile.Name = :profileName 
               GROUP BY SyncedQuote.ContactId, SyncedQuote.Contact.Name];

      for (AggregateResult ar : results) 
      {
        numOp = (Integer)ar.get('numOp');
        cntId = (String)ar.get('contid');
        contactsOpp.put(cntId, numOp);
      }
      return contactsOpp;
    }
*/
    public static Map<Id, Integer> getOportunidadesPorCuenta(List<String> idEjecutivos, String estadoOportunidad, String profileName, Date fechaInicio, Date fechaFin, List<String> tiposProducto)
    {
      Integer index = 1;
      Integer aux = 0;
      Integer numOp;
      String accId;
      String accName;
      AggregateResult[] results = null;
      Map<Id, Integer> accountsOpp = new Map<Id, Integer>();

      System.debug('GOPA ['+ estadoOportunidad +']['+ fechaInicio +']['+ fechaFin +']['+ profileName +']['+ idEjecutivos +']');

      results = [SELECT COUNT(Id) numOp, 
                        AccountId accid, 
                        Account.Name accname
                   FROM Opportunity 
                  WHERE Stagename = :estadoOportunidad 
                    AND Fecha_de_Venta__c >= :fechaInicio
                    AND Fecha_de_Venta__c <= :fechaFin
                    AND Owner.id IN :idEjecutivos 
                    AND Owner.IsActive = true 
                    AND Owner.Profile.Name = :profileName 
                    AND Tipo_contacto__c IN :tiposProducto
               GROUP BY AccountId, Account.Name
               ORDER BY account.name];

      for (AggregateResult ar : results) 
      {
         
        numOp = (Integer)ar.get('numOp');
        aux += numOp;
        accId = (Id)ar.get('accid');
        accName = (String)ar.get('accname');
        //System.debug('REC ['+ index +']['+ accId +'] ['+ accname +'] ['+ numOp +'] [' + aux + ']');
        accountsOpp.put(accId, numOp);
        index++;
      }

      System.debug('Total ['+ aux +']');
      return accountsOpp;
    }


    public static Map<String, Integer> getOportunidadesPerdidas(List<String> idEjecutivos, String estadoOportunidad, String profileName, Date fechaInicio, Date fechaFin, List<String> tiposProducto)
    {
      Integer numOp;
      String razon;
      AggregateResult[] results = null;
      Map<String, Integer> oppPerdidas = new Map<String, Integer>();

      System.debug('GOPPER ['+ estadoOportunidad +']['+ fechaInicio +']['+ fechaFin +']['+ profileName +']['+ idEjecutivos +']');

      results = [SELECT COUNT(Id) numOp, 
                        Razon_Perdida__c rp
                   FROM Opportunity 
                  WHERE Stagename = :estadoOportunidad 
                    AND Closedate >= :fechaInicio
                    AND Closedate <= :fechaFin
                    AND Owner.id IN :idEjecutivos 
                    AND Owner.IsActive = true 
                    AND Owner.Profile.Name = :profileName 
                    AND Tipo_contacto__c IN :tiposProducto
               GROUP BY Razon_Perdida__c
               ORDER BY Razon_Perdida__c];

      for (AggregateResult ar : results) 
      {
         
        numOp = (Integer)ar.get('numOp');
        razon = (String)ar.get('rp');
        if(razon == null)
        {
            razon = 'N/A';
        }
        oppPerdidas.put(razon, numOp);
      }

      return oppPerdidas;
    }


    public static List<Integer> getVentasCash(List<String> idEjecutivos, String estadoOportunidad, Date fechaInicio, Date fechaFin, List<String> tiposProducto)
    {
       Integer numVentas = 0;
       Integer ventasCash = 0;
       Integer ventasFs = 0;
       String formaPago;       
       List<Integer> cashFSResults = new List<Integer>();

       AggregateResult[] results = null;
       
       results = [SELECT COUNT(Id) sum, 
                         Forma_de_pago__c fpago 
                    FROM Quote 
                   WHERE OpportunityId IN (
                                           SELECT Id 
                                             FROM Opportunity 
                                            WHERE Owner.Id IN :idEjecutivos
                                              AND Tipo_contacto__c IN :tiposProducto
                                              AND Fecha_de_Venta__c >= :fechaInicio
                                              AND Fecha_de_Venta__c <= :fechaFin
                                              AND Stagename = :estadoOportunidad)
                     AND IsSyncing = true
                GROUP BY Forma_de_pago__c];

       for (AggregateResult ar : results) 
       {
         numVentas = (Integer)ar.get('sum');
         formaPago = (String)ar.get('fpago');
         if(formaPago.equals('Contado'))
         {
            ventasCash = numVentas;
         }
         else
         {
           ventasFs = ventasFs + numVentas;
         }
       }

       System.debug('CASH FS c[' + ventasCash + '] f[' + ventasFs + ']');
       cashFSResults.add(ventasCash);
       cashFSResults.add(ventasFs);
       return cashFSResults;
    }
    
    
    public static Integer getVentasEntrega(List<String> idEjecutivos, String estadoOportunidad, Date fechaInicio, Date fechaFin, List<String> tiposProducto)
    {
       Integer ventasEntrega;
       AggregateResult[] results = null;
       
       results = [SELECT Entregado__c,
                         COUNT(Id) sum
                    FROM Opportunity 
                   WHERE Owner.Id = :idEjecutivos
                     AND Closedate >= :fechaInicio
                     AND Closedate <= :fechaFin
                     AND Stagename = :estadoOportunidad
                     AND Tipo_contacto__c IN :tiposProducto
                     AND Entregado__c = true
                GROUP BY Entregado__c];
                    
       for (AggregateResult ar : results) 
       {
         ventasEntrega = (Integer)ar.get('sum');
       }
       return ventasEntrega;
    }

    /**
     * tipo = 'Retail'  or tipo = 'Wholesale'
     */
    public static Integer getVentasRetailOrWholesale(List<String> idEjecutivos, String estadoOportunidad, Date fechaInicio, Date fechaFin, String tipo, List<String> tiposProducto)
    {
       Integer ventas;
       AggregateResult[] results = null;
       
       results = [SELECT Es_Retail_WholeSale__c,
                         COUNT(Id) sum
                    FROM Opportunity 
                   WHERE Owner.Id = :idEjecutivos
                     AND Fecha_de_Venta__c >= :fechaInicio
                     AND Fecha_de_Venta__c <= :fechaFin
                     AND Stagename = :estadoOportunidad
                     AND Tipo_contacto__c IN :tiposProducto
                     AND Es_Retail_WholeSale__c = :tipo
                GROUP BY Es_Retail_WholeSale__c];

       for (AggregateResult ar : results) 
       {
         ventas = (Integer)ar.get('sum');
       }
       return ventas;
    }
    
    /**
    * Returns the list of possible Lead Sources
    */
    public static List<String> getFuentesOrigen()
    {
      String value;
      List<String> fuenteOrigenList = new List<String>();
      Schema.DescribeFieldResult source = Lead.LeadSource.getDescribe();
      List<Schema.PicklistEntry> plv = source.getPicklistValues();
      for( Schema.PicklistEntry pickListVal : plv){
        fuenteOrigenList.add(pickListVal.getValue());
        //fuenteOrigenList.add(pickListVal.getLabel());
      }
      return fuenteOrigenList;
    }
    
    /**
    * Returns the list of possible Lead Sources
    */
    public static Map<String, String> getFuentesOrigenLabel()
    {
      String value;
      Map<String, String> fuenteOrigenMap = new Map<String, String>();
      Schema.DescribeFieldResult source = Lead.LeadSource.getDescribe();
      List<Schema.PicklistEntry> plv = source.getPicklistValues();
      for( Schema.PicklistEntry pickListVal : plv){
        fuenteOrigenMap.put(pickListVal.getValue(), pickListVal.getLabel());
      }
      return fuenteOrigenMap;
    }


    /**
    * REFACTORING: Clave variable (Ejecutivo o Fuente)
    */
    public static Map<String, Integer> getTestDrives(Date fechaIni, Date fechaFin, List<String> tiposProducto, List<String> idEjecutivos)
    {
       Map<String, Integer> ejecutivosTD = new Map<String, Integer>();
       List<String> oppsId = new List<String>();
       
       System.debug('TD EJ Fini [' + fechaIni + ']  FFin[' + fechaFin + ']');

       String idejstr = '';
       for(String idej : idEjecutivos)
       {
         idejstr = idejstr + '\'' + idej + '\',';
       }
       System.debug('TDEJ idejs[' + idejstr + ']');

       AggregateResult[] results = null;
       results = [SELECT CreatedById idus, 
                         COUNT(Id) countN 
                    FROM Prueba_de_manejo__c  
                   WHERE DAY_ONLY(convertTimeZone(Createddate)) >= :fechaIni
                     AND DAY_ONLY(convertTimeZone(Createddate)) <= :fechaFin
                     //AND Oportunidad__r.Ownerid IN :idEjecutivos
                     AND CreatedById IN :idEjecutivos
                     AND Oportunidad__r.Tipo_contacto__c IN :tiposProducto
                GROUP BY CreatedById];

       for (AggregateResult ar : results) 
       {
          //System.debug('TD  OP ownerid[' + ar.get('idus') + '] ownername[' + ar.get('nameus') + '] count[' + ar.get('countN') + ']');
          ejecutivosTD.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       
       return ejecutivosTD;
    }


    public static Map<String, List<Integer>> getTestDrivesConquistaLealtadEjecutivo(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tipoProductos)
    {
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String ejecutivoId;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
                  
       List<Prueba_de_manejo__c> listPruebamanejo = [SELECT Id, 
                                                            Createddate, 
                                                            Oportunidad__c,
                                                            CreatedById,
                                                            Oportunidad__r.Ownerid,
                                                            Oportunidad__r.CreatedById,
                                                            Oportunidad__r.Tipo_contacto__c,
                                                            Oportunidad__r.AccountId 
                                                       FROM Prueba_de_manejo__c 
                                                      WHERE DAY_ONLY(convertTimeZone(Createddate)) >= :fechaIni 
                                                        AND DAY_ONLY(convertTimeZone(Createddate)) <= :fechaFin
                                                        //AND Oportunidad__r.Ownerid IN :idEjecutivos
                                                        AND CreatedById IN :idEjecutivos
                                                        AND Oportunidad__r.Tipo_contacto__c IN :tipoProductos];
                                                        
       System.debug('CONQLTLD [' + listPruebamanejo.size() + '] [' + fechaIni + '] [' + fechaFin + ']');
                                                        
       // We get the account.id of the opportunities related to 'prueba_de_manejo__c' This will be the opportunities that will count in Test Drive section
       for(Prueba_de_manejo__c pm : listPruebamanejo)
       {
          //System.debug(' [' + pm.id + '] [' + pm.createddate + '] [' + pm.oportunidad__c + '] [' + pm.oportunidad__r.ownerid + ']');
          idsAccount.add(pm.Oportunidad__r.AccountId);
       }
       
       cuentasAssets = getCountAccountAssets(idsAccount, tipoProductos);

       // for each opportunity we need to find the account and check if this contains an asset or not
       for(Prueba_de_manejo__c pm : listPruebamanejo)
        {
           accId = pm.Oportunidad__r.AccountId;
           numAssets = cuentasAssets.get(accId);
           //valuesConquistaLealtad = results.get(pm.Oportunidad__r.OwnerId);
           valuesConquistaLealtad = results.get(pm.CreatedById);
           //ejecutivoId = pm.Oportunidad__r.OwnerId;
           ejecutivoId = pm.CreatedById;
           if(valuesConquistaLealtad == null)
           {
               valuesConquistaLealtad = new List<Integer>();
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.add(1);
                  valuesConquistaLealtad.add(0);                  
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.add(0);
                  valuesConquistaLealtad.add(1);                  
               }
               results.put(ejecutivoId, valuesConquistaLealtad);
           }
           else
           {
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
               }
           }
        }
       
       System.debug('CONQL MAP [' + results + ']');
       return results;
    }


    public static Map<String, Integer> getTestDrivesFuenteOrigen(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Map<String, Integer> ejecutivosTD = new Map<String, Integer>();
       AggregateResult[] results = null;       
       System.debug('TD FO fini[' + fechaIni + '] ffin[' + fechaFin + ']');

       String idejstr = '';
       for(String idej : idEjecutivos)
       {
         idejstr = idejstr + '\'' + idej + '\',';
       }
       System.debug('TDFO idejs[' + idejstr + ']');
       System.debug('TDFO tipos prod[' + tiposProducto + ']');
       
       results = [SELECT Oportunidad__r.LeadSource leads, 
                         COUNT(Id) countN 
                    FROM Prueba_de_manejo__c
                   WHERE Createddate >= :fechaIni
                     AND Createddate <= :fechaFin 
                     //AND Oportunidad__r.Ownerid IN :idEjecutivos
                     AND CreatedById IN :idEjecutivos
                     AND Oportunidad__r.Tipo_contacto__c IN :tiposProducto
                GROUP BY Oportunidad__r.LeadSource];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ejecutivosTD.put((String)ar.get('leads'), (Integer)ar.get('countN'));
       }
       
       return ejecutivosTD;
    }


    /**
    * REFACTORING: Clave variable (Ejecutivo o Fuente)
    */
    public static Map<String, Integer> getOfertasEjecutivo(Date fechaIni, Date fechaFin, List<String> tipoProductos)
    {
       //select Ownerid, Count(Id) countN  from quote where createddate > 2018-08-01T12:00:00.000+0000 and createddate < 2018-08-31T12:00:00.000+0000 group by ownerid
       Map<String, Integer> ejecutivosOfertas = new Map<String, Integer>();

       AggregateResult[] results = null;
       results = [SELECT Ownerid idus, 
                         COUNT(Id) countN  
                    FROM Quote 
                   WHERE Createddate >= :fechaIni
                     AND Createddate <= :fechaFin
                     AND Opportunity.Tipo_contacto__c IN :tipoProductos
                GROUP BY Ownerid];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ejecutivosOfertas.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       
       return ejecutivosOfertas;
    }
    
    public static Map<String, Integer> getOfertasFuenteOrigen(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Map<String, Integer> fuenteOrigenOfertas = new Map<String, Integer>();    
       AggregateResult[] results = null; 
       
       System.debug('OF FO - fini[' + fechaIni + '] ffin[' + fechaFin + '] tp[' + tiposProducto + ']');

       results = [SELECT Opportunity.LeadSource leadsrc, 
                         COUNT(Id) countN  
                    FROM Quote 
                   WHERE Createddate >= :fechaIni
                     AND Createddate <= :fechaFin 
                     AND Opportunity.OwnerId IN :idEjecutivos
                     AND Opportunity.Tipo_contacto__c IN :tiposProducto
                GROUP BY Opportunity.LeadSource];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          fuenteOrigenOfertas.put((String)ar.get('leadsrc'), (Integer)ar.get('countN'));
       }
       
       return fuenteOrigenOfertas;
    }
    
    /**
    * REFACTORING: Clave variable (Ejecutivo o Fuente)
    */
    public static Map<String, Integer> getEntregasPorEjecutivo(List<String> idEjecutivos, String estadoOportunidad, Date fechaIni, Date fechaFin, List<String> tipoProductos)
    {

       Map<String, Integer> entregas = new Map<String, Integer>();
       AggregateResult[] results = null;

       results = [SELECT Owner.id idus, 
                         Owner.Name nameus, 
                         COUNT(Id) countN 
                    FROM Opportunity  
                   WHERE Owner.Id = :idEjecutivos
                     AND Stagename = :estadoOportunidad
                     AND Closedate >= :fechaIni
                     AND Closedate <= :fechaFin
                     AND Tipo_contacto__c IN :tipoProductos
                     AND Entregado__c = true
                GROUP BY Owner.Id, Owner.Name];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          entregas.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       
       return entregas;
    }

    /**
    * REFACTORING: Clave variable (Ejecutivo o Fuente)
    */
    public static Map<String, Integer> getVOCPorEjecutivo(Date fechaIni, Date fechaFin, List<String> tipoProductos)
    {
       Map<String, Integer> ejecutivosVOC = new Map<String, Integer>();
       List<String> oppsId = new List<String>();
       List<Calificaci_n_VOC__c> listCalificaciones = [SELECT Id, 
                                                              Createddate, 
                                                              Oportunidad__c, 
                                                              Oportunidad__r.Ownerid,
                                                              Oportunidad__r.Tipo_contacto__c
                                                         FROM Calificaci_n_VOC__c
                                                        WHERE Createddate >= :fechaIni 
                                                          AND Createddate <= :fechaFin
                                                          AND Oportunidad__r.Stagename = 'Cerrada/Ganada'
                                                          AND Oportunidad__r.Tipo_contacto__c IN :tipoProductos
                                                          AND Oportunidad__r.Fecha_de_Venta__c >= :fechaIni
                                                          AND Oportunidad__r.Fecha_de_Venta__c <= :fechaFin];
       for(Calificaci_n_VOC__c cal : listCalificaciones)
       {
          //System.debug(' [' + pm.id + '] [' + pm.createddate + '] [' + pm.oportunidad__c + '] [' + pm.oportunidad__r.ownerid + ']');
          oppsid.add(cal.oportunidad__c);
       }

       AggregateResult[] results = null;
       results = [SELECT Owner.id idus, 
                         Owner.Name nameus, 
                         COUNT(Id) countN 
                    FROM Opportunity  
                   WHERE Id IN :oppsid
                GROUP BY Owner.Id, Owner.Name];

       for (AggregateResult ar : results) 
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          ejecutivosVOC.put((String)ar.get('idus'), (Integer)ar.get('countN'));
       }
       
       return ejecutivosVOC;

    }
    
    public static Map<String, Objetivo__c> getObjetivosEjecutivos(String tipo, Date fechaIni, Date fechaFin, String selectedSucursal)    
    {
        Map<String, Objetivo__c> resultados = new Map<String, Objetivo__c>();    
        List<Objetivo__c> objetivos;
        String[] tokens;
        
        if(selectedSucursal != null)
        {
          tokens = selectedSucursal.split('\\+');
        }
        
        objetivos = [SELECT Id, 
                            Ejecutivo__c, 
                            Ejecutivo__r.Name, 
                            Prospectos__c, 
                            Leads_Calificados__c, 
                            Ventas__c, 
                            Test_Drives__c, 
                            Ofertas__c, 
                            VoC__c, 
                            Entregas__c 
                       FROM Objetivo__c 
                      WHERE Tipo__c = :tipo 
                        AND Mes__c >= :fechaIni.month() 
                        AND mes__c <= :fechaFin.month() 
                        AND anio__c = :fechaIni.year() 
                        AND Ejecutivo__r.Sucursal__c IN :tokens 
                   ORDER BY Ejecutivo__r.Name];

        for(Objetivo__c o : objetivos)
        {
            resultados.put(o.ejecutivo__c, o);
        }
        return resultados;
    
    }
    

    public static Integer getObjetivosProspectosTotales(String tipo, Date fechaIni, Date fechaFin, String selectedSucursal)
    {
        Integer totales = 0;
        Map<String, Objetivo__c> resultados = new Map<String, Objetivo__c>();    
        List<Objetivo__c> objetivos;
        String[] tokens;
        
        if(selectedSucursal != null)
        {
          tokens = selectedSucursal.split('\\+');
        }

        System.debug('[' + fechaIni.month() + '] [' + fechaFin.month() + '] [' + fechaIni.year() + '] [' + tokens + ']');

        AggregateResult[] results = null;
        
        results = [SELECT SUM(Prospectos__c) suma 
                       FROM Objetivo__c 
                      WHERE Tipo__c = :tipo 
                        AND Mes__c >= :fechaIni.month() 
                        AND mes__c <= :fechaFin.month() 
                        AND anio__c = :fechaIni.year() 
                        AND Ejecutivo__r.Sucursal__c IN :tokens];

       for (AggregateResult ar : results) 
       {
          totales = Integer.valueOf(ar.get('suma'));
       }
       
       return totales;    
    }
 
 
 
    public static Map<String, Integer> getOportunidadesPorFuenteOrigen(List<String> idEjecutivos, String estadoOportunidad, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {

       Map<String, Integer> opps = new Map<String, Integer>();
       AggregateResult[] results = null;

       results = [SELECT LeadSource leadsrc, 
                         COUNT(Id) countN 
                    FROM Opportunity  
                   WHERE Owner.Id = :idEjecutivos
                     //AND Stagename = :estadoOportunidad
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) >= :fechaIni
                     AND DAY_ONLY(convertTimeZone(CreatedDate)) <= :fechaFin
                     AND Tipo_contacto__c IN :tiposProducto
                GROUP BY LeadSource];

       for (AggregateResult ar : results)
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          opps.put((String)ar.get('leadsrc'), (Integer)ar.get('countN'));
       }
       return opps;
    }


    public static Map<String, Integer> getVentasPorFuenteOrigen(List<String> idEjecutivos, String estadoOportunidad, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {

       Map<String, Integer> opps = new Map<String, Integer>();
       AggregateResult[] results = null;

       results = [SELECT LeadSource leadsrc, 
                         COUNT(Id) countN 
                    FROM Opportunity  
                   WHERE Owner.Id = :idEjecutivos
                     AND Stagename = :estadoOportunidad
                     AND Fecha_de_Venta__c >= :fechaIni
                     AND Fecha_de_Venta__c <= :fechaFin
                     AND Tipo_contacto__c IN :tiposProducto
                GROUP BY LeadSource];

       for (AggregateResult ar : results)
       {
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          opps.put((String)ar.get('leadsrc'), (Integer)ar.get('countN'));
       }
       
       return opps;
    }


    public static Map<String, ScorecardTotalesObjetivo> getObjetivosFuenteOrigen(String selectedSucursal, Date fechaIni, Date fechaFin)
    {
       Map<String, ScorecardTotalesObjetivo> objetivosFO = new Map<String, ScorecardTotalesObjetivo>();
       ScorecardTotalesObjetivo scto;
       AggregateResult[] results = null;
       
       String[] tokens;
        
       if(selectedSucursal != null)
       {
         tokens = selectedSucursal.split('\\+');
       }
       
       results = [SELECT Fuente_Origen__c leadsrc, 
                         SUM(Prospectos__c) sumPros, 
                         SUM(Leads_Calificados__c) sumLeads, 
                         SUM(Ventas__c) sumVentas, 
                         SUM(Test_Drives__c) sumTD, 
                         SUM(Ofertas__c) sumOf, 
                         SUM(VoC__c) sumVOC, 
                         SUM(Entregas__c) sumEnt
                    FROM Objetivo__c 
                   WHERE Tipo__c = 'Mensual Origen'
                     AND Objetivo_Sucursal__c IN :tokens
                     AND Mes__c >= :fechaIni.month() 
                     AND mes__c <= :fechaFin.month() 
                     AND anio__c = :fechaIni.year() 
                GROUP BY Fuente_Origen__c];
          
       Decimal value;
       for (AggregateResult ar : results)
       {
          scto = new ScorecardTotalesObjetivo();
           
          value = (Decimal)ar.get('sumPros');
          scto.prospectos = value == null ? 0 : value.intValue();
          value = (Decimal)ar.get('sumTD');
          scto.testDrive = value == null ? 0 : value.intValue();
          value = (Decimal)ar.get('sumLeads');
          scto.leads = value == null ? 0 : value.intValue();
          value = (Decimal)ar.get('sumVentas');
          scto.ventas = value == null ? 0 : value.intValue();
          value = (Decimal)ar.get('sumOf');
          scto.ofertas = value == null ? 0 : value.intValue();
          value = (Decimal)ar.get('sumEnt');
          scto.entregas = value == null ? 0 : value.intValue();            
          value = (Decimal)ar.get('sumVOC');
          scto.voc = value == null ? 0 : value.intValue();                     
          //System.debug(ar.get('idus')+'-'+ar.get('nameus')+'-'+ar.get('countN'));
          objetivosFO.put((String)ar.get('leadsrc'), scto);
       }
                
       return objetivosFO;
    }
    
    
    public static List<Campaign> getCampanias(String selectedSucursal, Date fechaIni, Date fechaFin)
    {
        List<Campaign> campanias;
        String aux = selectedSucursal.replace('+',';');
        
        String[] tokens;
        
        if(selectedSucursal != null)
        {
          tokens = selectedSucursal.split('\\+');
        }
        
        System.debug('campanias suc [' + tokens + '] fini[' + fechaIni + '] ffin[' + fechaFin + '] replace[' + aux + ']');
        
        campanias = [SELECT Id,
                            Name,
                            NumberOfLeads,
                            NumberOfContacts,
                            Asistentes__c,
                            Confirmados__c,
                            Objetivo_Invitados__c,
                            Objetivo_de_Asistentes__c,
                            Objetivo_Leads_Calificados__c,
                            Objetivo_Ofertas__c,
                            Objetivo_Test_Drive__c,
                            Objetivo_Ventas__c,
                            Sucursal__c,
                            Type,
                            Status,
                            StartDate,
                            EndDate
                       FROM Campaign
                     WHERE Sucursal__c in :tokens
                       AND Type = 'Event'
                     AND ((StartDate >= :fechaIni
                          AND StartDate <= :fechaFin)
                          OR (EndDate >= :fechaIni
                          AND EndDate <= :fechaFin))];
        
        System.debug('campanias [' + campanias.size() + ']');    
        return campanias;
    }
    
    
    public static Map<String, Integer> getTestDriveCampania(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Map<String, Integer> campaniasTD = new Map<String, Integer>();
       List<Opportunity> oportunidades;
       List<Prueba_de_manejo__c> listTD;
       Integer numPruebasManejo;
       Integer numPruebasManejoExistentes = 0;
       
       oportunidades = [SELECT Id,
                               Campaignid,
                               (SELECT Id 
                                  FROM Pruebas_de_manejo__r)
                          FROM Opportunity
                         WHERE Owner.Id IN :idEjecutivos
                           AND Closedate >= :fechaIni
                           AND Closedate <= :fechaFin
                           AND Campaignid != null
                           AND Tipo_contacto__c IN :tiposProducto];

       for(Opportunity op : oportunidades)
       {
          listTD = op.Pruebas_de_manejo__r;
          numPruebasManejo = (listTD != null) ? listTD.size() : 0;
          numPruebasManejoExistentes = campaniasTD.get(op.CampaignId);
          if(numPruebasManejoExistentes == null)
          {
             campaniasTD.put(op.CampaignId, numPruebasManejo);
          }
          else
          {
            numPruebasManejo = numPruebasManejo + numPruebasManejoExistentes;
            campaniasTD.put(op.CampaignId, numPruebasManejo);
          }
       }
       
       return campaniasTD;
    }


    public static Map<String, Integer> getVentasCampania(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Map<String, Integer> campaniasVentas = new Map<String, Integer>();
       List<Opportunity> oportunidades;
       Integer numVentas;
       Integer numVentasExistentes = 0;
       
       oportunidades = [SELECT Id,
                               Campaignid
                          FROM Opportunity
                         WHERE Owner.Id IN :idEjecutivos
                           AND Closedate >= :fechaIni
                           AND Closedate <= :fechaFin
                           AND Stagename = 'Cerrada/Ganada'
                           AND Tipo_contacto__c IN :tiposProducto];

       for(Opportunity op : oportunidades)
       {
         if (op.CampaignId != null)
         {
          numVentas = 1;
          numVentasExistentes = campaniasVentas.get(op.CampaignId);
          if(numVentasExistentes == null)
          {
             campaniasVentas.put(op.CampaignId, numVentas);
          }
          else
          {
            numVentas = numVentas + numVentasExistentes;
            campaniasVentas.put(op.CampaignId, numVentas);
          }
         }
       }
       
       return campaniasVentas;
    }
 

    public static Map<String, Integer> getOfertasCampania(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Map<String, Integer> campaniasOfertas = new Map<String, Integer>();
       List<Quote> ofertas;
       List<String> oppIds = new List<String>();
       List<Opportunity> oportunidades;
       Integer numOfertas;
       Integer numOfertasExistentes = 0;
       
       ofertas = [ SELECT OpportunityId,
                          Opportunity.Tipo_contacto__c
                    FROM Quote 
                   WHERE Createddate >= :fechaIni
                     AND Createddate <= :fechaFin 
                     AND Opportunity.OwnerId IN :idEjecutivos
                     AND Opportunity.Tipo_contacto__c IN :tiposProducto];
       for(Quote q : ofertas)
       {
          oppIds.add(q.OpportunityId);
       }
       
       oportunidades = [SELECT Id,
                               Campaignid
                          FROM Opportunity
                         WHERE Id IN :oppIds];

       for(Opportunity op : oportunidades)
       {
         if (op.CampaignId != null)
         {
          numOfertas = 1;
          numOfertasExistentes = campaniasOfertas.get(op.CampaignId);
          if(numOfertasExistentes == null)
          {
             campaniasOfertas.put(op.CampaignId, numOfertas);
          }
          else
          {
            numOfertas = numOfertas + numOfertasExistentes;
            campaniasOfertas.put(op.CampaignId, numOfertas);
          }
         }
       }
       
       return campaniasOfertas;
    }
    
    
    
    /**
    *   Returns the number of Assets with Type assetTypes for Accounts in accIds
    */
    public static Map<Id, Integer> getCountAccountAssets(set<Id> accIds, list<String> assetTypes){
        map<Id, Integer> result = new map<Id, Integer>();
        List<Asset> assets = [SELECT Contact.AccountId, 
                            Id
                            FROM Asset 
                            WHERE Tipo_Venta__c IN :assetTypes 
                            AND Contact.AccountId IN :accIds 
                            ORDER BY Contact.AccountId];

        for(Asset a : assets)
        {
            if(!result.containsKey(a.Contact.AccountId)){
                result.put(a.Contact.AccountId, 0);
            }
            result.put(a.Contact.AccountId, result.get(a.Contact.AccountId) + 1);
        }
        return result;  
    }
    
    
    public static Map<String, List<Integer>> getLeadsConquistaLealtadEjecutivo(List<String> idEjecutivos, Date fechaIni, Date fechaFin, String etapa, List<String> tipoProductos)
    {
     //SELECT Id, Createddate, Oportunidad__c, Oportunidad__r.Ownerid, Oportunidad__r.AccountId, Oportunidad__r.Account.Name FROM Prueba_de_manejo__c 
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String ejecutivoId;       
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
                  
       List<Opportunity> listOpps = [SELECT Owner.id, 
                                           Owner.Name, 
                                           Id,
                                           AccountId,
                                           Account.Name
                                      FROM Opportunity  
                                     WHERE Owner.Id = :idEjecutivos
                                       //AND Stagename = :etapa
                                       AND Tipo_contacto__c IN :tipoProductos
                                       AND DAY_ONLY(convertTimeZone(CreatedDate)) >= :fechaIni
                                       AND DAY_ONLY(convertTimeZone(CreatedDate)) <= :fechaFin];
                                                        
       System.debug('CONQLTLD LEADS [' + listOpps.size() + ']');
                                                        
       // We get the account.id of the opportunities related to 'prueba_de_manejo__c' This will be the opportunities that will count in Test Drive section
       for(Opportunity opp : listOpps)
       {
          //System.debug(' [' + pm.id + '] [' + pm.createddate + '] [' + pm.oportunidad__c + '] [' + pm.oportunidad__r.ownerid + ']');
          idsAccount.add(opp.AccountId);
       }
       
       cuentasAssets = getCountAccountAssets(idsAccount, tipoProductos);
       // we get the opportunities
       // for each opportunity we need to find the account and check if this contains an asset or not
       for(Opportunity op : listOpps)        
       {
          accId = op.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(op.Owner.id);
          ejecutivoId = op.Owner.id;
          if(valuesConquistaLealtad == null)
          {
             valuesConquistaLealtad = new List<Integer>();
             if(numAssets == null || numAssets == 1)
             {
                valuesConquistaLealtad.add(1);
                valuesConquistaLealtad.add(0);                  
             }
             if(numAssets != null && numAssets > 1)
             {
                valuesConquistaLealtad.add(0);
                valuesConquistaLealtad.add(1);                  
             }
             results.put(ejecutivoId, valuesConquistaLealtad);
          }
          else
          {
             if(numAssets == null || numAssets == 1)
             {
                valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
             }
             if(numAssets != null && numAssets > 1)
             {
                valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
             }
          }
       }
       
       System.debug('CONQL MAP LEADS [' + results + ']');
       return results;
    }
    

    public static Map<String, List<Integer>> getVentasConquistaLealtadEjecutivo(List<String> idEjecutivos, Date fechaIni, Date fechaFin, String etapa, List<String> tipoProductos)
    {
     //SELECT Id, Createddate, Oportunidad__c, Oportunidad__r.Ownerid, Oportunidad__r.AccountId, Oportunidad__r.Account.Name FROM Prueba_de_manejo__c 
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String ejecutivoId;       
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
                  
       List<Opportunity> listOpps = [SELECT Owner.id, 
                                           Owner.Name, 
                                           Id,
                                           AccountId,
                                           Account.Name
                                      FROM Opportunity  
                                     WHERE Owner.Id = :idEjecutivos
                                       AND Stagename = :etapa
                                       AND Tipo_contacto__c IN :tipoProductos
                                       AND Fecha_de_Venta__c >= :fechaIni
                                       AND Fecha_de_Venta__c <= :fechaFin];
                                                        
       System.debug('CONQLTLD LEADS [' + listOpps.size() + ']');
                                                        
       // We get the account.id of the opportunities related to 'prueba_de_manejo__c' This will be the opportunities that will count in Test Drive section
       for(Opportunity opp : listOpps)
       {
          //System.debug(' [' + pm.id + '] [' + pm.createddate + '] [' + pm.oportunidad__c + '] [' + pm.oportunidad__r.ownerid + ']');
          idsAccount.add(opp.AccountId);
       }
       
       cuentasAssets = getCountAccountAssets(idsAccount, tipoProductos);
       // we get the opportunities
       // for each opportunity we need to find the account and check if this contains an asset or not
       for(Opportunity op : listOpps)        
       {
          accId = op.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(op.Owner.id);
          ejecutivoId = op.Owner.id;
          if(valuesConquistaLealtad == null)
          {
             valuesConquistaLealtad = new List<Integer>();
             if(numAssets == null || numAssets == 1)
             {
                valuesConquistaLealtad.add(1);
                valuesConquistaLealtad.add(0);                  
             }
             if(numAssets != null && numAssets > 1)
             {
                valuesConquistaLealtad.add(0);
                valuesConquistaLealtad.add(1);                  
             }
             results.put(ejecutivoId, valuesConquistaLealtad);
          }
          else
          {
             if(numAssets == null || numAssets == 1)
             {
                valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
             }
             if(numAssets != null && numAssets > 1)
             {
                valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
             }
          }
       }
       
       System.debug('CONQL MAP LEADS [' + results + ']');
       return results;
    }


    public static Map<String, List<Integer>> getOfertasConquistaLealtadEjecutivo(Date fechaIni, Date fechaFin, List<String> tipoProductos)
    {
       Set<Id> idsAccount = new Set<Id>();
       List<String> idEjecutivos = new List<String>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String ejecutivoId;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
    
       List<Quote> listQuotes = [SELECT Ownerid, 
                                        Id,
                                        Opportunity.Tipo_contacto__c,
                                        Contact.Id, 
                                        Contact.AccountId, 
                                        Accountid  
                                   FROM Quote 
                                  WHERE Createddate >= :fechaIni
                                    AND Createddate <= :fechaFin
                                    AND Opportunity.Tipo_contacto__c IN :tipoProductos];
       for(Quote q : listQuotes)
       {
           idsAccount.add(q.AccountId);
           idEjecutivos.add(q.Ownerid);
       }
       
       List<String> assetTypes = new List<String>();
       assetTypes.add('0Km');
       assetTypes.add('BPS');
       
       cuentasAssets = getCountAccountAssets(idsAccount, assetTypes);
       
        for(Quote q : listQuotes)
        {
           accId = q.AccountId;
           numAssets = cuentasAssets.get(accId);
           valuesConquistaLealtad = results.get(q.OwnerId);
           ejecutivoId = q.OwnerId;
           if(valuesConquistaLealtad == null)
           {
               valuesConquistaLealtad = new List<Integer>();
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.add(1);
                  valuesConquistaLealtad.add(0);                  
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.add(0);
                  valuesConquistaLealtad.add(1);                  
               }
               results.put(ejecutivoId, valuesConquistaLealtad);
           }
           else
           {
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
               }
           }
        }
       
       return results;
    }
 
   
    public static Map<String, List<Integer>> getEntregasConquistaLealtadEjecutivo(List<String> idEjecutivos, Date fechaIni, Date fechaFin, String etapa, List<String> tipoProductos)
    {
     //SELECT Id, Createddate, Oportunidad__c, Oportunidad__r.Ownerid, Oportunidad__r.AccountId, Oportunidad__r.Account.Name FROM Prueba_de_manejo__c 
       Set<Id> idsAccount = new Set<Id>();
       List<String> oppsId = new List<String>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String ejecutivoId;       
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
                  
       List<Opportunity> listOpps = [SELECT Owner.id, 
                         Owner.Name,
                         Tipo_contacto__c,
                         AccountId,
                         Account.Name 
                    FROM Opportunity  
                   WHERE Owner.Id = :idEjecutivos
                     AND Stagename = :etapa
                     AND Closedate >= :fechaIni
                     AND Closedate <= :fechaFin
                     AND Tipo_contacto__c IN :tipoProductos
                     AND Entregado__c = true];
                                                        
       System.debug('CONQLTLD LEADS [' + listOpps.size() + ']');
                                                        
       // We get the account.id of the opportunities related to 'prueba_de_manejo__c' This will be the opportunities that will count in Test Drive section
       for(Opportunity opp : listOpps)
       {
          //System.debug(' [' + pm.id + '] [' + pm.createddate + '] [' + pm.oportunidad__c + '] [' + pm.oportunidad__r.ownerid + ']');
          idsAccount.add(opp.AccountId);
          oppsid.add(opp.id);          
       }
       
       cuentasAssets = getCountAccountAssets(idsAccount, tipoProductos);
       // we get the opportunities
       /*List<Opportunity> opps = [SELECT Owner.id, 
                         Owner.Name, 
                         AccountId, 
                         Account.Name
                    FROM Opportunity  
                   WHERE Id IN :oppsid];*/
        // for each opportunity we need to find the account and check if this contains an asset or not
        //for(Opportunity op : opps)
        for(Opportunity op : listOpps)
        {
           accId = op.AccountId;
           numAssets = cuentasAssets.get(accId);
           valuesConquistaLealtad = results.get(op.Owner.id);
           ejecutivoId = op.Owner.id;
           if(valuesConquistaLealtad == null)
           {
               valuesConquistaLealtad = new List<Integer>();
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.add(1);
                  valuesConquistaLealtad.add(0);                  
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.add(0);
                  valuesConquistaLealtad.add(1);                  
               }
               results.put(ejecutivoId, valuesConquistaLealtad);
           }
           else
           {
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
               }
           }
        }
       
       System.debug('CONQL MAP LEADS [' + results + ']');
       return results;
    }
   

    public static Map<String, List<Integer>> getVOCConquistaLealtadEjecutivo(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();    
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String ejecutivoId;       
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
    
       List<Calificaci_n_VOC__c> listCalificaciones = [SELECT Id, 
                                                              Createddate, 
                                                              Oportunidad__c, 
                                                              Oportunidad__r.Ownerid,
                                                              Oportunidad__r.Tipo_contacto__c,
                                                              Oportunidad__r.Accountid 
                                                         FROM Calificaci_n_VOC__c
                                                        WHERE Createddate >= :fechaIni 
                                                          AND Createddate <= :fechaFin
                                                          AND Oportunidad__r.Stagename = 'Cerrada/Ganada'
                                                          AND Oportunidad__r.Tipo_contacto__c IN :tiposProducto
                                                          AND Oportunidad__r.Fecha_de_Venta__c >= :fechaIni
                                                          AND Oportunidad__r.Fecha_de_Venta__c <= :fechaFin];
       for(Calificaci_n_VOC__c voc : listCalificaciones)
       {
          idsAccount.add(voc.Oportunidad__r.Accountid);
       }

       List<String> assetTypes = new List<String>();
       assetTypes.add('0Km');
       assetTypes.add('BPS');
       
       cuentasAssets = getCountAccountAssets(idsAccount, assetTypes);

       for(Calificaci_n_VOC__c voc : listCalificaciones)
       {
          accId = voc.Oportunidad__r.Accountid;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(voc.Oportunidad__r.Ownerid);
          ejecutivoId = voc.Oportunidad__r.Ownerid;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);                  
              }
              results.put(ejecutivoId, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }

       return results;
    }

//------------------------------------------------ Fuente Origen Conquista Lealtad---------------------------------------------------------------

    public static Map<String, List<Integer>> getTDConquistaLealtadFuenteOrigen(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String leadSource;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
    
       List<Prueba_de_manejo__c> listPruebamanejo = [SELECT Id,
                                                            CreatedById,
                                                            Createddate, 
                                                            Oportunidad__c,
                                                            Oportunidad__r.Tipo_contacto__c,
                                                            Oportunidad__r.Ownerid,
                                                            Oportunidad__r.AccountId,
                                                            Oportunidad__r.LeadSource
                                                       FROM Prueba_de_manejo__c 
                                                      WHERE Createddate >= :fechaIni 
                                                        AND Createddate <= :fechaFin
                                                        //AND Oportunidad__r.Ownerid IN :idEjecutivos
                                                        AND CreatedById IN :idEjecutivos
                                                        AND Oportunidad__r.Tipo_contacto__c IN :tiposProducto];
       for(Prueba_de_manejo__c pm : listPruebamanejo)
       {
          idsAccount.add(pm.Oportunidad__r.AccountId);
       }

       cuentasAssets = getCountAccountAssets(idsAccount, tiposProducto);

       for(Prueba_de_manejo__c pm : listPruebamanejo)
       {
          accId = pm.Oportunidad__r.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(pm.Oportunidad__r.LeadSource);
          leadSource = pm.Oportunidad__r.LeadSource;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);                  
              }
              results.put(leadSource, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }
       return results;       
    }


    public static Map<String, List<Integer>> getOportunidadConquistaLealtadFuenteOrigen(List<String> idEjecutivos, String estadoOportunidad, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String leadSource;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
    
       List<Opportunity> listOpps = [SELECT Owner.id, 
                                           Owner.Name, 
                                           Id,
                                           AccountId,
                                           Tipo_contacto__c,
                                           LeadSource
                                      FROM Opportunity  
                                     WHERE Owner.Id = :idEjecutivos
                                       AND Stagename = :estadoOportunidad
                                       AND Closedate >= :fechaIni
                                       AND Closedate <= :fechaFin
                                       AND Tipo_contacto__c IN :tiposProducto];
                                       
       for(Opportunity opp : listOpps)
       {
          idsAccount.add(opp.AccountId);
       }

       List<String> assetTypes = new List<String>();
       assetTypes.add('0Km');
       assetTypes.add('BPS');
       
       cuentasAssets = getCountAccountAssets(idsAccount, assetTypes);

        for(Opportunity op : listOpps)
        {
          accId = op.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(op.LeadSource);
          leadSource = op.LeadSource;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);                  
              }
              results.put(leadSource, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }
       return results;       
    }


    public static Map<String, List<Integer>> getVentasConquistaLealtadFuenteOrigen(List<String> idEjecutivos, String estadoOportunidad, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String leadSource;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
    
       List<Opportunity> listOpps = [SELECT Owner.id, 
                                           Owner.Name, 
                                           Id,
                                           AccountId,
                                           Tipo_contacto__c,
                                           LeadSource
                                      FROM Opportunity  
                                     WHERE Owner.Id = :idEjecutivos
                                       AND Stagename = :estadoOportunidad
                                       AND Fecha_de_Venta__c >= :fechaIni
                                       AND Fecha_de_Venta__c <= :fechaFin
                                       AND Tipo_contacto__c IN :tiposProducto];
                                       
       for(Opportunity opp : listOpps)
       {
          idsAccount.add(opp.AccountId);
       }

       /*List<String> assetTypes = new List<String>();
       assetTypes.add('0Km');
       assetTypes.add('BPS');*/
       
       cuentasAssets = getCountAccountAssets(idsAccount, tiposProducto);

        for(Opportunity op : listOpps)
        {
          accId = op.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(op.LeadSource);
          leadSource = op.LeadSource;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);                  
              }
              results.put(leadSource, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }
       return results;       
    }


    public static Map<String, List<Integer>> getOfertasConquistaLealtadFO(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String leadSource;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
    
       List<Quote> listQuotes = [SELECT Ownerid, 
                                        Id,
                                        Contact.Id, 
                                        Contact.AccountId, 
                                        Accountid,
                                        Opportunity.LeadSource,
                                        Opportunity.Tipo_contacto__c
                                   FROM Quote 
                                  WHERE Createddate >= :fechaIni
                                    AND Createddate <= :fechaFin
                                    AND Opportunity.OwnerId IN :idEjecutivos
                                    AND Opportunity.Tipo_contacto__c IN :tiposProducto];
       for(Quote q : listQuotes)
       {
           idsAccount.add(q.AccountId);
       }

       cuentasAssets = getCountAccountAssets(idsAccount, tiposProducto);
       
        for(Quote q : listQuotes)
        {
           accId = q.AccountId;
           numAssets = cuentasAssets.get(accId);
           valuesConquistaLealtad = results.get(q.Opportunity.LeadSource);
           leadSource = q.Opportunity.LeadSource;
           if(valuesConquistaLealtad == null)
           {
               valuesConquistaLealtad = new List<Integer>();
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.add(1);
                  valuesConquistaLealtad.add(0);                  
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.add(0);
                  valuesConquistaLealtad.add(1);                  
               }
               results.put(leadSource, valuesConquistaLealtad);
           }
           else
           {
               if(numAssets == null || numAssets == 1)
               {
                  valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
               }
               if(numAssets != null && numAssets > 1)
               {
                  valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
               }
           }
        }
       
       return results;
    
    }
 
 //------------------------------------------------ Campanias Conquista Lealtad---------------------------------------------------------------
 
     public static Map<String, List<Integer>> getTestDriveCampaniaConquistaLealtad(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String idCampaign;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
    
       List<Prueba_de_manejo__c> listPruebamanejo = [SELECT Id, 
                                                            Createddate, 
                                                            Oportunidad__c, 
                                                            Oportunidad__r.Ownerid,
                                                            Oportunidad__r.AccountId,
                                                            Oportunidad__r.LeadSource,
                                                            Oportunidad__r.Tipo_contacto__c,
                                                            Oportunidad__r.Campaignid
                                                       FROM Prueba_de_manejo__c 
                                                      WHERE Createddate >= :fechaIni 
                                                        AND Createddate <= :fechaFin
                                                        AND Oportunidad__r.Campaignid != null
                                                        AND Oportunidad__r.Tipo_contacto__c IN :tiposProducto];
       for(Prueba_de_manejo__c pm : listPruebamanejo)
       {
          idsAccount.add(pm.Oportunidad__r.AccountId);
       }

       cuentasAssets = getCountAccountAssets(idsAccount, tiposProducto);

       for(Prueba_de_manejo__c pm : listPruebamanejo)
       {
          accId = pm.Oportunidad__r.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(pm.Oportunidad__r.Campaignid);
          idCampaign = pm.Oportunidad__r.Campaignid;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);                  
              }
              results.put(idCampaign, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }
       return results;
    
    }
    
    
    public static Map<String, List<Integer>> getVentasCampaniaConquistaLealtad(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       List<Opportunity> oportunidades;
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String idCampaign;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
        
       oportunidades = [SELECT Id,
                               AccountId,
                               Tipo_contacto__c,
                               Campaignid
                          FROM Opportunity
                         WHERE Owner.Id IN :idEjecutivos
                           AND Closedate >= :fechaIni
                           AND Closedate <= :fechaFin
                           AND Stagename = 'Cerrada/Ganada'
                           AND Tipo_contacto__c IN :tiposProducto];
        
       for(Opportunity op : oportunidades)
       {
          idsAccount.add(op.AccountId);
       }

       List<String> assetTypes = new List<String>();
       assetTypes.add('0Km');
       assetTypes.add('BPS');
       
       cuentasAssets = getCountAccountAssets(idsAccount, assetTypes);
     
       for(Opportunity op : oportunidades)
       {
          accId = op.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(op.Campaignid);
          idCampaign = op.Campaignid;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);                  
              }
              results.put(idCampaign, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }
       return results;
        
    }

    public static Map<String, List<Integer>> getOfertasCampaniaConquistaLealtad(List<String> idEjecutivos, Date fechaIni, Date fechaFin, List<String> tiposProducto)
    {
       List<Quote> ofertas;
       Set<Id> idsAccount = new Set<Id>();
       Map<Id, Integer> cuentasAssets;
       String accId;
       String idCampaign;
       Integer numAssets;
       List<Integer> valuesConquistaLealtad;
       Map<String, List<Integer>> results = new Map<String, List<Integer>>();
        
       ofertas = [SELECT OpportunityId,
                         Opportunity.AccountId,
                         Opportunity.Tipo_contacto__c,
                         Opportunity.CampaignId 
                    FROM Quote 
                   WHERE Createddate >= :fechaIni
                     AND Createddate <= :fechaFin 
                     AND Opportunity.OwnerId IN :idEjecutivos
                     AND Opportunity.Tipo_contacto__c IN :tiposProducto];
        
       for(Quote q : ofertas)
       {
          idsAccount.add(q.Opportunity.AccountId);
       }

       List<String> assetTypes = new List<String>();
       assetTypes.add('0Km');
       assetTypes.add('BPS');
       
       cuentasAssets = getCountAccountAssets(idsAccount, assetTypes);
     
       for(Quote q : ofertas)
       {
          accId = q.Opportunity.AccountId;
          numAssets = cuentasAssets.get(accId);
          valuesConquistaLealtad = results.get(q.Opportunity.CampaignId);
          idCampaign = q.Opportunity.CampaignId;
          if(valuesConquistaLealtad == null)
          {
              valuesConquistaLealtad = new List<Integer>();
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.add(1);
                 valuesConquistaLealtad.add(0);                  
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.add(0);
                 valuesConquistaLealtad.add(1);
              }
              results.put(idCampaign, valuesConquistaLealtad);
          }
          else
          {
              if(numAssets == null || numAssets == 1)
              {
                 valuesConquistaLealtad.set(0, valuesConquistaLealtad.get(0) + 1);
              }
              if(numAssets != null && numAssets > 1)
              {
                 valuesConquistaLealtad.set(1, valuesConquistaLealtad.get(1) + 1);
              }
          }
       }
       return results;
        
    }


    /**
    *   Returns the number of Assets with Type assetTypes for Contacts in cntIds
    */
    public static Map<Id, Integer> getCountContactAssets(set<Id> cntIds, list<String> assetTypes){
        map<Id, Integer> result = new map<Id, Integer>();

        for(AggregateResult ar : [SELECT ContactId, 
                                    COUNT(Id) cnt
                                    FROM Asset 
                                    WHERE Tipo_Venta__c IN :assetTypes 
                                    AND ContactId IN :cntIds 
                                    GROUP BY ContactId]){
            result.put((Id)ar.get('ContactId'), Integer.valueOf(ar.get('cnt')));
        }
        return result;  
    }


    public static List<Map<String, ProspectoInformacion>> getProspectosEjecutivoLeadSource(List<String> idEjecutivos, List<String> tiposProducto, Date fechaIni, Date fechaFin, PSummary psumm)
    {
        ProspectoInformacion prospectoInfoEjecutivo;
        ProspectoInformacion prospectoInfoFO;
        Map<String, ProspectoInformacion> ejecutivosProspectos = new Map<String, ProspectoInformacion>();
        Map<String, ProspectoInformacion> fuenteOrigenProspectos = new Map<String, ProspectoInformacion>();

        List<String> leadsIds = new List<String>();
        
        List<Map<String, ProspectoInformacion>> results = new List<Map<String, ProspectoInformacion>>();

        List<Lead> leads = [SELECT Id, 
                                   Es_Retail_WholeSale__c,
                                   Name, 
                                   IsConverted,
                                   OwnerId, 
                                   Owner.Name, 
                                   LeadSource, 
                                   Status 
                              FROM Lead
                             WHERE OwnerId IN :idEjecutivos
                               AND Tipo_de_producto__c IN :tiposProducto
                               AND CreatedDate >= :fechaIni
                               AND CreatedDate <= :fechaFin];

        System.debug('TOT LDS [' + leads.size() + ']');
        for (Lead lead : leads)
        {
           leadsIds.add(lead.Id);
           prospectoInfoEjecutivo = ejecutivosProspectos.get(lead.OwnerId);
           if(prospectoInfoEjecutivo == null)
           { 
               prospectoInfoEjecutivo = new ProspectoInformacion();
               prospectoInfoEjecutivo.identificador = lead.OwnerId;
               prospectoInfoEjecutivo.numeroProspectos = 1;
           }
           else
           {
               prospectoInfoEjecutivo.numeroProspectos++;
           }
           prospectoInfoEjecutivo.numeroConquista++;
           ejecutivosProspectos.put(lead.OwnerId, prospectoInfoEjecutivo);

           prospectoInfoFO = fuenteOrigenProspectos.get(lead.LeadSource);
           if(prospectoInfoFO == null)
           {
              prospectoInfoFO = new ProspectoInformacion();
              prospectoInfoFO.identificador = lead.LeadSource;
              prospectoInfoFO.numeroProspectos = 1;
           }
           else
           {
               prospectoInfoFO.numeroProspectos++;
           }
           prospectoInfoFO.numeroConquista++;           
           fuenteOrigenProspectos.put(lead.LeadSource, prospectoInfoFO);

           if(lead.Es_Retail_WholeSale__c == 'Retail')
           {
               psumm.retailConq++;
           }

           if(lead.Es_Retail_WholeSale__c == 'WholeSale')
           {
               psumm.wholesaleConq++;
           }

            /*if(!lead.IsConverted && lead.Status != DESCALIFICADO){
                psumm.accumActive += 1;
                if(lead.CreatedDate >= dateIni){
                    psumm.generatedActive += 1;
                }
            }*/
            psumm.accumRaw += 1;

        }

        ProspectoInformacion pi;
        Integer sumPi = 0;
        for(String leadId : ejecutivosProspectos.keySet())
        {
           pi = ejecutivosProspectos.get(leadId);
           sumPi = sumPi + pi.numeroProspectos;
        }

        ProspectoInformacion pil;
        Integer sumPil = 0;
        for(String leadId : fuenteOrigenProspectos.keySet())
        {
           pil = fuenteOrigenProspectos.get(leadId);
           sumPil = sumPil + pil.numeroProspectos;
        }

       // obtener contactos asociados a campanias que estan en el intervalo de fechas elegido
        Map<Id, CampaignMember> cntIdToMemberStatus = new Map<Id, CampaignMember>();
        for(CampaignMember c : [SELECT ContactId,
                                       Status,
                                       Campaign.StartDate,
                                       LeadSource,
                                       LeadId, 
                                       CampaignId
                                  FROM CampaignMember
                                 WHERE Campaign.StartDate >= :fechaIni
                                   AND Campaign.EndDate <= :fechaFin
                                   AND Campaign.RecordType.DeveloperName != 'CRM_Satisf'
                                   AND ContactId != null
                                   //AND LeadId IN :leadsIds
                              ORDER BY Campaign.StartDate])
        {
            cntIdToMemberStatus.put(c.ContactId, c);
        }

       //obtener el conteo de activos por contacto
       Map<Id, Integer> contactAssets = getCountContactAssets(cntIdToMemberStatus.keySet(), tiposProducto);

       //por cada contacto, contabiliza prospectos, prospectos conquista y lealtas, por ejecutivo y fuente origen
       CampaignMember cm;
       Integer numActivos = 0;

       // mapa de contactId, ownerid
       Map<String, Contact> contactsMap = new Map<String, Contact>([SELECT Id, OwnerID FROM Contact WHERE Id IN :cntIdToMemberStatus.keySet()]);
       Contact contactOwner;

       for(String idContacto : cntIdToMemberStatus.keySet())
       {
          cm = cntIdToMemberStatus.get(idContacto);
          numActivos = contactAssets.get(idContacto);
          contactOwner = contactsMap.get(idContacto);

          //prospectoInfoEjecutivo = ejecutivosProspectos.get(cm.LeadId);
          prospectoInfoEjecutivo = ejecutivosProspectos.get(contactOwner.OwnerId);
          //sort por owner del contacto
           // mapa de idejecutivos, prospectoInfomracion

           // en lead source tabla con source nulo
          prospectoInfoFO = fuenteOrigenProspectos.get(cm.LeadSource);

          if(prospectoInfoEjecutivo != null && prospectoInfoFO != null)
          {
             prospectoInfoEjecutivo.numeroProspectos++;
             if(numActivos > 1)
             {
                 prospectoInfoEjecutivo.numeroLealtad++;
             }
             else
             {
                 prospectoInfoEjecutivo.numeroConquista++;
             }

             prospectoInfoFO.numeroProspectos++;
             if(numActivos > 1)
             {
                prospectoInfoFO.numeroLealtad++;
             }
             else
             {
                prospectoInfoFO.numeroConquista++;
             }

             psumm.retailConq++;
             //prospectosSummary.accumRaw += 1;
          }
       }

        sumPi = 0;
        for(String leadId : ejecutivosProspectos.keySet())
        {
           pi = ejecutivosProspectos.get(leadId);
           sumPi = sumPi + pi.numeroProspectos;
        }

        sumPil = 0;
        for(String leadId : fuenteOrigenProspectos.keySet())
        {
           pil = fuenteOrigenProspectos.get(leadId);
           sumPil = sumPil + pil.numeroProspectos;
        }
       psumm.generatedRaw = sumPil;

       results.add(ejecutivosProspectos);
       results.add(fuenteOrigenProspectos);
       return results;
    }

    public static Map<String, Report_Link__mdt> getCustomMetadata()
    {
      Map<String, Report_Link__mdt> results = new Map<String, Report_Link__mdt>();
      List<Report_Link__mdt> metadataList;
      metadataList = [SELECT Id, 
                             MasterLabel, 
                             Label, 
                             Link__c,
                             pc0__c,
                             pn0__c,
                             pc1__c,
                             pn1__c,
                             pc2__c,
                             pn2__c,
                             pc3__c,
                             pn3__c,
                             pc4__c,
                             pn4__c,
                             pc5__c,
                             pn5__c
                        FROM Report_Link__mdt];
      for(Report_Link__mdt mdt : metadataList)
      {
        results.put(mdt.MasterLabel, mdt);
      }
      return results;
    }


    public static Map<String, Integer> getProspectsByExec(List<Id> idEjecutivos, String subjectTask, List<String> typesProductStr, Date fechaIni, Date fechaFin) {
        Map<String, Integer> prospectos = new Map<String, Integer>();

        Map<Id, set<Id>> ejToAccIds = new Map<Id, set<Id>>();
        Map<Id, set<Id>> ejToLeadIds = new Map<Id, set<Id>>();
        Map<Id, set<Id>> oppIdToEj = new Map<Id, set<Id>>();
        Map<Id, set<Id>> cntIdToEj = new Map<Id, set<Id>>();

        /*for(String idEj : idEjecutivos)
        {
            System.debug('idEj [' + idEj + ']');
        }*/

        for(Task t : [SELECT OwnerId,
                             WhatId,
                             WhoId
                        FROM Task
                       WHERE Subject = :subjectTask
                         AND Owner.id IN :idEjecutivos 
                         //AND Owner.id IN ('005f4000000Icdx') 
                         AND ActivityDate >= :fechaIni
                         AND ActivityDate <= :fechaFin]){
                            
            if(t.whatId != null && UtilFunctions.isAccount(t.whatId)){
                if(!ejToAccIds.containsKey(t.OwnerId)){
                    ejToAccIds.put(t.OwnerId, new set<Id>());
                }
                ejToAccIds.get(t.OwnerId).add(t.whatId);
            }else if(t.whoId != null && UtilFunctions.isContact(t.whoId)){
                if(!cntIdToEj.containsKey(t.whoId)){
                    cntIdToEj.put(t.whoId, new set<Id>());
                }
                cntIdToEj.get(t.whoId).add(t.OwnerId);
            }else if(t.whatId != null && UtilFunctions.isOpp(t.whatId)){
                if(!oppIdToEj.containsKey(t.whatId)){
                    oppIdToEj.put(t.whatId, new set<Id>());
                }
                oppIdToEj.get(t.whatId).add(t.OwnerId);
            }else if(t.whoId != null && UtilFunctions.isLead(t.whoId)){
                if(!ejToLeadIds.containsKey(t.OwnerId)){
                    ejToLeadIds.put(t.OwnerId, new set<Id>());
                }
                ejToLeadIds.get(t.OwnerId).add(t.whoId);
            }

            /*if(t.Ownerid == '005f4000000Icdx')
            {
                System.debug('TASK [' + t.whatid + '] [' + t.whoid + '] [' + t.ownerid + ']');
            }*/
        }

        System.debug(' [' + ejToAccIds.size() + '] [' + cntIdToEj.size() + '] [' + oppIdToEj.size() + '] [' + ejToLeadIds.size() + ']');

        //Leads by type product
        for(Lead lead : [SELECT Id
                           FROM Lead
                          WHERE Id IN :ejToLeadIds.keyset()
                            AND Tipo_contacto__c IN :typesProductStr]){
            for(Id ejecutivo : oppIdToEj.get(lead.Id)){
                ejToLeadIds.get(ejecutivo).add(lead.Id);
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

        typesProductStr.add(null);
        //System.debug('PPPPPPPPPPPPPPPP TPROD[' + typesProductStr + ']');
        for(Contact c : [SELECT Id,
                                AccountId,
                                Tipo_de_producto__c
                                FROM Contact
                                WHERE Id IN :cntIdToEj.keyset()
                                AND Tipo_de_producto__c IN :typesProductStr]){
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

}