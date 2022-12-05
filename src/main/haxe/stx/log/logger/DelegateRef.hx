package stx.log.logger;

class DelegateRef<T> implements LoggerApi<T>{
  public final delegate : Ref<LoggerApi<T>>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public var format(get,default): Format;
  public function get_format(){
    return this.delegate.value.format;
  }
  public function with_format(f : CTR<Format,Format>):LoggerApi<T>{
    return new DelegateRef(this.delegate.value.with_format(f(this.format)));
  }

  public var logic(get,null) : stx.log.Logic<T>;
  public function get_logic(){
    return this.delegate.value.logic;
  }
  public function with_logic(f : CTR<stx.log.Logic<T>,stx.log.Logic<T>>):LoggerApi<T>{
    return new DelegateRef(this.delegate.value.with_logic(f(this.logic)));
  }

  public function apply(v:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return delegate.value.apply(v);
  }
  private function do_apply(v:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return delegate.value.do_apply(v);
  }
}