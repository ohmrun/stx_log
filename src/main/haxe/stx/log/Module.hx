package stx.log;

class Module extends Clazz{
  public function attach(logger){
    new stx.log.Signal().attach(logger);
  } 
  // public function config(){
  //   return new Config(); 
  // }
  public function global(){
    return new Global();
  }
}
private class Global extends Clazz{
  public function configure(f : CTR<LoggerApi<Dynamic>,LoggerApi<Dynamic>> ){
    stx.log.FrontController.configure(f);
  }
  public function reinstate(){
    new stx.log.global.config.ReinstateTagless().value = true;
  }
}
// private class Config extends Clazz{
  
// }
