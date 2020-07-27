package stx.log.pack.log.term;

import stx.log.pack.log.pack.Meta;

class LevelledLog implements PredicateApi<Pos,LogFailure>{
  var level : Level;
  public function new(level:Level){
    this.level = level;
  }
  public function applyI(pos:LogPosition):Report<LogFailure>{
    var params        = __.option(pos.customParams).defv([]);

    return params.filter(
      (param) -> param != null
    ).map_filter(
      (param:Any)-> (Meta == (StdType.getClass(param):Class<Dynamic>)).if_else(
        () -> __.option(
          Std.isOfType(param,Meta) ? (param:Meta) : null
        ).map((x:Meta) -> x.stamp.map(x -> x.level.asInt() >= level.asInt()).defv(false)),
        () -> None
      )
    ).is_defined().report(
      __.fault().of(UnderLogLevel)
    );
  }
}