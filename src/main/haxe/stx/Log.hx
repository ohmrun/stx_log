package stx;

typedef Signal        = stx.log.Signal;
typedef Value<T>      = stx.log.Value<T>;
typedef Level         = stx.log.Level;
typedef LevelSum      = stx.log.LevelSum;
typedef LogPosition   = stx.log.LogPosition;
typedef LogFailure    = stx.fail.LogFailure;
typedef FormatSum     = stx.log.Format.FormatSum;
typedef Format        = stx.log.Format.Format;
typedef ScopeSum      = stx.log.ScopeSum;
typedef Scoping       = stx.log.Scoping; 


class LiftLog{
  static public function log(wildcard:Wildcard):Log{
    return Log.ZERO;
  }
  static public function scope(stx:Wildcard,pos:Pos,?method:String){
    var scoping = return LogPosition.fromPos(pos).scoping;
    if(method!=null){
      scoping.method = method;
    }
    return scoping;
  }
  static public function stamp(pos:Pos):LogPosition{
    return new LogPosition(pos);
  }
}
typedef LogDef = Dynamic -> ?Pos -> Void;

@:callable abstract Log(LogDef) to LogDef from LogDef{
  static public var _(default,never) = LogLift;
  static public function LOG(value:Dynamic,?pos:Pos):Void{
    //trace("transmit");
    Signal.transmit(enlog(value,pos));
  }
  static public function enlog<T>(value:T,?pos:Pos):Value<T>{
    var log_position  = LogPosition.pure(pos);
    var value         = new Value(value,log_position);
    return value;
  }
  static public function make<T>(fn:Value<T>->Void):Log{
    return (value:Dynamic,?pos:Pos) -> fn(enlog(value,pos));
  }
  static public var ZERO(default,null)  : Log     = LOG;

  public function new(){
    this = LOG;
  }
  /** Logs with LogLevel[LEVEL] **/
  public function level(level:Level):Log{
    return mod(
      (pos) -> pos.restamp( stamp -> stamp.relevel(level) )
    );
  }

  /** Logs with Level.TRACE   **/
  public function trace(v:Dynamic,?pos:Pos) level(TRACE)(v,pos);
  /** Logs with Level.DEBUG   **/
  public function debug(v:Dynamic,?pos:Pos) level(DEBUG)(v,pos);
  /** Logs with LogLevel.INFO **/
  public function info(v:Dynamic,?pos:Pos)  level(INFO)(v,pos);
  /** Logs with LogLevel.WARN **/
  public function warn(v:Dynamic,?pos:Pos)  level(WARN)(v,pos);
  /** Logs with LogLevel.ERROR **/
  public function error(v:Dynamic,?pos:Pos) level(ERROR)(v,pos);
  /** Logs with LogLevel.FATAL **/
  public function fatal(v:Dynamic,?pos:Pos) level(FATAL)(v,pos);

  public function mod(fn:LogPosition->LogPosition){
    return (value:Dynamic,?pos:Pos) -> this(value,fn(pos));
  }
  public function tag(tag:String):Log{
    return mod((pos) -> pos.restamp((stamp) -> stamp.tag(tag)));
  }
  public function close():Log{
    return mod((pos) -> pos.restamp(stamp -> stamp.hide()));
  }
  public function through<T>(?pos:Pos):T->T{
    return (v:T) -> {
      this(v,pos);
      return v;
    }
  }
  public function printer<T>(?pos:Pos):T->Void{
    return (v:T) -> {
      this(v,pos);
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
  static public function Logic(){
    return {
      pack      : stx.log.Logic.pack,
      line      : stx.log.Logic.line,
      lines     : stx.log.Logic.lines,
      tag       : stx.log.Logic.tag,
      always    : stx.log.Logic.always,
      method    : stx.log.Logic.method
    };
  }
}