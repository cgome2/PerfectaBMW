@isTest
public class TestUtil
{
    public static final String SUC_CENTRAL = 'CENTRAL';
    public static final String SUC_CDE = 'CDE';
    public static final String SUC_BPS = 'BPS';

    public static final String OKM = '0Km';

    public static final String PERFIL_VENTAS = 'Usuario de Ventas';

    public static final String CONTACTO_PROSP = 'Contacto de Prospección';

    public static final String OPP_CERRADA = 'Cerrada/Ganada';
    public static final String OPP_CALIFICADO = 'Calificado';


    public List<User> usuarios {get; set;}

    public list<Account> accounts {get; set;}
    public list<Contact> contacts {get; set;}
    public list<Lead> leads {get; set;}

    public Campaign bigEvent {get; set;}

    public List<Opportunity> opportunities {get; set;}

    public void initPruebaEjecutivos(){
        usuarios = createUsuarios(SUC_CENTRAL);
        createObjetivoMensualEjecutivos(usuarios);
        createObjetivoDiarioEjecutivos(usuarios);
        createObjetivoMensualFuenteOrigen();
        createAccountAndContacts(3);
        createAssetsForContacts(contacts);
        createProspectsForExecs(usuarios);
        createFollowUpTaskEjecutivos(usuarios, contacts, leads, CONTACTO_PROSP);
        createCampaignWMembers(contacts, leads);
        createOpportunities();        
    }

    public void initUsuarios() {
        createUsuarios(3, PERFIL_VENTAS, SUC_CENTRAL);
    }

    private List<User> createUsuarios(String suc) {
        return createUsuarios(3, PERFIL_VENTAS, suc);
    }

    private List<User> createUsuarios(Integer num, String prof, String suc) {
        List<User> usuariosObj = new List<User>();
        User user;
        
        Profile p = [SELECT Id
                        FROM Profile
                        WHERE Name = :prof
                        LIMIT 1];

        for(Integer i = 0; i < num; i ++)
        {
          user = new User(FirstName = 'U' + i, 
                          LastName = 'LN'+ i, 
                          Profileid = p.Id, 
                          Sucursal__c = suc,
                          Alias = 'utst',
                          Email = 'utst@asdf.com',
                          Username = 'utst'+ i + suc + '@asdf.com',
                          TimeZoneSidKey = 'GMT', 
                          LocaleSidKey = 'en_US', 
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US',
                          isActive = true);
          usuariosObj.add(user);
        }
        insert usuariosObj;
        return usuariosObj;
    }

    private void createObjetivoMensualEjecutivos(list<User> ejecutivos){
        list<Objetivo__c> objetivos = new list<Objetivo__c>();
        for(User u : ejecutivos){
           objetivos.add(new Objetivo__c (Ejecutivo__c = u.Id,
                                            Prospectos__c = 50,
                                            Leads_Calificados__c = 20,                                        
                                            Test_Drives__c = 12,
                                            Ventas__c = 6,
                                            Tipo__c = PlanificacionPorEjecutivo.MENSUAL_E,
                                            Mes__c = Date.today().month(),
                                            anio__c = Date.today().year()));
        }
        insert objetivos;
    }

    private void createObjetivoDiarioEjecutivos(list<User> ejecutivos){
        list<Objetivo__c> objetivos = new list<Objetivo__c>();
        for(User u : ejecutivos){
           objetivos.add(new Objetivo__c (Ejecutivo__c = u.Id,
                                            Prospectos__c = 2,
                                            Leads_Calificados__c = 1,                                        
                                            Test_Drives__c = 1,
                                            Ventas__c = 1,
                                            Tipo__c = PlanificacionPorEjecutivo.DIARIO_E,
                                            Fecha_Planificacion__c = Date.today()));
        }
        insert objetivos;
    }

    private void createObjetivoMensualFuenteOrigen(){
        list<Objetivo__c> objetivos = new list<Objetivo__c>();
        Schema.DescribeFieldResult source = Lead.LeadSource.getDescribe();
        List<Schema.PicklistEntry> plv = source.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : plv){
            objetivos.add(new Objetivo__c (Fuente_Origen__c = pickListVal.getValue(), 
                                            Prospectos__c = 300,
                                            Leads_Calificados__c = 120,                                        
                                            Test_Drives__c = 72,
                                            Ventas__c = 36,
                                            Tipo__c = Scorecards.MENSUAL_FUENTE,
                                            Mes__c = Date.today().month(),
                                            anio__c = Date.today().year(),
                                            Objetivo_Sucursal__c = SUC_CENTRAL));
        }
        insert objetivos;
    }


    private void createAccountAndContacts(Integer num){
        accounts = new list<Account>();
        for(Integer i = 0; i < num; i++){
            accounts.add(new Account(Name = 'Test' + String.valueof(i),
                                    Type = 'Cliente',
                                    Industry = 'Ingenieria',
                                    RUC_Coma_ia__c = '1234567890' + String.valueof(i),
                                    AccountSource = 'Referido',
                                    Phone = '123123123'));
        }
        insert accounts;
        contacts = new list<Contact>();
        Integer i = 0;
        for(Account a : accounts){
            i++;
            contacts.add(new Contact(AccountId = a.Id,
                                    LastName = 'Doe' + a.Name,
                                    C_dula_de_Identidad__c = '1234567' + String.valueof(i),
                                    Nacionalidad__c = 'Brasil',
                                    Genero__c = 'Masculino',
                                    Birthdate = Date.newInstance(1970, 1, 1),
                                    Contacto_de_Preferencia__c = 'Oficina.',
                                    Phone = '0303456' + String.valueof(i),
                                    Email = 'john@doe.com.' + a.Name));
        }
        insert contacts;
    }

    /**
    *   Creates 0 Assets for the first Contact in the list, 1 for the second and so on
    */
    private void createAssetsForContacts(list<Contact> contacts){
        list<Product2> lp = new list<Product2>();

        lp.add(new Product2(Name = 'Luxus-SUV',
                                Marca__c = 'BMW',
                                Modelo__c = 'X5',
                                Color__c = 'Metallisch Blau',
                                Tapizado__C = 'HellBraun Leder',
                                Ubicacion__c = 'ASUNCION',
                                Kilometraje__c = 0,
                                Posicion__c = 'N 14/18',
                                A_o__c = Date.today().year(),
                                ProductCode = '001122'));
        insert lp;

        list<Asset> assets = new list<Asset>();
        for(Integer i = 0; i < contacts.size(); i++){
            for(Integer j = 0; j < i; j++){
                assets.add(new Asset(Name = 'Ausgezeichnet!',
                                    tipo_venta__c = OKM,
                                    ContactId = contacts[i].Id,
                                    Product2Id = lp[0].Id));
            }
        }
        insert assets;
    }

    private void createProspectsForExecs(list<user> execs){
        Schema.DescribeFieldResult source = Lead.LeadSource.getDescribe();
        List<Schema.PicklistEntry> plv = source.getPicklistValues();

        leads =  new list<Lead>();
        Integer i = 0;
        for(User u : execs){
            i++;
            leads.add(new Lead(OwnerId = u.Id,
                                LeadSource = plv[0].getValue(),
                                Status = 'Nuevo',
                                Tipo_de_Producto__c = '0Km',
                                LastName = 'TestLead',
                                Genero__c = 'Masculino',
                                contacto_preferencia__c = 'Oficina.',
                                MobilePhone = '0303456' + String.valueof(i),
                                Email = 'john@doe.com.' + u.Id,
                                Company = 'Big Gig Inc.'));
        }
        insert leads;
    }

    private void createFollowUpTaskEjecutivos(list<User> ejecutivos, list<Contact> contactos, 
                                                                list<Lead> prospects, String tType){
        list<Task> tasks = new list<Task>();
        for(Integer i = 0; i < ejecutivos.size(); i++){
            if(contactos.size() < i || prospects.size() < i){
                break;
            }
            tasks.add(new Task(Subject = tType,
                                WhoId = contactos[i].Id,
                                OwnerId = ejecutivos[i].Id,
                                Priority = 'Normal',
                                Status = 'Abierto',
                                ActivityDate = Date.today()));
            tasks.add(new Task(Subject = tType,
                                WhoId = prospects[i].Id,
                                OwnerId = ejecutivos[i].Id,
                                Priority = 'Normal',
                                Status = 'Abierto',
                                ActivityDate = Date.today()));
        }
        insert tasks;
    }

    private void createCampaignWMembers(list<Contact> cnt, list<Lead> lds){
        RecordType rt = [SELECT Id 
                                FROM RecordType
                                WHERE sObjectType = 'Campaign'
                                AND DeveloperName = 'Standard'];

        bigEvent = new Campaign(Name = 'Big Event',
                                isActive = true,
                                RecordTypeId = rt.Id,
                                Objetivo_Invitados__c = 500,
                                Objetivo_de_Asistentes__c = 150,
                                Objetivo_Leads_Calificados__c = 70,
                                Objetivo_Ofertas__c = 20,
                                Objetivo_Test_Drive__c = 10,
                                Objetivo_Ventas__c = 4,
                                Sucursal__c = SUC_CENTRAL,
                                Type = 'Evento',
                                Status = 'En Progreso',
                                StartDate = Date.today().addDays(-5),
                                EndDate = Date.today().addDays(-5));
        insert bigEvent;
        list<CampaignMember> members = new list<CampaignMember>();
        for(Contact c : cnt){
            members.add(new CampaignMember(CampaignId = bigEvent.Id,
                                            ContactId = c.Id,
                                            Status = 'Respondida'));
        }
        for(Lead l : lds){
            members.add(new CampaignMember(CampaignId = bigEvent.Id,
                                            LeadId = l.Id,
                                            Status = 'AsistenciaConfirmada'));
        }
        insert members;
    }
 
 
    private List<Quote> createPresupuestos()
    {
        return null;
    }   
    
    private void createOpportunities()
    {
        Opportunity opp;
        opportunities = new List<Opportunity>();
        Quote quote;
        
        User user = usuarios.get(0);

           opp = new Opportunity(Name = 'Test Opp',
                                 StageName = OPP_CALIFICADO,
                                 OwnerId = user.id,
                                 CloseDate = Date.today(),
                                 Accountid = accounts.get(0).id,
                                 Justificacion__c = 'Because',
                                 Tipo_contacto__c = '0Km');

         insert opp;
 
        Contact c = contacts.get(0);
        c.Estado_civil__c = 'Casado';
        c.MobilePhone = '12334566';
        update c;      
 
        System.debug(' CC cdi[' + c + '] [' + c.C_dula_de_Identidad__c + ']');
        
        quote = new Quote();
        quote.Name = 'First Proposal';
        quote.description = 'quote ' + 'XVC';
        quote.contactid = c.id;
        quote.opportunityId = opp.id;
        quote.status = 'Aprobado';

        System.debug('Q C [' + quote.contact.C_dula_de_Identidad__c + ']');
           
        insert quote;

        opp.syncedQuoteId = quote.Id;
        update opp;

        opp.stageName = OPP_CERRADA;
        update opp;
        
    }
    
}