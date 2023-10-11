package stx.log;

import haxe.ds.Map;

class LogPositionCls{
  public function new(pos:Option<Position>){
    this.pos    = pos;
  }
  public final pos              : Option<Position>;
  public var scoping(get,null)  : Scoping;

  #if !macro
    private function get_scoping():Scoping{
      final methodName    = this.pos.map(x -> x.methodName).defv("");
      final className     = this.pos.map(x -> x.className).defv("");
      final fileName      = this.pos.map(x -> x.fileName).defv("");
      return new Scoping(methodName,className,fileName);
    }
  #else
    private function get_scoping():Scoping{
      return new Scoping("<method>","<type>","<module>");
    }
  #end

  public function copy(?pos):LogPosition{
    return new LogPositionCls(
      __.option(pos).defv(this.pos).map(x -> x.copy())
    );
  }
  
  public function toString(){
    return '${pos.map(x -> (x:Position).toString())} $scoping';
  }
}
@:forward abstract LogPosition(LogPositionCls) from LogPositionCls to LogPositionCls{
  public function new(self) this = self;
  @:noUsing static public function lift(self:LogPositionCls):LogPosition return new LogPosition(self);

  @:noUsing static public function pure(pos:Pos){
    return new LogPositionCls(Some(pos));
  }
  @:from static public function fromPos(pos:Pos):LogPosition{
    return new LogPositionCls(__.option(pos));
  }
  @:noUsing static public function unit():LogPosition{
    return new LogPositionCls(None);
  }

  public function prj():LogPositionCls return this;
  private var self(get,never):LogPosition;
  private function get_self():LogPosition return lift(this);

  #if !macro
  static public function is_runtime() return true;
  #else
  static public function is_runtime() return false;
  #end
}

