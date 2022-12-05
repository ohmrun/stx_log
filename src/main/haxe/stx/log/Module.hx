package stx.log;

class Module extends Clazz{
  public function attach(logger){
    new stx.log.Signal().attach(logger);
  } 
  public function configure(f : LoggerApi<Dynamic> -> LoggerApi<Dynamic> ){
    new stx.log.Global().configure(f);
  }
  public function config(){
    return new Config(); 
  }
}
private class Config extends Clazz{
  
}
