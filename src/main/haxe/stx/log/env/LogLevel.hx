package stx.log.env;

@:forward abstract LogLevel(Option<stx.log.Level>) to Option<stx.log.Level>{
  public function new(){
    this = __.option(std.Sys.getEnv("STX_LOG__LEVEL")).flat_map(x -> Level.fromString(x));
  }
}