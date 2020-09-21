package stx.log.filter.term;

import stx.fs.Path;


class Predicate extends Filter<Dynamic>{
  public var delegate(default,null):stx.assert.Predicate<LogPosition,LogFailure>;
  public function new(delegate){
    super('Predicate');
    this.delegate = delegate;
  }
  override public function react(value:Value<Dynamic>){
    this.opinion = delegate.ok()(value.source);
  }
}