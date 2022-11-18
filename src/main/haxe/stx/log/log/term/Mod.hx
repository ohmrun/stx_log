package stx.log.log.term;

abstract class Mod implements LogApi extends Base{
  public final delegate : Log;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function comply(entry:Entry<Dynamic>,pos:LogPosition):Void{
    this.delegate.comply(entry,mod(pos));
  }
  abstract public function mod(pos:LogPosition):LogPosition;
}