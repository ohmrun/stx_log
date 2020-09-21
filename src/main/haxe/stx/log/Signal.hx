package stx.log;

import tink.core.Signal               in TinkSignal;
import tink.core.Signal.SignalTrigger in TinkSignalTrigger;

typedef SignalDef = TinkSignal<Value<Dynamic>>;

abstract Signal(SignalDef){
  static function __init__(){
    #if (stx.log.debugging)
      instance.handle((x) -> new DebugLogger().react(x));
    #end
      instance.handle(Facade.unit().react);
  }
  static public   var is_custom(default,null):Bool                              = false;
  static private  var transmitter(default,never):Trigger                        = new Trigger();
  static private  var instance                                                  = transmitter.asSignal();

  public inline function new(){
    this = instance;
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
  override public function apply(value:Value<T>):String{
    return '<DEBUGLOGGER>' + super.apply(value);
  }
}