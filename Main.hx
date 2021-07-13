package;

using stx.Pico;
using stx.Nano;
using stx.Log;

class Main{

  static function main(){
    //macro_test(); 
    trace("MAIN");
    stx.log.Test.main();
    //$type(__.log().trace);   
  }
  // macro static function macro_test(){
  //   trace("MACRO");
  //   stx.log.Test.main();
  //   __.log().debug("ok");
  //   return macro {};
  // }
}