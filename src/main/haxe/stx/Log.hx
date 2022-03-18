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
typedef Logger            = stx.log.Logger;

class LiftLog{
  static public inline function log(wildcard:Wildcard):Log{
    return Log.ZERO;
  }
  static public inline function scope(stx:Wildcard,pos:Pos,?method:String):stx.Scoping{
    var scoping : Scoping = LogPosition.fromPos(pos).scoping;
    if(method!=null){
      scoping = scoping.with_method(method);
    }
    return scoping;
  }
  static public inline function stamp(pos:Pos):LogPosition{
    return LogPosition.pure(pos);
  }
}
typedef LogDef = stx.log.core.Entry<Dynamic> -> LogPosition -> Void;

@:callable abstract Log(LogDef) to LogDef from LogDef{
  static public var _(default,never) = LogLift;

  @:noUsing static public inline function lift(self:LogDef){
    return new Log(self);
  }
  public var global(get,never) : stx.log.logger.Global;
  inline function get_global(){
    return stx.log.logger.Global.ZERO;
  }

  static public inline function pkg(pkg:Pkg):Log{
    return @:privateAccess pkg.source().map(
      scope -> unit().tag((scope.pack.join("/")))
    ).def(unit);
  }
  static public inline function LOG<T>(value:stx.log.core.Entry<T>,pos:LogPosition):Void{
    //trace("transmit");cid
    #if stx.log.null
    #else
      stx.log.Signal.transmit(enlog(value,pos));
    #end 
  }
  static public inline function VOID<T>(value:stx.log.core.Entry<T>,pos:LogPosition):Void{

  }
  static public function unit():Log{
    return new Log();
  }
  static public function void():Log{
    return new Log(VOID);
  }
  static public function enlog<T>(value:stx.log.core.Entry<T>,info:LogPosition):Value<T>{
    var value         = new Value(value,info);
    return value;
  }
  static public function make<T>(fn:Value<T>->Void):Log{
    return (value:Dynamic,pos:LogPosition) -> fn(enlog(value,pos));
  }
  static public var ZERO(default,null)  : Log     = LOG;

  inline public function new(?self) this = self == null ? LOG : self;
  
  /** Logs with LogLevel[LEVEL] **/
  public inline function level(level:Level):Log{
    return mod(
      (pos:LogPosition) -> {
        //trace(pos);
        return pos.with_stamp( stamp -> stamp.relevel(level) );
      }
    );
  }
  /** Logs with Level.BLANK   **/
  public inline function blank<X>(v:Stringify<X>,?pos:Pos) level(BLANK)(v(new EntryCtr()),pos);
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
    return (value:stx.log.core.Entry<Dynamic>,pos:LogPosition) -> this(value,fn(pos));
  }
  public inline function tag(tag:String):Log{
    return mod((pos) -> pos.with_stamp((stamp) -> stamp.tag(tag)));
  }
  public inline function close():Log{
    return mod((pos) -> pos.with_stamp(stamp -> stamp.hide()));
  }
  public inline function through<T>(?ctr:StringCtr<T>,?pos:Pos):T->T{
    final log_pos = LogPosition.pure(pos);
          ctr     = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this(ctr.capture(v),pos);
      return v;
    }
  }
  public inline function printer<T>(?ctr:StringCtr<T>,pos:LogPosition):T->Void{
    ctr = __.option(ctr).def(StringCtr.unit);
    return (v:T) -> {
      this(ctr.capture(v),pos);
    }
  }
  static public function attach(logger){
    new stx.log.Signal().attach(logger);
  }
  public function prj():LogDef{
    return this;
  }
}
class LogLift{
  static public function Filter(){
    return stx.log.Filter;  
  }
  static public inline function Logic(){
    return stx.log.Logic._.make();
  }
}