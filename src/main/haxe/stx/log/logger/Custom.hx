package stx.log.logger;


class Custom extends Unit{
  override private function do_apply(value:Value<Dynamic>):Continuation<Res<String,LogFailure>,Value<Dynamic>>{
    var level       = value.stamp.level.asInt() >= level.asInt();
    var include_tag = includes.is_defined() ? includes.any(
      x -> value.stamp.tags.search(
        y -> x == y
      ).is_defined()
    ) : !value.stamp.tags.is_defined();

    var res = (level && include_tag) || verbose;

    note( 
      'level:$level '                             +
      'includes:${includes} '                     +
      'include_tag:$include_tag '                 +
      'stamp_tag:${value.stamp.tags} '            +
      'verbose:$verbose '                         +
      'res:$res '
    );
    return (fn:Value<Dynamic>->Res<String,LogFailure>) -> res.if_else(
      () -> __.accept(format.print(value)),
      () -> __.reject(__.fault().of(E_Log_Default({
        level       : level,
        includes    : includes,
        include_tag : include_tag,
        verbose     : verbose
      })))
    );
  }
}