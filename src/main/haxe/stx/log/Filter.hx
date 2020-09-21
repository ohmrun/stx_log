package stx.log;

class Filter<T>{
  public function new(?cause:Null<String>,opinion = true){
    this.cause   = __.option(cause);
    this.opinion = __.option(opinion).defv(true);
  }
  public var opinion(default,null):Bool;
  public var cause(default,null):Option<String>;

  public function react(value:Value<T>){
    this.opinion = this.opine(value);
  }
  public function opine(value:Value<T>):Bool{
    this.react(value);
    return this.opinion;
  }
  function note(str){
    #if stx.log.filter.show
      trace(str);
    #end
  }
  static public function Unit(){
    return new UnitFilter();
  }
  static public function ZebraList(bias){
    return new stx.log.filter.term.ZebraList(bias);
  }
  static public function Race(){
    return new stx.log.filter.term.Race();
  }
  static public function Predicate(){
    return stx.log.filter.term.Predicate;
  }
}
class UnitFilter<T> extends Filter<T>{
  override public function react(value:Value<T>){
    this.opinion = true;
  }
}