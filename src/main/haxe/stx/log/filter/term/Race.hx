package stx.log.filter.term;

import stx.log.filter.term.race.Stamp;

class Race<T> extends Filter<T>{
  public var races(default,null):Array<Stamp>;
  public function new(){
    super();
    this.races = [];
  }
  override public function apply(value:Value<T>){
    var race = races.fold(
      (next:Stamp,memo:Option<Stamp>) -> memo.fold(
        (v:Stamp) -> (next.timestamp > v.timestamp).if_else(
          () -> Some(next),
          () -> Some(v)
        ),
        () -> Some(next)
      ),
      None
    );
    return switch(race){
      case Some(v)  : 
        trace('wins race');
        var out = value.source.match(v);
        if(out){
          trace('wins race');
        }
        out.if_else(() -> Report.unit(),() -> Report.pure(__.fault().of(E_Log_LosesRace)));
        default       : Report.pure(__.fault().of(E_Log_LosesRace));
    }
  }
}