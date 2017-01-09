package stx.log.data;

import stx.log.Level;
import haxe.PosInfos;
import stx.Positions;


class Stamp{
  public var timestamp : Date;
  public var verbose   : Bool;
  public var level     : Level;

  public function new(level){
    this.level     = level;
    this.timestamp = Date.now();
  }
  public function toLogString(posInfos){
    var pos   = Positions.toStringClassMethodLine(posInfos);
    var time  = timestamp.toString();
    var lev   = Levels.toString(level);
    var out   = '$lev $time ($pos)';
    return out;
  }
}
