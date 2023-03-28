package stx.log.global.filter;

class IsFilteringWithTags<T> extends Filter<T>{
  override public function apply(value:Value<T>):Report<LogFailure>{
    final result =  new stx.log.global.config.IsFilteringWithTags().value == true 
      ? __.report() : __.report(f -> f.of(E_Log('Not filtering on tags')));
    note('IsFilteringWithTags $result');
    return result;
  }
}