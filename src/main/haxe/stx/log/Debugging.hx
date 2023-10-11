package stx.log;

class Debugging{
  function note(str:Dynamic,?pos:Pos){
    
    #if (stx.log.filter.show == "true" || stx.log.switches.debug == "true")
      #if macro
        haxe.Log.trace(str,cast pos);
      #end
    #end
  }
}