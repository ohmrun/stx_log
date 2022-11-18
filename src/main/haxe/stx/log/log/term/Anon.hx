package stx.log.log.term;

class Anon implements LogApi extends Base{
  public function new(_comply){
    this._comply = _comply;
  }
  final _comply : stx.log.core.Entry<Dynamic> -> LogPosition -> Void;

  public function comply(entry:Entry<Dynamic>,pos:LogPosition):Void{
    _comply(entry,pos);
  }
}