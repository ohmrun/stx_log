package stx.log.logger;

#if (!macro)
  import sys.io.Process;
#end
class Linux extends Unit{
  public function new(?logic:Logic<Any>,?format:Format,?level = DEBUG){
    super(logic,__.option(format).defv(new stx.log.core.format.Column()));
  }
  override private function render( v : Dynamic, infos : LogPosition ) : Void{
    //.haxe.Log.trace(v);
    var cols = new Process('tput',['cols']);
    var val  = cols.stdout.readAll().toString();
    var args : Array<String> = ["-t","-s","|"];
    var proc = new Process('column',args);
        proc.stdin.writeString(Std.string(v));
        proc.stdin.writeString("\n");
        proc.stdin.close();
    var error = proc.stderr.readAll();

    if(error.length > 0){
      throw error.toString();
    }else{
      super.render(proc.stdout.readAll().toString(),infos);
    }
  }
}