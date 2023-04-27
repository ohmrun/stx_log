package stx.log.logger;

class File extends Custom{
  final archive : sys.io.FileOutput;

  public function new(archive:sys.io.FileOutput){
    this.archive = archive;
    super(logic,__.option(format).defv(new stx.log.core.Format.FormatCls()));
  }
  override private function do_apply(value:Value<Dynamic>):Continuation<Upshot<String,LogFailure>,Value<Dynamic>>{
    return Continuation.lift(
      (fn:Value<Dynamic>->Upshot<String,LogFailure>) -> {
        var result = __.accept(this.format.print(value) + "\n");
        return result;
      }
    );
  }
  override private function render( v : Dynamic, infos : LogPosition ) : Void{
    archive.writeString('$v');
  }
}