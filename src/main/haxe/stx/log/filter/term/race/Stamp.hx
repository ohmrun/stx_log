package stx.log.filter.term.race;

typedef StampDef = {
  var timestamp     : Float;
  var scoping       : Scoping;
  var scope         : ScopeSum;
}
@:forward abstract Stamp(StampDef) from StampDef to StampDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:StampDef):Stamp return new Stamp(self);
  

  @:noUsing static public function make(scoping:Scoping,timestamp:Float,?scope){
    return {
      scoping       : scoping,
      timestamp     : timestamp,
      scope         : __.option(scope).defv(ScopeMethod)
    };
  }

  public function prj():StampDef return this;
  private var self(get,never):Stamp;
  private function get_self():Stamp return lift(this);
}