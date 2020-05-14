package stx.log;

import stx.log.pack.log.pack.Race;
import stx.log.pack.log.pack.Bias;

class Config{
  private var races                   : Array<Race>;
  public static var instance(default,null) : Config = new Config(Bias.instance);

  public function new(bias:Bias){
    this.bias       =  bias;
    this.whitelist  = [];
    this.blacklist  = [];
    this.races      = [];
  }
  

  public var bias                     : Bias;
  public var whitelist(default,null)  : StdArray<Predicate<LogPosition,LogFailure>>;
  public var blacklist(default,null)  : StdArray<Predicate<LogPosition,LogFailure>>;

  function race_predicate(pos:LogPosition){
    var race = races.fold(
      (next:Race,memo:Option<Race>) -> memo.fold(
        (v:Race) -> (next.stamp > v.stamp).if_else(
          () -> Some(next),
          () -> Some(v)
        ),
        () -> Some(next)
      ),
      None
    );
    return switch(race){
      case Some(v)  : 
        note('wins race');
        var out = pos.match(v);
        if(out){
          note('wins race');
        }
        out;
      default       : false; 
    }
  }
  function note(str){
    #if stx_log_config_show
      trace(str);
    #end
  }
  function do_apply(pos:LogPosition){
    note('for: ' + Std.string(pos));
    return if(whitelist.is_defined()){
      note('whitelist defined');
      if(whitelist.any((pred) -> pred.applyI(pos).ok())){
        note('in whitelist');
        if(blacklist.is_defined()){
          note('blacklist defined');
          var out = blacklist.all((pred) -> pred.applyI(pos).ok());   
          if(out){
            note('in blacklist');
          }
          out;
        }else{true;}
      }else{false;}
    }else if(blacklist.is_defined()){
      note('blacklist defined');
      var out = blacklist.all((pred) -> pred.applyI(pos).ok());   
      if(out){
        note('in blacklist');
      }
      out;
    }else if(races.is_defined()){
      note('in races');
      race_predicate(pos);
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
  #if test
    public function apply(pos:LogPosition):Bool{
      return if(races.is_defined()){
        race_predicate(pos);
      }else{
        do_apply(pos);
      }
    }
  #else
    public function apply(pos:LogPosition):Bool{
      return do_apply(pos);
    }
  #end
  public function race(ts:Float,scoping:Scoping,?scope:ScopeSum){
    races.push(Race.make(scoping,ts,scope));
  }
}