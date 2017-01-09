package stx;

import haxe.ds.Option;

using stx.Positions;

using stx.Tuple;
using stx.log.Level;

import stx.Compare.*;
import stx.ReadRef;

import haxe.PosInfos;
import stx.Log;

class Logs{
  static public function positioned(log:Log,p:Predicate<PosInfos>):Log{
    return function(v:Dynamic,?pos:PosInfos){
      if(p(pos)){
        //pos.customParams = null;
        log(v,pos);
      }
    }
  }
  static public function use(log:Log,fn:Dynamic->Dynamic):Log{
    return function(x:Dynamic,?pos:PosInfos){
      log(fn(x),pos);
    }
  }
  static public function containing(log:Log,p:Predicate<Dynamic>):Log{
    return function(v:Dynamic,?pos:PosInfos){
      if(p(v)){
        log(v,pos);
      }
    }
  }
  @:noUsing static public function levelled(log,level:ReadRef<Level>):Log{
    return positioned(log,
      function(pos:PosInfos):Bool{
        var level : Level = level;
        var params = (nil()(pos.customParams) ? [] : pos.customParams);

        var o =
          Transducer.Transducers.map(function(x):Level{ return x.Level; })
          .compose(
            Transducer.Transducers.map(
              function(print_level:Level){
                return print_level.asInt() >= level.asInt();
              }
            )
          )(
          Transducer.Reducers.search(
            Reflect.hasField.bind(_,"Level")
          )
        ).into(params,None);

        return switch(o.unbox()){
          case Some(v) : v;
          case None: false;
        }
      }
    ).use(
      function(x){
        var lvl = Levels.toString(level);
        var val = stx.Show.show(x);
        return '$lvl: $val';
      }
    );
  }
}
