package stx.log;

import hre.RegExp;

class LogicCtr extends Clazz{
  static public function unit(){
    return new LogicCtr();
  }
  private static function construct<T>(fn:LogPosition->Report<LogFailure>):stx.log.Logic<T>{
    return Logic.fromPosPredicate(stx.assert.Predicate.Anon(fn));
  }
  public function pack<T>(pack:Array<String>):stx.log.Logic<T>{
    return construct((info:LogPosition) -> {
      var canonical   = pack.join(".");
      var query       = new RegExp('${canonical}.*','g');

      return info.pos.map(
        pos -> query.test(Identifier.lift(pos.fileName).pack.join("."))
      ).defv(false).if_else(
        () -> Report.unit(),
        () -> __.report(
          f -> f.of(
            info.pos.map(
              pos -> E_Log_SourceNotInPackage(Identifier.fromPath(new haxe.io.Path(pos.fileName)),pack.join("."))
            ).def(() -> E_Log_SourceNotInPackage('<unknown>',pack.join("."))) 
          )  
        )
      );
    });
  }
  public function type<T>(type:String):stx.log.Logic<T>{
    return construct((info:LogPosition) -> {
      return info.pos.map(
        pos -> type == Identifier.fromPath(new haxe.io.Path(pos.fileName))
      ).defv(false).if_else(
        () -> Report.unit(),
        () -> __.report(
          f -> f.of(
            info.pos.map(
              pos -> E_Log_SourceNotInPackage(Identifier.fromPath(new haxe.io.Path(pos.fileName)),type)
            ).def(() -> E_Log_SourceNotInPackage('<unknown>','<unknown>')) 
          )  
        )
      );
    });
  }
  public function line<T>(n:Int):stx.log.Logic<T>{
    return construct((info) -> {
      var result      = info.pos.map(x -> x.lineNumber == n).defv(false);
      return result.if_else(
        () -> Report.unit(),
        () -> __.report(f -> f.of(E_Log_NotLine(n)))
      );
    });
  }
  public function level<T>(level:stx.log.Level):stx.log.Logic<T>{
    return construct((info) -> {
      final result = info.stamp.level.asInt() >= level.asInt();
      return if(result){
        Report.unit();
      }else{
        __.report(f -> f.of(E_Log_UnderLogLevel));
      }
    });
  }
  public function lines<T>(l:Int,h:Int):stx.log.Logic<T>{
    return construct((
      (info) -> info.pos.map(
          pos -> ((pos.lineNumber >= l) && (pos.lineNumber <= h))
        ).defv(false)
         .if_else(
          () -> Report.unit(),
          () -> __.report(f -> f.of(E_Log_NotOfRange(l,h)))
        )
    ));
  }
  public function tag<T>(str:String):stx.log.Logic<T>{
    return construct(
      (info) -> info.stamp.tags.search(
          (tag) -> tag == str
      ).is_defined().if_else(
        () -> Report.unit(),
        () -> __.report(f -> f.of(E_Log_DoesNotContainTag(str)))
      )
    );
  }
  public function tags<T>(arr:Array<String>):stx.log.Logic<T>{
    return stx.log.filter.term.Includes(arr);
  }
  public function tagless<T>():stx.log.Logic<T>{
    return construct(
      (info) -> if(!__.tracer()(info).stamp.tags.is_defined()){
        Report.unit();
      }else{
        __.report(f -> f.of(E_Log('not tagless')));
      }
    );
  }
  public function method<T>(str:String):stx.log.Logic<T>{
    return construct(
      (info) -> (info.pos.map(
        pos -> pos.methodName == str)
      ).defv(false).if_else(
        () -> Report.unit(),
        () -> __.report(f -> f.of(E_Log_NotInMethod(str)))
      )
    );
  }
  public function always<T>():stx.log.Logic<T>{
    return construct(
      (pos) -> Report.unit()
    );
  }
  public function never<T>():stx.log.Logic<T>{
    return construct(
      (value) -> Report.make(E_Log_Zero)
    );
  }
}
enum LogicSum<T>{
  LAnd(l:Logic<T>,r:Logic<T>);
  LOr(l:Logic<T>,r:Logic<T>);
  LNot(l:Logic<T>);
  LV(v:Filter<T>);
}
abstract Logic<T>(LogicSum<T>) from LogicSum<T> to LogicSum<T>{
  public function new(self) this = self;
  static public var _(default,never) = LogicLift;
  @:noUsing static public function lift<T>(self:LogicSum<T>):Logic<T> return new Logic(self);
 
  static public function fromPosPredicate<T>(self:stx.assert.Predicate<LogPosition,LogFailure>):Logic<T>{
    return lift(LV(new stx.log.filter.term.PosPredicate(self)));
  }
  static public function fromFilter<T>(self:Filter<T>):Logic<T>{
    return LV(self);
  }
  @:op(A && B)
  public function and(that:CTR<LogicCtr,Logic<T>>):Logic<T>{
    return LAnd(this,that.apply(LogicCtr.unit()));
  }
  @:op(A || B)
  public function or(that:CTR<LogicCtr,Logic<T>>):Logic<T>{
    return LOr(this,that.apply(LogicCtr.unit()));
  }
  @:op(!A)
  public function not():Logic<T>{
    return LNot(lift(this));
  }
  public function apply(value:Value<T>):Report<LogFailure>{
    __.assert().exists(this);
    __.assert().exists(value);
    #if macro
    return __.report();
    #else
    return switch(this){
      case LAnd(l,r)  : l.apply(value).or(() -> r.apply(value));
      case LOr(l,r)   : 
        var fst = l.apply(value);
        fst.is_defined().if_else(
          () -> r.apply(value),
          () -> fst
        );
      case LNot(v)    : v.apply(value).fold(
        (e) -> Report.unit(),
        ()  -> Report.make(E_Log_Not)//TODO hmmm
      );
      case LV(null)       : throw 'no Filter defined in Logic';
      case LV(v)          : v.apply(value);
    }
    #end
  }
  public function opine(value:Value<T>){
    return apply(value);
  }
  public function prj():LogicSum<T> return this;
  private var self(get,never):Logic<T>;
  private function get_self():Logic<T> return lift(this);

  public function pack(pack:Array<String>):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().pack(pack);
  }
  public function level<T>(level:stx.log.Level):stx.log.Logic<T>{
    return LogicCtr.unit().level(level);
  }
  public function type(type:String):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().type(type);
  }
  public function line(n:Int):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().line(n);
  }
  public function lines(l:Int,h:Int):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().lines(l,h);
  }
  public function tag(str:String):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().tag(str);
  }
  public function tags(arr:Cluster<String>):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().tags(arr);
  }
  public function tagless():stx.log.Logic<Dynamic>{
    return LogicCtr.unit().tagless();
  }
  public function method(str:String):stx.log.Logic<Dynamic>{
    return LogicCtr.unit().method(str);
  }
  public function always():stx.log.Logic<Dynamic>{
    return LogicCtr.unit().always();
  }
  public function never():stx.log.Logic<Dynamic>{
    return LogicCtr.unit().never();
  }
}
class LogicLift{

}