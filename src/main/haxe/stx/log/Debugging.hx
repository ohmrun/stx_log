package stx.log;

class Debugging{
  function note(str,?pos:Pos){
    #if (stx.log.filter.show == "true")
      haxe.Log.trace(str,cast pos);
    #end
  }
}