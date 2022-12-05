package stx.log;

import haxe.ds.Map;
import stx.log.Stamp;

class LogPositionCls{
  public function new(pos:Option<Position>,stamp){
    this.pos    = pos;
    this.stamp  = stamp;
  }
  public final pos              : Option<Position>;
  public final stamp            : Stamp; 
  public var scoping(get,null)  : Scoping;

  #if !macro
    private function get_scoping():Scoping{
      final methodName    = this.pos.map(x -> x.methodName).defv("");
      final className     = this.pos.map(x -> x.className).defv("");
      final fileName      = this.pos.map(x -> x.fileName).defv("");
      return new Scoping(methodName,className,fileName);
    }
    public function match(race:stx.log.filter.term.race.Stamp){
      return switch(race.scope){
        case ScopeMethod  : this.pos.map(x -> x.methodName == race.scoping.method).defv(false);
        case ScopeClass   : this.pos.map(x -> x.className  == race.scoping.type).defv(false);
        case ScopeModule  : this.pos.map(x -> x.fileName   == race.scoping.module).defv(false);
      }
    }
  #else
    private function get_scoping():Scoping{
      return new Scoping("<method>","<type>","<module>");
    }
    public function match(race){
      return true;
    }
  #end

  public function copy(?pos,?stamp):LogPosition{
    return new LogPositionCls(
      __.option(pos).defv(this.pos).map(x -> x.copy()),
      __.option(stamp).defv(this.stamp)
    );
  }
  public function with_stamp(fn:Stamp->Stamp){
    return copy(null,fn(stamp));
  }
  public function toString(){
    return '$stamp ${pos.map(x -> (x:Position).toString())} $scoping';
  }
}
@:forward abstract LogPosition(LogPositionCls) from LogPositionCls to LogPositionCls{
  public function new(self) this = self;
  @:noUsing static public function lift(self:LogPositionCls):LogPosition return new LogPosition(self);

  @:noUsing static public function pure(pos:Pos){
    return new LogPositionCls(Some(pos),new Stamp());
  }
  @:from static public function fromPos(pos:Pos):LogPosition{
    return new LogPositionCls(__.option(pos),new Stamp());
  }
  @:noUsing static public function unit():LogPosition{
    return new LogPositionCls(None,new Stamp());
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

