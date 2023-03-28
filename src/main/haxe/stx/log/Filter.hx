package stx.log;

class Filter<T> implements stx.assert.Predicate.PredicateApi<Value<T>,LogFailure>{
  public function new(){}

  public function apply(value:Value<T>):Report<LogFailure>{
    return Report.unit();
  }
  function note(str:Dynamic){
    #if (stx.log.filter.show==true)
      trace(str);
    #end
  }
  static public function Unit<T>():Filter<T>{
    return new stx.log.filter.term.Unit();
  }
  static public function Race<T>():Filter<T>{
    return new stx.log.filter.term.Race();
  }
  static public function PosPredicate<T>(delegate):Filter<T>{
    return new stx.log.filter.term.PosPredicate(delegate);
  }
  static public function HasCustom<T>():Filter<T>{
    return new stx.log.filter.term.HasCustom();
  }
  static public function Level<T>(level):Filter<T>{
    return new stx.log.filter.term.Level(level);
  }
  public function toLogic(){
    return Logic.fromFilter(this);
  }
}
