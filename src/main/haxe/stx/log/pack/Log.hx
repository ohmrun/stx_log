package stx.log.pack;

import stx.log.pack.log.Constructor;
import stx.log.pack.log.pack.Stamp;
import stx.log.pack.log.pack.Level;

@:callable abstract Log(LogDef) to LogDef from LogDef{
  static public inline function _() return Constructor.ZERO;

  static public var config(default,null)    : Config  = stx.log.Config.instance;
  static public var instance(default,null)  : Log     = new Log();

  public function new(?self:LogDef){
    this = __.option(self).def(()->FullHaxeLog.trace);
  }
  /**
    For using in each functions.
  */
  public function printer(?pos:Pos):Dynamic->Void{
    return function(x:Dynamic){
      this(x,pos);
    }
  }
  function logWithLevelAndLogPosition(v:Dynamic,level:Level,pos:Pos){
    var p = new LogPosition(pos);
    p.meta.set_stamp(new Stamp(level));
    var config : Config = Config.instance;
    var should = config.apply(p);
    #if stx_log_config_show
      trace(should ? 'should' : 'should not');
    #end
    if(should){
      this(v,p);
    }
  }

  /**
    Logs with Level.TRACE
  **/
  public function trace(v:Dynamic,?pos:Pos){
    logWithLevelAndLogPosition(v,TRACE,pos);
  }
  /**
    Logs with Level.DEBUG
  **/
  public function debug(v:Dynamic,?pos:Pos){
    logWithLevelAndLogPosition(v,DEBUG,pos);
  }
  /**
    Logs with LogLevel.INFO
  **/
  public function info(v:Dynamic,?pos:Pos){
    logWithLevelAndLogPosition(v,INFO,pos);
  }

  /**
    Logs with LogLevel.WARN
  **/
  public function warn(v:Dynamic,?pos:Pos){
    logWithLevelAndLogPosition(v,WARN,pos);
  }

  /**
    Logs with LogLevel.ERROR
  **/
  public function error(v:Dynamic,?pos:Pos){
    logWithLevelAndLogPosition(v,ERROR,pos);
  }

  /**
    Logs with LogLevel.FATAL
  **/
  public function fatal(v:Dynamic,?pos:Pos){
    logWithLevelAndLogPosition(v,FATAL,pos);
  }
  /**
    Logs with LogLevel[LEVEL]
  **/
  public function levelled(level){
    return _().levelled(this,level);
  }
  /**
    Adds customParam [obj] to the resulting log call.
  
  public function with(obj:Dynamic):Log{
    return function(x:Dynamic,?pos:Pos){
      var position : LogPosition = pos;
      return this(x,position.withCustomParam(obj));
    }
  }
  **/
  /**
    Adds a tag to the customParams[tags] of the resulting log call.
  **/
  public function tag(string:String):Log{
    return function(x:Dynamic,?pos:Pos){
      LogPosition.pure(pos).meta.tags.push(string);

      return this(x,pos);
    }
  }
  /**
    See tag
  */
  public function tags(arr:Array<String>):Log{
    return arr.fold(
      function(next,memo){
        var memo0 : Log   = memo;
        var memo1 : Log   = memo0.tag(next);
        var memo1 : LogDef  = memo1;
        return memo1;
      },this
    );
  }
  /**
    mutate the object before logging
  */
  public function use(fn:Dynamic->Dynamic):Log{
    return function(x:Dynamic,?pos:Pos){
      this(fn(x),pos);
    }
  }
  /**
    Filter based on the value of the printable object.
  */
  public function containing(p:Predicate<Dynamic,LogFailure>):Log{
    return _().containing(this,p);
  }
  /**
    @param selector
    @returns Log which filters on predicate.
  **/
  public function positioned(p:Predicate<Pos,LogFailure>):Log{
    return _().positioned(this,p);
  }

  /**

  */
  public function close():Log{
    return _().positioned(this,
      __.that().never()
    );
  }
  public function prj():LogDef{
    return this;
  }
}