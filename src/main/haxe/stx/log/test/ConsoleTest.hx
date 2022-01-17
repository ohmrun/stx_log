package stx.log.test;

@:rtti class ConsoleTest extends TestCase{
	public function test(){
		Signal.instance.attach(new stx.log.logger.ConsoleLogger());
		__.log()("hello");
		__.log().trace("hello");
		__.log().debug("hello");
		__.log().warn("hello");
		__.log().error("hello");
		__.log().fatal("hello");
	}
}