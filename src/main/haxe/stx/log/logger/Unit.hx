package stx.log.logger;

class Unit extends stx.log.logger.Base<Any>{
  public var level      : Level;
  public var reinstate  : Bool;
  public function new(?logic:Filter<Any>,?format:Format,?level = CRAZY,?verbose=false,?reinstate=false){
    super(logic,format);
    this.level      = level;
    this.verbose    = verbose;
    this.reinstate  = reinstate;
    this.includes   = new Array();
  }
  public var includes(default,null) : Includes;
  public var verbose                : Bool;

  override private function do_apply(data:Value<Any>):Continuation<Res<String,LogFailure>,Value<Any>>{
    var applied     = super.do_apply(data);
    var applied_fn  = __.reject.bind(__.fault().of(E_Log_Zero));
    var parent      = applied(_ -> applied_fn()).ok();
    var has_custom  = Signal.has_custom;
    var level       = data.stamp.level.asInt() >= level.asInt();
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
        () -> include_tag.if_else(
          () -> parent && level,
          () -> false
        )
      )
    );
    note( 
      'has_custom:$has_custom '                     +
      'parent:$parent '                           +
      'level:$level '                             +
      'includes:${includes} '                     +
      'include_tag:$include_tag '                 +
      'stamp_tag:${data.stamp.tags} '            +
      'parent && level: ${parent && level} '      +
      'verbose:$verbose '                         +
      'res:$res '
    );
    return (fn:Value<Any>->Res<String,LogFailure>) -> res.if_else(
      () -> __.accept(format.print(data)),
      () -> __.reject(__.fault().of(E_Log_Default({
        has_custom   : has_custom,
        parent      : parent,
        level       : level,
        includes    : includes,
        include_tag : include_tag,
        stamp_tag   : data.stamp.tags,
        verbose     : verbose
      })))
    );
  }
  public function reset(){
    this.includes.clear();
    this.level = CRAZY;
    this.logic = Log._.Logic().always();
  }
}