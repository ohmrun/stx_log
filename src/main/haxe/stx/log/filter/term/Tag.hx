package stx.log.filter.term;

class Tag<T> extends Filter<T>{
  final tag : String;
  public function new(tag){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
    this.tag = tag;
  }
  override public function apply(value:Value<Dynamic>){
    return __.option(data).flat_map(x -> x.stamp).flat_map(x -> x.tags).defv([]).lfold(
      (next:String,memo:Bool) -> memo.if_else(
        () -> true,
        () -> includes.match(next)
      ),
      false
    ).if_else(
      () -> __.report(),
      () -> __.report(E_Log('No Tag $tag'))
    );
  }
}