package stx.log.filter.term;

class Level<T> extends Filter<T>{
  public var level(default,null):stx.log.Level;
  public function new(level){
    super();
    this.level = level;
  }
  override public function opine(v:Value<T>){
    return v.stamp.level.asInt() >= level.asInt();
  }
}