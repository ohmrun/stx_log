package stx.log.type;

interface LogApi{
  var position : Pos;
  public function new(position:Pos){
    this.position = position;
  }
  public function react(v:Dynamic){

  }
}