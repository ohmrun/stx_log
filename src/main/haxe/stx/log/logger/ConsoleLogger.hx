package stx.log.logger;

class ConsoleLogger extends Unit{
  public function new(?logic:Filter<Dynamic>,?format:Format,?level = CRAZY,?verbose=false,?reinstate=false){
    super(logic,__.option(format).defv(new stx.log.core.format.Console()),level,verbose,reinstate);
  }
  override private function render( v : Dynamic, ?infos : LogPosition ) : Void{
    //.haxe.Log.trace(v);
    std.Console.log(v);
  }
}