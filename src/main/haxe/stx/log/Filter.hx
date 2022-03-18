package stx.log;

class Filter<T> implements stx.assert.Predicate.PredicateApi<Value<T>,LogFailure>{
  public function new(){}

  public function apply(value:Value<T>):Report<LogFailure>{
    return Report.unit();
  }
  function note(str){
    #if (stx.log.filter.show==true)
      trace(str);
    #end
  }
  static public function Unit(){
    return new stx.log.filter.term.Unit();
  }
  static public function Race(){
    return new stx.log.filter.term.Race();
  }
  static public function PosPredicate(){
    return stx.log.filter.term.PosPredicate;
  }
}
