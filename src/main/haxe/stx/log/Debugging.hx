package stx.log;

class Debugging{
  function note(str,?pos:Pos){
    #if stx.log.filter.show
      trace(str,pos);
    #end
  }
}