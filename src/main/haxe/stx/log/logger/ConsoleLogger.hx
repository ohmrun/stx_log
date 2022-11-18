package stx.log.logger;

class ConsoleLogger extends Custom{
  public function new(?logic:Logic<Dynamic>,?format:Format,?level = DEBUG,?verbose=false,?reinstate=false){
    super(
      logic,
      __.option(format).defv(new stx.log.core.format.Console()),
      level,
      verbose,
      reinstate
    );
  }
  override private function render( v : Dynamic, infos : LogPosition ) : Void{
    @:privateAccess std.Console.log(v);
  }
}