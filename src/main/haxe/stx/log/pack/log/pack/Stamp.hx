package stx.log.pack.log.pack;

class Stamp{
  public var timestamp : Date;
  public var verbose   : Bool;
  public var level     : Level;

  public function new(level:Level){
    this.level     = level;
    this.timestamp = Date.now();
  }
  inline public function toString(){
    var time  = timestamp.toString();
    var lev   = level.toString();
    var out   = 'Stamp($lev $time)';
    return out;
  }
  public function toLogString(posInfos:Pos){
    var pos   = LogPosition.rt().if_else(
      () -> Position._.toStringClassMethodLine(posInfos),
      () -> '<unknown>'
    );
    var time  = timestamp.toString();
    var lev   = level.toString();
    var out   = '$lev $time $pos';
    return out;
  }
}
