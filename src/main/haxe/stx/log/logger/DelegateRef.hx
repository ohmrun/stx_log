package stx.log.logger;

class DelegateRef<T> implements LoggerApi<T>{
  public final delegate : Ref<Logger<T>>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public var format(get,default): Format;
  public function get_format(){
    return this.delegate.format;
  }
  public function with_format(f : CTR<Format,Format>):LoggerApi<T>{
    return new Delegate(this.delegate.with_format(f(this.format)));
  }

  public final logic(get,null) : stx.log.Logic<T>;
  public function get_logic(){
    return this.delegate.logic;
  }
  public function with_logic(f : CTR<stx.log.Logic<T>,stx.log.Logic<T>>):LoggerApi<T>{
    return new Delegate(this.delegate.with_logic(f(this.logic)));
  }

  public function apply(v:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return delegate.apply(v);
  }
  private function do_apply(v:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return delegate.do_apply(c);
  }
}