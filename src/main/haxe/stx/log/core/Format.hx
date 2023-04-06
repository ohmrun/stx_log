package stx.log.core;

using stx.lift.ArrayLift;

enum FormatSum{
  INCLUDE_LEVEL;
  INCLUDE_TIMESTAMP;
  INCLUDE_TAGS;
  INCLUDE_LOCATION;
  INCLUDE_NEWLINE_FOR_DETAIL;
  INCLUDE_DETAIL;
}
class FormatCls{
  public final data :  Array<FormatSum>;
  public function new(?data){
    this.data = Option.make(data).defv(Format.DEFAULT);
  }
  public function has(v:FormatSum){
    return this.data.has(v).is_defined();
  }
  public function print<T>(value:Value<T>):String{
    var p = value.source;
    var s = p.stamp;
    var a : Array<String> = [];
    if(has(INCLUDE_LEVEL)){
      a.push(s.level.toString());
    }
    if(has(INCLUDE_TIMESTAMP)){
      a.push(s.timestamp.toString());
    }
    if(has(INCLUDE_TAGS)){
      a.push('[' + s.tags.join(",") + ']');
    }
    if(has(INCLUDE_LOCATION)){
      //TODO can be earlier than __init__?;
      final b = p.pos.map(stx.nano.Position.PositionLift.to_vscode_clickable_link).defv('');
      a.push(b);
    }
    if(has(INCLUDE_NEWLINE_FOR_DETAIL)){
      a.push("\n");
    }
    if(has(INCLUDE_DETAIL)){
      a.push(Std.string(value.detail));
    }
    return a.join(" ");
  }
}
@:forward abstract Format(FormatCls) from FormatCls to FormatCls{
  static public function unit():Format return lift(fromArray(DEFAULT));
  
  public inline function new(self) this = self;
  static public inline function lift(self:FormatCls):Format return new Format(self);
  
  @:isVar static public var DEFAULT(get,null) : Array<FormatSum>;
  
  @:from static public function fromArray(self:Array<FormatSum>):Format{
    return new FormatCls(self);
  }
  private static function get_DEFAULT(){
    return DEFAULT == null ? DEFAULT = [INCLUDE_TAGS,INCLUDE_LEVEL,INCLUDE_TIMESTAMP,INCLUDE_LOCATION,INCLUDE_DETAIL] : DEFAULT;
  }

  public function prj():FormatCls return this;
  private var self(get,never):Format;
  private function get_self():Format return lift(this);

}