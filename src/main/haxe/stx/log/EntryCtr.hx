package stx.log;

class EntryCtr<T> extends Clazz{
  public function self(val:T,ctr:T->String):stx.log.core.Entry<T>{
    return { val : val, ctr : ctr };
  }
  public function pure(val:T):stx.log.core.Entry<T>{
    return { val : val, ctr : Std.string };
  }
  public function thunk(fn:Void->T){
    return { val : null, ctr : (_) -> Std.string(fn()) };
  }
  public function json(val){
    return { val : val, ctr : (x) -> haxe.Json.stringify(x," ") };
  }
}