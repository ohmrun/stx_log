package stx.log.filter.term;

class Level<T> extends Filter<T>{
  public var level(default,null):stx.log.Level;
  public function new(level){
    super();
    this.level = level;
  }
  override public function apply(v:Value<T>){
    note('apply $v $level');
    return (v.stamp.level.asInt() >= level.asInt()).if_else(
      () -> Report.unit(),
      () -> Report.make(E_Log_UnderLogLevel)
    );
  }
  public function canonical(){
    return 'Level($level)';
  }
}