package stx.log.logger;

class Base<T> implements LoggerApi<T> extends stx.log.output.term.Full{
  
  public function new(?logic:Logic<T>,?format:Format){
    trace(logic);
    this.logic  = __.option(logic).defv(new stx.log.logic.term.Default());
    this.format = __.option(format).defv(Format.unit());
  }

  public var logic(get,null)  : stx.log.Logic<T>;
  public function get_logic():stx.log.Logic<T>{
    return this.logic;
  }
  public function with_logic(f : CTR<stx.log.Logic<T>,stx.log.Logic<T>>):LoggerApi<T>{
    return new Base(f.apply(logic),this.format);
  }
  public var format(get,null) : Format;
  public function get_format():Format{
    return this.format;
  }
  public function with_format(f : CTR<Format,Format>):LoggerApi<T>{
    return new Base(logic,f.apply(this.format));
  }

  final public function apply(value:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
    trace('apply: ${value.source}');
    return do_apply(value).mod(
      (res) -> {
        trace('applied: $res');
        return res.map(
          (
            (string:String) -> { 
              trace('about to render: ${value.stamp}');
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
    trace('do_apply');
    return Continuation.lift(
      (fn:Value<T>->Res<String,LogFailure>) -> {
        trace(logic);
        final proceed = logic.apply(value);
        trace(proceed);
        var result    = proceed.resolve(() -> this.format.print(value));
        trace(result);
        return result;
      }
    );
  }

} 