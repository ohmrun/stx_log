package stx;

using stx.Pico;
using stx.Fail;
using stx.Nano;

typedef Value<T>          = stx.log.Value<T>;
typedef Level             = stx.log.Level;
typedef LevelSum          = stx.log.LevelSum;
typedef LogApi            = stx.log.LogApi;
typedef Log               = stx.log.Log;
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
  static public inline function logger(wildcard:Wildcard){
    return new stx.log.Module();
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