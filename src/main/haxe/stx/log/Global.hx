package stx.log;

class Global{
  private static var instance(get,set) : LoggerApi;
  private static function get_instance(){
    return instance == null ? instance = stx.log.logger.Global.unit() : instance
  }
  private static function set_instance(i){
    return instance = i;
  }
  public function configure(f : LoggerApi -> LoggerApi ){
    set_instance(f(get_instance()));
  }
}