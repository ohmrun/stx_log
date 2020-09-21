package stx.log;

class Flash implements OutputApi extends Clazz{
  #if flash
  private function render( v : Dynamic, pos : Pos ) {
    var tf = flash.Boot.getTrace();
    var pstr = if( pos == null ) "(null)" else pos.fileName+":"+pos.lineNumber;
    if( lines == null ) lines = [];
    var str = pstr +": "+ flash.Boot.__string_rec(v, "");
    lines = lines.concat(str.split("\n"));
    tf.text = lines.join("\n");
    var stage = flash.Lib.current.stage;
    if( stage == null )
      return;
    while( lines.length > 1 && tf.height > stage.stageHeight ) {
      lines.shift();
      tf.text = lines.join("\n");
    }
  }
  #else
  private function render( v : Dynamic, pos : Pos ) {}
  #end
}