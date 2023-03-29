package stx.log.filter.term;

class Not<T> extends Filter<T>{
  public var delegate(default,null):Filter<T>;
  override public function apply(v:Value<T>){
    return delegate.apply(v);
  }
  public function canonical(){
    return 'Not(${delegate.canonical()})';
  }
}