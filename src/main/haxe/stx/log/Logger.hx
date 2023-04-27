package stx.log;

class Logger{
  static public function spur<T>(value:Value<T>):Upshot<String,LogFailure>{
    return __.reject(__.fault().of(E_Log_Zero));
  }  
  
  static public var ZERO(get,null) : stx.log.logger.Unit;
  static function get_ZERO(){
    __.option(ZERO).def(
      () -> ZERO = new stx.log.logger.Unit()
    );
    return ZERO;
  }

  #if (sys || nodejs)
  static public function ConsoleLogger(?logic:Logic<Dynamic>,?format:Format){
    return new stx.log.logger.ConsoleLogger(logic,format);
  }
  #end

}