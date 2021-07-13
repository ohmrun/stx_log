package stx.log.logger;

@:forward abstract Global(stx.log.logger.Unit) to stx.log.logger.Unit from stx.log.logger.Unit{
  static public var ZERO(default,never) = unit();
  @:isVar public static var instance(get,null):stx.log.logger.Unit;
  static private function get_instance(){
    return instance == null ? instance = new stx.log.logger.Unit() : instance;
  }
  public function new(){
    this = instance;
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