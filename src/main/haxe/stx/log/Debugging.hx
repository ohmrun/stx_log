package stx.log;

class Debugging{
  function note(str,?pos:Pos){
    #if (stx.log.filter.show == "true")
      trace(str,pos);
    #end
  }
}