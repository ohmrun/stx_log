package stx.log;

class Value<T>{
  static public function make<T>(detail:T,?source:Pos){
    return new Value(detail,source);
  }
  public function new(detail:T,?source:Pos){
    this.detail     = detail;
    this.source     = source;
  }
  public var detail(default,null)     : T;
  public var stamp(get,null)          : Stamp;

  private function get_stamp(){
    return this.source.stamp;
  }
  public var source(default,null)     : LogPosition;

  public function restamp(fn:Stamp->Stamp){
    var next = source.restamp(fn);
    return new Value(detail,next);
  }

  // public function toString(){
  //   return this.source.stamp.toLogString(this.source) + ":" + Std.string(this.detail);
  // }
}