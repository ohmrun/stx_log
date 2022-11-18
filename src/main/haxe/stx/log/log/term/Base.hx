package stx.log.log.term;

abstract class Base implements LogApi{
  abstract public function comply(entry:Entry<Dynamic>,pos:LogPosition):Void;
  public function toLogApi(){
    return this;
  }
}