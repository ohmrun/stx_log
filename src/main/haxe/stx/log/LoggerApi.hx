package stx.log;

interface LoggerApi<T>{
  public var format(default,null):Format;
  public var logic(default,null):stx.log.Logic<T>;

  public function react(v:Value<T>):Void;
}