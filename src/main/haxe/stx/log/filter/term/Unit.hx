package stx.log.filter.term;

class Unit<T> extends Filter<T>{
  override public function apply(value:Value<T>){
    return Report.unit();
  }
  public function canonical(){
    return 'Unit';
  }
}