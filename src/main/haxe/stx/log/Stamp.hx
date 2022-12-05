package stx.log;

class Stamp{
  static public var ZERO(default,never): Stamp = new Stamp();

  public var id(default,null)         : String;
  public var level                    : Level;
  public var timestamp                : Date;
  public var tags(default,null)       : Array<String>;
  public var hidden                   : Bool;

  public function new(?id,?level,?timestamp,?tags,?hidden=false){
    this.id         = __.option(id).def(__.uuid.bind("xxxxx"));
    this.level      = __.option(level).defv(BLANK);
    this.timestamp  = __.option(timestamp).def(Date.now);
    this.tags       = __.option(tags).defv([]);
    this.hidden     = hidden;
  }
  public function copy(?id,?level,?timestamp,?tags,?hidden):Stamp{
    return new Stamp(
      __.option(id).defv(this.id),
      __.option(level).defv(this.level),
      __.option(timestamp).defv(this.timestamp),
      __.option(tags).defv(this.tags),
      __.option(hidden).defv(this.hidden)
    );
  }
  public function relevel(level:Level){
    return copy(null,level);
  }
  public function tag(tag:String){
    return copy(null,null,null,tags.snoc(tag));
  }
  public function hide(){
    return copy(id,level,timestamp,tags,true);
  }
  
  inline public function toString(){
    var time  = timestamp.toString();
    var lev   = level.toString();
    var out   = 'Stamp($lev $time)';
    return out;
  }
  public function toLogString(posInfos:Pos){
    var pos   = LogPosition.is_runtime().if_else(
      () -> Position._.to_vscode_clickable_link(posInfos),
      () -> '<unknown>'
    );
    var time  = timestamp.toString();
    var tags  = tags.join(",");
    var lev   = level.toString();
    var out   = '$lev $time [$tags] $pos';
    return out;
  }
  
  public function is_zero(){
    return this == ZERO;
  }
}
