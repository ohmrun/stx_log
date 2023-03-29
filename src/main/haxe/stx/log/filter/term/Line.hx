package stx.log.filter.term;

class Line<T> extends Filter<T>{
  public function new(n){
    super();
    this.n = n;
  }
  final n : Int;
  override public function apply(v:Value<T>){
    var info        = v.source;
    var result      = info.pos.map(x -> x.lineNumber == n).defv(false);
    return result.if_else(
      () -> Report.unit(),
      () -> __.report(f -> f.of(E_Log_NotLine(n)))
    );
  }
  public function canonical(){
    return "Line($n)";
  }
}