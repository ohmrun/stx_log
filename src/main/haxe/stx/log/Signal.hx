package stx.log;

using stx.Bake;

#if sys
  using stx.System;
#end

import tink.core.Signal               in TinkSignal;
import tink.core.Signal.SignalTrigger in TinkSignalTrigger;

private class SignalCls{
  public function new(){
    this.handlers = [];
  }
  var handlers : Array<LoggerApi<Dynamic>>;
  public function handle(fn:LoggerApi<Dynamic>){
    this.handlers.push(fn);
  }
  public function trigger(v:Value<Dynamic>):Void{
    for (handle in handlers){
      handle.apply(v);
    }
  }
  public function attach(logger:LoggerApi<Dynamic>){
    new stx.log.global.config.HasCustomLogger().value = true;
    handle(logger);
  }
}
private class NullSignalCls extends SignalCls{
  override public function trigger(v:Value<Dynamic>):Void{

  }
}
typedef SignalDef = SignalCls;

@:forward(attach) abstract Signal(SignalDef){
  static public var ZERO(default,null) : Signal = new Signal();
  static function __init__(){
    #if (stx.log.debugging)
      instance.attach(new DebugLogger());
      has_custom = false;
    #end
    var facade = stx.log.logger.Global.ZERO;
    instance.attach(facade);

    for(v in __.option(Sys.getEnv("STX_LOG__FILE"))){
      final bake = __.bake();
      #if (sys || nodejs)
        // final output = sys.io.File.append(v);
        // final log    = new stx.log.logger.File(output);
        // instance.attach(log);
      #else
        __.log().warn('No output file available');
      #end
    }
    has_custom = false;
  }
  static public var has_custom(default,null):Bool                              = false;
  @:isVar static public  var instance(get,null):SignalDef;
  static private function get_instance(){ 
    //trace('getting instance ${instance == null}');
#if sys
      var do_logging = __.sys().env("STX_LOG");
      return (instance == null).if_else(
        () -> {
          return instance = do_logging.fold(
            (str) -> Bools.truthiness(str).if_else(
              ()  -> new SignalCls(),
              ()  -> new NullSignalCls()
            ),
            () -> new SignalCls()
          );
        },
        () -> instance
        );
#else
      return (instance == null).if_else(
        () -> instance = new SignalCls(),
        () -> instance
        );
#end
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

class DebugLogger<T> extends stx.log.logger.Base<T>{
  
}