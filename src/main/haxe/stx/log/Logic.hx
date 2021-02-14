package stx.log;

import hre.RegExp;

typedef LogicMake = {
  public function pack(pack:Array<String>):stx.log.Logic<Dynamic>;
  public function type(type:String):stx.log.Logic<Dynamic>;
  public function line(n:Int):stx.log.Logic<Dynamic>;
  public function lines(l:Int,h:Int):stx.log.Logic<Dynamic>;
  public function tag(str:String):stx.log.Logic<Dynamic>;
  public function method(str:String):stx.log.Logic<Dynamic>;
  public function always():stx.log.Logic<Dynamic>;
  public function never():stx.log.Logic<Dynamic>;
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
  static public function lift<T>(self:LogicSum<T>):Logic<T> return new Logic(self);
 
  @:noUsing static public function ctr<T>(fn):Logic<T>{
    return _._(fn);
  }
  @:from static public function fromPosPredicate(self:stx.assert.Predicate<LogPosition,LogFailure>):Logic<Dynamic>{
    return new stx.log.filter.term.PosPredicate(self);
  }
  @:from static public function fromFilter<T>(self:Filter<T>):Logic<T>{
    return LV(self);
  }
  @:op(A && B)
  public function and(that:Logic<T>):Logic<T>{
    return LAnd(this,that);
  }
  @:op(A || B)
  public function or(that:Logic<T>):Logic<T>{
    return LOr(this,that);
  }
  @:op(!A)
  public function not():Logic<T>{
    return LNot(lift(this));
  }
  public function apply(value:Value<T>):Report<LogFailure>{
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
      case LV(v)      : v.applyI(value);
    }
  }
  public function opine(value:Value<T>){
    return apply(value);
  }
  public function prj():LogicSum<T> return this;
  private var self(get,never):Logic<T>;
  private function get_self():Logic<T> return lift(this);

  private static function construct(fn:LogPosition->Report<LogFailure>){
    return Logic.fromPosPredicate(stx.assert.Predicate.Anon(fn));
  }


  static public function pack(pack:Array<String>):stx.log.Logic<Dynamic>{
    return construct((value:LogPosition) -> {
      var canonical   = pack.join(".");
      var query       = new RegExp('${canonical}.*','g');
      var result      = query.test(value.fileName.get_pack().join("."));
      return result.if_else(
        () -> Report.unit(),
        () -> __.fault().of(E_Log_SourceNotInPackage(value.fileName,canonical))
      );
    });
  }
  static public function type(type:String):stx.log.Logic<Dynamic>{
    return construct((value:LogPosition) -> {
      var result      = type == value.fileName.get_canonical();
      return result.if_else(
        () -> Report.unit(),
        () -> __.fault().of(E_Log_SourceNotInPackage(value.fileName,value.fileName.get_canonical()))
      );
    });
  }
  static public function line(n:Int):stx.log.Logic<Dynamic>{
    return construct((value) -> {
      var result      = value.lineNumber == n;
      return result.if_else(
        () -> Report.unit(),
        () -> __.fault().of(E_Log_NotLine(n))
      );
    });
  }
  static public function lines(l:Int,h:Int):stx.log.Logic<Dynamic>{
    return construct((
      (value) -> return 
        ((value.lineNumber >= l) && (value.lineNumber <= h)).if_else(
        () -> Report.unit(),
        () -> __.fault().of(E_Log_NotOfRange(l,h))
      )
    ));
  }
  static public function tag(str:String):stx.log.Logic<Dynamic>{
    return construct(
      (value) -> value.stamp.tags.search(
        (tag) -> tag == str
      ).is_defined().if_else(
        () -> Report.unit(),
        () -> __.fault().of(E_Log_DoesNotContainTag(str))
      )
    );
  }
  static public function method(str:String):stx.log.Logic<Dynamic>{
    return construct(
      (value) -> (value.methodName == str).if_else(
        () -> Report.unit(),
        () -> __.fault().of(E_Log_NotInMethod(str))
      )
    );
  }
  static public function always():stx.log.Logic<Dynamic>{
    return construct(
      (value) -> Report.unit()
    );
  }
  static public function never():stx.log.Logic<Dynamic>{
    return construct(
      (value) -> Report.make(E_Log_Zero)
    );
  }
}
class LogicLift{
  static public function make():LogicMake{
    return {
      pack      : stx.log.Logic.pack,
      type      : stx.log.Logic.type,
      line      : stx.log.Logic.line,
      lines     : stx.log.Logic.lines,
      tag       : stx.log.Logic.tag,
      always    : stx.log.Logic.always,
      never     : stx.log.Logic.never,
      method    : stx.log.Logic.method
    };
  }
  static public function _<T>(fn:LogicMake->Logic<T>):Logic<T>{
    return fn(make());
  }
}