package stx.log.env;

@:forward abstract Verbose(Bool) to Bool{
  public function new(){
    this = __.option(std.Sys.getEnv("VERBOSE")).map(x -> x == 'true').defv(false);
  }
}