package stx.log.filter.term;

class Tagless<T> extends Filter<T>{
  public function new(){
    super();
  }
  override public function apply(value:Value<Dynamic>){
    return if(!value.stamp.tags.is_defined()){
      Report.unit();
    }else{
      __.report(f -> f.of(E_Log('not tagless')));
    }
  }
  public function canonical(){
    return 'Tagless';
  }
}