package stx.log.logger;

class Base<T> implements LoggerApi<T> extends stx.log.output.term.Full{
  
  public function new(?logic:Logic<T>,?format:Format){
    this.logic  = __.option(logic).defv(__.log().logic().tagless());
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
        //trace(logic);
        var result = logic.apply(value).resolve(() -> this.format.print(value));
        return result;
      }
    );
  }

} 