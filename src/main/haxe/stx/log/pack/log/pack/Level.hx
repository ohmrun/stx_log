package stx.log.pack.log.pack;

abstract Level(LevelSum) from LevelSum{
  public function new(self){
    this  = self;
  }
  public function asInt():Int{
    var int : Int = this;
    return int;
  }
  public function toString():String{
    return switch (this) {
      case 0: "TRACE";
      case 1: "DEBUG";
      case 2: "INFO";
      case 3: "WARN";
      case 4: "ERROR";
      case 5: "FATAL";
    }
  }
}
