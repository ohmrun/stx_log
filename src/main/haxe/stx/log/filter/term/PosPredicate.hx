package stx.log.filter.term;


class PosPredicate extends Filter<Dynamic>{
  public var delegate(default,null):stx.assert.Predicate<LogPosition,LogFailure>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(value:Value<Dynamic>){
    return delegate.apply(value.source);
  }
}