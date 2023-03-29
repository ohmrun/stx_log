package stx.log.filter.term;

class Always<T> extends Filter<T>{
  public function new(){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
  }
  override public function apply(value:Value<Dynamic>){
    final info = value.source;
    return Report.unit();
  }
  public function canonical(){
    return 'Always';
  }
}