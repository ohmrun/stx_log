package stx.log.test;

class PrintFilterTest extends TestCase{
  public function test(){
    final log   = __.log().global;
    final logic = log.logic;
    trace(logic);
  }
}