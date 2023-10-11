package stx.log.log.term;

class Anon implements LogApi extends Base{
  public function new(_apply){
    this._apply = _apply;
  }
  final _apply : Value<Dynamic> -> Void;

  public function apply(value:Value<Dynamic>):Void{
    _apply(value);
  }
}