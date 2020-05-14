package stx.log.pack.log.pack;

@:forward abstract Race(RaceDef) from RaceDef to RaceDef{
  public function new(self) this = self;
  static public function lift(self:RaceDef):Race return new Race(self);
  static public function make(scoping:Scoping,stamp:Float,?scope){
    return {
      scoping   : scoping,
      stamp     : stamp,
      scope     : __.option(scope).defv(ScopeMethod)
    };
  }
  public function prj():RaceDef return this;
  private var self(get,never):Race;
  private function get_self():Race return lift(this);

  public function rescope(fn : Scoping -> Scoping ) {
    return make(fn(this.scoping),this.stamp,this.scope);
  }
}