package stx.log.logger;

#if (sys || hxnodejs)
class ConsoleLogger extends Custom{
  public function new(?logic:Logic<Dynamic>,?format:Format){
    super(
      logic,
      __.option(format).defv(new stx.log.core.format.Console())
    );
  }
  override private function render( v : Dynamic, infos : LogPosition ) : Void{
    @:privateAccess std.Console.log(v);
  }
}
#end