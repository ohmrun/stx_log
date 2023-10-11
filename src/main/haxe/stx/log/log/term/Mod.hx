package stx.log.log.term;

abstract class Mod implements LogApi extends Base{
  public final delegate : Log;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function apply(value:Value<Dynamic>):Void{
    this.delegate.apply(mod(value));
  }
  abstract public function mod(pos:Value<Dynamic>):Value<Dynamic>;
}