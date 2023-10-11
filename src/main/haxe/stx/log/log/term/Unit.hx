package stx.log.log.term;

using stx.log.log.term.Unit.Logging;

using stx.Pkg;

class Logging{
  static public function log(wildcard:Wildcard){
    return stx.Log.pkg(__.pkg(),"stx/loggyoo");
  }
}


class Unit implements LogApi extends Base{
  public function new(){}
  public function apply(value:Value<Dynamic>):Void{
    // trace(pos.pos);
    // trace(__.pkg());
    #if stx.log.null
    #else
      stx.log.Signal.transmit(value);
    #end 
  }
}