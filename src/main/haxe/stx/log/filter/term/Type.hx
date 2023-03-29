package stx.log.filter.term;

import hre.RegExp;

class Type<T> extends Filter<T>{
  public var type(default,null):String;
  public function new(type){
    super();
    this.type = type;
  }
  override public function apply(v:Value<T>){
    return v.source.pos.map(
      pos -> type == Identifier.fromPath(new haxe.io.Path(pos.fileName))
    ).defv(false).if_else(
      () -> Report.unit(),
      () -> __.report(
        f -> f.of(
          v.source.pos.map(
            pos -> E_Log_SourceNotInPackage(Identifier.fromPath(new haxe.io.Path(pos.fileName)),type)
          ).def(() -> E_Log_SourceNotInPackage('<unknown>','<unknown>')) 
        )  
      )
    );
  }
  public function canonical(){
    return 'Type("$type")';
  }
}