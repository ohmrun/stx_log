package stx.log.log.term;

class Level extends Mod{
  public final level : stx.log.Level;
  public function new(delegate,level){
    super(delegate);
    this.level = level;
  }
  public function mod(pos:LogPosition){
    return pos.with_stamp(stamp -> stamp.relevel(this.level) );
  }
}