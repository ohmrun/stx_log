package stx.log.global.filter;

class HasCustomLogger<T> extends Filter<T>{
  override public function apply(value:Value<T>):Report<LogFailure>{
    return new stx.log.global.config.HasCustomLogger().value == true 
      ? __.report() : __.report(f -> f.of(E_Log('No Custom Logger added')));
  }
}