package stx.log.env;

@:forward abstract Verbose(Bool) to Bool{
  public function new(){
    #if(sys || nodejs)
      this = __.option(std.Sys.getEnv("VERBOSE")).map(x -> x == 'true').defv(false);
    #else
      this = false;
    #end
  }
}