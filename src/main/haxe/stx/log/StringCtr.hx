package stx.log;

typedef StringCtrDef<T> = {
  public function ctr(t:T):String;
}
abstract StringCtr<T>(StringCtrDef<T>) from StringCtrDef<T> to StringCtrDef<T>{
  public function new(self) this = self;
  static public function unit<T>():StringCtr<T>{
    return lift({ ctr : Std.string });
  }
  static public function make<T>(fn:T->String){
    return lift({
      ctr : fn
    });
  }
  @:noUsing static public function lift<T>(self:StringCtrDef<T>):StringCtr<T> return new StringCtr(self);
  
  public function capture(val:T):stx.log.core.Entry<T>{
    return {
      ctr : this.ctr,
      val : val
    };
  }
  public function prj():StringCtrDef<T> return this;
  private var self(get,never):StringCtr<T>;
  private function get_self():StringCtr<T> return lift(this);
}