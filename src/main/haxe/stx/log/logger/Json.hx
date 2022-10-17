package stx.log.logger;

class Json extends Custom{
  public function new(arhive:sys.io.FileOutput,?logic:Filter<Dynamic>,?format:Format,?level = DEBUG,?verbose=false,?reinstate=false){
    super(logic,__.option(format).defv(new stx.log.core.format.Console()),level,verbose,reinstate);
  }
  override private function do_apply(data:Value<Any>):Continuation<Res<String,LogFailure>,Value<Any>>{
    return super.do_apply(data).mod(
      (res) -> res.map(
        (_) -> {
          final json = haxe.Json.stringify(data);
          return json;
        }
      )
    );
  }
}