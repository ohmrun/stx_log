package stx.log.global.filter;

class ReinstateTagless<T> extends Filter<T>{
  override public function apply(value:Value<T>):Report<LogFailure>{
    final result =  new stx.log.global.config.ReinstateTagless().value == true 
      ? __.report() : __.report(f -> f.of(E_Log('tagless not reinstated')));
    note('ReinstateTagless $result');
    return result;
  }
  public function canonical(){
    return 'ReinstateTagless';
  }
}