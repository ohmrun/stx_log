package stx.log.logger;

#if nodejs
@:jsRequire("bunyan") extern class Bunyan{
  static public function createLogger(obj:Dynamic):Dynamic;
  public function debug(meta:Dynamic,str:String):Void;
  public function info(meta:Dynamic,str:String):Void;
  public function warn(meta:Dynamic,str:String):Void;
  public function error(meta:Dynamic,str:String):Void;
  public function fatal(meta:Dynamic,str:String):Void;
}
@:jsRequire("@google-cloud/logging-bunyan","LoggingBunyan")
extern class BunyanGCloud{
  public function new();
  public function stream(str:String):Dynamic;
}
@:jsRequire("@google-cloud/logging-bunyan")extern class BunyanGCloudCtr{
  static public var LoggingBunyan : Class<BunyanGCloud>;
}
class BunyanGCloudLogger extends Custom{
  private final internal : Bunyan;

  public function new(?logic:Filter<Any>,?level = DEBUG,?verbose=false,?reinstate=false){
    super(logic,[INCLUDE_TAGS,INCLUDE_LOCATION,INCLUDE_DETAIL],level,verbose,reinstate);
    // Creates a Bunyan Cloud Logging client
    final loggingBunyan = new BunyanGCloud();
    // Create a Bunyan logger that streams to Cloud Logging
    // Logs will be written to: "projects/YOUR_PROJECT_ID/logs/bunyan_log"
    this.internal = Bunyan.createLogger({
      // The JSON payload of the log as it appears in Cloud Logging
      // will contain "name": "my-service"
        name: 'ov8-server-haxe-log',
        streams: [
          // Log to the console at 'info' and above
          { stream: js.Node.process.stdout, level: 'debug' },
            // And log to Cloud Logging, logging at 'info' and above
          loggingBunyan.stream('debug'),
        ],
    });
  } 
  override private function render( v : Dynamic, ?infos : LogPosition ) : Void{
    var str = Std.string(v);
    __.option(infos).fold(
      infos  -> {
        final meta = {
          "labels" : {
            "env_id" : Sys.getEnv("ENV_ID")
          }
        };
        switch(infos.stamp.level){
          case DEBUG  : internal.debug(meta,str);
          case INFO   : internal.info(meta,str);
          case WARN   : internal.warn(meta,str);
          case ERROR  : internal.error(meta,str);
          case FATAL  : internal.fatal(meta,str);
          default     :  
        }
      },
      () -> {}    
    );
  }
}
#end