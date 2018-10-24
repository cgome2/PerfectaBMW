public class ProspectoInformacion
{
    // Id ejecutivo o lead source
    public String identificador {get; set;}
    public Integer numeroProspectos {get; set;}
    public Integer numeroConquista {get; set;}
    public Integer numeroLealtad {get; set;}

    public ProspectoInformacion()
    {
       numeroProspectos = 0;
       numeroConquista = 0;
       numeroLealtad = 0;
    }
}