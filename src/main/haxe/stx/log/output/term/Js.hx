package stx.log.output.term;

class Js implements OutputApi extends Clazz{
  #if js
  private function render(v:Dynamic,pos : LogPosition) {
    untyped {
      var msg = "";//if( i != null ) i.fileName+":"+i.lineNumber+": " else "";
      #if jsfl
      msg += js.Boot.__string_rec(v,"");
      fl.trace(msg);
      #else
      msg += js.Boot.__string_rec(v, "");
      var d;
      if( js.Syntax.code("typeof")(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null )
        d.innerHTML += __unhtml(msg)+"<br/>";
      else if( js.Syntax.code("typeof console") != "undefined" && js.Syntax.code("console").log != null )
        js.Syntax.code("console").log(msg);
      #end
    }
  }
  #else
  private function render( v : Dynamic, info : LogPosition ) {}
  #end
}