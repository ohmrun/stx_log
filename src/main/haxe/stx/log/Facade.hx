package stx.log;

@:forward abstract Facade(stx.log.logger.Default){
  private static var instance = new stx.log.logger.Default();
  public function new(){
    this = instance;
  }
  static public function unit(){
    return new Facade();
  }
}