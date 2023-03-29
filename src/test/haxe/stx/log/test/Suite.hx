package stx.log.test;

@:keep
class Suite{
  static public function tests():Cluster<TestCase>{
    return [
      new PrintFilterTest(),
    ];
  }
}