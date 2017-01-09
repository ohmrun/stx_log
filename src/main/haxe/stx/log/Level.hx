package stx.log;

@:enum abstract Level(Int) from Int to Int{
  var TRACE = 0;
  var DEBUG = 1;
  var INFO  = 2;
  var WARN  = 3;
  var ERROR = 4;
  var FATAL = 5;
}
class Levels{
  static public function asInt(lvl:Level):Int{
    var int : Int = lvl;
    return int;
  }
  static public function toString(lvl:Level):String{
    return switch (lvl) {
      case 0: "TRACE";
      case 1: "DEBUG";
      case 2: "INFO";
      case 3: "WARN";
      case 4: "ERROR";
      case 5: "FATAL";
    }
  }
}
