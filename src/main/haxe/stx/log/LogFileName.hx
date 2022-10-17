package stx.log;

abstract LogFileName(String) from String to String{
  public function new(self) this = self;
  @:noUsing static public function lift(self:String):LogFileName return new LogFileName(self);
  

  public function get_pack():Array<String>{
    var parts = this.split(__.sep());
    parts.pop();
    return parts;
  }
  public function get_canonical():String{
    var a           = this.split(".")[0];
    var canonical   = a.split(__.sep()).join(".");
    return canonical;
  }
  public function prj():String return this;
  private var self(get,never):LogFileName;
  private function get_self():LogFileName return lift(this);
}