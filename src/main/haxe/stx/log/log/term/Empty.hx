package stx.log.log.term;

class Empty implements LogApi extends Base{
  public function new(){}
  public function comply(entry:Entry<Dynamic>,pos:LogPosition):Void{
    
  }
}