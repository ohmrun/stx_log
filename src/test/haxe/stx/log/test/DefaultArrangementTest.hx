package stx.log.test;

import stx.log.log.term.None as NoneLog;

class DefaultArrangementTest extends TestCase{
  function delegate(logger){
    return new stx.log.logger.DelegateRef(logger);
  }
  function log(log):Log{
    return Log.lift(log);
  }
  function log_tester(logger){
    return new stx.log.log.term.LogTester(logger);
  }
  final logger : Ref<LoggerApi<Dynamic>> =__.log().global;

  public function replace(ctr:CTR<LoggerApi<Dynamic>,LoggerApi<Dynamic>>){
    this.logger.value = ctr.apply(this.logger);
  }
  public function test(){
    final lX = __.log().logic();
    Sys.println("_______________________________________________");
    new stx.log.global.config.IsFilteringWithTags().value = false;//Globals are still evil
    final p = delegate(logger);
    final t = log_tester(p);
    final l = log(t);
    Sys.println("_______________________________________________");
    Sys.println("");
    trace("BEFORE HELLO");
          l.trace('hello');
    trace("AFTER HELLO");
    Sys.println("");
    replace(l -> l.with_logic(x -> x.or(lX.tag("tagged"))));
    Sys.println("");
    Sys.println("_______________________________________________");
    trace("BEFORE HELLO PRINTED WITH NO TAG AFTER LOG TAGGED");
          l.trace('hello again');
    trace("AFTER HELLO PRINTED WITH NO TAG AFTER LOG TAGGED");
    Sys.println("");
    Sys.println("_______________________________________________");
    Sys.println("");
    trace("BEFORE HELLO PRINTED WITH CORRECT TAG AFTER LOG TAGGED");
    l.tag("tagged").trace('hello again');
    trace("AFTER HELLO PRINTED WITH CORRECT TAG AFTER LOG TAGGED");
    Sys.println("_______________________________________________");
    Sys.println("");
    final i = t.history[0];
    is_true(i.result.is_ok());
    final ii = t.history[1];
    is_false(ii.result.is_ok());
    final iii = t.history[2];
    is_true(iii.result.is_ok());
  }
}