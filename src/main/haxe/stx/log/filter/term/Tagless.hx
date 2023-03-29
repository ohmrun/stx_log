package stx.log.filter.term;

class Tagless<T> extends Filter<T>{
  public function new(){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
  }
  override public function apply(value:Value<Dynamic>){
    final info = value.source;
    return if(!(info).stamp.tags.is_defined()){
      Report.unit();
    }else{
      __.report(f -> f.of(E_Log('not tagless')));
    }
  }
  public function canonical(){
    return 'Tagless';
  }
}