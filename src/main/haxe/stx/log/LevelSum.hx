package stx.log;

@:enum abstract LevelSum(Int) from Int to Int{
  var BLANK = 0;
  var TRACE = 1;
  var DEBUG = 2;
  var INFO  = 3;
  var WARN  = 4;
  var ERROR = 5;
  var FATAL = 6;

  public function prj():Int{
    return this;
  }
}