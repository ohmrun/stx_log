package stx.log.filter.term;

class Tag<T> extends Filter<T>{
  final tag : String;
  public function new(tag){
    new stx.log.global.config.IsFilteringWithTags().value = true;
    super();
    this.tag = tag;
  }
  override public function apply(value:Value<Dynamic>){
    final info = value.source;
    return info.stamp.tags.search(
      (s) -> tag == s
    ).is_defined().if_else(
      () -> Report.unit(),
      () -> __.report(f -> f.of(E_Log_DoesNotContainTag(tag)))
    );
  }
  public function canonical(){
    return 'Tag($tag)';
  }
}