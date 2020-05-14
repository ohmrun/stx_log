package stx.log.pack.log.pack;

abstract Bias(Bool) from Bool{
  static public var instance : Bool = #if (test || debug) true #else false #end;
  public function new(){
    this = instance;
  }
  public function ok():Bool{
    return this;
  }
}