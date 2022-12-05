package stx.log.global.config;

@:forward abstract ReinstateTagless(Ref<Bool>) to Ref<Bool>{

  static private var instance(get,null) : Ref<Bool>;
  static private function get_instance(){
    return instance == null ? instance = false : instance;
  }
  public function new(){
    this = instance;
  }
}