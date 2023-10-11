package stx.log;

interface LogApi{
  public function apply(value:Value<Dynamic>):Void;
  public function toLogApi():LogApi;
}