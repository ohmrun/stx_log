package stx.log.type;

@:enum abstract LevelSum(Int) from Int to Int{
  var TRACE = 0;
  var DEBUG = 1;
  var INFO  = 2;
  var WARN  = 3;
  var ERROR = 4;
  var FATAL = 5;
}