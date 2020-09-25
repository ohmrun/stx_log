package stx.log;

import tink.core.Signal               in TinkSignal;
import tink.core.Signal.SignalTrigger in TinkSignalTrigger;

typedef SignalDef = TinkSignal<Value<Dynamic>>;

abstract Signal(SignalDef){
  static function __init__(){
    #if (stx.log.debugging)
      new Signal().attach(new DebugLogger());
      is_custom = false;
    #end
    var facade = Facade.unit();
    new Signal().attach(facade);
    is_custom = false;
  }
  static public   var is_custom(default,null):Bool                              = false;
  @:isVar static private  var transmitter(get,null):Trigger;
  static private function get_transmitter(){
    return transmitter == null ? transmitter = new Trigger() : transmitter;
  }
  @:isVar static private  var instance(get,null):SignalDef;
  static private function get_instance(){
    return instance == null ? instance = transmitter.asSignal() : instance;
  }

  public inline function new(){
    this = instance;
  }
  public function attach(logger:LoggerApi<Dynamic>){
    __.assert().exists(logger);
    handle(
      (x:Value<Dynamic>) -> { 
        var o = logger.apply(x)(Logger.spur);
      }
    );
  }
  public function handle(x){
    is_custom = true;
    return this.handle(x);
  }
  static public function transmit(v){
    transmitter.trigger(v);
  }
}
typedef TriggerDef = TinkSignalTrigger<Value<Dynamic>>;
@:forward abstract Trigger(TriggerDef){
  public function new(){
    this = TinkSignal.trigger(); 
  }
}

class DebugLogger<T> extends Logger<T>{
  
}