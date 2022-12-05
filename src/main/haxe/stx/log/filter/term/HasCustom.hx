package stx.log.filter.term;

class HasCustom<T> extends Filter<T>{
  public function new(){
    super();
  }
  override public function apply(v:Value<T>){
    final result = new stx.log.global.config.HasCustomLogger().value == true ? 
      __.report() 
        : 
      __.report(f -> f.of(E_Log('Has No Custom Logger')));
    trace('has custom? $result');
    return result;
  }
}