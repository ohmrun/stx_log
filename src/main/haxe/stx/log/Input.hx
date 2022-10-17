package stx.log;

typedef InputDef<T> = Value<T>;

abstract Input<T>(InputDef<T>) from InputDef<T> to InputDef<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:InputDef<T>):Input<T> return new Input(self);
  
  
  public function prj():InputDef<T> return this;
  private var self(get,never):Input<T>;
  private function get_self():Input<T> return lift(this);
}