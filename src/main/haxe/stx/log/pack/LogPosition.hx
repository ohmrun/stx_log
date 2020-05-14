package stx.log.pack;

import stx.log.pack.log.pack.Meta;
import stx.log.pack.log.pack.Stamp;

@:allow(stx.log.pack.log) @:forward abstract LogPosition(Pos) from Pos to Pos{
  
  static inline var id : String = "306cccf1-89a7-44a4-b99a-7c69772a528d";

  @:from static public function fromPos(pos:Pos):LogPosition{
    return new LogPosition(pos);
  }
  public function new(self:Pos){
    this = self;
  }
  #if !macro
  static public function here(?pos:haxe.PosInfos){
    return new LogPosition(pos);
  }
  static public function rt() return true;
  #else
  static public function rt() return false;
  #end

  @:noUsing static public function pure(pos:Pos){
    return new LogPosition(pos);
  }
  

  public var meta(get,never) : Meta;

  public function get_meta():Meta{
    var obj : Meta = null;
    var cs         = __.option(customParams).defv([]);
    for(x in cs){
      var clazz = StdType.getClass(x);
      if(clazz == Meta){
        obj = x;
        break;
      }
    }
    if(obj == null){
      obj = new Meta();
      customParams.push(obj);
    }
    return obj;
  }
  public function stamp(l:Stamp){
    var meta       = get_meta();
        meta.stamp = l;
  }
  public var customParams(get,never) : Array<Dynamic>;

  private function get_customParams(){
    #if macro 
      return [];
    #else
    return __.option(this.customParams).is_defined().if_else(
      () -> this.customParams,
      () -> {
        this.customParams = [];
        return this.customParams;
      }
    );
    #end
  }
  #if !macro
    public function scoping(?method){
      return new Scoping(__.option(method).defv(this.methodName),this.className,this.fileName);
    }
    public function match(race){
      return switch(race.scope){
        case ScopeMethod  : this.methodName == race.scoping.method;
        case ScopeClass   : this.className  == race.scoping.type;
        case ScopeModule  : this.fileName   == race.scoping.module;
      }
    }
  #else
  public function scoping(?method){
    return new Scoping(method,null,null);
  }
    public function match(race){
      return true;
    }
  #end
  public function prj():Pos{
    return this;
  }
}