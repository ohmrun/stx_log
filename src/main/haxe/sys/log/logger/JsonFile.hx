package sys.log.logger;
#if (sys || nodejs)
class Json extends Custom{
  public function new(arhive:sys.io.FileOutput,?logic:Logic<Any>,?format:Format){
    super(logic,__.option(format).defv(new stx.log.core.format.Console()));
  }
  override private function do_apply(data:Value<Any>):Continuation<Upshot<String,LogFailure>,Value<Any>>{
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
#end