package stx.log;

class Value<T>{
  @:noUsing static public function make<T>(detail:stx.log.core.Entry<T>,?source:Pos){
    return new Value(detail,source);
  }
  public function new(detail:stx.log.core.Entry<T>,source:LogPosition){
    this.detail     = detail;
    this.source     = source;
  }
  public var detail(default,null)     : stx.log.core.Entry<T>;
  public var stamp(get,null)          : Stamp;

  private function get_stamp(){
    return this.source.stamp;
  }
  public var source(default,null)     : LogPosition;

  public function restamp(fn:Stamp->Stamp){
    var next = source.with_stamp(fn);
    return new Value(detail,next);
  }
  
  public function toString(){
    return this.source.pos.map(x -> this.source.stamp.toLogString(x)).defv(".") + ":" + Std.string(this.detail);
  }
}