package stx.log.pack;

#if flash
  class FlashLog{
    public static function __trace( v : Dynamic, pos : haxe.PosInfos ) {
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
  }
#end