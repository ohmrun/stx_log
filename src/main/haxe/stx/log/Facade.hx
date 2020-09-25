package stx.log;

@:forward abstract Facade(stx.log.logger.Default){
  @:isVar private static var instance(get,null):stx.log.logger.Default;
  static private function get_instance(){
    return instance == null ? instance = new stx.log.logger.Default() : instance;
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