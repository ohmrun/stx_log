package stx.log;

class Global extends Clazz{
  @:isVar private static var instance(get,null) : Ref<LoggerApi<Dynamic>>;
  private static function get_instance(){
    return instance == null ? {
      final ref : Ref<LoggerApi<Dynamic>> = (new stx.log.logger.Global():LoggerApi<Dynamic>);
      instance = ref;
    } : instance;
  }
  private static function set_instance(i:Ref<LoggerApi<Dynamic>>){
    instance.value = i;
    return instance;
  }
  public function configure(f : LoggerApi<Dynamic> -> LoggerApi<Dynamic> ){
    set_instance(f(get_instance()));
  }
}