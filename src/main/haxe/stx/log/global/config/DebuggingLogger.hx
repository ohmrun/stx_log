package stx.log.global.config;

abstract DebuggingLogger(Ref<Bool>){
  static private final instance(get,null) : Ref<Bool>;
  static private function get_instance(){
    return instance == null ? instance = false : instance;
  }
  public function new(){
    this = instance;
  }
}