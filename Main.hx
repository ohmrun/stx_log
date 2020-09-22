package;

using stx.Pico;
using stx.Nano;
using stx.Log;

class Main{

  static function main(){    
    trace("MAIN");
    stx.log.Test.main();   
  }

  macro static function macro_test(){
    trace("MACRO");
    return macro {};
  }
}