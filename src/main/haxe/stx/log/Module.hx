package stx.log;

class Module extends Clazz{
  public function config(?_bias:Bias):stx.log.Config{
    return __.option(_bias).map((x)-> new Config(x)).defv(Config.instance);
  }
  public function bias():Bias{
    return new Bias();
  }
}