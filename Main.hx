package;

using stx.Pico;
using stx.Nano;
using stx.Log;
using stx.Assert;
using stx.log.Core;

class Main{

  static function main(){
    //macro_test(); 
    trace("MAIN");
    //final entry             = Entry.fromString('hello');
    // final pos : LogPosition = __.here();
    // var log = new stx.Log();
    //     log.comply(entry,pos);
    //stx.log.Test.main();

    __.log().info("begin");

    __.logger().configure(
        api -> api.with_logic(
          logic -> logic.tags(['toot'])
        )
      );
      __.log().info("begin again");
    // __.logger().configure(
    //   api -> api.with_logic(
    //     logic -> logic.level(TRACE)
    //   )
    // );
    // __.log().trace("hi");
    // trace("____________________________");
    // __.logger().configure(
    //   api -> api.with_logic(
    //     _ -> new stx.log.global.filter.IsFilteringWithTags().toLogic().or(new stx.log.global.filter.ReinstateTagless().toLogic())
    //   )
    // );
    // __.log().trace("hi again");

    // __.logger().configure(
    //   api -> api.with_logic(
    //     logic -> logic.and( logic.tags(['gello']))
    //   )
    // );
    // __.log().trace("hello again");

    // new stx.log.global.config.ReinstateTagless().value = true;

    // __.logger().configure(
    //   api -> api.with_logic(
    //     logic -> logic.and( logic.tags(['gello']))
    //   )
    // );
    // __.log().trace("helloski");

    // new stx.log.global.config.ReinstateTagless().value = false;

    // __.log().tag('gello').trace('bienvenido');


  }
  // macro static function macro_test(){
  //   trace("MACRO");
  //   stx.log.Test.main();
  //   __.log().debug("ok");
  //   return macro {};
  // }
}