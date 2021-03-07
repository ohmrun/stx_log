package stx.log;

@:forward abstract Facade(stx.log.logger.Unit){
  static public var ZERO(default,never) = unit();
  @:isVar private static var instance(get,null):stx.log.logger.Unit;
  static private function get_instance(){
    return instance == null ? instance = new stx.log.logger.Unit() : instance;
  }
  public function new(){
    this = instance;
  }
  static public function unit(){
    return new Facade();
  }
  @:to public function toLoggerApi():LoggerApi<Dynamic>{
    return this;
  }
}