package stx.log.log.term;

class ModAnon extends Mod{
  public function new(delegate,_mod){
    super(delegate);
    this._mod = _mod;
  }
  final _mod : LogPosition -> LogPosition;
  public function mod(pos:LogPosition):LogPosition{
    return _mod(pos);
  }
}