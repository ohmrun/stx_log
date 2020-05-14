package stx.log.pack.log.pack;

class Meta implements MetaApi{
  
  public var id(default,null)    : String;
  public var tags(default,null)  : Array<String>;
  public var stamp               : Option<Stamp>; 
  
  public function new(?id,?tags,?stamp:Stamp){
    this.id     = __.option(id).def(__.uuid.bind(null));
    this.tags   = __.option(tags).defv([]);
    this.stamp  = __.option(stamp);
  }
  public function set_stamp(stamp:Stamp):Void{
    this.stamp = Some(stamp);
  }
}