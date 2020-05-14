package;

using stx.Pico;
using stx.Nano;
using stx.Log;

class Main{

  static function main(){    
    __.log().trace("HELOO");
    var test = new Test();
    Log.config.race(1582106039,
      __.scope(Test.pos(),'test0')
    );
    Log.config.race(1582106636,__.scope(Test.pos(),'test1'));
    Log.config.race(1582107321,__.scope(Test.pos(),'test2'));
    test.test0();
    test.test1();
  }

  macro static function macro_test(){
    __.log().trace("boo");
    __.log().levelled(DEBUG).debug("BOOP THA SNOOT");
    return macro {};
  }
}
class Test{
  static public function pos():LogPosition{
    return __.here();
  }
  public function new(){}
  public function test0(){
    __.log().trace('zero');
  }
  public function test1(){
    __.log().trace('one');
  }
}