package stx.log;

abstract Level(LevelSum) from LevelSum to LevelSum{
  public function new(self){
    this  = self;
  }
  public function asInt():Int{
    var int : Int = this;
    return int;
  }
  public function toString():String{
    return switch (this) {
      case 0: "CRAZY";
      case 1: "TRACE";
      case 2: "DEBUG";
      case 3: "INFO";
      case 4: "WARN";
      case 5: "ERROR";
      case 6: "FATAL";
    }
  }
}
