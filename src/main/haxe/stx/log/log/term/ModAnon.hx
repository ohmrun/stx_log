package stx.log.log.term;

class ModAnon extends Mod{
  public function new(delegate,_mod){
    super(delegate);
    this._mod = _mod;
  }
  final _mod : Value<Dynamic> -> Value<Dynamic>;
  public function mod(pos:Value<Dynamic>):Value<Dynamic>{
    return _mod(pos);
  }
}