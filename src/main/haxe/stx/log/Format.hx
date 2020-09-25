package stx.log;

enum FormatSum{
  INCLUDE_LEVEL;
  INCLUDE_TIMESTAMP;
  INCLUDE_TAGS;
  INCLUDE_LOCATION;
  INCLUDE_NEWLINE_FOR_DETAIL;
  INCLUDE_DETAIL;
}
abstract Format(Array<FormatSum>) from Array<FormatSum> to Array<FormatSum>{
  static public function unit():Format return lift(DEFAULT);
  
  public function new(self) this = self;
  static public function lift(self:Array<FormatSum>):Format return new Format(self);
  
  @:isVar static public var DEFAULT(get,null) : Array<FormatSum>;
  
  private static function get_DEFAULT(){
    return DEFAULT == null ? DEFAULT = [INCLUDE_LEVEL,INCLUDE_TIMESTAMP,INCLUDE_LOCATION,INCLUDE_DETAIL] : DEFAULT;
  }

  public function prj():Array<FormatSum> return this;
  private var self(get,never):Format;
  private function get_self():Format return lift(this);

  public function has(v:FormatSum){
    return this.has(v).is_defined();
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
      a.push(Position._.to_vscode_clickable_link(p));
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