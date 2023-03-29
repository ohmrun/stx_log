package stx.log.filter.term;

class Method<T> extends Filter<T>{
  final method : String;
  public function new(method){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
    this.method = method;
  }
  override public function apply(value:Value<Dynamic>){
    final info = value.source;
    return (info.pos.map(
      pos -> pos.methodName == method)
    ).defv(false).if_else(
      () -> Report.unit(),
      () -> __.report(f -> f.of(E_Log_NotInMethod(method)))
    );
  }
  public function canonical(){
    return 'Method($method)';
  }
}