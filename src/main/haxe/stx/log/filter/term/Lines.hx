package stx.log.filter.term;

class Lines<T> extends Filter<T>{
  public function new(l,h){
    super();
    this.l = l;
    this.h = h;
  }
  final l : Int;
  final h : Int;

  override public function apply(v:Value<T>){
    var info        = v.source;
    return info.pos.map(
      pos -> ((pos.lineNumber >= l) && (pos.lineNumber <= h))
    ).defv(false)
     .if_else(
      () -> Report.unit(),
      () -> __.report(f -> f.of(E_Log_NotOfRange(l,h)))
    );
  }
  public function canonical(){
    return "Line($n)";
  }
}