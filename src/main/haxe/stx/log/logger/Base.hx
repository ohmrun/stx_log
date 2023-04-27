package stx.log.logger;

class Base<T> implements LoggerApi<T> extends stx.log.output.term.Full{
  
  public function new(?logic:Logic<T>,?format:Format){
    note(logic);
    this.logic  = __.option(logic).defv(new stx.log.logic.term.Default());
    this.format = __.option(format).defv(Format.unit());
  }

  public var logic(get,null)  : stx.log.Logic<T>;
  public function get_logic():stx.log.Logic<T>{
    return this.logic;
  }
  public function with_logic(f : CTR<stx.log.Logic<T>,stx.log.Logic<T>>,?pos:Pos):LoggerApi<T>{
    final res = f.apply(logic);
    stx.log.Logging.log(__).info('${res.toString()} at ${pos.toPosition()}');
    return new Base(res,this.format);
  }
  public var format(get,null) : Format;
  public function get_format():Format{
    return this.format;
  }
  public function with_format(f : CTR<Format,Format>):LoggerApi<T>{
    return new Base(logic,f.apply(this.format));
  }

  final public function apply(value:Value<T>):Continuation<Upshot<String,LogFailure>,Value<T>>{
    note('apply: ${value.source}');
    return do_apply(value).mod(
      (res) -> {
        note('applied: $res');
        return res.map(
          (
            (string:String) -> { 
              note('about to render: ${value.stamp}');
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

  private function do_apply(value:Value<T>):Continuation<Upshot<String,LogFailure>,Value<T>>{
    note('do_apply');
    return Continuation.lift(
      (fn:Value<T>->Upshot<String,LogFailure>) -> {
        note(logic);
        final proceed = logic.apply(value);
        note(proceed);
        var result    = proceed.resolve(() -> this.format.print(value));
        note(result);
        return result;
      }
    );
  }

} 