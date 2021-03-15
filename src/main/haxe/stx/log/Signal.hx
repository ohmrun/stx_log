package stx.log;

import tink.core.Signal               in TinkSignal;
import tink.core.Signal.SignalTrigger in TinkSignalTrigger;

private class SignalCls{
  public function new(){
    this.handlers = [];
  }
  var handlers : Array<Value<Dynamic> -> Void>;
  public function handle(fn:Value<Dynamic>->Void){
    this.handlers.push(fn);
  }
  public function trigger(v:Value<Dynamic>):Void{
    for (handle in handlers){
      handle(v);
    }
  }
  public function attach(logger:LoggerApi<Dynamic>){
    has_custom = true;
    handle(
      (x:Value<Dynamic>) -> { 
        var o = logger.apply(x)(Logger.spur);
      }
    );
  }
}
typedef SignalDef = SignalCls;

@:forward(attach) abstract Signal(SignalDef){
  static public var ZERO(default,null) : Signal = new Signal();
  static function __init__(){
    #if (stx.log.debugging)
      instanceg.attach(new DebugLogger());
      has_custom = false;
    #end
    var facade = Facade.unit();
    instance.attach(facade);
    has_custom = false;
  }
  static public var has_custom(default,null):Bool                              = false;
  @:isVar static public  var instance(get,null):SignalDef;
  static private function get_instance(){
    return instance == null ? instance = new SignalCls() : instance;
  }

  public inline function new(){
    this = instance;
  }
  
  public function handle(x){
    has_custom = true;
    return this.handle(x);
  }
  static public function transmit(v){
    instance.trigger(v);
  }
}

class DebugLogger<T> extends Logger<T>{
  
}