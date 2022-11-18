package stx.log.global.filter;

class Verbose<T> extends Filter<T>{
  public function apply(value:Value<T>):Report<LogFailure>{
    return new stx.log.global.config.Verbose() == true 
      ? __.report() : __.report(f -> f.of(E_Log('Env VERBOSE not set')));
  }
}