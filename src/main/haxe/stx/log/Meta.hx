package stx.log;

import stx.log.data.Stamp;
import stx.log.data.Meta in MetaT;

@:forward @:access(stx.log.Position)abstract Meta(MetaT){
  public function new(?self){
    if(self == null){
      this = {
        id    : Position.id,
        tags  : [], 
        stamp : null
      };
    }else{
      this = self;
    }
  }
  public function setStamp(stamp:Stamp):Meta{
    this.stamp = stamp;
    return new Meta(this);
  }
}