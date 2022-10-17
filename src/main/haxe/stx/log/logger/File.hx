package stx.log.logger;

class File extends Custom{
  final archive : sys.io.FileOutput;

  public function new(archive:sys.io.FileOutput,?logic:Filter<Dynamic>,?format:Format,?level = DEBUG,?verbose=false,?reinstate=false){
    this.archive = archive;
    super(logic,__.option(format).defv(new stx.log.core.Format.FormatCls()),level,verbose,reinstate);
  }
  override private function do_apply(value:Value<Dynamic>):Continuation<Res<String,LogFailure>,Value<Dynamic>>{
    return Continuation.lift(
      (fn:Value<Dynamic>->Res<String,LogFailure>) -> {
        var result = __.accept(this.format.print(value) + "\n");
        return result;
      }
    );
  }
  override private function render( v : Dynamic, infos : LogPosition ) : Void{
    archive.writeString('$v');
  }
}