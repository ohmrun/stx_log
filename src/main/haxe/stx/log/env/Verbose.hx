package stx.log.global.config;

abstract Verbose(Bool) to Bool{
  public function new(){
    this = __.option(std.Sys.getEnv("VERBOSE")).map(x -> x == 'true').defv(false);
  }
}