package stx.log.logger;

using tink.streams.Stream;
using tink.io.Source;

import asys.io.Process;

class Linux extends Unit{
  var delegate : Unit;
  public function new(?logic:stx.log.Filter<Dynamic>,?format:Format,?level = TRACE,?verbose=false,?reinstate=false){
    super(logic,__.option(format).defv(new stx.log.core.format.Column()),level,verbose,reinstate);
    this.delegate = new Unit(logic,format,level,verbose,reinstate);
  }
  override private function render( v : Dynamic, ?infos : LogPosition ) : Void{
    //.haxe.Log.trace(v);
    var args : Array<String>  = ["-t","-s","|"];
    var proc                  = new Process('column',args);
    proc.stderr.all().handle(
      (val) -> {
        trace(val);
      }
    );
    proc.stdout.all().handle(
      (val) -> {
        trace(val);
      }
    );
    proc.stdin
      .consume(Stream.single(tink.Chunk.ofString(Std.string(v) + "\\0")),{})
      .handle(
        (x) -> {
          trace(x);
        }
      );
  }
}