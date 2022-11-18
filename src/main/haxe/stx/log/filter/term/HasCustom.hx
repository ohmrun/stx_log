package stx.log.filter.term;

class HasCustom<T> extends Filter<T>{
  public function new(l){
    super();
  }
  override public function apply(v:Value<T>){
    return new stx.log.global.config.HasCustomLogger().value == true ? __.report() : E_Log('Has No Custom Logger');
  }
}