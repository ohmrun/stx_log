package stx.log.filter.term;

class Unit<T> extends Filter<T>{
  override public function applyI(value:Value<T>){
    return Report.unit();
  }
}