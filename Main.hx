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
    final entry             = Entry.fromString('hello');
    final pos : LogPosition = __.here();
    var log = new stx.Log();
        log.comply(entry,pos);
    //stx.log.Test.main();
    __.log().trace("hello");
  }
  // macro static function macro_test(){
  //   trace("MACRO");
  //   stx.log.Test.main();
  //   __.log().debug("ok");
  //   return macro {};
  // }
}