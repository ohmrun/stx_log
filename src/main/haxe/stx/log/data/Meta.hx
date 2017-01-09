package stx.log.data;

@:allow(stx.log) typedef Meta = {
  var id(default,null)    : String;
  var tags(default,null)  : Array<String>;
  var stamp               : Stamp; 
}