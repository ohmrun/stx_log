package stx.log.core;

typedef EntryDef<T> = StringCtrDef<T> & {
  val : T  
};
abstract Entry<T>(EntryDef<T>) from EntryDef<T> to EntryDef<T>{
  public function new(self:EntryDef<T>) this = self;
  @:from static public function fromString(str:String){
    return new Entry({ ctr : (_:String) -> str, val : null });
  }
  public function toString():String{
    return this.ctr(this.val);
  }
}