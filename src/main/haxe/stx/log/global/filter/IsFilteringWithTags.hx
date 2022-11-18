package stx.log.global.filter;

class IsFilteringWithTags<T> extends Filter<T>{
  public function apply(value:Value<T>):Report<LogFailure>{
    return new stx.log.global.config.IsFilteringWithTags() == true 
      ? __.report() : __.report(f -> f.of(E_Log('Global Log not filtering on tags')));
  }
}