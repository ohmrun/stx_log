package stx.log.logger;

class Base<T> implements LoggerApi<T> extends stx.log.output.term.Full{
  
  public function new(?logic:Filter<T>,?format:Format){
    this.logic  = __.option(logic).def(Filter.Unit);
    this.format = __.option(format).defv(Format.unit());
  }

  public var logic  : stx.log.Logic<T>;
  public var format : Format;

  final public function apply(value:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return do_apply(value).mod(
      (res) -> {
        return res.map(
          (
            (string:String) -> { 
              //trace('about to render: ${value.stamp}');
              if(!value.stamp.hidden){
                #if macro
                  render(string,value.source);
                  // if(value.stamp.level != BLANK){
                  // }
                #else
                  render(string,value.source);
                #end
              }
            }
          ).promote()
        );
      }
    );
  }

  private function do_apply(value:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    return Continuation.lift(
      (fn:Value<T>->Res<String,LogFailure>) -> {
        var result = logic.apply(value).resolve(() -> this.format.print(value));
        return result;
      }
    );
  }
} 