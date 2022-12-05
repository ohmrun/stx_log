package stx.log.logger;

class Unit extends stx.log.logger.Base<Any>{
  public function new(?logic:Logic<Any>,?format:Format){
    super(logic,format);
  }
  override private function do_apply(data:Value<Any>):Continuation<Res<String,LogFailure>,Value<Any>>{
    return super.do_apply(data);
  }
}