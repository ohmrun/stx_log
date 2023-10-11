package stx.log;

@:forward abstract Log(LogApi) to LogApi from LogApi{
  static public var _(default,never) = LogLift;

  @:noUsing static public inline function lift(self:LogApi){
    return new Log(self);
  }
  
  public var global(get,never) : LoggerApi<Dynamic>;
  inline function get_global(){
    return FrontController.facade;
  }
  static public inline function pkg(pkg:Pkg,?macro_time:String):Log{
    return __.option(macro_time)
             .or(
                () -> @:privateAccess pkg.source().map(scope -> scope.pack.join("/"))
             ).map(
                name -> unit().tag(name)
             ).def(unit);
  }
  static public function unit():Log{
    return new Log();
  }
  static public function empty():Log{
    return new stx.log.log.term.Empty();
  }
  @:noUsing static public function enlog<T>(entry:stx.log.core.Entry<T>,info:LogPosition):Value<T>{
    var value         = new Value(entry,new Stamp(),info);
    return value;
  }
  @:noUsing static public function make(fn:Value<Dynamic>->Void):Log{
    return new stx.log.log.term.Anon(fn);
  }
  static public var ZERO(default,null)  : Log     = new stx.log.log.term.Unit();

  inline public function new(?self) this = self == null ? new stx.log.log.term.Unit() : self;
  
  /** Logs with LogLevel[LEVEL] **/
  public inline function level(level:Level):Log{
    return new stx.log.log.term.Level(this,level).toLogApi();
  }
  /** Logs with Level.BLANK   **/
  public inline function blank<X>(v:Stringify<X>,?pos:Pos) level(BLANK).apply(v(new EntryCtr()).toValue(pos));
  /** Logs with Level.TRACE   **/
  public inline function trace<X>(v:Stringify<X>,?pos:Pos) level(TRACE).apply(v(new EntryCtr()).toValue(pos));
  /** Logs with Level.DEBUG   **/
  public inline function debug<X>(v:Stringify<X>,?pos:Pos) level(DEBUG).apply(v(new EntryCtr()).toValue(pos));
  /** Logs with LogLevel.INFO **/
  public inline function info<X>(v:Stringify<X>,?pos:Pos)  level(INFO).apply(v(new EntryCtr()).toValue(pos));
  /** Logs with LogLevel.WARN **/
  public inline function warn<X>(v:Stringify<X>,?pos:Pos)  level(WARN).apply(v(new EntryCtr()).toValue(pos));
  /** Logs with LogLevel.ERROR **/
  public inline function error<X>(v:Stringify<X>,?pos:Pos) level(ERROR).apply(v(new EntryCtr()).toValue(pos));
  /** Logs with LogLevel.FATAL **/
  public inline function fatal<X>(v:Stringify<X>,?pos:Pos) level(FATAL).apply(v(new EntryCtr()).toValue(pos));

  public inline function mod(fn:Value<Dynamic>->Value<Dynamic>){
    return new stx.log.log.term.ModAnon(this,fn);
  }
  public inline function tag(tag:String):Log{
    return mod((value) -> value.with_stamp((stamp) -> stamp.tag(tag)));
  }
  public inline function close():Log{
    return mod((pos) -> pos.with_stamp(stamp -> stamp.hide()));
  }
  public inline function through<T>(?ctr:StringCtr<T>,?pos:Pos):T->T{
    final log_pos = LogPosition.pure(pos);
          ctr     = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this.apply(ctr.capture(v).toValue(pos));
      return v;
    }
  }
  public inline function printer<T>(?ctr:StringCtr<T>,pos:LogPosition):T->Void{
    ctr = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this.apply(ctr.capture(v).toValue(pos));
    }
  }
  public inline function logger<T>(?ctr:StringCtr<T>,?pos:Pos):T->T{
    final log_pos = LogPosition.pure(pos);
          ctr     = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this.apply(ctr.capture(v).toValue(pos));
      return v;
    }
  }
  public function logic(){
    return new stx.log.Logic.LogicCtr();
  }
  public function prj():LogApi{
    return this;
  }
}
class LogLift{
  static public function Filter(){
    return stx.log.Filter;  
  }
  static public inline function Logic(){
    return stx.log.Logic.LogicCtr.unit();
  }
}