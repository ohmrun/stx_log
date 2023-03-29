package stx.log;

class FrontController extends Clazz{
  static public var facade(get,null) : LoggerApi<Dynamic>;
  static public function get_facade() : LoggerApi<Dynamic>{
    return facade == null ? facade = @:privateAccess new stx.log.logger.DelegateRef(stx.log.FrontController.instance) : facade;
  }
  @:isVar static private var instance(get,null) : Ref<LoggerApi<Dynamic>>;
  static private function get_instance(){
    return instance == null ? {
      final ref : Ref<LoggerApi<Dynamic>> = (new stx.log.logger.Global():LoggerApi<Dynamic>);
      instance = ref;
    } : instance;
  }
  static private function set_instance(i:Ref<LoggerApi<Dynamic>>){
    instance.value = i;
    return instance;
  }
  static public function configure(f : CTR<LoggerApi<Dynamic>,LoggerApi<Dynamic>> ){
    set_instance(f.apply(get_instance()));
  }
}