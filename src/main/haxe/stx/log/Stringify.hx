package stx.log;

typedef StringifyDef<T> = EntryCtr<T>->stx.log.core.Entry<T>;

@:callable abstract Stringify<T>(StringifyDef<T>) from StringifyDef<T> to StringifyDef<T>{
  @:from static public function fromString(str:String):Stringify<String>{
    return (ctr) -> return stx.log.core.Entry.fromString(str);
  }
}