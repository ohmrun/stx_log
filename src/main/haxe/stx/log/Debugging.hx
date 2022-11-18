package stx.log;

class Debugging{
  function note(str,?pos:Pos){
    #if (stx.log.filter.show == "true" || stx.log.switches.debug == "true")
      haxe.Log.trace(str,cast pos);
    #end
  }
}