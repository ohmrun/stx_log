package stx.log;


class Logger<T> implements LoggerApi<T> extends stx.log.output.term.Full{
  static public function spur<T>(value:Value<T>):Res<String,LogFailure>{
    return __.reject(__.fault().of(E_Log_Zero));
  }  
  public function new(?logic:Filter<T>,?format:Format){
    this.logic  = __.option(logic).def(Filter.Unit);
    this.format = __.option(format).defv(Format.DEFAULT);
  }

  public var logic  : stx.log.Logic<T>;
  public var format : Format;

  final public function apply(value:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return do_apply(value).mod(
      (res) -> {
        return res.map(
          __.passthrough(
            (string:String) -> 
              if(!value.stamp.hidden){
                render(string,value.source);
              }
          )
        );
      }
    );
  }

  private function do_apply(value:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return Continuation.lift(
      (fn:Value<T>->Res<String,LogFailure>) -> {
        var result = logic.apply(value).populate(() -> value.toString());
        return result;
      }
    );
  }
}