package stx;

typedef Value<T>          = stx.log.Value<T>;
typedef Level             = stx.log.Level;
typedef LevelSum          = stx.log.LevelSum;
typedef LogPosition       = stx.log.LogPosition;
typedef LogFailure        = stx.fail.LogFailure;

typedef ScopeSum          = stx.log.ScopeSum;
typedef Scoping           = stx.log.Scoping; //stx.log.Entry<T>;
typedef EntryCtr<T>       = stx.log.EntryCtr<T>;
typedef Stringify<T>      = stx.log.Stringify<T>;
typedef StringCtr<T>      = stx.log.StringCtr<T>;
typedef StringCtrDef<T>   = stx.log.StringCtr.StringCtrDef<T>;

class LiftLog{

  static public inline function log(wildcard:Wildcard):Log{
    return Log.ZERO;
  }
  static public inline function scope(stx:Wildcard,pos:Pos,?method:String){
    var scoping = return LogPosition.fromPos(pos).scoping;
    if(method!=null){
      scoping.method = method;
    }
    return scoping;
  }
  static public inline function stamp(pos:Pos):LogPosition{
    return new LogPosition(pos);
  }
}
typedef LogDef = stx.log.core.Entry<Dynamic> -> ?Pos -> Void;

@:callable abstract Log(LogDef) to LogDef from LogDef{
  static public var _(default,never) = LogLift;

  static public inline function LOG<T>(value:stx.log.core.Entry<T>,?pos:Pos):Void{
    //trace("transmit");
    stx.log.Signal.transmit(enlog(value,pos));
  }
  static public function unit():Log{
    return new Log();
  }
  static public function enlog<T>(value:stx.log.core.Entry<T>,?pos:Pos):Value<T>{
    var log_position  = LogPosition.pure(pos);
    var value         = new Value(value,log_position);
    return value;
  }
  static public function make<T>(fn:Value<T>->Void):Log{
    return (value:Dynamic,?pos:Pos) -> fn(enlog(value,pos));
  }
  static public var ZERO(default,null)  : Log     = LOG;

  inline public function new() this = LOG;
  
  /** Logs with LogLevel[LEVEL] **/
  public inline function level(level:Level):Log{
    return mod(
      (pos:LogPosition) -> pos.restamp( stamp -> stamp.relevel(level) )
    );
  }
  /** Logs with Level.TRACE   **/
  public inline function trace<X>(v:Stringify<X>,?pos:Pos) level(TRACE)(v(new EntryCtr()),pos);
  /** Logs with Level.DEBUG   **/
  public inline function debug<X>(v:Stringify<X>,?pos:Pos) level(DEBUG)(v(new EntryCtr()),pos);
  /** Logs with LogLevel.INFO **/
  public inline function info<X>(v:Stringify<X>,?pos:Pos)  level(INFO)(v(new EntryCtr()),pos);
  /** Logs with LogLevel.WARN **/
  public inline function warn<X>(v:Stringify<X>,?pos:Pos)  level(WARN)(v(new EntryCtr()),pos);
  /** Logs with LogLevel.ERROR **/
  public inline function error<X>(v:Stringify<X>,?pos:Pos) level(ERROR)(v(new EntryCtr()),pos);
  /** Logs with LogLevel.FATAL **/
  public inline function fatal<X>(v:Stringify<X>,?pos:Pos) level(FATAL)(v(new EntryCtr()),pos);

  public inline function mod(fn:LogPosition->LogPosition){
    return (value:stx.log.core.Entry<Dynamic>,?pos:Pos) -> this(value,fn(pos));
  }
  public inline function tag(tag:String):Log{
    return mod((pos) -> pos.restamp((stamp) -> stamp.tag(tag)));
  }
  public inline function close():Log{
    return mod((pos) -> pos.restamp(stamp -> stamp.hide()));
  }
  public inline function through<T>(?ctr:StringCtr<T>,?pos:Pos):T->T{
    ctr = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this(ctr.capture(v),pos);
      return v;
    }
  }
  public inline function printer<T>(?ctr:StringCtr<T>,?pos:Pos):T->Void{
    ctr = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this(ctr.capture(v),pos);
    }
  }
}
class LogLift{
  static public function Filter(){
    return stx.log.Filter;  
  }
  static public function Facade(){
    return new stx.log.Facade();
  }
  static public inline function Logic(){
    return stx.log.Logic._.make();
  }
}