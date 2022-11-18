package stx.log.logger;

class Unit extends stx.log.logger.Base<Any>{
  public var level      : Level;
  public var reinstate  : Bool;
  public function new(?logic:Logic<Any>,?format:Format,?level = DEBUG,?verbose=false,?reinstate=false){
    super(logic,format);
    this.level      = level;
    this.verbose    = verbose;
    this.reinstate  = reinstate;
    this.includes   = new Array();
  }
  public var includes(default,null) : Includes;
  public var verbose                : Bool;

  override private function do_apply(data:Value<Any>):Continuation<Res<String,LogFailure>,Value<Any>>{
    note('$this');
    var applied     = super.do_apply(data);
    note('applied: $applied');
    var applied_fn  = __.reject.bind(__.fault().of(E_Log_Zero));
    var parent      = applied(_ -> applied_fn()).is_ok();
    note('parent applied');
    var has_custom    = Signal.has_custom;
    final stamp_level = data.stamp.level;
    note('level: $level stamp.level: $stamp_level ${stamp_level.asInt()} >= ${level.asInt()}');
    note('${data.stamp.level.asInt()}');
    note('${level.asInt()}');
    note('${data.detail}');
    var levelI      = data.stamp.level.asInt() >= level.asInt();
    var include_tag = includes.is_defined().if_else(
      () -> 
        __.option(data).flat_map(x -> x.stamp).flat_map(x -> x.tags).defv([]).lfold(
          (next:String,memo:Bool) -> memo.if_else(
            () -> true,
            () -> includes.match(next)
          ),
          false
        )
      ,
      () -> !data.stamp.tags.is_defined()
    ); 
    var res = has_custom.if_else(
      () -> reinstate,
      () -> verbose.if_else(
        () -> true,
        () -> data.stamp.level == FATAL || include_tag.if_else(
          () -> parent && levelI,
          () -> false
        )
      )
    );
    note( 
      'has_custom:$has_custom '                   +
      'parent:$parent '                           +
      'level:$level '                             +
      'includes:${includes} '                     +
      'include_tag:$include_tag '                 +
      'stamp_tag:${data.stamp.tags} '             +
      'parent && level: ${parent && levelI} '     +
      'verbose:$verbose '                         +
      'res:$res '
    );
    return (fn:Value<Any>->Res<String,LogFailure>) -> res.if_else(
      () -> __.accept(format.print(data)),
      () -> __.reject(__.fault().of(E_Log_Default({
        has_custom   : has_custom,
       arent      : parent,
        level       : level,
        includes    : includes,
        include_tag : include_tag,
        stamp_tag   : data.stamp.tags,
        verbose     : verbose
      })))
    );
  }
}