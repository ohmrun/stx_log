package stx.log.filter.term;

import stx.fs.Path;

class PosPredicate extends Filter<Dynamic>{
  public var delegate(default,null):stx.assert.Predicate<LogPosition,LogFailure>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function applyI(value:Value<Dynamic>){
    return delegate.applyI(value.source);
  }
}