package stx.log.filter.term;

class PosPredicate<T> extends Filter<T>{
  public final delegate:stx.assert.Predicate<LogPosition,LogFailure>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(value:Value<Dynamic>){
    return delegate.apply(value.source);
  }
  public function canonical(){
    return 'PosPredicate';
  }
}