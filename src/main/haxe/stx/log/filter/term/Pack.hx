package stx.log.filter.term;


class Pack<T> extends Filter<T>{
  public var pack(default,null):Cluster<String>;
  public function new(pack){
    super();
    this.pack = pack;
  }
  override public function apply(v:Value<T>){
    trace('apply $v $pack');
      final canonical   = pack.join(".");
      final query       = new EReg('${canonical}.*','g');

      

      return v.source.pos.map(
        pos -> {
          final string      = Identifier.lift(pos.fileName).pack.join(".");
          return query.match(string);
        }
      ).defv(false).if_else(
        () -> Report.unit(),
        () -> __.report(
          f -> f.of(
            v.source.pos.map(
              pos -> E_Log_SourceNotInPackage(Identifier.fromPath(new haxe.io.Path(pos.fileName)),pack.join("."))
            ).def(() -> E_Log_SourceNotInPackage('<unknown>',pack.join("."))) 
          )  
        )
      );
  }
  public function canonical(){
    return 'Pack($pack)';
  }
}