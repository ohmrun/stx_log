package stx.log;

#if stx_show
  using stx.Show;
#end
class EntryCtr<T> extends Clazz{
  public function make(val:T,ctr:T->String):stx.log.core.Entry<T>{
    return { val : val, ctr : ctr };
  }
  public function pure(val:T):stx.log.core.Entry<T>{
    return { val : val, ctr : Std.string };
  }
  public function thunk(fn:Void->T):stx.log.core.Entry<T>{
    return { val : null, ctr : (_) -> Std.string(fn()) };
  }
  public function json<T>(val:T){
    return { val : val, ctr : (x) -> haxe.Json.stringify(x," ") };
  }
  #if stx_show
  public function show<T>(val:T){
    return { val : val, ctr : (x:T) -> __.show(x) };
  }
  #end
}