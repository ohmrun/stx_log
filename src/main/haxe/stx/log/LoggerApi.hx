package stx.log;

interface LoggerApi<T>{
  public var format(default,null):Format;
  public var logic(default,null):stx.log.Logic<T>;

  public function apply(v:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>;
  private function do_apply(v:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>;
}