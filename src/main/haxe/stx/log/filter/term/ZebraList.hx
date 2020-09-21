package stx.log.filter.term;

import stx.log.filter.term.zebra_list.Bias;

class ZebraList<T> extends Filter<T>{

  public function new(bias){
    super();
    this.bias       =  bias;
    this.whitelist  = [];
    this.blacklist  = [];
  }
  public var bias                     : Bias;
  public var whitelist(default,null)  : StdArray<Predicate<LogPosition,LogFailure>>;
  public var blacklist(default,null)  : StdArray<Predicate<LogPosition,LogFailure>>;

  override public function opine(value:Value<T>){
    note('for: ' + Std.string(value.source));
    return if(whitelist.is_defined()){
      note('whitelist defined: $whitelist');
      if(whitelist.any((pred) -> pred.applyI(value.source).ok())){
        note('in whitelist');
        if(blacklist.is_defined()){
          note('blacklist defined');
          var out = blacklist.all((pred) -> pred.applyI(value.source).ok());   
          if(out){
            note('in blacklist');
          }
          out;
        }else{true;}
      }else{false;}
    }else if(blacklist.is_defined()){
      note('blacklist defined');
      var out = blacklist.all((pred) -> pred.applyI(value.source).ok());   
      if(out){
        note('in blacklist');
      }
      out;
    }else{
      var ok = bias.ok();
      if(ok){
        note('bias ok');
      }else{
        note('no');
      }
      ok;
    }
  }
}