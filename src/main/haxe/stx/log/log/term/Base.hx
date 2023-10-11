package stx.log.log.term;

abstract class Base implements LogApi{
  abstract public function apply(value:Value<Dynamic>):Void;
  public function toLogApi(){
    return this;
  }
}