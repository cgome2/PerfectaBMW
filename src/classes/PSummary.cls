public class PSummary{
    public Integer retailConq{get;set;}
    public Integer wholesaleConq{get;set;}
    public Decimal retailConqPerc{get;set;}
    public Decimal wholesaleConqPerc{get;set;}
    public Integer generatedRaw{get;set;}
    public Integer generatedActive{get;set;}
    public Integer accumRaw{get;set;}
    public Integer accumActive{get;set;}
        
    public PSummary(){
        retailConq = 0;
        wholesaleConq = 0;
        retailConqPerc = 0;
        wholesaleConqPerc = 0;
        generatedRaw = 0;
        generatedActive = 0;
        accumRaw = 0;
        accumActive = 0;
    }
}