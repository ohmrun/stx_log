package stx.log.output.term;

#if flash
class Flash implements OutputApi extends Clazz{
  
  private function render( v : Dynamic, infos : LogPosition ) {
    final pos = infos.pos;
    var tf = flash.Boot.getTrace();
    var pstr = if( pos == null ) "(null)" else pos.fileName+":"+pos.lineNumber;
    if( lines == null ) lines = [];
    var str = flash.Boot.__string_rec(v, "");
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
}
#end