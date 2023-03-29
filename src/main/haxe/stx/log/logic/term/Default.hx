package stx.log.logic.term;

import stx.log.global.filter.*;

final l = () -> __.log().logic();

@:forward abstract Default<T>(LogicSum<T>) from LogicSum<T> to LogicSum<T>{
  @:to public function toLogic(){
    return Logic.lift(this);
  }
  public function new(?level = INFO,?includes:stx.log.Includes){
    final has_custom              = Filter.HasCustom().toLogic();
    final reinstate_tagless       = new ReinstateTagless().toLogic();
    final level                   = Filter.Level(level).toLogic();
    final verbose                 = new Verbose().toLogic();
    final is_filtering_with_tags  = new IsFilteringWithTags().toLogic();  
    final base_state_filter       = l().tagless().and(
      is_filtering_with_tags.not()
    );
    
    var result                  = base_state_filter.or(
      reinstate_tagless
    );
    if(includes!=null){
      result = result.or(
        new stx.log.filter.term.Tags(includes).toLogic()
      );
    }
    result = result.or(level);
    this = result;
  }  
}