package stx.log.logger;

@:forward abstract Global(stx.log.logger.Unit) to stx.log.logger.Unit from stx.log.logger.Unit{
  @:isVar static public var ZERO(get,null): stx.log.logger.Unit;
  static private function get_ZERO(){
    final result = ZERO == null ? {
      #if (sys || nodejs)
        //ZERO = new stx.log.logger.ConsoleLogger();
        ZERO = new stx.log.logger.Unit();
        trace("stx.Log.global = stx.log.logger.ConsoleLogger()");
        ZERO;
      #else
        ZERO = new stx.log.logger.Unit();
        trace("stx.Log.global = stx.log.logger.Unit()");
        ZERO;
      #end
     } : ZERO;
    
    //trace(std.Sys.environment());
    #if (sys || nodejs)
    for(level in __.option(std.Sys.getEnv("STX_LOG__LEVEL")).flat_map(x -> Level.fromString(x))){
      ZERO.level = level;
      trace('ENV SET STX_LOG Global $level');
    };
    if(std.Sys.getEnv("VERBOSE") == 'true'){
      trace("ENV SET STX_LOG Global VERBOSE");
      ZERO.verbose = true;
    }
    #end
    return result;
  }
  public function new(){
    this = ZERO;
  }
  static public function unit(){
    return new Global();
  }
  @:to public function toLoggerApi():LoggerApi<Dynamic>{
    return this;
  }
  public function prj(){
    return this;
  }
}