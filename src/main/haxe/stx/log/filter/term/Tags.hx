package stx.log.filter.term;

class Tags<T> extends Filter<T>{
  final includes : stx.log.Includes;
  public function new(includes){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
    this.includes = includes;
  }
  override public function apply(value:Value<Dynamic>){
    return __.option(value).flat_map(x -> x.stamp).flat_map(x -> x.tags).defv([]).lfold(
      (next:String,memo:Bool) -> memo.if_else(
        () -> true,
        () -> includes.match(next)
      ),
      false
    ).if_else(
      () -> __.report(),
      () -> __.report(f -> f.of(E_Log('No Tag of $includes')))
    );
  }
  public function canonical(){
    return 'Tags($includes)';
  }
}