package stx.log.logic.term;

import stx.log.global.filter.*;

abstract Default<T>(LogicSum<T>) from LogicSum<T> to LogicSum<T>{
  public function new(?level = Info){
    final has_custom              = Filter.HasCustom().toLogic();
    final reinstate_default       = new ReinstateDefault().toLogic();
    final level                   = Filter.Level(level).toLogic();
    final verbose                 = new Verbose().toLogic();
    final is_filtering_with_tags =  

    this = __.log().logic().tagless().or(
      l -> l.level(INFO)
    );
  }  
}