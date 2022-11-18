package stx.log;

interface LogApi{
  public function comply(entry:stx.log.core.Entry<Dynamic>,pos:LogPosition):Void;
  public function toLogApi():LogApi;
}