package stx.log;

import haxe.ds.Map;
import stx.log.Stamp;

@:allow(stx.log.pack.log) @:forward abstract LogPosition(Pos) from Pos to Pos{
  
  static inline var id : String = "306cccf1-89a7-44a4-b99a-7c69772a528d";
  
  @:from static public function lift(pos:Pos):LogPosition return new LogPosition(pos);

  @:from static public function fromPos(pos:Pos):LogPosition{
    return new LogPosition(pos);
  }
  public function new(self:Pos){
    this = self;
  }
  #if !macro
  static public function is_runtime() return true;
  #else
  static public function is_runtime() return false;
  #end

  @:noUsing static public function pure(pos:Pos){
    return new LogPosition(pos);
  }
  
  public var stamp(get,never) : Stamp;

  public function get_stamp():Stamp{
    return customParams.stamp;
  }
  public function restamp(fn:Stamp->Stamp):LogPosition{
    return lift(copy(null,null,null,null,customParams.restamp(fn)));
  }
  #if macro
  private static var macro_custom_params : Array<Couple<Pos,Array<Dynamic>>>     = [];

  public function copy(?fileName:String,?className:String,?methodName:String,?lineNumber:Null<Int>,?customParams:Array<Dynamic>):Pos{
    return this;
  }
  #else
  public function copy(?fileName:String,?className:String,?methodName:String,?lineNumber:Null<Int>,?customParams:Array<Dynamic>):LogPosition{
    return lift({
      fileName      : __.option(fileName).defv(this.fileName),
      className     : __.option(className).defv(this.className),
      methodName    : __.option(methodName).defv(this.methodName),
      lineNumber    : __.option(lineNumber).defv(this.lineNumber),
      customParams  : __.option(customParams).defv(this.customParams)
    });
  }
  #end
  public var customParams(get,never) : LogCustomParameters;

  private function get_customParams(){
    #if macro 
      return macro_custom_params.search(
        (x) -> x.fst() == this
      ).map(
        (x) -> x.snd()
      ).def(
        () -> {
          var val = __.couple(this,new LogCustomParameters());
          macro_custom_params.push(val);
          return val.snd();
        }
      );
    #else
    return __.option(this.customParams).is_defined().if_else(
      () -> this.customParams,
      () -> {
        this.customParams = new LogCustomParameters();
        return this.customParams;
      }
    );
    #end
  }
  public var scoping(get,never) : Scoping;

  #if !macro
    private function get_scoping(){
      return new Scoping(this.methodName,this.className,this.fileName);
    }
    public function match(race){
      return switch(race.scope){
        case ScopeMethod  : this.methodName == race.scoping.method;
        case ScopeClass   : this.className  == race.scoping.type;
        case ScopeModule  : this.fileName   == race.scoping.module;
      }
    }
  #else
    private function get_scoping(){
      return new Scoping("<method>","<type>","<module>");
    }
    public function match(race){
      return true;
    }
  #end
  public function prj():Pos{
    return this;
  }
  public var fileName(get,never):LogFileName;
  private function get_fileName():LogFileName{
    return #if macro 'unknown' #else this.fileName #end;
  }
  public var lineNumber(get,never):Int;
  private function get_lineNumber():Int{
    return #if macro -1 #else this.lineNumber #end;
  }
  public var methodName(get,never):String;
  private function get_methodName():String{
    return #if macro 'unknown' #else this.methodName #end;
  }

  public function re_methodName(method:String):LogPosition{
    return copy(null,null,method);
  }
  public function re_lineNumber(n:Int):LogPosition{
    return copy(null,null,null,n);
  }
}