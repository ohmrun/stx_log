package stx.log;

using Bake;

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
      handle.apply(v)(Logger.spur);
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
    //trace('__init__');
    #if (stx.log.debugging)
      instance.attach(new DebugLogger());
      new stx.log.global.config.HasCustomLogger().value = false;
    #end
    var facade = FrontController.facade;
    instance.attach(facade);

    #if (sys || nodejs)
      for(v in __.option(Sys.getEnv("STX_LOG__FILE"))){
          final bake    = Bake.pop();
          final output  = sys.io.File.append(v);
          final log     = new sys.log.logger.File(output);
          instance.attach(log);
      }
    #else
      __.log().warn('No output file available');
    #end
    new stx.log.global.config.HasCustomLogger().value = false;
  }
  static public var has_custom(default,null):Bool                              = false;
  @:isVar static public  var instance(get,null):SignalDef;
  static private function get_instance(){ 
    //trace('getting instance ${instance == null}');
    #if sys
      var do_logging = std.Sys.env("STX_LOG");
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