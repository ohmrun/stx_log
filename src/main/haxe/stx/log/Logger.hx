package stx.log;

class Logger<T> implements LoggerApi<T> extends stx.log.output.term.Full{
  public function new(?logic:Filter<T>,?format:Format){
    this.logic  = __.option(logic).def(Filter.Unit);
    this.format = __.option(format).defv(Format.DEFAULT);
  }

  public var logic:stx.log.Logic<T>;
  public var format:Format;

  private function opine(value:Value<T>):Bool{
    return logic.apply(value);
  }
  public function react(value:Value<T>):Void{
    if(opine(value)){
      if(!value.stamp.hidden){
        render(apply(value),value.source);
      }
    }
  }
  private function apply(value:Value<T>):String{
    return Std.string(value);
  }
  override private function render(value:Dynamic,?pos:Pos):Void{
    super.render(value,pos);
  }
}