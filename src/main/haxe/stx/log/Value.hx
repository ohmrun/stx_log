package stx.log;

class Value<T>{
  @:noUsing static public function make<T>(detail:stx.log.core.Entry<T>,stamp:Stamp,?source:Pos){
    return new Value(detail,stamp,source);
  }
  @:noUsing static public function makeI<T>(detail:stx.log.core.Entry<T>,source:LogPosition){
    return new Value(detail,new Stamp(),source);
  }
  public function new(detail:stx.log.core.Entry<T>,stamp:Stamp,source:LogPosition){
    this.detail     = detail;
    this.stamp      = stamp;
    this.source     = source;
  }
  public var detail(default,null)     : stx.log.core.Entry<T>;
  public var stamp(default,null)      : Stamp;
  public var source(default,null)     : LogPosition;

  public function with_stamp(fn:Stamp->Stamp){
    final restamped =  copy(null,fn(stamp));
    return restamped;
  }
  public function copy(?detail,?stamp,?source){
    return new Value(
      __.option(detail).defv(this.detail),
      __.option(stamp).defv(this.stamp),
      __.option(source).defv(this.source)
    );
  }
  public function restamp(fn:Stamp->Stamp){
    return copy(null,fn(this.stamp),null);
  }
  
  public function toString(){
    return this.source.pos.map(
      x -> this.stamp.toLogString(x)
    ).defv(".") + ":" + Std.string(this.detail);
  }
  #if macro 
    public function match(race:stx.log.filter.term.race.Stamp){
      return switch(race.scope){
        case ScopeMethod  : this.source.pos.map(x -> x.methodName == race.scoping.method).defv(false);
        case ScopeClass   : this.source.pos.map(x -> x.className  == race.scoping.type).defv(false);
        case ScopeModule  : this.source.pos.map(x -> x.fileName   == race.scoping.module).defv(false);
      }
    }
  #else
      public function match(race){
        return true;
      }
  #end
}