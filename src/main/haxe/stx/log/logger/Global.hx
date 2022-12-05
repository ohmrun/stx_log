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