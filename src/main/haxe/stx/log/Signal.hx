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
    new Signal().attach(Facade.unit());
    is_custom = false;
  }
  static public   var is_custom(default,null):Bool                              = false;
  static private  var transmitter(default,never):Trigger                        = new Trigger();
  static private  var instance                                                  = transmitter.asSignal();

  public inline function new(){
    this = instance;
  }
  public function attach(logger:LoggerApi<Dynamic>){
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