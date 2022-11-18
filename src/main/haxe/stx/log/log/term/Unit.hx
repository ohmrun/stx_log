package stx.log.log.term;

class Unit implements LogApi extends Base{
  public function new(){}
  public function comply(entry:Entry<Dynamic>,pos:LogPosition):Void{
    #if stx.log.null
    #else
      stx.log.Signal.transmit(Log.enlog(entry,pos));
    #end 
  }
}