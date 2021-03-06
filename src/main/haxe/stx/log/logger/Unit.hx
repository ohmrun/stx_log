package stx.log.logger;

class Unit extends Logger<Dynamic>{
  public var level      : Level;
  public var reinstate  : Bool;
  public function new(?logic:Filter<Dynamic>,?format:Format,?level = CRAZY,?verbose=false,?reinstate=false){
    super(logic,format);
    this.level      = level;
    this.verbose    = verbose;
    this.reinstate  = reinstate;
    this.includes   = [];
  }
  public var includes(default,null) : Includes;
  public var verbose                : Bool;

  override private function do_apply(value:Value<Dynamic>):Continuation<Res<String,LogFailure>,Value<Dynamic>>{
    var parent      = super.do_apply(value)(_ -> __.reject(__.fault().of(E_Log_Zero))).ok();
    var is_custom   = Signal.is_custom;
    var level       = value.stamp.level.asInt() >= level.asInt();
    var include_tag = includes.is_defined() ? includes.any(
      x -> value.stamp.tags.search(
        y -> x == y
      ).is_defined()
    ) : !value.stamp.tags.is_defined();
    var res = is_custom.if_else(
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
      'is_custom:$is_custom '                     +
      'parent:$parent '                           +
      'level:$level '                             +
      'includes:${includes} '                     +
      'include_tag:$include_tag '                 +
      'stamp_tag:${value.stamp.tags} '            +
      'parent && level: ${parent && level} '      +
      'verbose:$verbose '                         +
      'res:$res '
    );
    return (fn:Value<Dynamic>->Res<String,LogFailure>) -> res.if_else(
      () -> __.accept(format.print(value)),
      () -> __.reject(__.fault().of(E_Log_Default({
        is_custom   : is_custom,
        parent      : parent,
        level       : level,
        includes    : includes,
        include_tag : include_tag,
        stamp_tag   : value.stamp.tags,
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