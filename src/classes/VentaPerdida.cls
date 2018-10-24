public class VentaPerdida
{
  public String razonVentaPerdida {get; set;}
  public Integer cantidad {get; set;}
  public Decimal porcentaje {get; set;}
  
  public VentaPerdida(String prazonVentaPerdida)
  {
    razonVentaPerdida = prazonVentaPerdida;
  }
}