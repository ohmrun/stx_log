package stx.log.pack;

class Scoping{
  public var method : String;
  public var type   : String;
  public var module : String;

  public function new(method,type,module){
    this.method = method;
    this.type   = type;
    this.module = module;
  }
  public function copy(?method,?type,?module){
    return new Scoping(
      __.option(method).defv(this.method),
      __.option(type).defv(this.type),
      __.option(module).defv(this.module)
    );
  }
  public function with_method(name:String){
    return copy(name);
  }
  public function toString(){
    return '($module::$type::$method)';
  }
}