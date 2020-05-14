package stx.log.pack.log;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  
  public function positioned(log:Log,p:Predicate<Pos,LogFailure>):Log{
    return function(v:Dynamic,?pos:Pos){
      if(!p.applyI(pos).is_defined()){
        //pos.customParams = null;
        log(v,pos);
      }
    }
  }
  public function use(log:Log,fn:Dynamic->Dynamic):Log{
    return function(x:Dynamic,?pos:Pos){
      log(fn(x),pos);
    }
  }
  public function containing(log:Log,p:Predicate<Dynamic,LogFailure>):Log{
    return function(v:Dynamic,?pos:Pos){
      if(!p.applyI(v).is_defined()){
        log(v,pos);
      }
    }
  }
  public function levelled(log,level:Level):Log{
    return positioned(log,
      new stx.log.pack.log.term.LevelledLog(level)
    ).use(
      function(x){
        var lvl = level.toString();
        var val = Std.string(x);
        return '$lvl: $val';
      }
    );
  }
}
