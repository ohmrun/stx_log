package stx.log.logger;

class Default extends Logger<Dynamic>{
  public var level      : Level;
  public var reinstate  : Bool;
  public function new(){
    super();
    this.level      = CRAZY;
    this.verbose    = false;
    this.reinstate  = false;
    this.includes   = [];
  }
  public var includes(default,null) : Includes;
  public var verbose                : Bool;

  override public function react(value:Value<Dynamic>):Void{
    super.react(value);
  }
  override public function opine(value:Value<Dynamic>):Bool{
    var is_custom   = Signal.is_custom;
    var parent      = super.opine(value);
    var level       = value.stamp.level.asInt() >= level.asInt();
    var include_tag = includes.is_defined() ? includes.any(
      x -> value.stamp.tags.search(
        y -> x == y
      ).is_defined()

    ) : !value.stamp.tags.is_defined();
    note( 
      'is_custom:$is_custom '                     +
      'parent:$parent '                           +
      'level:$level '                             +
      'includes:${includes} '                     +
      'include_tag:$include_tag '                 +
      'stamp_tag:${value.stamp.tags}'             +
      'verbose:$verbose '         
    );
    return is_custom ? reinstate : verbose ? true : include_tag ? parent && level : false;
  }
  public function reset(){
    this.includes.clear();
    this.level = CRAZY;
    this.logic = Log._.Logic().always();
  }
}