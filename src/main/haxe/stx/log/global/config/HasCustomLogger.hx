package stx.log.global.config;

abstract HasCustomLogger(Ref<Bool>){
  static private finals instance(get,null) : Ref<Bool>;
  static private function get_instance(){
    return instance == null ? instance = false : instance;
  }
  public function new(){
    this = instance;
  }
}