package stx.log.log.term;

private class LogTesterInfo{
  public function new(logic,value,result){
    this.logic  = logic;
    this.value  = value;
    this.result = result;
  }
  public final logic  : Logic<Dynamic>;
  public final value  : Value<Dynamic>;
  public final result : Report<LogFailure>;

  public function toString(){
    return '$logic,$value,$result';
  }
}
class LogTester implements LogApi{
  public final history : Array<LogTesterInfo>;
  final logger  : LoggerApi<Dynamic>;

  public function new(logger){
    this.history  = [];
    this.logger   = logger;
  }
  public function apply(value:Value<Dynamic>):Void{
    final logic   = logger.logic;
    final result  = logger.logic.apply(value);
    this.history.push(new LogTesterInfo(logic,value,result));
  }
  public function toLogApi():LogApi{
    return this;
  }
}