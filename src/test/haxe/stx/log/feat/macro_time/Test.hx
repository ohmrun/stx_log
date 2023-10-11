package stx.log.feat.macro_time;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

using stx.Nano;
using stx.Test;
using stx.Log;

class Test extends TestCase{
  static public function main(){
    trace("RUNTIME");
    __.logger().global().configure(
      logger -> logger.with_logic(
        logic -> logic.never()
      )
    );
    __.test().run(
      [
        new Test()
      ],[]
    );
  }
  public function test(){
    log_situation(null);
  }
  static macro function log_situation(e:Expr){
    __.logger().global().configure(
          logger -> logger.with_logic(
            logic -> logic.tags(['stx/loggyoo'])
          )
        );
    __.log().tag("stx/loggyoo").debug("test");
    return macro {}
  }
}