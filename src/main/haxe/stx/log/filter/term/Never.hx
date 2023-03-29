package stx.log.filter.term;

class Never<T> extends Filter<T>{
  public function new(){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
  }
  override public function apply(value:Value<Dynamic>){
    final info = value.source;
    return Report.make(E_Log_Zero);
  }
  public function canonical(){
    return 'Never';
  }
}