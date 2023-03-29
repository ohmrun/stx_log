package stx.log.global.filter;

class Verbose<T> extends Filter<T>{
  override public function apply(value:Value<T>):Report<LogFailure>{
    return new stx.log.env.Verbose() == true 
      ? __.report() : __.report(f -> f.of(E_Log('Env VERBOSE not set')));
  }
  public function canonical(){
    return 'Verbose';
  }
}