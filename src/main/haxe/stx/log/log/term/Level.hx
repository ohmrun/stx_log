package stx.log.log.term;

class Level extends Mod{
  public final level : stx.log.Level;
  public function new(delegate,level){
    super(delegate);
    this.level = level;
  }
  public function mod(value:Value<Dynamic>):Value<Dynamic>{
    return value.restamp(stamp -> stamp.relevel(this.level));
  }
}