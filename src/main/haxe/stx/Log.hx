package stx;


typedef LogPosition   = stx.log.pack.LogPosition;

typedef LogDef        = stx.log.type.LogDef;
typedef Log           = stx.log.pack.Log;

typedef LogFailure    = stx.log.pack.LogFailure;

typedef LevelSum      = stx.log.type.LevelSum;
typedef ScopeSum      = stx.log.type.ScopeSum;

typedef FullHaxeLog   = stx.log.pack.FullHaxeLog;
typedef Scoping       = stx.log.pack.Scoping; 

class LiftLog{
  static public function log(wildcard:Wildcard):Log{
    return Log.instance;  
  }
  static public function logger<T>(wildcard:Wildcard,?pos:Pos):T->T{
    return (t:T) -> {
      __.log()(t,pos);
      return t;
    }
  }
  static public function scope(stx:Wildcard,pos:Pos,?method:String){
    return LogPosition.fromPos(pos).scoping(method);
  }
}