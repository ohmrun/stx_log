package stx.log.pack.log.type;

interface MetaApi{
  var id(default,null)    : String;
  var tags(default,null)  : Array<String>;
  var stamp               : Option<Stamp>; 
}