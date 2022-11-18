package stx.log.global.filter;

class ReinstateDefault<T> extends Filter<T>{
  public function apply(value:Value<T>):Report<LogFailure>{
    return new stx.log.global.config.ReinstateDefault() == true 
      ? __.report() : __.report(f -> f.of(E_Log('default not reinstated')));
  }
}