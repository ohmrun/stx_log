package stx.log;

import stx.log.data.Stamp;

import thx.Position in PositionT;

@:allow(stx.log.Meta) @:forward abstract Position(PositionT) from PositionT to PositionT{
  @:from static public function fromPos(pos:haxe.PosInfos):Position{
    return new Position(new thx.Position(pos));
  }
  public function new(self){
    this = self;
  }
  static public function here(?pos:haxe.PosInfos){
    return new Position(pos);
  }
  @:noUsing static public function pure(pos:haxe.PosInfos){
    return new Position(pos);
  }
  static inline var id : String = "306cccf1-89a7-44a4-b99a-7c69772a528d";

  public var meta(get,never) : Meta;

  public function get_meta():Meta{
    var obj = null;
    for(x in this.customParams){
      if(Reflect.hasField(x,"id") && Reflect.field(x,"id") == Position.id ){
        obj = x;
        break;
      }
    }
    var meta = new Meta();
    if(obj == null){
      this.customParams.push(obj = meta);
    }
    return meta;
  }
  public function stamp(l:Stamp){
    var meta = get_meta();
    meta.stamp = l;
  }
}