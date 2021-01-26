package stx.log;

typedef StringifyDef<T> = Void->Entry<T>;
abstract Stringify<T>(StringifyDef<T>) from StringifyDef<T> to StringifyDef<T>{
  @:from static public function fromToString<T:{ toString : ()->String }>(t:T):Stringify<T>{
    return () -> t;
  }
  @:from static public function fromT<T>(t:T):Stringify<T>{
    return () -> t;
  }
  public function reply(){
    return this();
  }
}