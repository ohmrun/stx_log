package stx.log;

enum FormatSum{
  TIMESTAMP;
  LEVEL;
  LOCATION;
  DETAIL;
}
abstract Format(Array<FormatSum>) from Array<FormatSum> to Array<FormatSum>{
  public function new(self) this = self;
  static public function lift(self:Array<FormatSum>):Format return new Format(self);
  
  static public var DEFAULT = [LEVEL,TIMESTAMP,LOCATION,DETAIL];
  

  public function prj():Array<FormatSum> return this;
  private var self(get,never):Format;
  private function get_self():Format return lift(this);
}