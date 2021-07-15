package stx.log.logger;

@:forward abstract Global(stx.log.logger.Unit) to stx.log.logger.Unit from stx.log.logger.Unit{
  static public var ZERO(get,never) = unit();
  static private function get_ZERO(){
    return ZERO == null ? ZERO = new stx.log.logger.Unit() : ZERO;
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